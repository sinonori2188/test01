//+------------------------------------------------------------------+
//|                                                    LineAlert.mq4 |
//|                                              Copyright 2019 ands |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019 ands"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2

#property indicator_width1 3
#property indicator_color1 Red
#property indicator_width2 3
#property indicator_color2 Aqua


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
  IndicatorBuffers(2);
   
SetIndexBuffer(0,Buffer_0);
SetIndexStyle(0,DRAW_ARROW); 
SetIndexArrow(0,241);
     
SetIndexBuffer(1,Buffer_1);  
SetIndexStyle(1,DRAW_ARROW);
SetIndexArrow(1,242);
//--- indicator buffers mapping
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int NowBars=0;
double hline,tline;
double Buffer_0[];
double Buffer_1[];
bool flag1, flag2 = false;

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
   int i;



   for(i = 0; i <= ObjectsTotal()-1; i++) {
          string ObjName0=ObjectName(i);
          if(StringFind(ObjName0, "Horizontal",0) != -1){//水平ラインを識別した時
                  hline = ObjectGetDouble(0, ObjName0, OBJPROP_PRICE);   

                  if((iClose(NULL,0,0) <= hline && iOpen(NULL,0,0) > hline) && Bid < hline && flag1 == false){ //水平ライン下に抜けた時
                      if(NowBars < Bars){                  
                          Alert(Symbol()+" M"+Period()+" Line Touch !!");
                          Buffer_0[0] = Bid -10*Point;
                          flag1 = true;
                          PlaySound("alert.wav");
                          NowBars = Bars;
                      }
                  }    
                 if((iClose(NULL,0,0) >= hline && iOpen(NULL,0,0) < hline) && Bid > hline && flag1 == false){ //水平ラインの上に抜けた時 
                      if(NowBars < Bars){                  
                          Alert(Symbol()+" M"+Period()+" Line Touch !!");
                          Buffer_1[0] = Bid +10*Point;
                          flag1 = true;
                          PlaySound("alert.wav");
                          NowBars = Bars;
                      }
                  }                               
          }

          if(StringFind(ObjName0, "Trend",0) != -1){//トレンドラインを識別した時
           
           tline = ObjectGetValueByShift(ObjName0,0);
           
                 // tline = ObjectGetDouble(0, ObjName0, OBJPROP_PRICE);//現在の足でのトレンドラインの価格   

                  if((iOpen(NULL,0,0) >= tline && iClose(NULL,0,0) < tline) && Bid < tline && flag2 == false){ //トレンドライン下に抜けた時
                      if(NowBars < Bars){                  
                          Alert(Symbol()+" M"+Period()+" Line Touch !!");
                          Buffer_0[0] = Bid -10*Point;
                          flag2 = true;
                          PlaySound("alert.wav");
                          NowBars = Bars;
                      }
                  }    
                 if((iOpen(NULL,0,0) <= tline && iClose(NULL,0,0) > tline) && Bid > tline && tline && flag2 == false){ //トレンドラインの上に抜けた時 
                      if(NowBars < Bars){                  
                          Alert(Symbol()+" M"+Period()+" Line Touch !!");
                          Buffer_1[0] = Bid +10*Point;
                          flag2 = true;
                          PlaySound("alert.wav");
                          NowBars = Bars;
                      }
                  }                               
          }          
          
          
   }     
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
