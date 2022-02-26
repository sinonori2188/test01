//LotsAntiMartingale.mqh

input double InitialLots = 0.1; //初期ロット数
input double Mult = 2;          //ロット数を変える倍率

//ロット数の算出
double CalculateLots(int pos_id=0)
{
   double lots = InitialLots; //初期ロット数

   //前回が勝ちトレードの場合、ロット数をMult倍
   if(MyOrderLastProfit(pos_id) > 0)
      lots = MyOrderLastLots(pos_id)*Mult;
   else lots = InitialLots; //初期ロット数に戻す

   return NormalizeLots(lots); //調整したロット数の出力
}
