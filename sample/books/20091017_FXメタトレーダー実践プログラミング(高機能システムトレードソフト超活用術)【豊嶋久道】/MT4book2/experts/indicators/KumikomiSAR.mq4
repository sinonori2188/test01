//+------------------------------------------------------------------+
//|                                                  KumikomiSAR.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Blue

// 指標バッファ
double BufSAR[];

// 外部パラメータ
extern double Step = 0.02;
extern double Maximum = 0.2;

// 初期化関数
int init()
{
   // 指標バッファの割り当て
   SetIndexBuffer(0,BufSAR);

   // 指標ラベルの設定
   SetIndexLabel(0, "SAR("+DoubleToStr(Step,2)+","+DoubleToStr(Maximum,1)+")");

   // 指標スタイルの設定
   SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID, 1, Blue);
   SetIndexArrow(0, 159);

   return(0);
}

// スタート関数
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      BufSAR[i] = iSAR(NULL, 0, Step, Maximum, i);
   }

   return(0);
}

