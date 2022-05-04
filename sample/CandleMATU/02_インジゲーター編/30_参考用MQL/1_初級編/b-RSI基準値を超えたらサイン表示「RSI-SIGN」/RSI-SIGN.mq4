//+------------------------------------------------------------------+
//|                                                             .mq4 |
//|                                             Copyright 2020, ands |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "ands"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2

#property indicator_width1 3
#property indicator_color1 Orange
#property indicator_width2 3
#property indicator_color2 Magenta


double Buffer_0[];
double Buffer_1[];


int OnInit()
  {
   IndicatorBuffers(2);
   SetIndexBuffer(0,Buffer_0);
   SetIndexStyle(0,DRAW_ARROW); 
   SetIndexArrow(0,241);
     
   SetIndexBuffer(1,Buffer_1);  
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,242);

 
   
   return(INIT_SUCCEEDED);
  }

extern double pips = 2;//サイン表示位置調整
extern string Note1 = "";//インジケーター設定---------------------
extern int RSIPeriod = 14;//RSI期間

extern string Note2 = "";//レベル設定---------------------
extern int rsiup = 70;//RSI上レベル
extern int rsidn = 30;//RSI下レベル




int NowBars, RealBars,a, b, c, e, f, p, q, minute, minute2, Timeframe = 0;
bool flag1, flag2, upentryflag, dnentryflag = false;
double eprice, wincnt, losecnt, totalcnt, percent;
bool Certification = false;

double RSI1, RSI2;


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
   
    if(ChartPeriod(0) == 1){Timeframe = 2;}
    if(ChartPeriod(0) == 5){Timeframe = 4;}
    if(ChartPeriod(0) == 15){Timeframe = 6;}
    if(ChartPeriod(0) == 30){Timeframe = 8;}
    if(ChartPeriod(0) == 60){Timeframe = 10;}
    if(ChartPeriod(0) == 240){Timeframe = 15;}
    if(ChartPeriod(0) == 1440){Timeframe = 20;}
    
int limit = Bars - IndicatorCounted()-1;
for(int i = limit; i >= 0; i--){  

      RSI1 = iRSI(NULL,0,RSIPeriod,PRICE_CLOSE,i); //毎ティックRSIの値を読み込んでRSI1に代入
               
      if(i == 0){
          Buffer_0[i] = EMPTY_VALUE;  //毎ティックサインを消している（条件が外れた時にはサイン表示を行わなくなるようにするため）   
          Buffer_1[i] = EMPTY_VALUE;                                 
      }
                
      if(i == 0){ 
          if(RSI1 <= rsidn){ //リアルタイムサイン表示条件文
                          Buffer_0[i] = iLow(NULL,0,i)-5*pips*Point;
                          if(i==0 && RealBars < Bars){Alert(Symbol()+" M"+Period()+" Real Time High"); RealBars = Bars;}                
          }
          
          if(RSI1 >= rsiup){ //リアルタイムサイン表示条件文   
                          Buffer_1[i] = iHigh(NULL,0,i)+10*pips*Point;
                          if(i==0 && RealBars < Bars){Alert(Symbol()+" M"+Period()+" Real Time Low"); RealBars = Bars;}
          }       
      }
          
      if(i > 1 || (i == 1 && NowBars < Bars)){ 
          NowBars = Bars;      
          a++; b++;
                 
          if(RSI1 <= rsidn){//確定足サイン表示条件文 （確定足にも条件を書くのは過去足にもサイン表示を行うため）        
                            Buffer_0[i] = iLow(NULL,0,i)-5*pips*Point;                        
          }

          
          if(RSI1 >= rsiup){//確定足サイン表示条件文                          
                            Buffer_1[i] = iHigh(NULL,0,i)+10*pips*Point;                      
          }             
               
          }       


}
   

   return(rates_total);
  }
//+------------------------------------------------------------------+
 int deinit(){
   return(0);
}// end of deinit()
