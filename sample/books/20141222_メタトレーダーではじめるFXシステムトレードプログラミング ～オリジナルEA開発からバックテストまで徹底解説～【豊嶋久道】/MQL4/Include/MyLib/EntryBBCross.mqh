//EntryBBCross.mqh
#include <Indicators\Indicators.mqh> //テクニカル指標クラスの定義

//テクニカル指標の設定
CiBands BBands;           //ボリンジャーバンドのオブジェクト
input int BBPeriod = 20;  //ボリンジャーバンドの期間
input double BBDev = 2.0; //標準偏差の倍率

//仕掛けシグナル関数
int EntrySignal(int pos_id=0)
{
   //テクニカル指標の初期化
   if(BBands.MaPeriod() < 0)
      BBands.Create(_Symbol, 0, BBPeriod, 0, BBDev, PRICE_CLOSE);

   BBands.Refresh(); //テクニカル指標の更新

   int type = MyOrderType(pos_id); //ポジションの種類

   int ret = 0; //シグナルの初期化

   //買いシグナル
   if((type == OP_NONE || type == OP_SELL) 
      && Close[0] < BBands.Lower(0) && Close[1] >= BBands.Lower(1))
      ret = 1;

   //売りシグナル
   if((type == OP_NONE || type == OP_BUY)
      && Close[0] > BBands.Upper(0) && Close[1] <= BBands.Upper(1))
      ret = -1;

   return ret; //シグナルの出力
}
