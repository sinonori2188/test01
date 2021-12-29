//EntryMA2Cross.mqh
#include <Indicators\Indicators.mqh> //テクニカル指標クラスの定義

//テクニカル指標の設定
CiMA FastMA, SlowMA;         //移動平均のオブジェクト
input int FastMAPeriod = 20; // 短期移動平均の期間
input int SlowMAPeriod = 40; // 長期移動平均の期間

//仕掛けシグナル関数
int EntrySignal(int pos_id=0)
{
   //テクニカル指標の初期化
   if(FastMA.MaPeriod() < 0)
      FastMA.Create(_Symbol, 0, FastMAPeriod, 0, MODE_SMA, PRICE_CLOSE);
   if(SlowMA.MaPeriod() < 0)
      SlowMA.Create(_Symbol, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE);

   //テクニカル指標の更新
   FastMA.Refresh();
   SlowMA.Refresh();

   int type = MyOrderType(pos_id); //ポジションの種類

   int ret = 0; //シグナルの初期化

   //買いシグナル
   if((type == OP_NONE || type == OP_SELL)
      && FastMA.Main(1) > SlowMA.Main(1)
      && FastMA.Main(2) <= SlowMA.Main(2)) ret = 1;

   //売りシグナル
   if((type == OP_NONE || type == OP_BUY) 
      && FastMA.Main(1) < SlowMA.Main(1)
      && FastMA.Main(2) >= SlowMA.Main(2)) ret = -1;

   return ret; //シグナルの出力
}
