//+------------------------------------------------------------------+
//|                                                     OCOOrder.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC1  20093030
#define MAGIC2  20093031
#define COMMENT "OCOOrder"

// 外部パラメータ
extern double OpenPrice1 = 100.00;  // 売買価格１
extern double Lots1 = 0.1;          // 売買ロット数１（＋：買い　－売り）
extern double OpenPrice2 = 100.50;  // 売買価格２
extern double Lots2 = -0.1;         // 売買ロット数２（＋：買い　－売り）

// 待機注文の送信
void PendingOrderSend(double price, double lots, int magic)
{
   double stop_width = MarketInfo(Symbol(), MODE_STOPLEVEL) * Point;
   
   if(lots > 0)   // 買い注文
   {
      if(price < Ask-stop_width) MyOrderSend(OP_BUYLIMIT, lots, price, 0, 0, 0, COMMENT, magic);
      else if(price > Ask+stop_width) MyOrderSend(OP_BUYSTOP, lots, price, 0, 0, 0, COMMENT, magic);
   }
   else if(lots < 0) // 売り注文
   {
      if(price > Bid+stop_width) MyOrderSend(OP_SELLLIMIT, -lots, price, 0, 0, 0, COMMENT, magic);
      else if(price <= Bid-stop_width) MyOrderSend(OP_SELLSTOP, -lots, price, 0, 0, 0, COMMENT, magic);
   }
}

// スタート関数
int start()
{
   // MAGIC1のポジション処理
   if(MyCurrentOrders(MY_OPENPOS, MAGIC2) == 0)
   {
      if(MyCurrentOrders(MY_ALLPOS, MAGIC1) == 0) PendingOrderSend(OpenPrice1, Lots1, MAGIC1);
   }
   else if(MyCurrentOrders(MY_PENDPOS, MAGIC1) != 0) MyOrderDelete(MAGIC1);

   // MAGIC2のポジション処理
   if(MyCurrentOrders(MY_OPENPOS, MAGIC1) == 0)
   {
      if(MyCurrentOrders(MY_ALLPOS, MAGIC2) == 0) PendingOrderSend(OpenPrice2, Lots2, MAGIC2);
   }
   else if(MyCurrentOrders(MY_PENDPOS, MAGIC2) != 0) MyOrderDelete(MAGIC2);

   return(0);
}

