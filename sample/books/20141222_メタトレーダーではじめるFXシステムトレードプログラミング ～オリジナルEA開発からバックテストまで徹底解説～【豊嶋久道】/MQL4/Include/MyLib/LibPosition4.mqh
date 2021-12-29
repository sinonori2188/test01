//LibPosition4.mqh
#include <stderror.mqh>
#include <stdlib.mqh>

//order type extension
#define OP_NONE -1

int MagicNumber[POSITIONS] = {0}; //マジックナンバー
double PipPoint = _Point;         //1pipの値
input double SlippagePips = 1;    //成行注文時のスリッページ(pips)
int Slippage = 1;                 //成行注文時のスリッページ(point)

//ポジションの更新
void UpdatePosition()
{
   if(MagicNumber[0] != 0) return; //マジックナンバー設定済み

   //定義済み変数の定義
   if(_Digits == 3 || _Digits == 5)
   {
      Slippage = SlippagePips * 10;
      PipPoint = _Point * 10;
   }
   else
   {
      Slippage = SlippagePips;
      PipPoint = _Point;
   }

   //マジックナンバーの設定
   for(int i=0; i<POSITIONS; i++) MagicNumber[i] = MAGIC*10+i;
}

//ポジションを建てるための注文の送信
bool MyOrderSend(int type, double lots, double price=0, int pos_id=0)
{
   //矢印の色データ
   color ArrowColor[6] = {clrBlue, clrRed, clrBlue, clrRed,
                          clrBlue, clrRed};

   if(MyOrderType(pos_id) != OP_NONE) return true; //注文済み

   price = NormalizeDouble(price, _Digits); //価格の正規化

   if(type == OP_BUY) price = Ask;  //成行注文の買値
   if(type == OP_SELL) price = Bid; //成行注文の売値

   //注文送信
   int ret = OrderSend(_Symbol, type, lots, price, Slippage, 0, 0,
                       IntegerToString(MagicNumber[pos_id]),
                       MagicNumber[pos_id], 0, ArrowColor[type]);
   if(ret == -1) //注文エラー
   {
      int err = GetLastError();
      Print("MyOrderSend : ", err, " " , ErrorDescription(err));
      return false;
   }
   return true; //正常終了
}

//ポジションを決済するための注文の送信
bool MyOrderClose(int pos_id=0)
{
   //矢印の色データ
   color ArrowColor[6] = {clrBlue, clrRed, clrBlue, clrRed,
                          clrBlue, clrRed};

   //オープンポジションがない場合
   if(MyOrderOpenLots(pos_id) == 0) return true;

   //注文送信
   bool ret = OrderClose(MyOrderTicket(pos_id), MyOrderLots(pos_id),
                         MyOrderClosePrice(pos_id), Slippage,
                         ArrowColor[MyOrderType(pos_id)]);
   if(!ret) //注文エラー
   {
      int err = GetLastError();
      Print("MyOrderClose : ", err, " ", ErrorDescription(err));
      return false;
   }
   return true; //正常終了
}

//待機注文の削除
bool MyOrderDelete(int pos_id=0)
{
   int type = MyOrderType(pos_id);
   //待機注文がない場合
   if(type == OP_NONE || type == OP_BUY || type == OP_SELL) return true;

   //注文送信
   bool ret = OrderDelete(MyOrderTicket(pos_id));
   if(!ret) //注文エラー
   {
      int err = GetLastError();
      Print("MyOrderDelete : ", err, " ", ErrorDescription(err));
      return false;
   }
   return true; //正常終了
}

