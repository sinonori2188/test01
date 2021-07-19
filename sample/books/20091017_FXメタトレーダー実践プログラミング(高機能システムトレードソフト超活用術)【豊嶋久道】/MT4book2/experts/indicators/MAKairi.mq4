//+------------------------------------------------------------------+
//|                                                      MAKairi.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
#property indicator_level1 0

// 指標バッファ
double BufKairi[];

// 外部パラメータ
extern int MAPeriod = 13;

// 初期化関数
int init()
{
   // 指標バッファの割り当て
   SetIndexBuffer(0, BufKairi);

   // 指標ラベルの設定
   string label = "MAKairi("+MAPeriod+")";
   IndicatorShortName(label);
   SetIndexLabel(0, label);

   return(0);
}

// スタート関数
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      double ma = iMA(NULL, 0, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, i);
      if(ma != 0) BufKairi[i] = (Close[i]-ma)/ma*100;
   }

   return(0);
}

