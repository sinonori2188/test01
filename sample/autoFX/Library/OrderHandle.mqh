//+------------------------------------------------------------------+
//|                                                  OrderHandle.mqh |
//|                                     Copyright (c) 2015, りゅーき |
//|                                           https://autofx100.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2015, りゅーき"
#property link      "https://autofx100.com/"
#property version   "1.00"

//+------------------------------------------------------------------+
//| 定数定義                                                         |
//+------------------------------------------------------------------+
// 注文数またはロット数合計
#define OP_OPEN           6 // ポジション
#define OP_LIMIT          7 // 指値注文
#define OP_STOP           8 // 逆指値注文
#define OP_ALL            9 // 全て
#define SUM_ORDER_NUMBER  1 // 注文数
#define SUM_LOTSIZE       2 // ロット数

//+------------------------------------------------------------------+
//|【関数】指定の注文種類の注文数またはロット数を合計する            |
//|                                                                  |
//|【引数】 IN OUT  引数名             説明                          |
//|        --------------------------------------------------------- |
//|         ○      aType              注文種別                      |
//|         ○      aMagic             マジックナンバー              |
//|         ○      aKbn               カウント対象                  |
//|                                      1: 注文数                   |
//|                                      2: ロット数                 |
//|         △      aComment           合計対象コメント              |
//|                                                                  |
//|【戻値】合計注文数または合計ロット数                              |
//|                                                                  |
//|【備考】△：既定値あり                                            |
//+------------------------------------------------------------------+
double sumOrderNumberOrLotSize(int aType, int aMagic, int aKbn, string aComment = "")
{
  double sumOrder = 0.0;
  double sumLot   = 0.0;

  for(int i = 0; i < OrdersTotal(); i++){
    if(OrderSelect(i, SELECT_BY_POS) == false){
      break;
    }

    if(OrderSymbol() != Symbol() || OrderMagicNumber() != aMagic){
      continue;
    }

    if(aComment != "" && OrderComment() != aComment){
      continue;
    }

    int type = OrderType();
    double lot = OrderLots();

    if(aType == OP_BUY){
      if(type == OP_BUY){
        sumOrder += 1.0;
        sumLot   += lot;
      }
    }else if(aType == OP_SELL){
      if(type == OP_SELL){
        sumOrder += 1.0;
        sumLot   += lot;
      }
    }else if(aType == OP_BUYSTOP){
      if(type == OP_BUYSTOP){
        sumOrder += 1.0;
        sumLot   += lot;
      }
    }else if(aType == OP_SELLSTOP){
      if(type == OP_SELLSTOP){
        sumOrder += 1.0;
        sumLot   += lot;
      }
    }else if(aType == OP_OPEN){
      if(type == OP_BUY || type == OP_SELL){
        sumOrder += 1.0;
        sumLot   += lot;
      }
    }else if(aType == OP_LIMIT){
      if(type == OP_BUYLIMIT || type == OP_SELLLIMIT){
        sumOrder += 1.0;
        sumLot   += lot;
      }
    }else if(aType == OP_STOP){
      if(type == OP_BUYSTOP || type == OP_SELLSTOP){
        sumOrder += 1.0;
        sumLot   += lot;
      }
    }else if(aType == OP_ALL){
      sumOrder += 1.0;
      sumLot   += lot;
    }else{
      Print("sumOrderNumberOrLotSize: 不正な注文種別です。aType = " + aType);
      return(-1);
    }
  }

  if(aKbn == SUM_ORDER_NUMBER){
    double num = sumOrder;
  }else if(aKbn == SUM_LOTSIZE){
    num = sumLot;
  }

  return(num);
}

//+------------------------------------------------------------------+
//|                                             OrderApplicative.mqh |
//|                                     Copyright (c) 2015, りゅーき |
//|                                            https://autofx100.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2015, りゅーき"
#property link      "https://autofx100.com/"
#property version   "1.00"

//+------------------------------------------------------------------+
//|【関数】一般的なトレイリングストップ                              |
//|                                                                  |
//|【引数】 IN OUT  引数名             説明                          |
//|        --------------------------------------------------------- |
//|         ○      aMagic             マジックナンバー              |
//|         ○      aTS_StartPips      ﾄﾚｲﾘﾝｸﾞｽﾄｯﾌﾟ開始値幅（pips）  |
//|         ○      aTS_StopPips       損切り値幅（pips）            |
//|                                                                  |
//|【戻値】なし                                                      |
//|                                                                  |
//|【備考】仕掛け位置からaTS_StartPips順行したら、その位置か         |
//|        aTS_StopPips逆行した位置にストップを設定                  |
//+------------------------------------------------------------------+
void trailingStopGeneral(int aMagic, double aTS_StartPips, double aTS_StopPips)
{
  for(int i = 0; i < OrdersTotal(); i++){
    // オーダーが１つもなければ処理終了
    if(OrderSelect(i, SELECT_BY_POS) == false){
      break;
    }

    string oSymbol = OrderSymbol();

    // 別EAのオーダーはスキップ
    if(oSymbol != Symbol() || OrderMagicNumber() != aMagic){
      continue;
    }

    int oType = OrderType();

    // 待機オーダーはスキップ
    if(oType != OP_BUY && oType != OP_SELL){
      continue;
    }

    double digits = MarketInfo(oSymbol, MODE_DIGITS);

    double oPrice    = NormalizeDouble(OrderOpenPrice(), digits);
    double oStopLoss = NormalizeDouble(OrderStopLoss(), digits);
    int    oTicket   = OrderTicket();

    double start = aTS_StartPips * gPipsPoint;
    double stop  = aTS_StopPips  * gPipsPoint;

    if(oType == OP_BUY){
      double price = MarketInfo(oSymbol, MODE_BID);
      double modifyStopLoss = price - stop;

      if(price >= oPrice + start){
        if(modifyStopLoss > oStopLoss){
          orderModifyReliable(oTicket, 0.0, modifyStopLoss, 0.0, 0, gArrowColor[oType]);
        }
      }
    }else if(oType == OP_SELL){
      price = MarketInfo(oSymbol, MODE_ASK);
      modifyStopLoss = price + stop;

      if(price <= oPrice - start){
        // ショートの場合、条件式にoStopLoss == 0.0が必要
        // oStopLoss=0は、損切り値を設定していない場合
        // その場合、modifyStopLoss < oStopLossの条件は永久に成立しない（※）ため
        // ※「modifyStopLoss < 0」でかつ「modifyStopLossは価格なので0以上」のため
        if(modifyStopLoss < oStopLoss || oStopLoss == 0.0){
          orderModifyReliable(oTicket, 0.0, modifyStopLoss, 0.0, 0, gArrowColor[oType]);
        }
      }
    }
  }
}