//注文の変更
bool MyOrderModify(double price, double sl, double tp, int pos_id=0)
{
   //矢印の色データ
   color ArrowColor[6] = {clrBlue, clrRed, clrBlue, clrRed,
                          clrBlue, clrRed};

   int type = MyOrderType(pos_id);
   if(type == OP_NONE) return true; //注文がない場合

   price = NormalizeDouble(price, _Digits); //価格の正規化
   sl = NormalizeDouble(sl, _Digits);       //損切り値の正規化
   tp = NormalizeDouble(tp, _Digits);       //利食い値の正規化

   if(price == 0) price = MyOrderOpenPrice(pos_id); //ポジションの価格
   if(sl == 0) sl = MyOrderStopLoss(pos_id);    //ポジションの損切り値
   if(tp == 0) tp = MyOrderTakeProfit(pos_id);  //ポジションの利食い値
   
   //損切り値、利食い値の変更がない場合
   if(MyOrderStopLoss(pos_id) == sl && MyOrderTakeProfit(pos_id) == tp)
   {
      //オープンポジションか、価格に変更がない場合
      if(type == OP_BUY || type == OP_SELL
         || MyOrderOpenPrice(pos_id) == price) return true;
   }

   //注文の送信
   bool ret = OrderModify(MyOrderTicket(pos_id), price, sl, tp, 0,
                          ArrowColor[type]);
   if(!ret) //注文エラー
   {
      int err = GetLastError();
      Print("MyOrderModify : ", err, " ", ErrorDescription(err));
      return false;
   }
   return true; //正常終了
}

//ポジションの選択
bool MyOrderSelect(int shift=0, int pos_id=0)
{
   if(shift == 0) //現在のポジションの選択
   {
      for(int i=0; i<OrdersTotal(); i++)
      {
         if(!OrderSelect(i, SELECT_BY_POS)) return false;
         if(OrderSymbol() != _Symbol
            || OrderMagicNumber() != MagicNumber[pos_id]) continue;
         return true; //正常終了
      }
   }
   if(shift > 0) //過去のポジションの選択
   {
      for(i=OrdersHistoryTotal()-1; i>=0; i--)
      {
         if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) return false;
         if(OrderSymbol() != _Symbol
            || OrderMagicNumber() != MagicNumber[pos_id]) continue;
         if(--shift > 0) continue;
         return true; //正常終了
      } 
   }
   return false; //ポジション選択なし
}

//チケット番号の取得
int MyOrderTicket(int pos_id=0)
{
   int ticket = 0;
   if(MyOrderSelect(0, pos_id)) ticket = OrderTicket();
   return ticket;
}

//注文タイプの取得
int MyOrderType(int pos_id=0)
{
   int type = OP_NONE;
   if(MyOrderSelect(0, pos_id)) type = OrderType();
   return type;
}

//注文のロット数の取得
double MyOrderLots(int pos_id=0)
{
   double lots = 0;
   if(MyOrderSelect(0, pos_id)) lots = OrderLots();
   return lots;
}

//オープンポジションのロット数（符号付）を取得
double MyOrderOpenLots(int pos_id=0)
{
   double lots = 0;
   int type = MyOrderType(pos_id);
   double newlots = MyOrderLots(pos_id); 
   if(type == OP_BUY) lots = newlots;   //買いポジションはプラス
   if(type == OP_SELL) lots = -newlots; //売りポジションはマイナス
   return lots;   
}

//ポジションの売買価格の取得
double MyOrderOpenPrice(int pos_id=0)
{
   double price = 0;
   if(MyOrderSelect(0, pos_id)) price = OrderOpenPrice();
   return price;   
}

//ポジションの売買時刻の取得
datetime MyOrderOpenTime(int pos_id=0)
{
   datetime opentime = 0;
   if(MyOrderSelect(0, pos_id)) opentime = OrderOpenTime();
   return opentime;   
}

//オープンポジションの決済価格の取得
double MyOrderClosePrice(int pos_id=0)
{
   double price = 0;
   if(MyOrderSelect(0, pos_id)) price = OrderClosePrice();
   return price ;
}

//ポジションに付加された損切り価格の取得
double MyOrderStopLoss(int pos_id=0)
{
   double sl = 0;
   if(MyOrderSelect(0, pos_id)) sl = OrderStopLoss();
   return sl;
}

//ポジションに付加された利食い価格の取得
double MyOrderTakeProfit(int pos_id=0)
{
   double tp = 0;
   if(MyOrderSelect(0, pos_id)) tp = OrderTakeProfit();
   return tp;
}

//オープンポジションの損益（金額）の取得
double MyOrderProfit(int pos_id=0)
{
   double profit = 0;
   if(MyOrderSelect(0, pos_id)) profit = OrderProfit();
   return profit;
}

