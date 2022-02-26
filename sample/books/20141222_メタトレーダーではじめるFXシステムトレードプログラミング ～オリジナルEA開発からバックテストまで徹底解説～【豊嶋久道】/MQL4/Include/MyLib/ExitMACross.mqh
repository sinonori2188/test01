//ExitMACross.mqh
#include <Indicators\Indicators.mqh> //テクニカル指標クラスの定義

//テクニカル指標の設定
CiMA ExitMA;                 //移動平均のオブジェクト
input int ExitMAPeriod = 10; //移動平均の期間

//手仕舞いシグナル
bool ExitSignal(int sig_entry, int pos_id=0)
{
   //テクニカル指標の初期化
   if(ExitMA.MaPeriod() < 0)
      ExitMA.Create(_Symbol, 0, ExitMAPeriod, 0, MODE_SMA, PRICE_CLOSE);

   ExitMA.Refresh(); //テクニカル指標の更新

   int type = MyOrderType(pos_id); //ポジションの種類

   bool ret = false; //シグナルの初期化

   //買いシグナル
   if(type == OP_SELL && Close[1] > ExitMA.Main(1)
      && Close[2] <= ExitMA.Main(2)) ret = true;

   //売りシグナル
   if(type == OP_BUY && Close[1] < ExitMA.Main(1)
      && Close[2] >= ExitMA.Main(2)) ret = true;

   return ret | sig_entry; //シグナルの出力
}
