//+------------------------------------------------------------------+
//|                                                  Momentum1F1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC   20094011
#define COMMENT "Momentum1F1"

// 外部パラメータ
extern double Lots = 0.1;
extern int Slippage = 3;

// エントリー関数
extern int MomPeriod = 20; // モメンタムの期間
int EntrySignal(int magic)
{
   // オープンポジションの計算
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // モメンタムの計算
   double mom1 = iMomentum(NULL, 0, MomPeriod, PRICE_CLOSE, 1);

   int ret = 0;
   // 買いシグナル
   if(pos <= 0 && mom1 > 100) ret = 1;
   // 売りシグナル
   if(pos >= 0 && mom1 < 100) ret = -1;

   return(ret);
}

// フィルター関数
extern int SMAPeriod = 200;   // 移動平均の期間
int FilterSignal(int signal)
{
   double sma1 = iMA(NULL, 0, SMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);

   int ret = 0;
   if(signal > 0 && Close[1] > sma1) ret = signal;
   if(signal < 0 && Close[1] < sma1) ret = signal;

   return(ret);
}

// スタート関数
int start()
{
   // エントリーシグナル
   int sig_entry = EntrySignal(MAGIC);

   // ポジションの決済
   if(sig_entry != 0) MyOrderClose(Slippage, MAGIC);

   // エントリーシグナルのフィルター
   sig_entry = FilterSignal(sig_entry);

   // 買い注文
   if(sig_entry > 0) MyOrderSend(OP_BUY, Lots, Ask, Slippage, 0, 0, COMMENT, MAGIC);
   // 売り注文
   if(sig_entry < 0) MyOrderSend(OP_SELL, Lots, Bid, Slippage, 0, 0, COMMENT, MAGIC);

   return(0);
}

