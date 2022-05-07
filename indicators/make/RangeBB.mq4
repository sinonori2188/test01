//+------------------------------------------------------------------+
//|                                                      RangeBB.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
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
int NowBars,limit;
bool EntryFlag=false;
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

   return(INIT_SUCCEEDED);
  }

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
   limit = Bars-IndicatorCounted()-1;
   for(int i = limit; i >= 0; i--)
     {
      double MABAND=iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,i);
      double UPBAND=iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,i);
      double LOWBAND=iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,i);
      double RSI=iRSI(NULL,0,14,0,i);
      double MACD=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,i);

      //買いシグナル
      if(EntryFlag==false)
        {
         if(MACD>0 && RSI>40 && RSI<60 && iOpen(NULL,0,i)>LOWBAND && iLow(NULL,0,i)<=LOWBAND)
           {
            Buffer_0[i] = LOWBAND-20*Point;
            
            //EntryFlag=true;
           }


         if(MACD<0 && RSI>40 && RSI<60 && iOpen(NULL,0,i)<UPBAND &&iHigh(NULL,0,i)>=UPBAND)
           {
            Buffer_1[i] = UPBAND+20*Point;
            //EntryFlag=true;
           }

        }
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
