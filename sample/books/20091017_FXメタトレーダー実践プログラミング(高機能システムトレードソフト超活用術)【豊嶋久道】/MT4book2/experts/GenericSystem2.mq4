//+------------------------------------------------------------------+
//|                                               GenericSystem2.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC   20094001
#define COMMENT "GenericSystem2"

// 外部パラメータ
extern double Lots = 0.1;
extern int Slippage = 3;

// エントリー関数
int EntrySignal(int magic)
{
   // オープンポジションの計算
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   int ret = 0;
   // if(pos <= 0 && 買いシグナル) ret = 1;
   // if(pos >= 0 && 売りシグナル) ret = -1;
   return(ret);
}

// エグジット関数
void ExitPosition(int magic)
{
   // オープンポジションの計算
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   int ret = 0;
   // if(pos < 0 && 売りポジションの決済シグナル) ret = 1;
   // if(pos > 0 && 買いポジションの決済シグナル) ret = -1;

   // オープンポジションの決済
   if(ret != 0) MyOrderClose(Slippage, magic);
}

// スタート関数
int start()
{
   // 売買ポジションのエグジット
   ExitPosition(MAGIC);

   // エントリーシグナルの生成
   int sig_entry = EntrySignal(MAGIC);

   // 買い注文
   if(sig_entry > 0)
   {
      MyOrderClose(Slippage, MAGIC);
      MyOrderSend(OP_BUY, Lots, Ask, Slippage, 0, 0, COMMENT, MAGIC);
   }
   // 売り注文
   if(sig_entry < 0)
   {
      MyOrderClose(Slippage, MAGIC);
      MyOrderSend(OP_SELL, Lots, Bid, Slippage, 0, 0, COMMENT, MAGIC);
   }

   return(0);
}

