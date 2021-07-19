//+------------------------------------------------------------------+
//|    BS_ADX.mq4  ( Both Sides Average Directional Movement Index ) |
//|    Author: Takamitsu Gunji(郡司 隆充)   Date: 2014/5/1           |
//|                              Copyright(c) 2014, Takamitsu Gunji. |
//+------------------------------------------------------------------+
#property copyright "Copyright(c) 2014, Takamitsu Gunji."
#property link      "http://members3.jcom.home.ne.jp/tgunji/"
 
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Yellow            // ADX
#property indicator_color2 LimeGreen         // Plus DI
#property indicator_color3 Red               // Minus DI
#property indicator_color4 DarkTurquoise     // BS_ADX(Gunji考案)
#property indicator_width4 2 
//---- input parameters
extern int  AdxPeriod= 14;
extern bool ExistingAdxDisp= True;

       double AdxAlpha; 
//---- buffers
       double ADX_Buf[], PlusDi_Buf[], MinusDi_Buf[], BS_ADX_Buf[];
       double PlusSdi, MinusSdi;
       double EMAPlusDi=0, EMAMinusDi=0, EMA_ADX=0, EMA_BS_ADX=0;
       int    init_A=0, Bars1=0;
     
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {

   IndicatorBuffers(4);
//---- indicator buffers
   SetIndexBuffer(0,ADX_Buf);
   SetIndexBuffer(1,PlusDi_Buf);
   SetIndexBuffer(2,MinusDi_Buf);
   SetIndexBuffer(3,BS_ADX_Buf);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName( "BS_ADX"+" ("+AdxPeriod+")");
   SetIndexLabel(0,"ADX");
   SetIndexLabel(1,"+DI");
   SetIndexLabel(2,"-DI");
   SetIndexLabel(3,"BS_ADX");
//----
   SetIndexDrawBegin(0,AdxPeriod);
   SetIndexDrawBegin(1,AdxPeriod);
   SetIndexDrawBegin(2,AdxPeriod);
   SetIndexDrawBegin(3,AdxPeriod);

   AdxAlpha= 2./(1.+ AdxPeriod);

   return(0);
}

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() {
   Comment("");
   return(0);
}

//+------------------------------------------------------------------+
//| Both Sides Average Directional Movement Index                    |
//+------------------------------------------------------------------+
int start() {

   double pdm,mdm,tr, div, adx_i, num1, num2, num3;
   double price_high, price_low;
   int    i, limit, counted_bars=IndicatorCounted();

   limit=Bars-counted_bars;
   if( Bars== Bars1) return(0);
   Bars1= Bars;
   if( init_A==0 ) {
      init_A=1;
      PlusDi_Buf[limit+1]= 0; 
      MinusDi_Buf[limit+1]= 0; 
      ADX_Buf[limit+1]= 0;
   }
 
   for(i=limit; i>0; i--) {
      price_low=Low[i];
      price_high=High[i];
      //----
      pdm=price_high- High[i+1];
      mdm=Low[i+1]- price_low;
      if(pdm < 0) pdm= 0;  // +DM
      if(mdm < 0) mdm= 0;  // -DM
      if(pdm == mdm) { pdm= 0; mdm= 0; }
      else if(pdm < mdm) pdm= 0;
      else if(mdm < pdm) mdm= 0;

      //---- True Range
      num1= MathAbs( price_high - price_low );
      num2= MathAbs( price_high - Close[i+1] );
      num3= MathAbs( price_low - Close[i+1] );
      tr= MathMax( num1,num2 );
      tr= MathMax( tr,num3 );
      
      //---- counting plus/minus direction
      if(tr == 0) { PlusSdi= 0; MinusSdi=0; }
      else        { PlusSdi= 100.0 * pdm/tr; MinusSdi=100.0*mdm/tr; }

      //-- PlusSdi, MinusSdi のEMA 
      EMAPlusDi = EMAPlusDi*( 1- AdxAlpha) + PlusSdi* AdxAlpha;
      EMAMinusDi= EMAMinusDi*( 1- AdxAlpha) + MinusSdi* AdxAlpha;
      if( ExistingAdxDisp == True) {
         PlusDi_Buf[i]= EMAPlusDi;
         MinusDi_Buf[i]= EMAMinusDi;
      }

      div=MathAbs(EMAPlusDi+ EMAMinusDi);
      if(div <= 0.00) adx_i=0;
      else adx_i= 100*(MathAbs(EMAPlusDi- EMAMinusDi)/div);
      //--  EMA_ADX: ADX_Buf[i]     
      EMA_ADX= EMA_ADX*( 1- AdxAlpha) + adx_i * AdxAlpha;
      if( ExistingAdxDisp == True) ADX_Buf[i]= EMA_ADX;

      if( div <= 0 ) adx_i=0;
      else adx_i= 100*(EMAPlusDi- EMAMinusDi)/div;
      EMA_BS_ADX= EMA_BS_ADX*(1- AdxAlpha)+ adx_i*AdxAlpha;
      BS_ADX_Buf[i]= EMA_BS_ADX;
      
   }
   return(0);
}


