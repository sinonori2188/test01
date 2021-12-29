//TemplateEA3（待機注文を使った売買システム）
#property copyright "Copyright (c) 2014, Toyolab FX"
#property link      "http://forex.toyolab.com/"

//オリジナルライブラリ
#define POSITIONS 1
#define MAGIC 345678
#include <MyLib\LibPosition.mqh>

//仕掛けシグナル
//#include <MyLib\EntryMomentum.mqh>
#include <MyLib\EntryMACross.mqh>
//#include <MyLib\EntryMA2Cross.mqh>
//#include <MyLib\EntryMACD.mqh>
//#include <MyLib\EntryHLBand.mqh>

//手仕舞いシグナル
#include <MyLib\ExitEntry.mqh>
//#include <MyLib\ExitMACross.mqh>
//#include <MyLib\ExitMA2Cross.mqh>
//#include <MyLib\ExitHLBand.mqh>

//仕掛けシグナルのフィルタ
#include <MyLib\NoFilter.mqh>
//#include <MyLib\FilterTrend.mqh>
//#include <MyLib\FilterTime.mqh>

//売買ロット数
#include <MyLib\LotsFixed.mqh>
//#include <MyLib\LotsATR.mqh>
//#include <MyLib\LotsMartingale.mqh>
//#include <MyLib\LotsAntiMartingale.mqh>

input double LimitPips = 20; //指値までの値幅(pips)
input int PendingMin = 60;   //待機注文の有効時間(分)

//ティック時実行関数
void OnTick()
{
   UpdatePosition(); //ポジションの更新

   int sig_entry = EntrySignal(); //仕掛けシグナル
   
   //手仕舞いシグナルによるポジションの決済
   bool sig_exit = ExitSignal(sig_entry); //手仕舞いシグナル
   if(sig_exit) MyOrderClose(); //ポジションの決済

   if(PendingOrderExpiration(PendingMin))
      MyOrderDelete(); //待機注文のキャンセル

   sig_entry = FilterSignal(sig_entry); //仕掛けシグナルのフィルタ

   double lots = CalculateLots(); //売買ロット数

   //売買注文
   if(sig_entry > 0)
      MyOrderSend(OP_BUYLIMIT, lots, Ask-LimitPips*PipPoint); //買い注文
   if(sig_entry < 0)
      MyOrderSend(OP_SELLLIMIT, lots, Bid+LimitPips*PipPoint);//売り注文
}
