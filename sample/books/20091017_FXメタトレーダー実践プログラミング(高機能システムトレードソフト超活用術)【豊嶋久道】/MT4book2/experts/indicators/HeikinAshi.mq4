//+------------------------------------------------------------------+
//|                                                   HeikinAshi.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_width1 3
#property indicator_width2 3

// 指標バッファ
double BufOpen[];
double BufClose[];

// 初期化関数
int init()
{
   // 指標バッファの割り当て
   SetIndexBuffer(0, BufOpen);
   SetIndexBuffer(1, BufClose);

   // 指標ラベルの設定
   SetIndexLabel(0,"haOpen");
   SetIndexLabel(1,"haClose");

   // 指標スタイルの設定
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexStyle(1, DRAW_HISTOGRAM);

   return(0);
}

// スタート関数
int start()
{
   int limit=Bars-IndicatorCounted();

   for(int i=limit-1; i>=0; i--)
   {
      if(i == Bars-1) BufOpen[i] = (Open[i]+High[i]+Low[i]+Close[i])/4;
      else BufOpen[i] = (BufOpen[i+1]+BufClose[i+1])/2;
      BufClose[i] = (Open[i]+High[i]+Low[i]+Close[i])/4;
   }

   return(0);
}

