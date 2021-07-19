//+------------------------------------------------------------------+
//|                                                        MACD1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC   20094060
#define COMMENT "MACD1"

// 外部パラメータ
extern double Lots = 0.1;
extern int Slippage = 3;

// エントリー関数
extern int FastEMAPeriod = 12;   // 短期EMAの期間
extern int SlowEMAPeriod = 26;   // 長期EMAの期間
extern int SignalPeriod = 9;     // MACDのSMAを取る期間
int EntrySignal(int magic)
{
   // オープンポジションの計算
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // MACDの計算
   double macd1 = iMACD(NULL, 0, FastEMAPeriod, SlowEMAPeriod, SignalPeriod, PRICE_CLOSE, MODE_MAIN, 1);
   double macd2 = iMACD(NULL, 0, FastEMAPeriod, SlowEMAPeriod, SignalPeriod, PRICE_CLOSE, MODE_MAIN, 2);
   double macdsig1 = iMACD(NULL, 0, FastEMAPeriod, SlowEMAPeriod, SignalPeriod, PRICE_CLOSE, MODE_SIGNAL, 1);
   double macdsig2 = iMACD(NULL, 0, FastEMAPeriod, SlowEMAPeriod, SignalPeriod, PRICE_CLOSE, MODE_SIGNAL, 2);

   int ret = 0;
   // 買いシグナル
   if(pos <= 0 && macd2 <= macdsig2 && macd1 > macdsig1) ret = 1;
   // 売りシグナル
   if(pos >= 0 && macd2 >= macdsig2 && macd1 < macdsig1) ret = -1;

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

