//+------------------------------------------------------------------+
//|                                                          Ex6.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_level1 20
#property indicator_level2 80
#property indicator_buffers 1
#property indicator_color1 Red

//指標バッファ
double Buf[];

//最高値・最安値の期間
extern int ST_Period = 14;

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
   if(limit == Bars) limit -= ST_Period;

   //指標の計算
   for(int i=limit-1; i>=0; i--)
   {
      double HH=0, LL=10000;
      for(int j=0; j<ST_Period; j++)
      {
         if(High[i+j] > HH) HH = High[i+j];
         if(Low[i+j] < LL) LL = Low[i+j];
      }
      Buf[i] = (Close[i]-LL)/(HH-LL)*100;
   }

   return(0);
}
//+------------------------------------------------------------------+