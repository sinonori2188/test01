//+------------------------------------------------------------------+
//|                                              TrailingStopATR.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC  0

// 外部パラメータ
extern int ATRPeriod = 5;     // ATRの期間
extern double ATRMult = 2.0;  // ATRの倍率

// スタート関数
int start()
{
   double spread = Ask-Bid;
   double atr = iATR(NULL, 0, ATRPeriod, 1) * ATRMult;
   double HH = Low[1] + atr + spread;
   double LL = High[1] - atr;

   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MAGIC) continue;

      if(OrderType() == OP_BUY)
      {
         if(LL > OrderStopLoss()) MyOrderModify(LL, 0, MAGIC);
         break;
      }
   
      if(OrderType() == OP_SELL)
      {
         if(HH < OrderStopLoss() || OrderStopLoss() == 0) MyOrderModify(HH, 0, MAGIC);
         break;
      }
   }

   return(0);
}

