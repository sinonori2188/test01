//ExitHLBand.mqh

//テクニカル指標の設定
input int ExitHLPeriod = 10; //HLバンドの期間

//手仕舞いシグナル
bool ExitSignal(int sig_entry, int pos_id=0)
{
   int type = MyOrderType(pos_id); //ポジションの種類

   //終値の最高値ライン
   double HH2 = Close[iHighest(_Symbol, 0, MODE_CLOSE, ExitHLPeriod, 2)];
   //終値の最安値ライン
   double LL2 = Close[iLowest(_Symbol, 0, MODE_CLOSE, ExitHLPeriod, 2)];

   bool ret = false; //シグナルの初期化

   //買いシグナル
   if(type == OP_SELL && Close[1] > HH2 && Close[2] <= HH2) ret = true;

   //売りシグナル
   if(type == OP_BUY && Close[1] < LL2 && Close[2] >= LL2) ret = true;

   return ret | sig_entry; //シグナルの出力
}
