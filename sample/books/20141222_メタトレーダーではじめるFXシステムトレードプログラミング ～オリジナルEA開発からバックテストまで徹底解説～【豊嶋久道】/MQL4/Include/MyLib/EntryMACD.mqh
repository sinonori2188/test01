//EntryMACD.mqh
#include <Indicators\Indicators.mqh> //テクニカル指標クラスの定義

//テクニカル指標の設定
CiMACD MACD;                  //MACDのオブジェクト
input int FastEMAPeriod = 10; //短期EMAの期間
input int SlowEMAPeriod = 25; //長期EMAの期間
input int SignalPeriod = 5;   //MACDのSMAを取る期間

//仕掛けシグナル関数
int EntrySignal(int pos_id=0)
{
   //テクニカル指標の初期化
   if(MACD.FastEmaPeriod() < 0)
      MACD.Create(_Symbol, 0, FastEMAPeriod, SlowEMAPeriod,
                  SignalPeriod, PRICE_CLOSE);

   MACD.Refresh(); //テクニカル指標の更新

   int type = MyOrderType(pos_id); //ポジションの種類

   int ret = 0; //シグナルの初期化

   //買いシグナル
   if((type == OP_NONE || type == OP_SELL)
      && MACD.Main(1) > MACD.Signal(1)
      && MACD.Main(2) <= MACD.Signal(2)) ret = 1;

   //売りシグナル
   if((type == OP_NONE || type == OP_BUY)
      && MACD.Main(1) < MACD.Signal(1)
      && MACD.Main(2) >= MACD.Signal(2)) ret = -1;

   return ret; //シグナルの出力
}
