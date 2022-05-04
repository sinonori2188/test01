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
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
//externというのはパラメーターで後でチャートから変更できるようにしたい項目を設定する時に使います。
//externのあとは型が入り、今回は全部「スイッチ」を意味するbool型をパラメーターにしたいのでboolとしています。
//目的は、それぞれの形の表示のON/OFFを変更することで、trueだと表示、falseだと非表示になります。最初にスイッチをtrue,falseどちらに入れておくか書いておきます。（後でここで宣言した変数を使ってスイッチを設置します。）
//また、末尾にダブルスラッシュ（//）で日本語を入力すると、上で#property strictを書いておけば、パラメーター名を日本語にできます。標準は赤文字のままパラメーターに表示されます。
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

//変数を宣言しています。最初に全て宣言するのではなく、下の条件文を各中で使いたい変数が増えればここに戻って変数を追加してあげれば良いです。
int NowBars, limit, Timeframe, a, b, c, d, e, indexhigh, indexlow = 0;
double highest, lowest;

//OnCalculate関数もstart関数と全く同じなのでどちらでも構いません。（）の中は特に気にしなくてOKです。
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
  limit = Bars-IndicatorCounted()-1;
  for(int i=limit; i>=0; i--){
         if(i > 1 || (i == 1 && NowBars < Bars)){
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
   return(0);
}