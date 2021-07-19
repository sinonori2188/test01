//+------------------------------------------------------------------+
//|                                                         CBPB.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC   20094080
#define COMMENT "CBPB"

// 外部パラメータ
extern double Lots = 0.1;
extern int Slippage = 3;

// エントリー関数
extern int PBPeriod = 5;   // プルバック用HLバンドの期間
int EntrySignal(int magic)
{
   // オープンポジションの計算
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // プルバックのチェック
   double HH2 = iCustom(Symbol(), 0, "HLBand", PBPeriod, 0, 1, 2);
   double LL2 = iCustom(Symbol(), 0, "HLBand", PBPeriod, 0, 2, 2);

   int ret = 0;
   // 買いシグナル
   if(pos <= 0 && Low[2] >= LL2 && Low[1] < LL2) ret = 1;
   // 売りシグナル
   if(pos >= 0 && High[2] <= HH2 && High[1] > HH2) ret = -1;

   return(ret);
}

// フィルター関数
extern int BOPeriod = 40;  // ブレイクアウト用HLバンドの期間
int FilterSignal(int signal)
{
   for(int i=0; i<5; i++)
   {
      // HLバンドのの計算
      double HH2 = iCustom(Symbol(), 0, "HLBand", BOPeriod, 1, 1, i+2);
      double LL2 = iCustom(Symbol(), 0, "HLBand", BOPeriod, 1, 2, i+2);
   
      int ret = signal;
      // 買いシグナル
      if(signal > 0 && Close[i+2] <= HH2 && Close[i+1] > HH2) break;
      // 売りシグナル
      if(signal < 0 && Close[i+2] >= LL2 && Close[i+1] < LL2) break;
      ret = 0;
   }

   return(ret);
}

// HLバンドトレイリングストップ
extern int TSPeriod = 20;  // トレイリングストップ用HLバンドの期間
void MyTrailingStopHL(int period, int magic)
{
   double spread = Ask-Bid;
   double HH = iCustom(Symbol(), 0, "HLBand", period, 1, 1)+spread;
   double LL = iCustom(Symbol(), 0, "HLBand", period, 2, 1);

   if(MyCurrentOrders(OP_BUY, magic) != 0) MyOrderModify(LL, 0, magic);
   if(MyCurrentOrders(OP_SELL, magic) != 0) MyOrderModify(HH, 0, magic);
}

// スタート関数
int start()
{
   // エントリーシグナルの生成
   int sig_entry = EntrySignal(MAGIC);

   // エントリーのフィルター
   sig_entry = FilterSignal(sig_entry);

   // 買い注文
   if(sig_entry > 0) MyOrderSend(OP_BUY, Lots, Ask, Slippage, 0, 0, COMMENT, MAGIC);
   // 売り注文
   if(sig_entry < 0) MyOrderSend(OP_SELL, Lots, Bid, Slippage, 0, 0, COMMENT, MAGIC);

   // HLバンドトレイリングストップ
   MyTrailingStopHL(TSPeriod, MAGIC);
   
   return(0);
}

