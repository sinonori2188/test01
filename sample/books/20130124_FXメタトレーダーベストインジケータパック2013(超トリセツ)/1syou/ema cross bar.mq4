//+------------------------------------------------------------------+
//| ema cross bar.mq4                                                |
//+------------------------------------------------------------------+

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red

//---- input parameters
extern int fastperiod=8;
extern int slowperiod=21;

//---- buffers
double val1[];
double val2[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator line
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_HISTOGRAM,0,2);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(0,val1);
   SetIndexBuffer(1,val2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| ema cross                                                        |
//+------------------------------------------------------------------+
int start()
  {
   int i,shift,counted_bars=IndicatorCounted();
   double fastEma, slowEma;
   for (shift = counted_bars; shift>=0; shift--)
{ 

fastEma = iMA(NULL,0,fastperiod,0,MODE_EMA,PRICE_MEDIAN,i); 
slowEma = iMA(NULL,0,slowperiod,0,MODE_EMA,PRICE_MEDIAN,i); 
	val1[shift]=0;
	val2[shift]=0;
	if (fastEma>slowEma)
		{
		val1[shift]=Low[shift]; 
		val2[shift]=High[shift];
		}
	if (fastEma<slowEma)
		{
		val1[shift]=High[shift]; 
		val2[shift]=Low[shift];
		}

}
   return(0);
  }
//+------------------------------------------------------------------+