//オープンポジションの損益（pips）の取得
double MyOrderProfitPips(int pos_id=0)
{
   double profit = 0;
   //決済価格-約定価格
   double newprofit = MyOrderClosePrice(pos_id)
                    - MyOrderOpenPrice(pos_id);
   //買いポジション
   if(MyOrderType(pos_id) == OP_BUY) profit = newprofit;
   //売りポジション
   if(MyOrderType(pos_id) == OP_SELL) profit = -newprofit;
   return profit/PipPoint; //pips値に変換
}

//前回のポジションの注文タイプの取得
int MyOrderLastType(int pos_id=0)
{
   int type = OP_NONE;
   if(MyOrderSelect(1, pos_id)) type = OrderType();
   return type;
}

//前回のポジションのロット数の取得
double MyOrderLastLots(int pos_id=0)
{
   double lots = 0;
   if(MyOrderSelect(1, pos_id)) lots = OrderLots();
   return lots;   
}

//前回のポジションの売買価格の取得
double MyOrderLastOpenPrice(int pos_id=0)
{
   double price = 0;
   if(MyOrderSelect(1, pos_id)) price = OrderOpenPrice();
   return price;
}

//前回のポジションの売買時刻の取得
datetime MyOrderLastOpenTime(int pos_id=0)
{
   datetime opentime = 0;
   if(MyOrderSelect(1, pos_id)) opentime = OrderOpenTime();
   return opentime;   
}

//前回のポジションの決済価格の取得
double MyOrderLastClosePrice(int pos_id=0)
{
   double price = 0;
   if(MyOrderSelect(1, pos_id)) price = OrderClosePrice();
   return price;
}

//前回のポジションの決済時刻の取得
datetime MyOrderLastCloseTime(int pos_id=0)
{
   datetime closetime = 0;
   if(MyOrderSelect(1, pos_id)) closetime = OrderCloseTime();
   return closetime;   
}

//前回のポジションの損益（金額）の取得
double MyOrderLastProfit(int pos_id=0)
{
   double profit = 0;
   if(MyOrderSelect(1, pos_id)) profit = OrderProfit();
   return profit;
}

//前回のポジションの損益（pips）の取得
double MyOrderLastProfitPips(int pos_id=0)
{
   double profit = 0;
   //決済価格-約定価格
   double newprofit = MyOrderLastClosePrice(pos_id)
                    - MyOrderLastOpenPrice(pos_id);
   //買いポジション
   if(MyOrderLastType(pos_id) == OP_BUY) profit = newprofit;
   //売りポジション
   if(MyOrderLastType(pos_id) == OP_SELL) profit = -newprofit;
   return profit/PipPoint; //pips値に変換
}

//ポジション情報の表示
void MyOrderPrint(int pos_id=0)
{
   //ロット数の刻み幅
   double lots_step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   //ロット数の小数点以下桁数
   int lots_digits = MathLog10(1.0/lots_step);
   string stype[] = {"buy", "sell", "buy limit", "sell limit",
                     "buy stop", "sell stop"};
   string s = "MyPos[";
   s = s + pos_id + "] ";  //ポジション番号
   if(MyOrderType(pos_id) == OP_NONE) s = s + "No position";
   else
   {
      s = s + "#"
            + MyOrderTicket(pos_id) //チケット番号
            + " ["
            + TimeToStr(MyOrderOpenTime(pos_id)) //売買日時
            + "] "
            + stype[MyOrderType(pos_id)]  //注文タイプ
            + " "
            + DoubleToStr(MyOrderLots(pos_id), lots_digits) //ロット数
            + " "
            + _Symbol //通貨ペア
            + " at " 
            + DoubleToStr(MyOrderOpenPrice(pos_id), Digits); //売買価格
      //損切り価格
      if(MyOrderStopLoss(pos_id) != 0) s = s + " sl "
         + DoubleToStr(MyOrderStopLoss(pos_id), Digits);
      //利食い価格
      if(MyOrderTakeProfit(pos_id) != 0) s = s + " tp " 
         + DoubleToStr(MyOrderTakeProfit(pos_id), Digits);
      s = s + " magic " + MagicNumber[pos_id]; //マジックナンバー
   }
   Print(s); //出力
}
