#property copyright "Copyright(C) 2018, ands"
#property version "1.0"
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_width1 5
#property indicator_style1 0
#property indicator_color1 C'254,1,46'
#property indicator_width2 5
#property indicator_style2 0
#property indicator_color2 C'255,255,255'
#property indicator_width3 5
#property indicator_style3 0
#property indicator_color3 C'255,128,0'
#property indicator_width4 5
#property indicator_style4 0
#property indicator_color4 C'0,128,255'
#property indicator_width5 5
#property indicator_style5 0
#property indicator_color5 C'255,128,255'
#property indicator_width6 5
#property indicator_style6 0
#property indicator_color6 C'0,255,255'

double dBuffer_0[];
double dBuffer_1[];
double dBuffer_2[];
double dBuffer_3[];
double dBuffer_4[];
double dBuffer_5[];

#define INDIVAL_CNT 15


int init(){
   IndicatorBuffers(6);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexShift(0,0);
   SetIndexBuffer(0,dBuffer_0);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexShift(1,0);
   SetIndexBuffer(1,dBuffer_1);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexShift(2,0);
   SetIndexBuffer(2,dBuffer_2);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexShift(3,0);
   SetIndexBuffer(3,dBuffer_3);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexShift(4,0);
   SetIndexBuffer(4,dBuffer_4);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexShift(5,0);
   SetIndexBuffer(5,dBuffer_5);
   return(0);
}

int start(){
   int limit;
   int pos;
   int timepos;
   int ExtCountedBars;
   int i;
   double dIndiVal[INDIVAL_CNT];
   static double dCalc[10][2];

   double dPoint = Point;
   if( Digits==3 || Digits==5 ) dPoint = Point * 10;

   ExtCountedBars = IndicatorCounted();
   if( ExtCountedBars < 0 ) return(-1);
   if( ExtCountedBars > 0 ) ExtCountedBars--;
   limit = Bars-ExtCountedBars-1;
   for( pos=limit; pos>=0; pos-- ){
      timepos = iBarShift(NULL,PERIOD_M15,Time[pos+1],false);
      dIndiVal[0] = iMA(NULL,PERIOD_M15,10,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_M15,Time[pos+1],false);
      dIndiVal[1] = iMA(NULL,PERIOD_M15,20,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_M15,Time[pos+1],false);
      dIndiVal[2] = iMA(NULL,PERIOD_M15,75,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_M15,Time[pos+1],false);
      dIndiVal[3] = iMA(NULL,PERIOD_M15,100,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_M15,Time[pos+1],false);
      dIndiVal[4] = iMA(NULL,PERIOD_M15,200,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_H1,Time[pos],false);
      dIndiVal[5] = iMA(NULL,PERIOD_H1,10,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_H1,Time[pos],false);
      dIndiVal[6] = iMA(NULL,PERIOD_H1,20,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_H1,Time[pos],false);
      dIndiVal[7] = iMA(NULL,PERIOD_H1,75,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_H1,Time[pos],false);
      dIndiVal[8] = iMA(NULL,PERIOD_H1,100,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_H1,Time[pos],false);
      dIndiVal[9] = iMA(NULL,PERIOD_H1,200,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_M5,Time[pos],false);
      dIndiVal[10] = iMA(NULL,PERIOD_M5,10,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_M5,Time[pos],false);
      dIndiVal[11] = iMA(NULL,PERIOD_M5,20,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_M5,Time[pos],false);
      dIndiVal[12] = iMA(NULL,PERIOD_M5,75,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_M5,Time[pos],false);
      dIndiVal[13] = iMA(NULL,PERIOD_M5,100,0,0,0,timepos);
      timepos = iBarShift(NULL,PERIOD_M5,Time[pos],false);
      dIndiVal[14] = iMA(NULL,PERIOD_M5,200,0,0,0,timepos);

      if( dIndiVal[0] < dIndiVal[1] ){
         if( dIndiVal[1] < dIndiVal[2] ){
            if( dIndiVal[2] < dIndiVal[3] ){
               if( dIndiVal[3] < dIndiVal[4] ){
                  dBuffer_0[pos] = iHigh(NULL,0,pos);
               }
            }
         }
      }
      if( dIndiVal[0] > dIndiVal[1] ){
         if( dIndiVal[1] > dIndiVal[2] ){
            if( dIndiVal[2] > dIndiVal[3] ){
               if( dIndiVal[3] > dIndiVal[4] ){
                  dBuffer_1[pos] = iHigh(NULL,0,pos);
               }
            }
         }
      }
      if( dIndiVal[5] < dIndiVal[6] ){
         if( dIndiVal[6] < dIndiVal[7] ){
            if( dIndiVal[7] < dIndiVal[8] ){
               if( dIndiVal[8] < dIndiVal[9] ){
                  dCalc[0][0] = -1;
                  dCalc[0][1] = iHigh(NULL,0,pos) - (50 * dPoint);
                  if( dCalc[0][0] != 0 ){
                     dBuffer_2[pos] =  dCalc[0][1];
                  }
               }
            }
         }
      }
      if( dIndiVal[5] > dIndiVal[6] ){
         if( dIndiVal[6] > dIndiVal[7] ){
            if( dIndiVal[7] > dIndiVal[8] ){
               if( dIndiVal[8] > dIndiVal[9] ){
                  if( dCalc[0][0] != 0 ){
                     dBuffer_3[pos] =  dCalc[0][1];
                  }
               }
            }
         }
      }
      if( dIndiVal[10] < dIndiVal[11] ){
         if( dIndiVal[11] < dIndiVal[12] ){
            if( dIndiVal[12] < dIndiVal[13] ){
               if( dIndiVal[13] < dIndiVal[14] ){
                  dCalc[1][0] = -1;
                  dCalc[1][1] = iHigh(NULL,0,pos) - (100 * dPoint);
                  if( dCalc[1][0] != 0 ){
                     dBuffer_4[pos] =  dCalc[1][1];
                  }
               }
            }
         }
      }
      if( dIndiVal[10] > dIndiVal[11] ){
         if( dIndiVal[11] > dIndiVal[12] ){
            if( dIndiVal[12] > dIndiVal[13] ){
               if( dIndiVal[13] > dIndiVal[14] ){
                  if( dCalc[1][0] != 0 ){
                     dBuffer_5[pos] =  dCalc[1][1];
                  }
               }
            }
         }
      }
   }

   return(0);
}

int deinit(){
   return(0);
}

