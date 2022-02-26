//+------------------------------------------------------------------+
//|                                                     MACross1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC   20094030
#define COMMENT "MACross1"

// 外部パラメータ
extern double Lots = 0.1;
extern int Slippage = 3;

// エントリー関数
extern int MAPeriod = 40;  // 移動平均の期間
int EntrySignal(int magic)
{
   // オープンポジションの計算
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // 移動平均の計算
   double sma1 = iMA(NULL, 0, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);

   int ret = 0;
   // 買いシグナル
   if(pos <= 0 && Close[2] <= sma1 && Close[1] > sma1) ret = 1;
   // 売りシグナル
   if(pos >= 0 && Close[2] >= sma1 && Close[1] < sma1) ret = -1;

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

