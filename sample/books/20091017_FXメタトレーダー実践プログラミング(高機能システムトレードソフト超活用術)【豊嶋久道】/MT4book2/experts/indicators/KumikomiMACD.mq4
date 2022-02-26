//+------------------------------------------------------------------+
//|                                                 KumikomiMACD.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Silver
#property indicator_color2 Red

// 指標バッファ
double BufMACD[];
double BufSignal[];

// 外部パラメータ
extern int FastEMA = 12;
extern int SlowEMA = 26;
extern int SignalSMA = 9;

// 初期化関数
int init()
{
   // 指標バッファの割り当て
   SetIndexBuffer(0, BufMACD);
   SetIndexBuffer(1, BufSignal);

   // 指標スタイルの設定
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexStyle(1, DRAW_LINE, STYLE_DOT);
   
   // 指標ラベルの設定
   SetIndexLabel(0, "MACD("+FastEMA+","+SlowEMA+")");
   SetIndexLabel(1, "Signal("+SignalSMA+")");
   IndicatorShortName("MACD("+FastEMA+","+SlowEMA+","+SignalSMA+")");

   return(0);
}

// スタート関数
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      BufMACD[i] = iMACD(NULL, 0, FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_MAIN, i);
      BufSignal[i] = iMACD(NULL, 0, FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_SIGNAL, i);
   }

   return(0);
}

