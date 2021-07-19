//compile//
//+------------------------------------------------------------------+
//|                                       EMA_58_Crossover_Alert.mq4 |
//|                         Copyright © 2006, Robert Hill            |
//|                                                                  |
//| Written Robert Hill for use with AIME for the EMA 5/8 cross to   |
//| draw arrows and popup alert or send email                        |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2006, Robert Hill"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 LawnGreen
#property indicator_color2 Red
#property indicator_color3 Red
#property indicator_color4 Aqua
#property indicator_color5 Yellow
#property indicator_width1  2
#property indicator_width2  2
#property indicator_width3  2
#property indicator_width4  2
#property indicator_width5  2

extern bool SoundON=true;
extern bool EmailON=false;

double CrossUp[];
double CrossDown[];
double Ema5[];
double Ema8[];
double Ema20[];
int flagval1 = 0;
int flagval2 = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID);
   SetIndexBuffer(2, Ema5);
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID);
   SetIndexBuffer(3, Ema8);
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID);
   SetIndexBuffer(4, Ema20);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 

//----
   return(0);
  }


//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   int limit, i, counter;
   double tmp=0;
   double fastMAnow, slowMAnow, fastMAprevious, slowMAprevious;
   double Range, AvgRange;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;
   
   for(i = 1; i <= limit; i++) {
   
      counter=i;
      Range=0;
      AvgRange=0;
      for (counter=i ;counter<=i+9;counter++)
      {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
      }
      Range=AvgRange/10;
       
      fastMAnow = iMA(NULL, 0, 5, -1, MODE_EMA, PRICE_CLOSE, i);
      fastMAprevious = iMA(NULL, 0, 5, -1, MODE_EMA, PRICE_CLOSE, i+1);

      slowMAnow = iMA(NULL, 0, 8, 0, MODE_EMA, PRICE_OPEN, i);
      slowMAprevious = iMA(NULL, 0, 8, 0, MODE_EMA, PRICE_OPEN, i+1);
      
      Ema20[i] = iMA(NULL, 0, 20, 0, MODE_EMA, PRICE_CLOSE, i);
      Ema5[i] = fastMAnow;
      Ema8[i] = slowMAnow;
      CrossUp[i] = 0;
      CrossDown[i] = 0;
      if ((fastMAnow > slowMAnow) && (fastMAprevious < slowMAprevious))
      {
         if (i == 1 && flagval1==0)
         {
           flagval1=1;
           flagval2=0;
           if (SoundON) Alert("BUY signal at Ask=",Ask,"\n Bid=",Bid,"\n Time=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime()),"\n Symbol=",Symbol()," Period=",Period());
           if (EmailON) SendMail("BUY signal alert","BUY signal at Ask="+DoubleToStr(Ask,4)+", Bid="+DoubleToStr(Bid,4)+", Date="+TimeToStr(CurTime(),TIME_DATE)+" "+TimeHour(CurTime())+":"+TimeMinute(CurTime())+" Symbol="+Symbol()+" Period="+Period());
         }
         CrossUp[i] = Low[i] - Range*0.75;
      }
      else if ((fastMAnow < slowMAnow) && (fastMAprevious > slowMAprevious))
      {
         if (i == 1 && flagval2==0)
         {
          flagval2=1;
          flagval1=0;
         if (SoundON) Alert("SELL signal at Ask=",Ask,"\n Bid=",Bid,"\n Date=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime()),"\n Symbol=",Symbol()," Period=",Period());
         if (EmailON) SendMail("SELL signal alert","SELL signal at Ask="+DoubleToStr(Ask,4)+", Bid="+DoubleToStr(Bid,4)+", Date="+TimeToStr(CurTime(),TIME_DATE)+" "+TimeHour(CurTime())+":"+TimeMinute(CurTime())+" Symbol="+Symbol()+" Period="+Period());
         }
         CrossDown[i] = High[i] + Range*0.75;
      }
   }

   return(0);
}

