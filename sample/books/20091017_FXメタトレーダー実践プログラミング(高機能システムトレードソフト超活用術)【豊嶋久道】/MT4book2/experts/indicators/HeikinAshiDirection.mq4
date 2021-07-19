//+------------------------------------------------------------------+
//|                                          HeikinAshiDirection.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_width1 3
#property indicator_width2 3
#property indicator_minimum 0
#property indicator_maximum 1

// 指標バッファ
double BufUp[];
double BufDown[];

// 初期化関数
int init()
{
   // 指標バッファの割り当て
   SetIndexBuffer(0, BufUp);
   SetIndexBuffer(1, BufDown);

   // 指標ラベルの設定
   SetIndexLabel(0, "Up");
   SetIndexLabel(1, "Down");

   // 指標スタイルの設定
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexStyle(1, DRAW_HISTOGRAM);

   return(0);
}

// スタート関数
int start()
{
   int limit = Bars-IndicatorCounted();

   for(int i=limit-1; i>=0; i--)
   {
      double valOpen = iCustom(NULL, 0, "HeikinAshi", 0, i);
      double valClose = iCustom(NULL, 0, "HeikinAshi", 1, i);

      BufUp[i] = 0; BufDown[i] = 0;
      if(valClose > valOpen) BufUp[i] = 1; //陽線の場合
      else if(valClose < valOpen) BufDown[i] = 1; //陰線の場合
   }

   return(0);
}

