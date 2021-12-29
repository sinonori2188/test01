//EntryRSI.mqh
#include <Indicators\Indicators.mqh> //テクニカル指標クラスの定義

//テクニカル指標の設定
CiRSI RSI;                //RSIのオブジェクト
input int RSIPeriod = 14; //RSIの期間

//仕掛けシグナル関数
int EntrySignal(int pos_id=0)
{
   //テクニカル指標の初期化
   if(RSI.MaPeriod() < 0) RSI.Create(_Symbol, 0, RSIPeriod, PRICE_CLOSE);

   RSI.Refresh(); //テクニカル指標の更新

   int type = MyOrderType(pos_id); // ポジションの種類

   int ret = 0; //シグナルの初期化

   //買いシグナル
   if((type == OP_NONE || type == OP_SELL) && RSI.Main(0) < 30) ret = 1;

   //売りシグナル
   if((type == OP_NONE || type == OP_BUY) && RSI.Main(0) > 70) ret = -1;

   return ret; //シグナルの出力
}
