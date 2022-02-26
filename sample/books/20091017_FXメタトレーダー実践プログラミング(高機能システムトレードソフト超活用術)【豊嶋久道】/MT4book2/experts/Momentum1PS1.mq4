//+------------------------------------------------------------------+
//|                                                 Momentum1PS1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC   20094012
#define COMMENT "Momentum1PS1"

// 外部パラメータ
extern double Leverage = 2; // 実質レバレッジ
extern int Slippage = 3;

// ロット数の計算
double CalculateLots(double leverage)
{
   string symbol = StringSubstr(Symbol(), 0, 3) + AccountCurrency();

   double conv = iClose(symbol, 0, 0);
   if(conv == 0) conv = 1;
   
   double lots = leverage * AccountFreeMargin() / 100000 / conv;

   double minlots = MarketInfo(Symbol(), MODE_MINLOT);
   double maxlots = MarketInfo(Symbol(), MODE_MAXLOT);
   int lots_digits = MathLog(1.0/minlots)/MathLog(10.0);
   lots = NormalizeDouble(lots, lots_digits);
   if(lots < minlots) lots = minlots;
   if(lots > maxlots) lots = maxlots;

   return(lots);
}

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

// スタート関数
int start()
{
   // 売買ロット数の計算
   double lots = CalculateLots(Leverage); 

   // エントリーシグナル
   int sig_entry = EntrySignal(MAGIC);

   // 買い注文
   if(sig_entry > 0)
   {
      MyOrderClose(Slippage, MAGIC);
      MyOrderSend(OP_BUY, lots, Ask, Slippage, 0, 0, COMMENT, MAGIC);
   }
   // 売り注文
   if(sig_entry < 0)
   {
      MyOrderClose(Slippage, MAGIC);
      MyOrderSend(OP_SELL, lots, Bid, Slippage, 0, 0, COMMENT, MAGIC);
   }

   return(0);
}

