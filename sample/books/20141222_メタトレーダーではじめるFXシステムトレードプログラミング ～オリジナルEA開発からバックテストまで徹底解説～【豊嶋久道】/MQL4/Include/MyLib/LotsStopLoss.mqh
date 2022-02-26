//LotsStopLoss.mqh

input double RiskPercent = 3; //許容リスクの割合（％）

//ロット数の算出
double CalculateLots(int pos_id=0)
{
   //１ロットあたりの最大損失
                    //初期損切り幅のポイント値
   double maxloss = InitialStopPips * PipPoint / _Point
                    //１ロットの１ポイント価格
                  * SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);

   double lots;
   if(maxloss == 0) lots = 0; //初期損切り幅が未設定
   else lots = AccountInfoDouble(ACCOUNT_FREEMARGIN) //利用可能証拠金
               //最大損失からロット数を算出
             * RiskPercent * 0.01 / maxloss;

   return NormalizeLots(lots); //調整したロット数の出力
}
