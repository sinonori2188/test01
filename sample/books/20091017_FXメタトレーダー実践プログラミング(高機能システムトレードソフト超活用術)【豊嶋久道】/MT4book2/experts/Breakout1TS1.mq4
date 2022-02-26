//+------------------------------------------------------------------+
//|                                                 Breakout1TS1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC   20094072
#define COMMENT "Breakout1TS1"

// 外部パラメータ
extern double Lots = 0.1;
extern int Slippage = 3;
extern int TStype = 1;  //トレイリングストップの種類

// エントリー関数
extern int HLPeriod = 20;  // HLバンドの期間
int EntrySignal(int magic)
{
   // オープンポジションの計算
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // HLバンドの計算
   double HH = iCustom(NULL, 0, "HLBand", HLPeriod, 1, 2);
   double LL = iCustom(NULL, 0, "HLBand", HLPeriod, 2, 2);
   
   int ret = 0;
   // 買いシグナル
   if(pos <= 0 && Close[2] <= HH && Close[1] > HH) ret = 1;
   // 売りシグナル
   if(pos >= 0 && Close[2] >= LL && Close[1] < LL) ret = -1;

   return(ret);
}

// 通常のトレイリングストップ(TStype=0)
extern int TSPoint = 15;   // トレイリングストップのポイント数
void MyTrailingStop(int ts, int magic)
{
   if(Digits == 3 || Digits == 5) ts *= 10;

   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;

      if(OrderType() == OP_BUY)
      {
         double newsl = Bid-ts*Point;
         if(newsl >= OrderOpenPrice() && newsl > OrderStopLoss()) MyOrderModify(newsl, 0, magic);
         break;
      }

      if(OrderType() == OP_SELL)
      {
         newsl = Ask+ts*Point;
         if(newsl <= OrderOpenPrice() && (newsl < OrderStopLoss() || OrderStopLoss() == 0)) MyOrderModify(newsl, 0, magic);
         break;
      }
   }
}

// HLバンドトレイリングストップ(TStype=1)
extern int TSPeriod = 5;   // トレイリングストップ用HLバンドの期間
void MyTrailingStopHL(int period, int magic)
{
   double spread = Ask-Bid;
   double HH = iCustom(Symbol(), 0, "HLBand", period, 1, 1)+spread;
   double LL = iCustom(Symbol(), 0, "HLBand", period, 2, 1);

   if(MyCurrentOrders(OP_BUY, magic) != 0) MyOrderModify(LL, 0, magic);
   if(MyCurrentOrders(OP_SELL, magic) != 0) MyOrderModify(HH, 0, magic);
}

// ATRトレイリングストップ(TStype=2)
extern int ATRPeriod = 5;     // トレイリングストップ用ATRの期間
extern double ATRMult = 2.0;  // トレイリングストップ用ATRの倍率
void MyTrailingStopATR(int period, double mult, int magic)
{
   double spread = Ask-Bid;
   double atr = iATR(NULL, 0, period, 1) * mult;
   double HH = Low[1] + atr + spread;
   double LL = High[1] - atr;      

   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;

      if(OrderType() == OP_BUY)
      {
         if(LL > OrderStopLoss()) MyOrderModify(LL, 0, magic);
         break;
      }
   
      if(OrderType() == OP_SELL)
      {
         if(HH < OrderStopLoss() || OrderStopLoss() == 0) MyOrderModify(HH, 0, magic);
         break;
      }
   }
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

   // トレイリングストップ
   switch(TStype)
   {
      case 0:  
      MyTrailingStop(TSPoint, MAGIC);
      break;
      
      case 1:  
      MyTrailingStopHL(TSPeriod, MAGIC);
      break;

      case 2:  
      MyTrailingStopATR(ATRPeriod, ATRMult, MAGIC);
      break;
   }
   
   return(0);
}

