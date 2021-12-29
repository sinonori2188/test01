//EntryMomentum.mqh
#include <Indicators\Indicators.mqh> //テクニカル指標クラスの定義

//テクニカル指標の設定
CiMomentum Mom;           //モメンタムのオブジェクト
input int MomPeriod = 20; //モメンタムの期間

//仕掛けシグナル関数
int EntrySignal(int pos_id=0)
{
   //テクニカル指標の初期化
   if(Mom.MaPeriod() < 0) Mom.Create(_Symbol, 0, MomPeriod, PRICE_CLOSE);

   Mom.Refresh(); //テクニカル指標の更新

   int type = MyOrderType(pos_id);   //ポジションの種類

   int ret = 0; //シグナルの初期化

   //買いシグナル
   if((type == OP_NONE || type == OP_SELL) && Mom.Main(1) > 100) ret = 1;

   //売りシグナル
   if((type == OP_NONE || type == OP_BUY) && Mom.Main(1) < 100) ret = -1;

   return ret; //シグナルの出力
}
