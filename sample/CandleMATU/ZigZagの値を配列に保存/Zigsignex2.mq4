//+------------------------------------------------------------------+
//|                                                      Zigsign.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
//#include <include/osime_modosime.mqh>

#property indicator_width1 3
#property indicator_color1 Red
#property indicator_width2 3
#property indicator_color2 Aqua



double Buffer_0[];
double Buffer_1[];


int OnInit()
  {
   IndicatorBuffers(2);
   SetIndexBuffer(0,Buffer_0);
   SetIndexStyle(0,DRAW_ARROW); 
   SetIndexArrow(0,233);//上
     
   SetIndexBuffer(1,Buffer_1);  
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,234);//下

   
   return(INIT_SUCCEEDED);
  }
  
  extern int Depth = 5; 
  extern int Deviation = 3; 
  extern int Backstep = 3; 
  //extern int pastbars = 500;//読み込み本数
  extern double pips = 1.0;//サイン表示位置調整
 
 
 int NowBars= 0; 
 double zigup,zigdn; 
 double r,r1,r2,r3,r4,r5,rhekin,now,rhige,bouzu;
 

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
  
//---

int limit = Bars - IndicatorCounted()-1;
  
//直近100本のzigzagの高値安値を取得が現在足で高安が3回連続で更新したらサイン        
         
      if( NowBars < Bars ){ 
          NowBars = Bars;
       
int a=0;
int b=0; 
double zighp[100],ziglp[100];   //zighp0,zighp1,zighp3///  
  
ArrayInitialize(zighp,EMPTY_VALUE);
ArrayInitialize(ziglp,EMPTY_VALUE);

double zigup1 = iCustom(Symbol(),0,"ZigZag",Depth,Deviation,Backstep,0,1);
double zigdn1 = iCustom(Symbol(),0,"ZigZag",Depth,Deviation,Backstep,0,1);
  
  for(int i = 1; i <= 100; i++){ 

      zigup = iCustom(Symbol(),0,"ZigZag",Depth,Deviation,Backstep,0,i);
      zigdn = iCustom(Symbol(),0,"ZigZag",Depth,Deviation,Backstep,0,i);
      if(zigup == iHigh(NULL,0,i)){
               zighp[a] = iHigh(NULL,0,i);
               a++;  
              } 
              
      if(zigdn == iLow(NULL,0,i)){
               ziglp[b] = iLow(NULL,0,i);
               b++;
               } 
      } //for
 
 //サインを出す式
      
      if(a>=2){
       
       if(ziglp[0]<ziglp[1] && ziglp[1]<ziglp[2] && zigup1==low[1]){
                 Buffer_0[1] = iLow(NULL,0,1)-pips*5*Point;
                 //if(i==1){Alert(Symbol()+" M"+Period()+"ZigZag High Sign");}   
             }
             }
      if(b>=2){ 
       if(zighp[0]>zighp[1]&&zighp[1]>zighp[2] && zigdn1==high[1]){
                 Buffer_1[1] = iHigh(NULL,0,1)+pips*10*Point;
                 //if(i==1){Alert(Symbol()+" M"+Period()+"ZigZag Low Sign");}                
             }  
             }
                 
           }                
//--- return value of prev_calculated for next call

   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
