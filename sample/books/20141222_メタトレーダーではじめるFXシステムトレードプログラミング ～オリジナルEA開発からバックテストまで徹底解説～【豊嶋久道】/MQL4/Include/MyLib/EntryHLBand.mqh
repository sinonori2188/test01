//EntryHLBand.mqh

//テクニカル指標の設定
input int HLPeriod = 20; //HLバンドの期間

//仕掛けシグナル関数
int EntrySignal(int pos_id=0)
{
   int type = MyOrderType(pos_id); //ポジションの種類

   //終値の最高値ライン
   double HH2 = Close[iHighest(_Symbol, 0, MODE_CLOSE, HLPeriod, 2)];
   //終値の最安値ライン
   double LL2 = Close[iLowest(_Symbol, 0, MODE_CLOSE, HLPeriod, 2)];

   int ret = 0; //シグナルの初期化

   //買いシグナル
   if((type == OP_NONE || type == OP_SELL)
      && Close[1] > HH2 && Close[2] <= HH2) ret = 1;

   //売りシグナル
   if((type == OP_NONE || type == OP_BUY)
      && Close[1] < LL2 && Close[2] >= LL2) ret = -1;

   return ret; //シグナルの出力
}
