//+------------------------------------------------------------------+
//|                                          AdamPriceReflection.mq4 |
//|                           Copyright (c) 2010, Fai Software Corp. |
//|                                    http://d.hatena.ne.jp/fai_fx/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2010, Fai Software Corp."
#property link      "http://d.hatena.ne.jp/fai_fx/"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_width1 1
#property indicator_style1 0
#property indicator_color2 DeepSkyBlue
#property indicator_width2 1
#property indicator_style2 2

//---- input parameters
extern int Length=60;
extern int Shift = 1;
extern bool UseFirst = false;

extern bool RePaint = true;

double apr[],apr2[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0,apr);
   SetIndexShift(0,Length-Shift);
   
   SetIndexBuffer(1,apr2);
   SetIndexShift(1,Length-Shift);
   if(!UseFirst){
      SetIndexStyle(1,DRAW_NONE);
   }else{
      SetIndexStyle(1,DRAW_LINE);
   }
   SetIndexLabel(0,NULL);
   SetIndexLabel(1,NULL);
   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   static bool draw = false;
   if(RePaint==false && draw == true) return(0);
   draw = true;
   int i;
   
   for(i=Bars-1;i>Length;i--){
      apr[i]=EMPTY_VALUE;
      apr2[i]=EMPTY_VALUE;
   }
   for(i=Length;i>=0;i--){
      apr[i]=Close[Shift]+(Close[Shift]-Close[Length+Shift-i]);
      apr2[i]=Close[Length+Shift-i];
   }

   return(0);
  }
//+------------------------------------------------------------------+