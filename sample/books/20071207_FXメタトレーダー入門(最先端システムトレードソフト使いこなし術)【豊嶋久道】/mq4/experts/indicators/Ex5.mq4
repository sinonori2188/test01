//+------------------------------------------------------------------+
//|                                                          Ex5.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window //<---サブウインドウに表示
#property indicator_buffers 1
#property indicator_color1 Red

//指標バッファ
double Buf[];

//モメンタムの期間
extern int Mom_Period = 14;

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
   if(limit == Bars) limit -= Mom_Period;

   //指標の計算
   for(int i=limit-1; i>=0; i--)
   {
      Buf[i] = Close[i]-Close[i+Mom_Period];
   }

   return(0);
}
//+------------------------------------------------------------------+