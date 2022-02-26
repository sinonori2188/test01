//FilterTrend.mqh
#include <Indicators\Indicators.mqh> //テクニカル指標クラスの定義

//テクニカル指標の設定
CiEnvelopes FilterEnv;               //エンベロープのオブジェクト
input int FilterMAPeriod = 200;      //移動平均の期間
input double FilterEnvDeviation = 1; //移動平均からの上下幅（％）

//フィルタ関数
int FilterSignal(int signal, int pos_id=0)
{
   //テクニカル指標の初期化
   if(FilterEnv.MaPeriod() < 0)
      FilterEnv.Create(_Symbol, 0, FilterMAPeriod, 0, MODE_SMA,
                       PRICE_CLOSE, FilterEnvDeviation);

   FilterEnv.Refresh(); //テクニカル指標の更新

   int ret = 0; //シグナルの初期化

   //買いシグナルのフィルタ
   if(signal > 0 && Close[1] > FilterEnv.Upper(1)) ret = signal;

   //売りシグナルのフィルタ
   if(signal < 0 && Close[1] < FilterEnv.Lower(1)) ret = signal;

   return ret; //シグナルの出力
}
