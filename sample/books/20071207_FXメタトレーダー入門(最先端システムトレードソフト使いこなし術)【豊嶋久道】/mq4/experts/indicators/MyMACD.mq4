//+------------------------------------------------------------------+
//|                                                       MyMACD.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Silver
#property indicator_color2 Blue
#property indicator_color3 Red

//指標バッファ
double BufMACD[];
double BufUp[];
double BufDown[];

//パラメーター
extern int FastEMA = 12;
extern int SlowEMA = 26;
extern int SignalSMA = 9;

//+------------------------------------------------------------------+
//| 初期化関数                                                       |
//+------------------------------------------------------------------+
int init()
{
   //指標バッファの割り当て
   SetIndexBuffer(0,BufMACD);
   SetIndexBuffer(1,BufUp);
   SetIndexBuffer(2,BufDown);

   //指標ラベルの設定
   string label = "MACD("+FastEMA+","+SlowEMA+","+SignalSMA+")";
   IndicatorShortName(label);
   SetIndexLabel(0,label);
   SetIndexLabel(1,"UpSignal");
   SetIndexLabel(2,"DownSignal");

   //指標スタイルの設定
   SetIndexStyle(0,DRAW_HISTOGRAM, STYLE_SOLID, 3, Silver);
   SetIndexStyle(1,DRAW_HISTOGRAM, STYLE_SOLID, 1, Blue);
   SetIndexStyle(2,DRAW_HISTOGRAM, STYLE_SOLID, 1, Red);

   return(0);
}

//+------------------------------------------------------------------+
//| 指標処理関数                                                     |
//+------------------------------------------------------------------+
int start()
{
   int limit = Bars-IndicatorCounted();

   for(int i=limit-1; i>=0; i--)
   {
      if(i == Bars-1) BufMACD[i] = 0;
      else BufMACD[i] = iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)
                       -iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i); //MACDの計算
   }
   
   if(limit == Bars) limit -= SignalSMA-1;
   for(i=limit-1; i>=0; i--)
   {
      BufUp[i] = 0; BufDown[i] = 0;
      double val = iMAOnArray(BufMACD,0,SignalSMA,0,MODE_SMA,i); //シグナルの計算
      if(BufMACD[i] >= val) BufUp[i] = val; //MACDがvalより上の場合
      else BufDown[i] = val;                //MACDがvalより下の場合
   }

   return(0);
}
//+------------------------------------------------------------------+