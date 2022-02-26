//+------------------------------------------------------------------+
//|                                                         8MAs.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"
#property strict    //外部パラメーターのコメントを日本語化する場合にも必要

#property indicator_chart_window
#property indicator_buffers 9
#property indicator_color1 Magenta
#property indicator_color2 LimeGreen
#property indicator_color3 Orange
#property indicator_color4 Gold
#property indicator_color6 Turquoise
#property indicator_color7 Blue
#property indicator_color8 BlueViolet
#property indicator_color9 Red

//描画する線の情報を指定する。
#property indicator_label5 "TickVolume"
#property indicator_type5  DRAW_LINE
#property indicator_color5 clrAqua
#property indicator_style5 STYLE_SOLID
#property indicator_width5 5

// 指標バッファ
double Buf0[];
double Buf1[];
double Buf2[];
double Buf3[];
double Buf4[];
double Buf5[];
double Buf6[];
double Buf7[];
double Buf8[];

// ----- 外部パラメータ ----- //
// externは、プログラム内部で変更可
extern int MAPeriod = 10;   // 計算期間
extern int Diff     = 4;    // MA計算期間乗数
// inputはプログラム内部で変更不可
input  int Num      = 9;    // バッファ数定義

//+------------------------------------------------------------------+
//| 初期化関数                                                        |
//+------------------------------------------------------------------+
int OnInit()
{
   // バッファの追加
   IndicatorBuffers(Num);

   // 指標バッファの割り当て
   SetIndexBuffer(0, Buf0);
   SetIndexBuffer(1, Buf1);
   SetIndexBuffer(2, Buf2);
   SetIndexBuffer(3, Buf3);
   SetIndexBuffer(4, Buf4);
   SetIndexBuffer(5, Buf5);
   SetIndexBuffer(6, Buf6);
   SetIndexBuffer(7, Buf7);
   SetIndexBuffer(8, Buf8);

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
   int limit = Bars-IndicatorCounted();

   for(int i=limit-1; i>=0; i--)
   {
      Buf0[i] = iMA(NULL, PERIOD_CURRENT, MAPeriod+Diff*0, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf1[i] = iMA(NULL, PERIOD_CURRENT, MAPeriod+Diff*1, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf2[i] = iMA(NULL, PERIOD_CURRENT, MAPeriod+Diff*2, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf3[i] = iMA(NULL, PERIOD_CURRENT, MAPeriod+Diff*3, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf4[i] = iMA(NULL, PERIOD_CURRENT, MAPeriod+Diff*4, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf5[i] = iMA(NULL, PERIOD_CURRENT, MAPeriod+Diff*5, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf6[i] = iMA(NULL, PERIOD_CURRENT, MAPeriod+Diff*6, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf7[i] = iMA(NULL, PERIOD_CURRENT, MAPeriod+Diff*7, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf8[i] = iMA(NULL, PERIOD_CURRENT, MAPeriod+Diff*8, 0, MODE_SMA, PRICE_CLOSE, i);
   }

   //--- return value of prev_calculated for next call
   return(rates_total);
}

