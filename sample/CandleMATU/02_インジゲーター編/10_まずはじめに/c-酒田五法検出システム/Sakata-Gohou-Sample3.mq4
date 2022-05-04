//+------------------------------------------------------------------+
//|                                                 Sakata-Gohou.mq4 |
//|                                                  Copyright 2018, |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018,"
#property link      ""
#property version   "1.00"
#property strict //インジケーターのパラメーターを日本語にするための記述です。
#property indicator_chart_window

//#includeというのは外部ファイルを読み込むためのもので非常に便利なので是非覚えておきましょう。
//簡単なイメージとしては、ファイルを分割して１ファイルあたりのコード数を少なくすることができるという感じです。
//外部ファイル化するためには[.mqh]という拡張子のファイルに書いていきます。新規ファイル作成で[include]を選択すると自動的にその拡張子のファイルの編集画面になります。
//例えば下記の意味は、自分のMT4のincludeの中にある[BO分析]というフォルダに入っている[Buttonlist.mqh]というファイルを読み込んでいます。
//外部ファイル化したファイルを読み込むためにはこのように、< [includeの中の場所を指定] / [ファイルの名前] >という書き方になります。includeの中に新たにフォルダを作っていない場合はファイル名だけでOKです。
//実際に読み込んだファイルをどのように使っていくかは後述しますのでまずはこのまま進んでいきましょう。
#include <Buttonlist2.mqh>
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   //ここで、前回のボタンが残っていたら被ってしまうので、一度buttonという名前がつくオブジェクトを全て消してリセットしています。
   for(int i = ObjectsTotal()-1; 0 <= i; i--) {
	   string ObjName=ObjectName(i);
	   if(StringFind(ObjName, "button") >= 0)
   	      ObjectDelete(ObjName); 	               	  
   }     
   
   int y = 250; //y座標を決めるためにint型でyを宣言し、その初期値に２５０を入れておきます。ボタンの位置を決めるのに使います。
   for(int i = 0;i < ArraySize(obj_name);i++){ //iをobj_nameの数まで１つずつ増やしているのですが、obj_nameというのはどこにも宣言していません。これはどこから出てきたのでしょうか？
                                                                              //その秘密は先ほどの外部ファイルになります。ここで一度外部ファイルのButtonlist.mqhを開いてみてください。
   
      //そして、ここで外部ファイルで作ったオリジナル関数を使っています。
      //create_buttonという関数を呼び出して引数（）の中をそれぞれ設定します。ここに設定した要素がi個分繰り返されるという形です。
      //例えば、一番最初はiは０で回ってくるので、obj_name[0],obj_text[0],yとなります。最初２つの中身は外部ファイルで設定していたものになります。
      //obj_nameの０番目は"akasanpeibutton",　obj_textの０番目は"赤三兵"でしたね。yは上で定義した250で固定です。
      //そしてforによってiが＋１されてもう一度回ってきたときはobj_name[1],obj_text[1],yとなり、それぞれ中身は"kurosanpeibutton", "黒三兵", 225となります。
      create_button(obj_name[i],obj_text[i],y);
      y -=25; //ここで固定のyを-25して次のiに回します。次のボタンが重なってしまわないようにボタンの位置を25だけ下にずらしています。
   }


//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
extern bool rectangle = false; //長方形表示
extern bool akasanpei = true; //赤三兵表示
extern bool kurosanpei = true; //黒三兵表示
extern bool sanzan = true; //三山表示
extern bool sansen = true; //三川表示
extern bool sanzon = true; //三尊表示
extern bool gyakusanzon = true; //逆三尊表示
extern bool sankuhumi = true; //三空踏み上げ表示
extern bool sankutataki = true; //三空叩き込み表示
extern bool agesanpou = true; //上げ三法表示
extern bool sagesanpou = true; //下げ三法表示

int NowBars, limit, Timeframe, a, b, c, d, e, indexhigh, indexlow = 0;
int ba, bb, bc, bd, be, bf, bg, bh, bi, bj = 0;
double highest, lowest;
bool redraw = false; 

