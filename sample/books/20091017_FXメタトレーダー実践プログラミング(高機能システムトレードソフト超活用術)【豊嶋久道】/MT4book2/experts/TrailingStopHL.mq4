//+------------------------------------------------------------------+
//|                                               TrailingStopHL.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC 0

// 外部パラメータ
extern int HLPeriod = 5;   // HLバンドの期間

// スタート関数
int start()
{
   double spread = Ask-Bid;
   double HH = iCustom(Symbol(), 0, "HLBand", HLPeriod, 1, 1)+spread;
   double LL = iCustom(Symbol(), 0, "HLBand", HLPeriod, 2, 1);

   if(MyCurrentOrders(OP_BUY, MAGIC) != 0) MyOrderModify(LL, 0, MAGIC);
   if(MyCurrentOrders(OP_SELL, MAGIC) != 0) MyOrderModify(HH, 0, MAGIC);

   return(0);
}

