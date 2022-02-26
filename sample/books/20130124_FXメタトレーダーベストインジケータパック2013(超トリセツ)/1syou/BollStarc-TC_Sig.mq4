//+------------------------------------------------------------------+
//| BOLLINGER+STARC (BollStarc-TC.mq4)                                    |
//| Copyright © 2006                                                 |
//| http://www.                                                      |
//+------------------------------------------------------------------+
//+sigArrows
#property copyright "Copyright © 2006, "
#property link "http://www.   "

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 DimGray // Starc midband
#property indicator_color2 Yellow //Starc upper
#property indicator_color3 Yellow
#property indicator_color4 RoyalBlue //BBupper
#property indicator_color5 RoyalBlue


#property indicator_color6 Blue 
#property indicator_color7 Red
#property indicator_color8 Orange

#property  indicator_width6  1
#property  indicator_width7  1
#property  indicator_width8  2

//---- indicator parameters
extern int BB_Period=20;
extern int BB_Deviations=2;
extern int MA_Period=13; //6
extern int ATR_Period=21; //15
extern double KATR=2;
extern int Shift=0; //1
extern double ArrowDistance =0.3;


//---- buffers
double MovingBuffer[];
double UpperBuffer[];
double LowerBuffer[];

double ExtMapBuffer1[];
double ExtMapBuffer2[];


double SigBufferUp[];
double SigBufferDn[];
double SigBufferWarn[];
double SigDistance;



//+------------------------------------------------------------------+
//| Custom indicator initialization function |
//+------------------------------------------------------------------+
int init()
{
  //---- indicators
  SetIndexStyle(0,DRAW_LINE,0,1);
  SetIndexBuffer(0,MovingBuffer);
  SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1);
  SetIndexBuffer(1,UpperBuffer);
  SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,1);
  SetIndexBuffer(2,LowerBuffer);
  //----
  SetIndexDrawBegin(0,MA_Period+Shift);
  SetIndexDrawBegin(1,ATR_Period+Shift);
  SetIndexDrawBegin(2,ATR_Period+Shift);
  //---- BB start
  SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,1);
  SetIndexBuffer(3,ExtMapBuffer1);
  SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,1);
  SetIndexBuffer(4,ExtMapBuffer2);
  //---- 
  SetIndexDrawBegin(3,BB_Period);
  SetIndexDrawBegin(4,BB_Period);
  //---- BB ends

    SetIndexEmptyValue(0,EMPTY_VALUE);
    SetIndexEmptyValue(1,EMPTY_VALUE);
    SetIndexEmptyValue(2,EMPTY_VALUE);
    SetIndexEmptyValue(3,EMPTY_VALUE);
    SetIndexEmptyValue(4,EMPTY_VALUE);
    SetIndexEmptyValue(5,EMPTY_VALUE);
    SetIndexEmptyValue(6,EMPTY_VALUE);
    SetIndexEmptyValue(7,EMPTY_VALUE);
 
 
   SetIndexBuffer(5,SigBufferUp);
   SetIndexStyle(5, DRAW_ARROW);
   SetIndexArrow(5, 241);//233221

   SetIndexBuffer(6,SigBufferDn);
   SetIndexStyle(6, DRAW_ARROW);
   SetIndexArrow(6, 242);//234221

   SetIndexBuffer(7,SigBufferWarn);
   SetIndexStyle(7, DRAW_ARROW);
   SetIndexArrow(7, 159);//115167244221  

  return(0);
}

//+------------------------------------------------------------------+
//| Bollinger+STARC Bands                                                      |
//+------------------------------------------------------------------+
int start()
{
  int i,k,counted_bars=IndicatorCounted();
  
  //----
 // if(Bars<=MA_Period) return(0);
  
  //---- initial zero
//  if(counted_bars<1)
//  for(k=1;k<=MA_Period;k++)
//  {
//    MovingBuffer[Bars-k]=EMPTY_VALUE;
//    UpperBuffer[Bars-k]=EMPTY_VALUE;
//    LowerBuffer[Bars-k]=EMPTY_VALUE;
//    ExtMapBuffer1[Bars-k]=EMPTY_VALUE;
//    ExtMapBuffer2[Bars-k]=EMPTY_VALUE;
 // }
  
  //----

  
     if(counted_bars<0) return(-1);
   
     if(counted_bars>0) counted_bars--;
     int  limit=Bars-counted_bars;

   for(i=limit; i>=0; i--)
//  if(counted_bars>0) limit++;
 // for(i=0; i<limit; i++)
  {
    //STARC Bands
    MovingBuffer[i] = iMA(NULL,0,MA_Period,Shift,MODE_EMA,PRICE_CLOSE,i);
    UpperBuffer[i] = MovingBuffer[i] + (KATR * iATR(NULL,0,ATR_Period,i+Shift));
    LowerBuffer[i] = MovingBuffer[i] - (KATR * iATR(NULL,0,ATR_Period,i+Shift));
    //BBands
    ExtMapBuffer1[i]=iBands(NULL,0,BB_Period,BB_Deviations,0,PRICE_CLOSE,MODE_UPPER,i);
    ExtMapBuffer2[i]=iBands(NULL,0,BB_Period,BB_Deviations,0,PRICE_CLOSE,MODE_LOWER,i);
 
           SigDistance = ArrowDistance*(KATR * iATR(NULL,0,ATR_Period,i+Shift));

 
   SigBufferUp [i] = EMPTY_VALUE;
   SigBufferDn [i] = EMPTY_VALUE;
   SigBufferWarn[i]= EMPTY_VALUE;
   


      if  ( ExtMapBuffer1[i+1]<UpperBuffer[i+1]&& ExtMapBuffer2[i+1]>=LowerBuffer[i+1]&&
            ExtMapBuffer2[i]<LowerBuffer[i]&& MovingBuffer[i+1]<MovingBuffer[i] )
  
           {
           SigBufferUp [i] = ExtMapBuffer2[i]-SigDistance;
            
            
            if (i==0)  SigBufferWarn[i]  = SigBufferUp[i];
            else       SigBufferWarn[i] = EMPTY_VALUE;
            
            }
 
  
      if  ( ExtMapBuffer1[i+1]<=UpperBuffer[i+1]&& ExtMapBuffer2[i+1]>LowerBuffer[i+1]&&
            ExtMapBuffer1[i]>UpperBuffer[i]&& MovingBuffer[i+1]>MovingBuffer[i])
            {
            SigBufferDn [i] = ExtMapBuffer1[i]+SigDistance;
 //           {SigBufferDn [i] = ExtMapBuffer1[i];
            
             if (i==0)  SigBufferWarn[i] = SigBufferDn[i];
             else       SigBufferWarn[i] = EMPTY_VALUE;
            }
 
   
  }
  
  //----
  return(0);
}

//+-----------------------------------------------------------------+