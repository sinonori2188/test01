//+------------------------------------------------------------------+
//|                                                Psychological.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "keiji"
#property link      ""

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 1
#property indicator_color1 Yellow

extern int Psycho_Period=12;

//---- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
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
int start()
  {
//----
   int i,j, limit=Bars-IndicatorCounted();

   for(i=limit-1; i>=0; i--)
   {
      ExtMapBuffer1[i] =0;
      for(j=0; j<Psycho_Period; j++)
      {
         if(Close[i+j]>Close[i+j+1]) ExtMapBuffer1[i]+=100;
         if(Close[i+j]==Close[i+j+1]) ExtMapBuffer1[i]+=50;
      }
      ExtMapBuffer1[i] /=Psycho_Period;
   }

//----
   return(0);
  }
//+------------------------------------------------------------------+