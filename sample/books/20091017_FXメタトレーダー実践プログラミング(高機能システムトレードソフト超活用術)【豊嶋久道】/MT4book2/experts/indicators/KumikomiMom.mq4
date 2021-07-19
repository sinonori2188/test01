//+------------------------------------------------------------------+
//|                                                  KumikomiMom.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
#property indicator_level1 100

// 指標バッファ
double BufMom[];

// 外部パラメータ
extern int MomPeriod = 20;

// 初期化関数
int init()
{
   // 指標バッファの割り当て
   SetIndexBuffer(0,BufMom);

   // 指標ラベルの設定
   string label = "Momentum("+MomPeriod+")";
   IndicatorShortName(label);
   SetIndexLabel(0,label);

   return(0);
}

// スタート関数
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      BufMom[i] = iMomentum(NULL, 0, MomPeriod, PRICE_CLOSE, i);
   }

   return(0);
}

