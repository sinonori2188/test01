//+------------------------------------------------------------------+
//|                                                  KumikomiRSI.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_level1 30
#property indicator_level2 70

// 指標バッファ
double BufRSI[];

// 外部パラメータ
extern int RSI_Period = 14;

// 初期化関数
int init()
{
   // 指標バッファの割り当て
   SetIndexBuffer(0, BufRSI);

   // 指標ラベルの設定
   string label = "RSI("+RSI_Period+")";
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
      BufRSI[i] = iRSI(NULL, 0, RSI_Period, PRICE_CLOSE, i);
   }

   return(0);
}

