//+------------------------------------------------------------------+
//|                                                       RSI1F1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC  20094023
#define COMMENT "RSI1F1"

// 外部パラメータ
extern double Lots = 0.1;
extern int Slippage = 3;

// エントリー関数
extern int RSIPeriod = 14; // RSIの期間
int EntrySignal(int magic)
{
   // オープンポジションの計算
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // RSIの計算
   double rsi1 = iRSI(Symbol(), 0, RSIPeriod, PRICE_CLOSE, 1);

   int ret = 0;
   // 買いシグナル
   if(pos <= 0 && rsi1 < 30) ret = 1;
   // 売りシグナル
   if(pos >= 0 && rsi1 > 70) ret = -1;

   return(ret);
}

// フィルター関数
extern string StartTime = "9:30";   // 開始時刻
extern string EndTime = "12:30";    // 終了時刻
int FilterSignal(int signal)
{
   string sdate = TimeToStr(TimeCurrent(), TIME_DATE);
   datetime start_time = StrToTime(sdate+" "+StartTime);
   datetime end_time = StrToTime(sdate+" "+EndTime);

   int ret = 0;
   if(start_time <= end_time)
   {
      if(TimeCurrent() >= start_time && TimeCurrent() < end_time) ret = signal;
      else ret = 0;
   }
   else
   {
      if(TimeCurrent() >= end_time && TimeCurrent() < start_time) ret = 0;
      else ret = signal;
   }

   return(ret);
}

// エグジット関数
void ExitPosition(int magic)
{
   string sdate = TimeToStr(TimeCurrent(), TIME_DATE);
   datetime end_time = StrToTime(sdate+" "+EndTime);

   if(TimeCurrent() >= end_time && TimeCurrent() < end_time+600) MyOrderClose(Slippage, magic);
}

// スタート関数
int start()
{
   // ポジションの決済
   ExitPosition(MAGIC);

   // エントリーシグナルの生成
   int sig_entry = EntrySignal(MAGIC);

   // エントリーのフィルター
   sig_entry = FilterSignal(sig_entry);

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

