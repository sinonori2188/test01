//+------------------------------------------------------------------+
//|                                                 Breakout1ET1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC   20094073
#define COMMENT "Breakout1ET1"

// 外部パラメータ
extern double Lots = 0.1;
extern int Slippage = 3;

// エントリー関数
extern int HLPeriod = 20;  // HLバンドの期間
int EntrySignal(int magic)
{
   // オープンポジションの計算
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // HLバンドの計算
   double HH2 = iCustom(NULL, 0, "HLBand", HLPeriod, 1, 2);
   double LL2 = iCustom(NULL, 0, "HLBand", HLPeriod, 2, 2);
   
   int ret = 0;
   // 買いシグナル
   if(pos <= 0 && Close[2] <= HH2 && Close[1] > HH2) ret = 1;
   // 売りシグナル
   if(pos >= 0 && Close[2] >= LL2 && Close[1] < LL2) ret = -1;

   return(ret);
}

// エグジット関数
extern int ExpBars = 5; // 決済のためのバーの経過本数
void ExitPosition(int magic)
{
   datetime opentime = 0;
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;
      if(OrderType() == OP_BUY || OrderType() == OP_SELL)
      {
         opentime = OrderOpenTime();
         break;
      }
   }

   int traded_bar = 0;
   if(opentime > 0) traded_bar = iBarShift(NULL, 0, opentime, false);
   if(traded_bar >= ExpBars) MyOrderClose(Slippage, magic);
}

// スタート関数
int start()
{
   // エグジットポジション
   ExitPosition(MAGIC);

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

