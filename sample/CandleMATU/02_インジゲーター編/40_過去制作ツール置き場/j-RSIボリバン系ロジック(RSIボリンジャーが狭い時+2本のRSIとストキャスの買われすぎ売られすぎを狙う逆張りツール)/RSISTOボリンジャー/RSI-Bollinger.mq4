//------------------------------------------------------------------
//
//------------------------------------------------------------------

#property strict
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 White
#property indicator_color2 DarkGreen
#property indicator_color3 DarkGreen
#property indicator_color4 DarkGreen
#property indicator_level1 70
#property indicator_level2 30
#property indicator_maximum 100
#property indicator_minimum 0

extern int    RSIPeriod     = 14;
extern int    BandPeriod    = 20;
extern double BandDeviation = 2.0;

double RSIBuf[],UpZone[],DnZone[],Ma[];


int init()
{
   IndicatorBuffers(4);
   SetIndexBuffer(0,RSIBuf);
   SetIndexBuffer(1,UpZone);
   //SetIndexStyle(1,DRAW_LINE);      
   SetIndexBuffer(2,DnZone);
   //SetIndexStyle(2,DRAW_LINE);   
   SetIndexBuffer(3,Ma);
   //SetIndexStyle(3,DRAW_LINE);
   return(0);
}
int deinit()
{

   return(0);
}


int start()
{
   int counted_bars=IndicatorCounted();
      if(counted_bars < 0) return(-1);
      if(counted_bars>0) counted_bars--;
         int limit = MathMin(Bars-counted_bars,Bars-1);
   
   for(int i=limit; i>=0; i--)
          RSIBuf[i] = iRSI(NULL,0,RSIPeriod,PRICE_CLOSE,i);
   for(int i=limit; i>=0; i--) 
   {
         double dev = iStdDevOnArray(RSIBuf,0,BandPeriod,0,MODE_SMA,i);
         Ma[i]     = iMAOnArray(RSIBuf,0,BandPeriod,0,MODE_SMA,i);
         UpZone[i] = Ma[i] + BandDeviation * dev;
         DnZone[i] = Ma[i] - BandDeviation * dev;  
   }
   return(0);
}
