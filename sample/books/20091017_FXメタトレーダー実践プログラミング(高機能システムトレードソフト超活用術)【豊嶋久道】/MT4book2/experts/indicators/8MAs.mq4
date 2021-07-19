//+------------------------------------------------------------------+
//|                                                         8MAs.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Magenta
#property indicator_color2 Red
#property indicator_color3 Orange
#property indicator_color4 Gold
#property indicator_color5 LimeGreen
#property indicator_color6 Turquoise
#property indicator_color7 Blue
#property indicator_color8 BlueViolet

// 指標バッファ
double Buf0[];
double Buf1[];
double Buf2[];
double Buf3[];
double Buf4[];
double Buf5[];
double Buf6[];
double Buf7[];

// 外部パラメータ
extern int MAPeriod = 10;
extern int Diff = 10;
extern int Num = 8;

// 初期化関数
int init()
{
   // 指標バッファの割り当て
   SetIndexBuffer(0, Buf0);
   SetIndexBuffer(1, Buf1);
   SetIndexBuffer(2, Buf2);
   SetIndexBuffer(3, Buf3);
   SetIndexBuffer(4, Buf4);
   SetIndexBuffer(5, Buf5);
   SetIndexBuffer(6, Buf6);
   SetIndexBuffer(7, Buf7);

   IndicatorBuffers(Num); 

   return(0);
}

// スタート関数
int start()
{
   int limit = Bars-IndicatorCounted();

   for(int i=limit-1; i>=0; i--)
   {
      Buf0[i] = iMA(NULL, 0, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf1[i] = iMA(NULL, 0, MAPeriod+Diff, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf2[i] = iMA(NULL, 0, MAPeriod+Diff*2, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf3[i] = iMA(NULL, 0, MAPeriod+Diff*3, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf4[i] = iMA(NULL, 0, MAPeriod+Diff*4, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf5[i] = iMA(NULL, 0, MAPeriod+Diff*5, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf6[i] = iMA(NULL, 0, MAPeriod+Diff*6, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf7[i] = iMA(NULL, 0, MAPeriod+Diff*7, 0, MODE_SMA, PRICE_CLOSE, i);
   }

   return(0);
}

