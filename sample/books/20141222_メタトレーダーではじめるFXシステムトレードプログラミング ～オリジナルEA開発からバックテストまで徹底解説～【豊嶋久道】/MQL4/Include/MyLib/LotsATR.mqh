//LotsATR.mqh
#include <Indicators\Indicators.mqh> //テクニカル指標クラスの定義

CiATR ATR;                    //ATRのオブジェクト
input int LotsATRPeriod = 10; //ATRの期間
input double RiskPercent = 3; //許容リスクの割合（％）

//ロット数の算出
double CalculateLots(int pos_id=0)
{
   //ATRの初期化
   if(ATR.MaPeriod() < 0) ATR.Create(_Symbol, PERIOD_D1, LotsATRPeriod);

   ATR.Refresh(); //ATRの更新

   //ATRから算出した１ロットあたりの最大損失
   double maxloss = ATR.Main(1) / _Point //ATRのポイント値
                    //１ロットの１ポイント価格
                  * SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);

   double lots = AccountInfoDouble(ACCOUNT_FREEMARGIN) //利用可能証拠金
                 //最大損失からロット数を算出
               * RiskPercent * 0.01 / maxloss;

   return NormalizeLots(lots); //調整したロット数の出力
}
