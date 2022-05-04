//+------------------------------------------------------------------+
//|                                                     RSI_M1M5.mq4 |
//|                                                           TAKATO |
//|                                     https://twitter.com/botkttkt |
//+------------------------------------------------------------------+
#property copyright "TAKATO"
#property link      "https://twitter.com/botkttkt"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_minimum    0
#property indicator_maximum    100
#property indicator_level1     30.0
#property indicator_level2     70.0
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_DOT

#property indicator_buffers 3
#property indicator_plots   3

#property indicator_label1  "rsi1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDodgerBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

#property indicator_label2  "rsi5"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrWhite
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

#property indicator_label3  "rsired"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrRed
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1


double         rsi1Buffer[];
double         rsi5Buffer[];
double         rsiredBuffer[];

extern int kikan = 1000;//計算期間
extern int rsikikan = 9;//RSI期間

int OnInit()
  {
   SetIndexBuffer(0,rsi1Buffer);
   SetIndexBuffer(1,rsi5Buffer);
   SetIndexBuffer(2,rsiredBuffer);
   
   
   return(INIT_SUCCEEDED);
  }

int start()
  {
  int limit=0;
  limit=Bars-IndicatorCounted()-1;
   for(int i=kikan;i>=0;i--){//for文始め

   //1分足RSI
   if(iRSI(NULL,1,rsikikan,0,i)>=70 || iRSI(NULL,1,rsikikan,0,i)<=30){
   rsiredBuffer[i]=iRSI(NULL,1,rsikikan,0,i);
   rsi1Buffer[i]=EMPTY_VALUE;
   }
   else{
   rsiredBuffer[i]=EMPTY_VALUE;
   }
   
   rsi1Buffer[i]=iRSI(NULL,1,rsikikan,0,i);
   
   //5分足RSI
   for(int j=0;j<5/Period();j++){
   rsi5Buffer[i+j]=iRSI(NULL,5,rsikikan,0,iBarShift(NULL,5,Time[i+j]));
   }
   
   
   }//for文終わり
   

   return(0);
  }
  
int deinit(){
   ObjectDelete(0,"r1");
   ObjectDelete(0,"r5");
   return(0);
}
//+------------------------------------------------------------------+
