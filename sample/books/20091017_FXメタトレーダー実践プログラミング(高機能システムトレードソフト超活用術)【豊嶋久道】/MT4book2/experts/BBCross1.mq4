//+------------------------------------------------------------------+
//|                                                     BBCross1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC   20094040
#define COMMENT "BBCross1"

// 外部パラメータ
extern double Lots = 0.1;
extern int Slippage = 3;

// エントリー関数
extern int BBPeriod = 20;  // ボリンジャーバンドの期間
extern int BBDev = 2;      // 標準偏差の倍率
int EntrySignal(int magic)
{
   // オープンポジションの計算
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // ボリンジャーバンドの計算
   double bbU1 = iBands(NULL, 0, BBPeriod, BBDev, 0, PRICE_CLOSE, MODE_UPPER, 1);
   double bbL1 = iBands(NULL, 0, BBPeriod, BBDev, 0, PRICE_CLOSE, MODE_LOWER, 1);

   int ret = 0;
   // 買いシグナル
   if(pos <= 0 && Close[2] >= bbL1 && Close[1] < bbL1) ret = 1;
   // 売りシグナル
   if(pos >= 0 && Close[2] <= bbU1 && Close[1] > bbU1) ret = -1;

   return(ret);
}

// スタート関数
int start()
{
   // エントリーシグナル
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

