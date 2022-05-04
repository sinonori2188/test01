#property version "1.0"
#property indicator_chart_window
#property indicator_buffers 8
#property strict

#property indicator_width1 3
#property indicator_color1 Red
#property indicator_width2 3
#property indicator_color2 White
#property indicator_width3 1
#property indicator_color3 Aqua
#property indicator_width4 1
#property indicator_color4 Orange
#property indicator_width5 1
#property indicator_color5 Blue
#property indicator_width6 1
#property indicator_color6 Magenta

//マルバツ表示のためにバッファーを２つ増やしました。
#property indicator_width7 3
#property indicator_color7 White
#property indicator_width8 3
#property indicator_color8 White

double Buffer_0[];
double Buffer_1[];
double Buffer_2[];
double Buffer_3[];
double Buffer_4[];
double Buffer_5[];

//入れ物も２つ増やします。
double Buffer_6[];
double Buffer_7[];

//enum型といって、パラメーターで選択肢を複数もたせたい場合はこの型を使います。
//enumのあとは任意の文字列を設定し、その中に選択肢を{};でくくって書きます。
//その際、ようその後ろに//で説明を書くと、それが選択肢の項目名となります。
enum limitdate1{
                    hday,//1時間
                    day,//1日
                    week,//１週間
                    month//１ヶ月
                    };
                    
//enum型はintやdoubleのような扱いで使用します。独自の型を作った感じで、下記のように使います。
extern limitdate1 limitdate;//勝率表示期間
extern bool maxbar = false;//任意本数指定
extern int Maxbars = 2000;//[上記trueの時]対象本数範囲
extern int labelsize = 10;//勝率ラベル大きさ
extern int labelpos = 1;//勝率ラベル表示位置(0~3)
extern int hantei = 1;//判定本数
extern int stopcnt = 5;//サインを停止させる本数

int NowBars, Hantei = 0;
int minute = 1;
int minute2 = 1;

double eprice, eprice2, uppercent, dnpercent, totalpercent,
   upwincnt, uplosecnt, dnwincnt, dnlosecnt, uptotalcnt, dntotalcnt, totalwin, totallose;
int upcnt, dncnt = 0;

bool upentryflag, dnentryflag = false;



int init(){

   IndicatorBuffers(8);
   SetIndexBuffer(0,Buffer_0);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,241);
     
   SetIndexBuffer(1,Buffer_1);  
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,242);
   
   SetIndexBuffer(2,Buffer_2);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,2);
   
   SetIndexBuffer(3,Buffer_3);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,2);
   
   SetIndexBuffer(4,Buffer_4);
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,2);
   
   SetIndexBuffer(5,Buffer_5);
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,2);
   
   //ここも２要素増やします。
   SetIndexBuffer(6,Buffer_6);
   SetIndexStyle(6,DRAW_ARROW);
   SetIndexArrow(6,161);
     
   SetIndexBuffer(7,Buffer_7);  
   SetIndexStyle(7,DRAW_ARROW);
   SetIndexArrow(7,251);   
   
   return(0);
}

