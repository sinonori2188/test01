//+------------------------------------------------------------------+
//|                                                          Ex2.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red       //<--ラインの色を指定
#property indicator_style1 STYLE_DOT //<--ラインの種類を指定

//指標バッファ
double Buf[];

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

   //指標の計算
   for(int i=limit-1; i>=0; i--)
   {
      Buf[i] = (Close[i]+Close[i+1]+Close[i+2]+Close[i+3])/4;
   }

   return(0);
}
//+------------------------------------------------------------------+