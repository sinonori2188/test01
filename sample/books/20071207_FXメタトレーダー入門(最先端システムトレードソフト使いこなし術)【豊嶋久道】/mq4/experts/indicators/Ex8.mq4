//+------------------------------------------------------------------+
//|                                                          Ex8.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue

//指標バッファ
double Buf0[];
double Buf1[];

extern int Mom_Period = 25; //モメンタムの期間
extern int MA_Period = 10; //移動平均の期間

//+------------------------------------------------------------------+
//| 初期化関数                                                       |
//+------------------------------------------------------------------+
int init()
{
   //指標バッファの割り当て
   SetIndexBuffer(0,Buf0);
   SetIndexBuffer(1,Buf1);

   return(0);
}

//+------------------------------------------------------------------+
//| 指標処理関数                                                     |
//+------------------------------------------------------------------+
int start()
{
   //指標の計算範囲
   int counted_bar = IndicatorCounted(); 
   int limit = Bars-counted_bar;

   //モメンタムの計算
   if(counted_bar == 0) limit -= Mom_Period;
   for(int i=limit-1; i>=0; i--)
   {
      Buf0[i] = iMomentum(NULL,0,Mom_Period,PRICE_CLOSE,i); //モメンタム
   }

   //移動平均の計算
   if(counted_bar == 0) limit -= MA_Period-1;
   for(i=limit-1; i>=0; i--)
   {
      Buf1[i] = iMAOnArray(Buf0,0,MA_Period,0,MODE_SMA,i); //SMA
   }
   return(0);
}
//+------------------------------------------------------------------+