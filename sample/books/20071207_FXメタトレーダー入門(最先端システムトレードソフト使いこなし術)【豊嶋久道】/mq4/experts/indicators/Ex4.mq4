//+------------------------------------------------------------------+
//|                                                          Ex4.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red

//指標バッファ
double Buf[];

//移動平均の期間
extern int MA_Period = 4;

//+------------------------------------------------------------------+
//| 初期化関数                                                       |
//+------------------------------------------------------------------+
int init()
{
   //指標バッファの割り当て
   SetIndexBuffer(0,Buf);

   return(0);
}

//+------------------------------------------------------------------+
//| 指標処理関数                                                     |
//+------------------------------------------------------------------+
int start()
{
   //指標の計算範囲
   int limit = Bars-IndicatorCounted();
   if(limit == Bars) limit -= MA_Period-1; //<--挿入直後の指標の計算範囲

   //指標の計算
   for(int i=limit-1; i>=0; i--)
   {
      Buf[i] = 0;
      for(int j=0; j<MA_Period; j++)
      {
         Buf[i] += Close[i+j];
      }
      Buf[i] /= MA_Period;
   }

   return(0);
}
//+------------------------------------------------------------------+