//これはチャートイベントといって、例えば今回のようにボタンクリックで何かさせたい場合などに使用します。
//ティックが動くのとは関係なく、何かをした時などに指定した処理を行いたい場合に使います。
void OnChartEvent(
                 const int chart_id,          // イベントID
                 const long& lparam,    // long型イベント
                 const double& dparam,  // double型イベント
                 const string& sparam)  // string型イベント
{ //ここまでは定型なので常にこのままで大丈夫です。
    int i;
    if(chart_id == CHARTEVENT_OBJECT_CLICK){     // CHARTEVENT_OBJECT_CLICKはオブジェクトがクリックされたことを認識する関数です。
        for(int j = 0;j < ArraySize(obj_name);j++){ //ArraySizeというのは配列の中身の総数を取得する関数で（）の中が配列名になります。
                                                                                    //obj_nameという配列は外部ファイルで定義していて中身の要素は10個でした。なのでArraySize(obj_name)=10となります。
                                                                                    //これで、jは０から９まで＋１されながら繰り返される、という意味になります。
            if(sparam == obj_name[j]){       // クリックされたオブジェクトは何なのか？を決めます。今回はobj_name[j]でj番目のobj_nameの中身を指定しています。
                   //jがそれぞれの数の時、上のパラメーターの所で宣言したどの変数をtrue（表示）またはfalse（非表示）にするかを設定します。
                   if(j == 0 && akasanpei == false){akasanpei = true;ObjectSet(obj_name[0],OBJPROP_BGCOLOR,clrLightCyan);}    //0番目のボタンの色を水色に変えます。（表示状態のボタンを水色にしてわかりやすくします）
                   else if(j == 0)                 {akasanpei = false;ObjectSet(obj_name[0],OBJPROP_BGCOLOR,clrYellow);};     //0番目のボタンの色を黄色に変えます。（非表示状態のボタンを黄色にしてわかりやすくします）
                   
                   if(j == 1 && kurosanpei == false){kurosanpei = true;ObjectSet(obj_name[1],OBJPROP_BGCOLOR,clrLightCyan);}
                   else if(j == 1)                  {kurosanpei = false;ObjectSet(obj_name[1],OBJPROP_BGCOLOR,clrYellow);};

                   if(j == 2 && sanzan == false){sanzan = true;ObjectSet(obj_name[2],OBJPROP_BGCOLOR,clrLightCyan);}
                   else if(j == 2)              {sanzan = false;ObjectSet(obj_name[2],OBJPROP_BGCOLOR,clrYellow);};

                   if(j == 3 && sansen == false){sansen = true;ObjectSet(obj_name[3],OBJPROP_BGCOLOR,clrLightCyan);}
                   else if(j == 3)              {sansen = false;ObjectSet(obj_name[3],OBJPROP_BGCOLOR,clrYellow);};

                   if(j == 4 && sanzon == false){sanzon = true;ObjectSet(obj_name[4],OBJPROP_BGCOLOR,clrLightCyan);}
                   else if(j == 4)              {sanzon = false;ObjectSet(obj_name[4],OBJPROP_BGCOLOR,clrYellow);};

                   if(j == 5 && gyakusanzon == false){gyakusanzon = true;ObjectSet(obj_name[5],OBJPROP_BGCOLOR,clrLightCyan);}
                   else if(j == 5)                   {gyakusanzon = false;ObjectSet(obj_name[5],OBJPROP_BGCOLOR,clrYellow);};

                   if(j == 6 && sankuhumi == false){sankuhumi = true;ObjectSet(obj_name[6],OBJPROP_BGCOLOR,clrLightCyan);}
                   else if(j == 6)                 {sankuhumi = false;ObjectSet(obj_name[6],OBJPROP_BGCOLOR,clrYellow);};

                   if(j == 7 && sankutataki == false){sankutataki = true;ObjectSet(obj_name[7],OBJPROP_BGCOLOR,clrLightCyan);}
                   else if(j == 7)                   {sankutataki = false;ObjectSet(obj_name[7],OBJPROP_BGCOLOR,clrYellow);};

                   if(j == 8 && agesanpou == false){agesanpou = true;ObjectSet(obj_name[8],OBJPROP_BGCOLOR,clrLightCyan);}
                   else if(j == 8)                 {agesanpou = false;ObjectSet(obj_name[8],OBJPROP_BGCOLOR,clrYellow);};

                   if(j == 9 && sagesanpou == false){sagesanpou = true;ObjectSet(obj_name[9],OBJPROP_BGCOLOR,clrLightCyan);}
                   else if(j == 9)                  {sagesanpou = false;ObjectSet(obj_name[9],OBJPROP_BGCOLOR,clrYellow);};
                   
                   redraw = true; //OnCalculate関数の中でティックが動くたびにボタンを再描画させるためにredrawというフラグをtrueにしておきます。
                   //一旦すべてのオブジェクトを消します。（消さないとその上に新たなオブジェクトが生成され被ってしまう）
                   for(i = ObjectsTotal()-1; 0 <= i; i--) {
                 	   string ObjName=ObjectName(i);
                 	   if(StringFind(ObjName, "SG") >= 0)
                   	      ObjectDelete(ObjName); 	               	  
                    }                         
               }
           }
    }  
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
  
  //再描画フラグが立っていない時は通常のlimit（インジ起動後の初ティック以降、limitは０になる）
  if(redraw == false){
      limit = Bars-IndicatorCounted()-1;
  }
  //ボタンのところで再描画フラグを立てていたらlimitはチャートにあるすべてのバーにする。
  else if(redraw == true){
               limit = Bars-1;
  }
           
  //redrawフラグが立っていればforによってまた最初のバーから読み込まれてオブジェクトが描画されていく。
  //その時にボタンによってfalseになっているパターンに関しては無視されて、非表示となって再描画される。
  //これがボタンによって各パターンの表示をON/OFFにしている中身となります。
  //ボタンを押して設定をtrue, falseに切り替えた後、また最初のバーから再描画させているということが一瞬で行われるため、ボタンを押すと指定したオブジェクトだけが非表示になったように見えるのです。
  
  for(int i=limit; i>=0; i--){
         redraw = false; //再描画フラグを降ろす。        
         if(i >= 1 || (NowBars < Bars && i == 1)){
             NowBars = Bars;  
              if(ChartPeriod(0) == 1){Timeframe = 1;} //ChartPeriod(0)は今表示しているチャートの時間足を取得します。＝＝１、つまり1分足の時、Timeframeに１を代入します。
              if(ChartPeriod(0) == 5){Timeframe = 2;} //5分足の時、Timeframeに2を代入します。以下同様です。
              if(ChartPeriod(0) == 15){Timeframe = 5;} //代入する数は適当に決めています。時間足が大きくなるにつれpips幅が変わってくるので後でテキストを表示させる時の位置の倍率を変えるために
              if(ChartPeriod(0) == 30){Timeframe = 7;} //ここでベースとなる数字を決めています。
              if(ChartPeriod(0) == 60){Timeframe = 10;}
              if(ChartPeriod(0) == 240){Timeframe = 15;}
              if(ChartPeriod(0) == 1440){Timeframe = 20;}

              //赤三兵の条件--------------------------------------------------------------------------------------
              if(akasanpei == true){ //ここで１つ目のスイッチを置きます。trueならこの中の条件を通り、falseならスイッチはOFFなのでこの中の条件文はスルーされます。２つ目以降のスイッチも同様です。
              if(iOpen(NULL,0,i+2) < iClose(NULL,0,i+2) && //2本前が陽線 
                  iOpen(NULL,0,i+1) < iClose(NULL,0,i+1) && //1本前が陽線 
                  iOpen(NULL,0,i) < iClose(NULL,0,i) && //今足が陽線
                  MathAbs(iOpen(NULL,0,i+2) - iClose(NULL,0,i+2)) >= 5*Timeframe*Point && //MathAbsは絶対値を取る関数です。今回は実体の大きさの絶対値を取っています。
                  MathAbs(iOpen(NULL,0,i+1) - iClose(NULL,0,i+1)) >= 5*Timeframe*Point && //そして、それが5*Timeframe以上として、実体の大きさに制限をかけています。
                  MathAbs(iOpen(NULL,0,i) - iClose(NULL,0,i)) >= 5*Timeframe*Point){
             
                  indexhigh = iHighest(NULL,0,MODE_HIGH,3,i);
                  highest = iHigh(NULL,0,indexhigh);
                  indexlow = iLowest(NULL,0,MODE_LOW,3,i);          
                  lowest = iLow(NULL,0,indexlow);            
                  if(rectangle == true){ //長方形を表示させるかのスイッチです。
                      ObjectCreate("SGasrec"+IntegerToString(a), OBJ_RECTANGLE, 0, iTime(NULL,0,i+2), highest, iTime(NULL,0,i), lowest);
                      ObjectSet("SGasrec"+IntegerToString(a),OBJPROP_HIDDEN,true);
                      ObjectSet("SGasrec"+IntegerToString(a), OBJPROP_COLOR, Red);
                  }                  
                  ObjectCreate("SGakasan"+IntegerToString(a), OBJ_TEXT, 0, iTime(NULL,0,i+1), highest+15*Timeframe*Point);
                  ObjectSetText("SGakasan"+IntegerToString(a), "赤三兵", 12, "MSゴシック", Red);                  
                  a++; //別にaの数は間が飛んでも問題はないので、この後も全てのオブジェクトに対して番号記号をaとしています。
              }
              }
              
              //黒三兵の条件--------------------------------------------------------------------------------------
              if(kurosanpei == true){
              if(iOpen(NULL,0,i+2) > iClose(NULL,0,i+2) && //2本前が陰線 
                  iOpen(NULL,0,i+1) > iClose(NULL,0,i+1) && //1本前が陰線 
                  iOpen(NULL,0,i) > iClose(NULL,0,i) && //今足が陰線
                  MathAbs(iOpen(NULL,0,i+2) - iClose(NULL,0,i+2)) >= 5*Timeframe*Point &&
                  MathAbs(iOpen(NULL,0,i+1) - iClose(NULL,0,i+1)) >= 5*Timeframe*Point &&
                  MathAbs(iOpen(NULL,0,i) - iClose(NULL,0,i)) >= 5*Timeframe*Point){
             
                  indexhigh = iHighest(NULL,0,MODE_HIGH,3,i);
                  highest = iHigh(NULL,0,indexhigh);
                  indexlow = iLowest(NULL,0,MODE_LOW,3,i);          
                  lowest = iLow(NULL,0,indexlow);            
                  if(rectangle == true){
                      ObjectCreate("SGksrec"+IntegerToString(a), OBJ_RECTANGLE, 0, iTime(NULL,0,i+2), highest, iTime(NULL,0,i), lowest);
                      ObjectSet("SGksrec"+IntegerToString(a),OBJPROP_HIDDEN,true);
                      ObjectSet("SGksrec"+IntegerToString(a), OBJPROP_COLOR, Pink);                  
                  }
                  ObjectCreate("SGkurosan"+IntegerToString(a), OBJ_TEXT, 0, iTime(NULL,0,i+1), lowest-5*Timeframe*Point);
                  ObjectSetText("SGkurosan"+IntegerToString(a), "黒三兵", 12, "MSゴシック", Pink);                  
                  a++;
              } 
              }   
              
              //三山の条件--------------------------------------------------------------------------------------
              if(sanzan == true){
              if(iOpen(NULL,0,i+5) < iClose(NULL,0,i+5) && iOpen(NULL,0,i+4) > iClose(NULL,0,i+4) && //陽線の次が陰線
                  iOpen(NULL,0,i+3) < iClose(NULL,0,i+3) && iOpen(NULL,0,i+2) > iClose(NULL,0,i+2) && //その次が陽線で、その次が陰線
                  iOpen(NULL,0,i+1) < iClose(NULL,0,i+1) && iOpen(NULL,0,i) > iClose(NULL,0,i) && //その次が陽線で、その次が陰線
                  iClose(NULL,0,i+5) > iOpen(NULL,0,i+3) && iClose(NULL,0,i+5) > iOpen(NULL,0,i+1) && //一番左の陽線の終値が真ん中と右の陽線の始値よりも上にある
                  iClose(NULL,0,i+3) > iOpen(NULL,0,i+5) && iClose(NULL,0,i+3) > iOpen(NULL,0,i+1) && //真ん中の陽線の終値が左と右の陽線の始値よりも上にある
                  iClose(NULL,0,i+1) > iOpen(NULL,0,i+3) && iClose(NULL,0,i+1) > iOpen(NULL,0,i+5)){ //一番右の陽線の終値が真ん中と左の陽線の始値よりも上にある
                  
                  indexhigh = iHighest(NULL,0,MODE_HIGH,6,i);
                  highest = iHigh(NULL,0,indexhigh);     
                  indexlow = iLowest(NULL,0,MODE_LOW,6,i);          
                  lowest = iLow(NULL,0,indexlow);            
                  if(rectangle == true){
                      ObjectCreate("SGszrec"+IntegerToString(a), OBJ_RECTANGLE, 0, iTime(NULL,0,i+5), highest, iTime(NULL,0,i), lowest);
                      ObjectSet("SGszrec"+IntegerToString(a),OBJPROP_HIDDEN,true);
                      ObjectSet("SGszrec"+IntegerToString(a), OBJPROP_COLOR, SkyBlue);                  
                  }                                        
                  ObjectCreate("SGsanzan"+IntegerToString(a), OBJ_TEXT, 0, iTime(NULL,0,i+3), highest+10*Timeframe*Point);
                  ObjectSetText("SGsanzan"+IntegerToString(a), "三 山", 12, "MSゴシック", SkyBlue);                  
                  a++;              
              }
              }

              //三川の条件--------------------------------------------------------------------------------------
              if(sansen == true){
              if(iOpen(NULL,0,i+5) > iClose(NULL,0,i+5) && iOpen(NULL,0,i+4) < iClose(NULL,0,i+4) && //ここからの各if文の中身の意味を一度考えてみましょう。
                  iOpen(NULL,0,i+3) > iClose(NULL,0,i+3) && iOpen(NULL,0,i+2) < iClose(NULL,0,i+2) &&
                  iOpen(NULL,0,i+1) > iClose(NULL,0,i+1) && iOpen(NULL,0,i) < iClose(NULL,0,i) &&
                  iClose(NULL,0,i+5) < iOpen(NULL,0,i+3) && iClose(NULL,0,i+5) < iOpen(NULL,0,i+1) &&
                  iClose(NULL,0,i+3) < iOpen(NULL,0,i+5) && iClose(NULL,0,i+3) < iOpen(NULL,0,i+1) &&
                  iClose(NULL,0,i+1) < iOpen(NULL,0,i+3) && iClose(NULL,0,i+1) < iOpen(NULL,0,i+5)){
                  
                  indexhigh = iHighest(NULL,0,MODE_HIGH,6,i);
                  highest = iHigh(NULL,0,indexhigh);     
                  indexlow = iLowest(NULL,0,MODE_LOW,6,i);          
                  lowest = iLow(NULL,0,indexlow);            
                  if(rectangle == true){
                      ObjectCreate("SGssrec"+IntegerToString(a), OBJ_RECTANGLE, 0, iTime(NULL,0,i+5), highest, iTime(NULL,0,i), lowest);
                      ObjectSet("SGssrec"+IntegerToString(a),OBJPROP_HIDDEN,true);
                      ObjectSet("SGssrec"+IntegerToString(a), OBJPROP_COLOR, Purple);                  
                  }                                        
                  ObjectCreate("SGsansen"+IntegerToString(a), OBJ_TEXT, 0, iTime(NULL,0,i+3), lowest-5*Timeframe*Point);
                  ObjectSetText("SGsansen"+IntegerToString(a), "三 川", 12, "MSゴシック", Purple);                  
                  a++;              
              }     
              }
              
              //三尊の条件--------------------------------------------------------------------------------------
              if(sanzon == true){
              if(iOpen(NULL,0,i+5) < iClose(NULL,0,i+5) && iOpen(NULL,0,i+4) > iClose(NULL,0,i+4) && //条件設定はまずは日本語化することからです。日本語化ができないとこのようにコードにはできません。
                  iOpen(NULL,0,i+3) < iClose(NULL,0,i+3) && iOpen(NULL,0,i+2) > iClose(NULL,0,i+2) &&
                  iOpen(NULL,0,i+1) < iClose(NULL,0,i+1) && iOpen(NULL,0,i) > iClose(NULL,0,i) &&
                  iHigh(NULL,0,i+5) < iHigh(NULL,0,i+3) && iHigh(NULL,0,i+4) < iHigh(NULL,0,i+3) &&
                  iHigh(NULL,0,i+1) < iHigh(NULL,0,i+3) && iHigh(NULL,0,i) < iHigh(NULL,0,i+3)){
                  
                  indexhigh = iHighest(NULL,0,MODE_HIGH,6,i);
                  highest = iHigh(NULL,0,indexhigh);     
                  indexlow = iLowest(NULL,0,MODE_LOW,6,i);          
                  lowest = iLow(NULL,0,indexlow);            
                  if(rectangle == true){
                      ObjectCreate("SGszzrec"+IntegerToString(a), OBJ_RECTANGLE, 0, iTime(NULL,0,i+5), highest, iTime(NULL,0,i), lowest);
                      ObjectSet("SGszzrec"+IntegerToString(a),OBJPROP_HIDDEN,true);
                      ObjectSet("SGszzrec"+IntegerToString(a), OBJPROP_COLOR, RoyalBlue);                  
                  }                                        
                  ObjectCreate("SGsanzon"+IntegerToString(a), OBJ_TEXT, 0, iTime(NULL,0,i+3), highest+20*Timeframe*Point);
                  ObjectSetText("SGsanzon"+IntegerToString(a), "三 尊", 12, "MSゴシック", RoyalBlue);                  
                  a++;              
              }  
              }          
              
              //逆三尊の条件--------------------------------------------------------------------------------------
              if(gyakusanzon == true){
              if(iOpen(NULL,0,i+5) > iClose(NULL,0,i+5) && iOpen(NULL,0,i+4) < iClose(NULL,0,i+4) &&
                  iOpen(NULL,0,i+3) > iClose(NULL,0,i+3) && iOpen(NULL,0,i+2) < iClose(NULL,0,i+2) &&
                  iOpen(NULL,0,i+1) > iClose(NULL,0,i+1) && iOpen(NULL,0,i) < iClose(NULL,0,i) &&
                  iLow(NULL,0,i+5) > iLow(NULL,0,i+3) && iLow(NULL,0,i+4) > iLow(NULL,0,i+3) &&
                  iLow(NULL,0,i+1) > iLow(NULL,0,i+3) && iLow(NULL,0,i) > iLow(NULL,0,i+3)){
                  
                  indexhigh = iHighest(NULL,0,MODE_HIGH,6,i);
                  highest = iHigh(NULL,0,indexhigh);     
                  indexlow = iLowest(NULL,0,MODE_LOW,6,i);          
                  lowest = iLow(NULL,0,indexlow);            
                  if(rectangle == true){
                      ObjectCreate("SGgszrec"+IntegerToString(a), OBJ_RECTANGLE, 0, iTime(NULL,0,i+5), highest, iTime(NULL,0,i), lowest);
                      ObjectSet("SGgszrec"+IntegerToString(a),OBJPROP_HIDDEN,true);
                      ObjectSet("SGgszrec"+IntegerToString(a), OBJPROP_COLOR, IndianRed);                  
                  }                                        
                  ObjectCreate("SGgyakusanzon"+IntegerToString(a), OBJ_TEXT, 0, iTime(NULL,0,i+3), lowest-10*Timeframe*Point);
                  ObjectSetText("SGgyakusanzon"+IntegerToString(a), "逆 三 尊", 12, "MSゴシック", IndianRed);                  
                  a++;              
              }  
              }    
              
              //三空踏み上げの条件--------------------------------------------------------------------------------------
              if(sankuhumi == true){
              if(iOpen(NULL,0,i+3) < iClose(NULL,0,i+3) && iOpen(NULL,0,i+2) < iClose(NULL,0,i+2) &&
                  iOpen(NULL,0,i+1) < iClose(NULL,0,i+1) && iOpen(NULL,0,i) < iClose(NULL,0,i) &&
                  iClose(NULL,0,i+3) < iOpen(NULL,0,i+2) && iClose(NULL,0,i+2) < iOpen(NULL,0,i+1) && iClose(NULL,0,i+1) < iOpen(NULL,0,i)){
                  
                  indexhigh = iHighest(NULL,0,MODE_HIGH,4,i);
                  highest = iHigh(NULL,0,indexhigh);     
                  indexlow = iLowest(NULL,0,MODE_LOW,4,i);          
                  lowest = iLow(NULL,0,indexlow);            
                  if(rectangle == true){
                      ObjectCreate("SGskhrec"+IntegerToString(a), OBJ_RECTANGLE, 0, iTime(NULL,0,i+3), highest, iTime(NULL,0,i), lowest);
                      ObjectSet("SGskhrec"+IntegerToString(a),OBJPROP_HIDDEN,true);
                      ObjectSet("SGskhrec"+IntegerToString(a), OBJPROP_COLOR, SeaGreen);                  
                  }                                        
                  ObjectCreate("SGsankuh"+IntegerToString(a), OBJ_TEXT, 0, iTime(NULL,0,i+2), highest+20*Timeframe*Point);
                  ObjectSetText("SGsankuh"+IntegerToString(a), "三空踏み上げ", 12, "MSゴシック", SeaGreen);                  
                  a++;              
              }   
              }   
              
              //三空叩き込みの条件--------------------------------------------------------------------------------------
              if(sankutataki == true){
              if(iOpen(NULL,0,i+3) > iClose(NULL,0,i+3) && iOpen(NULL,0,i+2) > iClose(NULL,0,i+2) &&
                  iOpen(NULL,0,i+1) > iClose(NULL,0,i+1) && iOpen(NULL,0,i) > iClose(NULL,0,i) &&
                  iClose(NULL,0,i+3) > iOpen(NULL,0,i+2) && iClose(NULL,0,i+2) > iOpen(NULL,0,i+1) && iClose(NULL,0,i+1) > iOpen(NULL,0,i)){
                  
                  indexhigh = iHighest(NULL,0,MODE_HIGH,4,i);
                  highest = iHigh(NULL,0,indexhigh);     
                  indexlow = iLowest(NULL,0,MODE_LOW,4,i);          
                  lowest = iLow(NULL,0,indexlow);            
                  if(rectangle == true){
                      ObjectCreate("SGsktrec"+IntegerToString(a), OBJ_RECTANGLE, 0, iTime(NULL,0,i+3), highest, iTime(NULL,0,i), lowest);
                      ObjectSet("SGsktrec"+IntegerToString(a),OBJPROP_HIDDEN,true);
                      ObjectSet("SGsktrec"+IntegerToString(a), OBJPROP_COLOR, CadetBlue);                  
                  }                                        
                  ObjectCreate("SGsankut"+IntegerToString(a), OBJ_TEXT, 0, iTime(NULL,0,i+2), lowest-10*Timeframe*Point);
                  ObjectSetText("SGsankut"+IntegerToString(a), "三空叩き込み", 12, "MSゴシック", CadetBlue);                  
                  a++;              
              }   
              }               
              
              //上げ三法の条件--------------------------------------------------------------------------------------
              if(agesanpou == true){
              if(iOpen(NULL,0,i+4) < iClose(NULL,0,i+4) && iOpen(NULL,0,i+3) > iClose(NULL,0,i+3) &&
                  iHigh(NULL,0,i+4) > iHigh(NULL,0,i+3) && iLow(NULL,0,i+4) < iLow(NULL,0,i+3) &&
                  iHigh(NULL,0,i+4) > iHigh(NULL,0,i+2) && iLow(NULL,0,i+4) < iLow(NULL,0,i+2) &&
                  iHigh(NULL,0,i+4) > iHigh(NULL,0,i+1) && iLow(NULL,0,i+4) < iLow(NULL,0,i+1) &&
                  iOpen(NULL,0,i) < iClose(NULL,0,i) && iHigh(NULL,0,i+4) < iClose(NULL,0,i)){
                  
                  indexhigh = iHighest(NULL,0,MODE_HIGH,5,i);
                  highest = iHigh(NULL,0,indexhigh);     
                  indexlow = iLowest(NULL,0,MODE_LOW,5,i);          
                  lowest = iLow(NULL,0,indexlow);            
                  if(rectangle == true){
                      ObjectCreate("SGasprec"+IntegerToString(a), OBJ_RECTANGLE, 0, iTime(NULL,0,i+4), highest, iTime(NULL,0,i), lowest);
                      ObjectSet("SGasprec"+IntegerToString(a),OBJPROP_HIDDEN,true);
                      ObjectSet("SGasprec"+IntegerToString(a), OBJPROP_COLOR, Orchid);                  
                  }                                        
                  ObjectCreate("SGagesan"+IntegerToString(a), OBJ_TEXT, 0, iTime(NULL,0,i+2), highest+20*Timeframe*Point);
                  ObjectSetText("SGagesan"+IntegerToString(a), "上げ三法", 12, "MSゴシック", Orchid);                  
                  a++;              
              }
              }
              
              //下げ三法の条件--------------------------------------------------------------------------------------
              if(sagesanpou == true){
              if(iOpen(NULL,0,i+4) > iClose(NULL,0,i+4) && iOpen(NULL,0,i+3) < iClose(NULL,0,i+3) &&
                  iHigh(NULL,0,i+4) > iHigh(NULL,0,i+3) && iLow(NULL,0,i+4) < iLow(NULL,0,i+3) &&
                  iHigh(NULL,0,i+4) > iHigh(NULL,0,i+2) && iLow(NULL,0,i+4) < iLow(NULL,0,i+2) &&
                  iHigh(NULL,0,i+4) > iHigh(NULL,0,i+1) && iLow(NULL,0,i+4) < iLow(NULL,0,i+1) &&
                  iOpen(NULL,0,i) > iClose(NULL,0,i) && iLow(NULL,0,i+4) > iClose(NULL,0,i)){
                  
                  indexhigh = iHighest(NULL,0,MODE_HIGH,5,i);
                  highest = iHigh(NULL,0,indexhigh);     
                  indexlow = iLowest(NULL,0,MODE_LOW,5,i);          
                  lowest = iLow(NULL,0,indexlow);            
                  if(rectangle == true){
                      ObjectCreate("SGssprec"+IntegerToString(a), OBJ_RECTANGLE, 0, iTime(NULL,0,i+4), highest, iTime(NULL,0,i), lowest);
                      ObjectSet("SGssprec"+IntegerToString(a),OBJPROP_HIDDEN,true);
                      ObjectSet("SGssprec"+IntegerToString(a), OBJPROP_COLOR, Khaki);                  
                  }                                        
                  ObjectCreate("SGsagesan"+IntegerToString(a), OBJ_TEXT, 0, iTime(NULL,0,i+2), lowest-10*Timeframe*Point);
                  ObjectSetText("SGsagesan"+IntegerToString(a), "下げ三法", 12, "MSゴシック", Khaki);                  
                  a++;              
              }  
              }                                                                                    
       }
  }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
int deinit(){
   for(int i = ObjectsTotal()-1; 0 <= i; i--) {
	   string ObjName=ObjectName(i);
	   if(StringFind(ObjName, "SG") >= 0)
   	      ObjectDelete(ObjName);
   }
   for(int i = ObjectsTotal()-1; 0 <= i; i--) {
	   string ObjName=ObjectName(i);
	   if(StringFind(ObjName, "button") >= 0)
   	      ObjectDelete(ObjName); 	               	  
   }     
   Comment("");      
   return(0);
}