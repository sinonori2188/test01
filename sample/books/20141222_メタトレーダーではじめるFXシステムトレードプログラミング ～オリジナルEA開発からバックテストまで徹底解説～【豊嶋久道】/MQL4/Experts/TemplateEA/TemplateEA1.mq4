//TemplateEA1（確定したバーの値のみを利用する順張りシステム）
#property copyright "Copyright (c) 2014, Toyolab FX"
#property link      "http://forex.toyolab.com/"

//オリジナルライブラリ
#define POSITIONS 1
#define MAGIC 123456
#include <MyLib\LibPosition.mqh>

//仕掛けシグナル
#include <MyLib\EntryMomentum.mqh>
//#include <MyLib\EntryMACross.mqh>
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

//ティック時実行関数
void OnTick()
{
   UpdatePosition(); //ポジションの更新

   int sig_entry = EntrySignal(); //仕掛けシグナル
   
   //手仕舞いシグナルによるポジションの決済
   bool sig_exit = ExitSignal(sig_entry); //手仕舞いシグナル
   if(sig_exit) MyOrderClose(); //ポジションの決済

   sig_entry = FilterSignal(sig_entry); //仕掛けシグナルのフィルタ

   double lots = CalculateLots(); //売買ロット数

   //売買注文
   if(sig_entry > 0) MyOrderSend(OP_BUY, lots);  //買い注文
   if(sig_entry < 0) MyOrderSend(OP_SELL, lots); //売り注文
}
