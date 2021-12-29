//LibPosition.mqh
#property copyright "Copyright (c) 2014, Toyolab FX"
#property link      "http://forex.toyolab.com/"
#property version   "141.120"

#ifdef __MQL4__
   #include "LibPosition4.mqh"
#endif
#ifdef __MQL5__
   #include "LibPosition5.mqh"
#endif

//オープンポジションの一定利益となる決済価格の取得
double MyOrderShiftPrice(double sftpips, int pos_id=0) 
{
   double price = 0;
   //買いポジション
   if(MyOrderType(pos_id) == OP_BUY)
   {
      price = MyOrderOpenPrice(pos_id) + sftpips*PipPoint;
   }
   //売りポジション
   if(MyOrderType(pos_id) == OP_SELL)
   {
      price = MyOrderOpenPrice(pos_id) - sftpips*PipPoint;
   }
   return price;
}

//オープンポジションの一定価格における損益(pips)の取得
double MyOrderShiftPips(double price, int pos_id=0)
{
   double sft = 0;
   //買いポジション
   if(MyOrderType(pos_id) == OP_BUY)
   {
      sft = price - MyOrderOpenPrice(pos_id);
   }
   //売りポジション
   if(MyOrderType(pos_id) == OP_SELL)
   {
      sft = MyOrderOpenPrice(pos_id) - price;
   }
   return sft/PipPoint; //pips値に変換   
}

//売買ロット数の正規化
double NormalizeLots(double lots)
{
   //最小ロット数
   double lots_min = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   //最大ロット数
   double lots_max = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   //ロット数刻み幅
   double lots_step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   //ロット数の小数点以下の桁数
   int lots_digits = (int)MathLog10(1.0/lots_step);
   lots = NormalizeDouble(lots, lots_digits); //ロット数の正規化
   if(lots < lots_min) lots = lots_min; //最小ロット数を下回った場合
   if(lots > lots_max) lots = lots_max; //最大ロット数を上回った場合
   return lots;
}

//待機注文の有効期限
bool PendingOrderExpiration(int min, int pos_id=0)
{
   int type = MyOrderType(pos_id);  // 注文の種類
   //待機注文でない場合
   if(type == OP_NONE || type == OP_BUY || type == OP_SELL) return false;
   //有効期限を過ぎた場合
   if(TimeCurrent() >= MyOrderOpenTime(pos_id) + min*60) return true;
   return false;  //有効期限内
}

//シグナル待機フィルタ
int WaitSignal(int signal, int min, int pos_id=0)
{
   int ret = 0; //シグナルの初期化
   if(MyOrderOpenLots(pos_id) != 0 //オープンポジションがある場合
      //待機時間が経過した場合
      && TimeCurrent() >= MyOrderOpenTime(pos_id) + min*60)
         ret = signal;

   return ret; //シグナルの出力
}
