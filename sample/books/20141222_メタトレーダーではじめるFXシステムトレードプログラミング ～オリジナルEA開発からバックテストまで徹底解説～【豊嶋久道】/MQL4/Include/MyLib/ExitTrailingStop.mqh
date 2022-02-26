//ExitTailingStop.mqh

input double InitialStopPips = 100;   // 初期損切り幅(pips)
input double InitialProfitPips = 200; // 初期利食い幅(pips)
input double TrailingStopPips = 20;   // トレイリングストップ幅(pips)

// 手仕舞いシグナル
bool ExitSignal(int sig_entry, int pos_id=0)
{
   //初期損切り値のセット
   if(MyOrderStopLoss(pos_id) == 0 && InitialStopPips != 0)
      MyOrderModify(0, MyOrderShiftPrice(-InitialStopPips, pos_id), 0,
                    pos_id);

   //初期利食い値のセット
   if(MyOrderTakeProfit(pos_id) == 0 && InitialProfitPips != 0)
      MyOrderModify(0, 0, MyOrderShiftPrice(InitialProfitPips, pos_id),
                    pos_id);

   //トレイリングストップのセット
   double profit = MyOrderProfitPips(pos_id) - TrailingStopPips;
   double sl = MyOrderStopLoss(pos_id);
   if(profit >= 0 && (sl == 0 || profit > MyOrderShiftPips(sl, pos_id)))
      MyOrderModify(0, MyOrderShiftPrice(profit, pos_id), 0, pos_id);

   return sig_entry; //シグナルの出力
}
