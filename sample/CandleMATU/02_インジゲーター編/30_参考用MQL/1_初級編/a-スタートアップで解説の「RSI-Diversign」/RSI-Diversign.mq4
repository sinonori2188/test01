//+------------------------------------------------------------------+
//|                                                RSI-Diversign.mq4 |
//|                                         Copyright 2020, Ands.llc |
//|                                        https://fx-tradesite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020., Ands.llc "
#property link      " https://fx-tradesite.com/"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2

#property indicator_width1 5
#property indicator_color1 Red
#property indicator_width2 5
#property indicator_color2 Red

double Buffer_0[];
double Buffer_1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init(){

 IndicatorBuffers(2);
   SetIndexBuffer(0,Buffer_0);//下向きサイン
   SetIndexStyle(0,DRAW_ARROW); 
   SetIndexArrow(0,242);
     
   SetIndexBuffer(1,Buffer_1);//上向きサイン
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,241);
   
   return(0);
}


//extern int Maxbars = 2000;//対象本数範囲
extern int range = 100;//ブレイク対象範囲
extern double pips = 1;//サイン表示位置調整
extern bool vline = true;//縦線表示
extern int    RSIPeriod     = 14; //RSI期間
extern int RSIue = 70;//RSI上ライン
extern int RSIsita = 30;//RSI下ライン

int NowBars, RealBars,a, b, c, d, e, f, Timeframe = 0;
int indexhigh,indexlow;
double HPrice,LPrice,highrsi,lowrsi,rsi,now,nowopen;
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
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
  
  
  int limit = Bars - IndicatorCounted()-1;
  
  
  for(int i = limit; i >= 0; i--){ 
  
  indexhigh = iHighest(NULL,0 ,MODE_HIGH,range, i+2);  //最新足から2本前～range(パラメーター)で設定した本数の中で一番高値を付けた位置の本数（最新足からの）を保存
  indexlow = iLowest(NULL,0 ,MODE_LOW,range, i+2);  //最新足から2本前～range(パラメーター)で設定した本数の中で一番安値を付けた位置の本数（最新足からの）を保存
                       
  HPrice = iHigh(NULL,0,indexhigh); //indexhighで保存しておいた高値をつけた位置の価格を保存

                
  LPrice = iLow(NULL,0,indexlow); //indexlowで保存しておいた安値をつけた位置の価格を保存

  
  highrsi=iRSI(NULL,0,RSIPeriod,0,indexhigh); //indexhighで保存しておいた高値をつけた位置のRSIの値を保存    
  lowrsi=iRSI(NULL,0,RSIPeriod,0,indexlow); //indexhighで保存しておいた高値をつけた位置のRSIの値を保存
  
  rsi= iRSI(NULL,0,RSIPeriod,0,i); //i本目（現在見ている足）のRSIの値を保存
  now = iClose(NULL,0,i); //i本目（現在見ている足）の終値を保存
  nowopen=iOpen(NULL,0,i); //i本目（現在見ている足）の始値を保存

  
  Comment(HPrice+"\n"+
         (i+100)+"\n"+
          i); 
  
  if(i > 1 || (i == 1 && NowBars < Bars)){ 
          NowBars = Bars;
          
 if(HPrice<nowopen && HPrice<now && highrsi>rsi && rsi>=RSIue){ //下向きサイン表示条件
                 Buffer_0[i] = iHigh(NULL,0,i)+pips*10*Point;
                  if(vline == true){ 
                     	  //ObjectDelete("kikana"+IntegerToString(b-1));
                          ObjectCreate("kikana"+IntegerToString(b), OBJ_VLINE, 0, iTime(NULL,0,i), 0);//赤点線
                          ObjectSet("kikana"+IntegerToString(b), OBJPROP_COLOR, Red);
                          ObjectSet("kikana"+IntegerToString(b), OBJPROP_STYLE, STYLE_DOT);
                          b++;
                                              
                          //ObjectDelete("kikana"+IntegerToString(a-1));
                          ObjectCreate("kikanb"+IntegerToString(a), OBJ_VLINE, 0, iTime(NULL,0,indexhigh), 0);//黄色点線
                          ObjectSet("kikanb"+IntegerToString(a), OBJPROP_COLOR, Yellow);
                          ObjectSet("kikanb"+IntegerToString(a), OBJPROP_STYLE, STYLE_DOT);
                          a++;                 
                          }
                 
                 
             } 
 
   if(LPrice>nowopen&&LPrice>now&&lowrsi<rsi&&rsi<=RSIsita){ //上向きサイン表示条件
                 Buffer_1[i] = iLow(NULL,0,i)-pips*10*Point;
                if(vline == true){ 
                     	  
                          ObjectCreate("kikanc"+IntegerToString(c), OBJ_VLINE, 0, iTime(NULL,0,i), 0);//赤点線
                          ObjectSet("kikanc"+IntegerToString(c), OBJPROP_COLOR, Red);
                          ObjectSet("kikanc"+IntegerToString(c), OBJPROP_STYLE, STYLE_DOT);
                          c++;
                                              
                          
                          ObjectCreate("kikand"+IntegerToString(d), OBJ_VLINE, 0, iTime(NULL,0,indexlow), 0);//黄色点線
                          ObjectSet("kikand"+IntegerToString(d), OBJPROP_COLOR, Yellow);
                          ObjectSet("kikand"+IntegerToString(d), OBJPROP_STYLE, STYLE_DOT);
                          d++;                 
                          }
                 
                 
             }  
    if(vline == true){
       ObjectDelete("kikan"); 	        	     
       ObjectCreate("kikan", OBJ_VLINE, 0, iTime(NULL,0,range+2), 0);
       ObjectSet("kikan", OBJPROP_COLOR, Red);
      
   }     
   
   } //nowbars         
//---
   }//for
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
int deinit(){ 	//インジケーターを停止する際にオブジェクト（縦線）をすべて削除　バッファーは自動で削除されます。
   ObjectDelete("kikan"); 	
   
    for(int i = ObjectsTotal(); 1 <= i; i--) {
	   string ObjName=ObjectName(i);
	   if(StringFind(ObjName, "counttotal") != -1)
   	      ObjectDelete(ObjName); 	               	  
   }
   
    for(int i = ObjectsTotal()-1; 0 <= i; i--) {
	   string ObjName=ObjectName(i);
	   if(StringFind(ObjName, "kikan") >= 0)
   	      ObjectDelete(ObjName); 	               	  
   }
   
   
   Comment("");           	  
   return(0);
}

//+------------------------------------------------------------------+
