//EntryMACross.mqh
#include <Indicators\Indicators.mqh> //テクニカル指標クラスの定義

//テクニカル指標の設定
CiMA MA;                 //移動平均のオブジェクト
input int MAPeriod = 20; //移動平均の期間

//仕掛けシグナル関数
int EntrySignal(int pos_id=0)
{
   //テクニカル指標の初期化
   if(MA.MaPeriod() < 0)
      MA.Create(_Symbol, 0, MAPeriod, 0, MODE_SMA, PRICE_CLOSE);

   MA.Refresh(); // テクニカル指標の更新

   int type = MyOrderType(pos_id); //ポジションの種類

   int ret = 0; //シグナルの初期化

   //買いシグナル
   if((type == OP_NONE || type == OP_SELL)
      && Close[1] > MA.Main(1) && Close[2] <= MA.Main(2)) ret = 1;

   //売りシグナル
   if((type == OP_NONE || type == OP_BUY)
      && Close[1] < MA.Main(1) && Close[2] >= MA.Main(2)) ret = -1;

   return ret; //シグナルの出力
}
