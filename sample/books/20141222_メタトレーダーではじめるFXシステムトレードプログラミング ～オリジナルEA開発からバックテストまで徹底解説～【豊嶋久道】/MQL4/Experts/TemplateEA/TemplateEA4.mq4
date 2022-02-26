//TemplateEA4（複数のポジションを扱う売買システム）
#property copyright "Copyright (c) 2014, Toyolab FX"
#property link      "http://forex.toyolab.com/"

//オリジナルライブラリ
#define POSITIONS 2
#define MAGIC 456789
#include <MyLib\LibPosition.mqh>

//仕掛けシグナル
//#include <MyLib\EntryRSI.mqh>
#include <MyLib\EntryBBCross.mqh>

//手仕舞いシグナル
#include <MyLib\ExitEntry.mqh>
//#include <MyLib\ExitTrailingStop.mqh>
//#include <MyLib\ExitTime.mqh>
//#include <MyLib\ExitMACross0.mqh>

//仕掛けシグナルのフィルタ
#include <MyLib\NoFilter.mqh>
//#include <MyLib\FilterTrend.mqh>
//#include <MyLib\FilterTime.mqh>

//売買ロット数
#include <MyLib\LotsFixed.mqh>
//#include <MyLib\LotsStopLoss.mqh>
//#include <MyLib\LotsATR.mqh>
//#include <MyLib\LotsMartingale.mqh>
//#include <MyLib\LotsAntiMartingale.mqh>

input int WaitingMin = 120; //待機時間（分）

//ティック時実行関数
void OnTick()
{
   UpdatePosition(); //ポジションの更新

   int sig_entry = EntrySignal(0);  //１つ目の仕掛けシグナル
   int sig_entry1 = EntrySignal(1); //２つ目の仕掛けシグナル
   
   //手仕舞いシグナルによるポジションの決済
   bool sig_exit = ExitSignal(sig_entry, 0); //手仕舞いシグナル
   if(sig_exit)
   {
      MyOrderClose(0); //１つ目のポジションの決済
      MyOrderClose(1); //２つ目のポジションの決済
   }

   //１つ目の仕掛けシグナルのフィルタ
   sig_entry = FilterSignal(sig_entry, 0);
   //２つ目の仕掛けシグナルのフィルタ
   sig_entry1 = FilterSignal(sig_entry1, 1);
   //２つ目の仕掛けシグナルの待機フィルタ
   sig_entry1 = WaitSignal(sig_entry1, WaitingMin, 0);

   double lots = CalculateLots(); //売買ロット数

   //１つ目の売買注文
   if(sig_entry > 0) MyOrderSend(OP_BUY, lots, 0, 0);   //買い注文
   if(sig_entry < 0) MyOrderSend(OP_SELL, lots, 0, 0);  //売り注文
   //２つ目の売買注文
   if(sig_entry1 > 0) MyOrderSend(OP_BUY, lots, 0, 1);  //買い注文
   if(sig_entry1 < 0) MyOrderSend(OP_SELL, lots, 0, 1); //売り注文
}
