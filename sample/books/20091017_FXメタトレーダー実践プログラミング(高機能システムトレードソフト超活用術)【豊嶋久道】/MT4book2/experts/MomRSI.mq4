//+------------------------------------------------------------------+
//|                                                       MomRSI.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC1    20094100
#define MAGIC2    20094101
#define COMMENT1  "MomRSI(Mom)"
#define COMMENT2  "MomRSI(RSI)"

// 外部パラメータ
extern double Lots = 0.1;
extern int Slippage = 3;

// エントリー関数(モメンタム)
extern int MomPeriod = 20; // モメンタムの期間
int EntrySignalMom(int magic)
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

// エントリー関数(RSI)
extern int RSIPeriod = 14; // RSIの期間
int EntrySignalRSI(int magic)
{
   // オープンポジションの計算
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // RSIの計算
   double rsi1 = iRSI(NULL, 0, RSIPeriod, PRICE_CLOSE, 1);

   int ret = 0;
   // 買いシグナル
   if(pos <= 0 && rsi1 < 30) ret = 1;
   // 売りシグナル
   if(pos >= 0 && rsi1 > 70) ret = -1;

   return(ret);
}

// スタート関数
int start()
{
   // モメンタムエントリーシグナル
   int sig_entry1 = EntrySignalMom(MAGIC1);

   // 買い注文
   if(sig_entry1 > 0)
   {
      MyOrderClose(Slippage, MAGIC1);
      MyOrderSend(OP_BUY, Lots, Ask, Slippage, 0, 0, COMMENT1, MAGIC1);
   }
   // 売り注文
   if(sig_entry1 < 0)
   {
      MyOrderClose(Slippage, MAGIC1);
      MyOrderSend(OP_SELL, Lots, Bid, Slippage, 0, 0, COMMENT1, MAGIC1);
   }

   // RSIエントリーシグナル
   int sig_entry2 = EntrySignalRSI(MAGIC2);

   // 買い注文
   if(sig_entry2 > 0)
   {
      MyOrderClose(Slippage, MAGIC2);
      MyOrderSend(OP_BUY, Lots, Ask, Slippage, 0, 0, COMMENT2, MAGIC2);
   }
   // 売り注文
   if(sig_entry2 < 0)
   {
      MyOrderClose(Slippage, MAGIC2);
      MyOrderSend(OP_SELL, Lots, Bid, Slippage, 0, 0, COMMENT2, MAGIC2);
   }

   return(0);
}