int start(){
   int limit = 0;
   double ma141, ma142, ma143, ma144, ma751, ma752, ma753, ma754;

   limit = Bars-IndicatorCounted()-1;

if(maxbar == false){
      //ChartPeriod()関数は現在表示している時間足を取得します。なので＝＝１ということは1分足ということになります。
      //注意が必要なのが、全てM換算です。なので、H1の場合はM60となります。
      if(ChartPeriod(0) == 1){
            //MathMin()関数は()の左側の数字と右側の数字を比べて小さい方を採用する関数です。
            //limitと60を比べるわけですが、limitは一番最初はIndicatorCounted()が０なのでlimitはBars-1となるのでしたね。
            //しかし、次からはIndicatorCounted()が確定足分になるのでlimitは０になるのでした。
            //ということはMathMin(limit,60)は最初はlimitと60を比べて60が採用され、次の足以降はlimit（=0）が採用されることになります。
            //そのような処理をすることで最初は60本分の結果をざっと調べて、次からは完成した足だけ見ていけばいいので処理が軽くなるのです。
            //指定機関での勝率計算を行う際はこのような書き方で自由に期間を変えられます。（その下の1440~33000のように）
            //ただ、注意が必要なのは期間はこのやり方だと日付ではなくロウソク足の本数指定になります。（日付指定で行うことも可能です。）
            //日付指定のデメリットとしてはその都度日付を変えないと希望機関にきっちりならない点です。本数の場合は常に最新のデータに更新されます。
            if(limitdate == hday){
               limit = MathMin(limit,60);
            }
            if(limitdate == day){
               limit = MathMin(limit,1440);
            }
            if(limitdate == week){
               limit = MathMin(limit,7200);
            }
            if(limitdate == month){
               limit = MathMin(limit,33000);
            }
      }
      //仮に5分足表示だった場合に関して、同様の処理をしています。（本数を5分足での本数に変更している）
      if(ChartPeriod(0) == 5){
            if(limitdate == hday){
               limit = MathMin(limit,12);
            }
            if(limitdate == day){
               limit = MathMin(limit,288);
            }
            if(limitdate == week){
               limit = MathMin(limit,1440);
            }
            if(limitdate == month){
               limit = MathMin(limit,6600);
            }
      }
}

//同じ考え方で下記のように任意の本数を指定することも可能です。
if(maxbar == true){
    limit = MathMin(limit, Maxbars);
}
   
   for(int i=limit; i>=0; i--){

      if(i >= 1 || (NowBars < Bars && i == 1)){
          NowBars = Bars;
          
          ma141 = iMA(NULL,0,14,0,0,0,i);
          ma142 = iMA(NULL,0,14,0,0,0,i+1);
          ma143 = iMA(NULL,0,14,0,0,0,i+2);
          ma144 = iMA(NULL,0,14,0,0,0,i+3);
          ma751 = iMA(NULL,0,75,0,0,0,i);
          ma752 = iMA(NULL,0,75,0,0,0,i+1);
          ma753 = iMA(NULL,0,75,0,0,0,i+2);
          ma754 = iMA(NULL,0,75,0,0,0,i+3);
          
          if(ma142 < ma141){
              Buffer_2[i] = ma141;
              Buffer_2[i+1] = ma142;
          }
          
          if(ma142 > ma141){ //期間14MAが下降中の時
              Buffer_3[i] = ma141;
              Buffer_3[i+1] = ma142;
          }
          
          if(ma752 < ma751){ //期間75MAが上昇中の時
              Buffer_4[i] = ma751;
              Buffer_4[i+1] = ma752;
          }

          if(ma752 > ma751){ //期間75MAが下降中の時
              Buffer_5[i] = ma751;
              Buffer_5[i+1] = ma752;
          }       
          //--ここまで
          
          //--ここから勝敗判定（まずは下のサイン箇所へ移動）
          //サイン箇所を下に移動しています。そこでのupentryflagがtrueの時にここを通します。
          if(upentryflag == true){
              //判定させたい本数分ロウソク足が完成するのを待ちます。まだminuteが少ない間は途中の処理は通らず最後のminute++で足されて次足に移ります。
              if(minute == hantei){        
                  //指定本数分経ったら、サインが出た時に保存していた価格と今の終値を比べます。
                  //勝っていたらupwincntを１つ足します。この時、flagは降ろしておきましょう。
                  if(eprice < iClose(NULL,0,i)){            
                      Buffer_6[i] = iLow(NULL,0,i)-5*Point;
                      upentryflag = false;
                      upwincnt++;                                 
                  }
                  //elseなので逆に負けた時にバツのBufferを表示させてlosecntを１つ増やします。
                  else{
                           Buffer_7[i] = iLow(NULL,0,i)-5*Point;
                           upentryflag = false;       
                           uplosecnt++;                                  
                   }
              //マルバツを出したらminuteは０に戻しておいて次のサインをまた待ちます。
              minute = 0;
              } 
          minute++;   
          }
          
          
          if(dnentryflag == true){  
              if(minute2 == hantei){        
                  if(eprice2 > iClose(NULL,0,i)){           
                     Buffer_6[i] = iHigh(NULL,0,i)+10*Point;
                     dnentryflag = false;         
                     dnwincnt++;            
                  }       
                  else{
                        Buffer_7[i] = iHigh(NULL,0,i)+10*Point;
                        dnentryflag = false;       
                        dnlosecnt++;       
                   }
              minute2 = 0;
              } 
          minute2++;   
          }
          
       
         //ここからサイン箇所
         //サインが出ていたらカウントを１つずつ増やしていく。
          if(dncnt >= 1){dncnt++;}
          if(upcnt >= 1){upcnt++;}
          
          //そのカウントが指定したカウントよりも大きくなったらカウントはリセットする。
          if(dncnt > stopcnt){dncnt = 0;}
          if(upcnt > stopcnt){upcnt = 0;}
          
          //カウントがリセットされた時だけ通るようにする。（カウント中はサインは停止させる機能）
          if(upcnt == 0){
              if(ma142 < ma752 && ma141 >= ma751){
                  Buffer_0[i] = iLow(NULL,0,i)-20*Point;
                  //サインが出たことを示すフラグを立てておき、その時の価格をepriceとして保存しておく。
                  //アラートはi==1の時としておかないと過去足のサインに対してもチャート適用時にアラートが鳴ってしまうので注意が必要です。
                  //SendMail()関数は(件名,本文)と設定することができます。
                  //カウントがスタートするようにupcntを１にしておきます。
                  //勝敗判定の際の最初のズレ補正のために１以下、つまりpは２で止まります。
                  upentryflag = true;
                  eprice = iClose(NULL,0,i);
                  if(i == 1){Alert(Symbol()+" M"+IntegerToString(Period())+" High Sign");}
                  SendMail("High Sign", "High Sign");            
                  upcnt = 1;
              }
          }
          
          if(dncnt == 0){
              if(ma142 > ma752 && ma141 <= ma751){
                  Buffer_1[i] = iHigh(NULL,0,i)+20*Point;
                  dnentryflag = true;
                  eprice2 = iClose(NULL,0,i);
                  if(i == 1){Alert(Symbol()+" M"+IntegerToString(Period())+" Low Sign");}
                  SendMail("Low Sign", "Low Sign");                   
                  dncnt = 1;
              }
              //--ここまで
          }                    

          ObjectCreate("counttotal1",OBJ_LABEL,0,0,0);
          ObjectSet("counttotal1",OBJPROP_CORNER,labelpos);
          ObjectSet("counttotal1",OBJPROP_XDISTANCE,5);
          ObjectSet("counttotal1",OBJPROP_YDISTANCE,30);
          
          ObjectCreate("counttotal2",OBJ_LABEL,0,0,0);
          ObjectSet("counttotal2",OBJPROP_CORNER,labelpos);
          ObjectSet("counttotal2",OBJPROP_XDISTANCE,5);
          ObjectSet("counttotal2",OBJPROP_YDISTANCE,45);     
          
          ObjectCreate("counttotal3",OBJ_LABEL,0,0,0);
          ObjectSet("counttotal3",OBJPROP_CORNER,labelpos);
          ObjectSet("counttotal3",OBJPROP_XDISTANCE,5);
          ObjectSet("counttotal3",OBJPROP_YDISTANCE,60);                        
                
          //それまでためてきた勝利カウントと負けカウントを足して合計を出します。      
          uptotalcnt = upwincnt + uplosecnt;      
          dntotalcnt = dnwincnt + dnlosecnt;      
          totalwin = upwincnt+dnwincnt;
          totallose = uplosecnt+dnlosecnt;

          //それぞれのカウントが０ではない時、パーセントを出します。MathRound()関数は整数値にくり上げる関数です。
          //なぜupwincnt > 0のようにそれぞれ書いているかというと、割り算をする場合、破られる方が０であってはいけない、というプログラムルールがあります。
          //一番初めなどの０の時に回ってき場合、そこでエラーが起こってインジケーターが停止してしまいます。
          //そのため最初の０の時は割り算はスルーされるようにしているのです。
          if(upwincnt > 0){uppercent = MathRound((upwincnt / uptotalcnt)*100);} else uppercent = 0;
          if(dnwincnt > 0){dnpercent = MathRound((dnwincnt / dntotalcnt)*100);} else dnpercent = 0;
          if(totalwin > 0){totalpercent = MathRound((totalwin / (totalwin+totallose))*100);} else totalpercent = 0;

          ObjectSetText("counttotal1", "UP: 勝"+upwincnt+" 負"+uplosecnt+" 勝率"+uppercent+"%", labelsize, "MS ゴシック",Yellow);       
          ObjectSetText("counttotal2", "DN: 勝"+dnwincnt+" 負"+dnlosecnt+" 勝率"+dnpercent+"%", labelsize, "MS ゴシック",Yellow);     
          ObjectSetText("counttotal3", "TTL: 勝"+totalwin+" 負"+totallose+" 勝率"+totalpercent+"%", labelsize, "MS ゴシック",Yellow);   
                       
      } //この}でNowBarsで制限をかけていた条件を抜けます。この後値動きがあってもロウソク足が増えない限りは上記の条件文の中は通りません。 
   } //これがforの}で、ここから上までをi=limitからi=0になるまでiを-1していきます。ここは値動き（ティック）毎に通るのですが、NowBarsによって弾かれる形です。

   return(0); //forも最後まで繰り返すと他の条件は何もなく、start関数は終わります。次ティックでまたstart関数の一番初めに戻ります。それをティック毎に永遠と繰り返します。
}

//deinit関数はinit関数の反対で、インジケーターをチャートから削除した時に一度だけ呼び出されます。
//もし長方形やラインなどをObject関数を使って描画していたらここの中で消す処理を書いておかないと、インジケーターを除外してもチャートにはオブジェクトが残ったままになってしまいます。
//インジケーター中で何かオブジェクトを作成した場合は必ずdeinitに中で消すことを忘れないようにしましょう。
int deinit(){
   for(int i = ObjectsTotal(); i >= 0; i--){
      string ObjName=ObjectName(i);
      if(StringFind(ObjName, "counttotal") != -1)//StringFindは、見つかればワードが開始される文字列位置を返し、見つからなければ-1を返します。
            ObjectDelete(ObjName);
  }
  Comment("");
  return(0);
}