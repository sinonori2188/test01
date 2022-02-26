//+------------------------------------------------------------------+
//|                                                        MyEMA.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red

//指標バッファ
double BufMA[];

//パラメーター
extern int MA_Period = 20;

//+------------------------------------------------------------------+
//| 初期化関数                                                       |
//+------------------------------------------------------------------+
int init()
{
   //指標バッファの割り当て
   SetIndexBuffer(0,BufMA);

   //指標ラベルの設定
   SetIndexLabel(0, "EMA("+MA_Period+")");

   return(0);
}

//+------------------------------------------------------------------+
//| 指標処理関数                                                     |
//+------------------------------------------------------------------+
int start()
{
   int limit = Bars-IndicatorCounted();

   double a = 2.0/(MA_Period+1); //a = 1.0/MAPeriod とすると SMMA

   for(int i=limit-1; i>=0; i--)
   {
      if(i == Bars-1) BufMA[i] = Close[i];
      else BufMA[i] = a*Close[i] + (1-a)*BufMA[i+1];
   }

   return(0);
}
//+------------------------------------------------------------------+