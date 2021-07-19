//+------------------------------------------------------------------+
//|                                                      ATRBand.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 LightBlue
#property indicator_color2 Blue
#property indicator_color3 Blue

// 指標バッファ
double BufMain[];
double BufUpper[];
double BufLower[];

// 外部パラメータ
extern int ATRPeriod = 20;
extern double ATRMult = 2.0;

// 初期化関数
int init()
{
   // 指標バッファの割り当て
   SetIndexBuffer(0, BufMain);
   SetIndexBuffer(1, BufUpper);
   SetIndexBuffer(2, BufLower);

   // 指標ラベルの設定
   SetIndexLabel(0, "Main("+ATRPeriod+")");
   SetIndexLabel(1, "Upper("+DoubleToStr(ATRMult,1)+")");
   SetIndexLabel(2, "Lower("+DoubleToStr(ATRMult,1)+")");

   return(0);
}

// スタート関数
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      BufMain[i] = iBands(NULL, 0, ATRPeriod, 1, 0, PRICE_CLOSE, MODE_MAIN, i);
      double atr = iATR(NULL, 0, ATRPeriod, i) * ATRMult;
      BufUpper[i] = BufMain[i] + atr;
      BufLower[i] = BufMain[i] - atr;
   }

   return(0);
}

