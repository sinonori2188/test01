//+------------------------------------------------------------------+
//|                                        OutputTradeHistoryCSV.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//| 機　能：トレード履歴のCSVファイル出力スクリプト
//| 詳　細：①マジックナンバーとオーダー時コメントでフィルタリング
//| 　　　　②「\\MQL4\Files\TradeHistory_yyyy.mm.dd.csv」を出力
//|                                  ※yyyy.mm.ddはサーバーの現在日付
//| 前　提：[口座履歴]タブの任意の場所で右クリックして[全履歴]を選択
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs //実行時にパラメーターウィンドウを表示

//+-----------------------------------------------------------------+
//| パラメータ設定情報                                               |
//+-----------------------------------------------------------------+
extern bool     extDisplayHeader      = true;          //見出の出力時はtrue
extern datetime extCloseTimeFrom      = NULL;          //出力開始となる決済日時(From)
extern datetime extCloseTimeTo        = D'2038.01.01'; //出力開始となる決済日時(To)
extern string   extFileName           = "";            //ファイル名の追記

//Trueは、CommentとMagicNumberをAND条件で検索。Flaseは、OR条件で検索
//extCommentFilter1～3とagicNumberFilter1～3は、それぞれOR条件で検索
extern string   extHelp               = "true:AND false:OR";  //後続パラメーターの説明
extern bool     extFilterSwitch       = true;
extern string   extCommentFilter1     = "";
extern string   extCommentFilter2     = "";
extern string   extCommentFilter3     = "";
extern string   extMagicNumberFilter1 = "";
extern string   extMagicNumberFilter2 = "";
extern string   extMagicNumberFilter3 = "";

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
  //ターミナルにロードされたアカウント履歴の決済済み注文の数を取得
  int historyTotal = OrdersHistoryTotal();

  // トレード履歴の有無チェック
  if(historyTotal <= 0){
    Print("トレード履歴データはありません。");
    return;
  }

  int ticket[];
  ArrayResize(ticket, historyTotal);
  ArrayInitialize(ticket, -1);

  for(int i = 0; i < historyTotal; i++){
    if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)){
      if(OrderType() == OP_BUY || OrderType() == OP_SELL){
        ticket[i] = OrderTicket();
        OrderPrint();
      }else{
        Print("OK");
        ticket[i] = -1;
      }
    }
  }

  // ファイル名
  string flNm = "";
  string ymdhms = replace(TimeToStr(TimeLocal(), TIME_DATE|TIME_SECONDS), ":", ".");

  if(extFileName == ""){
    flNm = "TradeHistory_" + ymdhms + ".csv";
  }else{
    flNm = "TradeHistory_" + extFileName + "_" + ymdhms + ".csv";
  }

  Print("flNm = ", flNm);

  int fileHandle = FileOpen(flNm, FILE_CSV|FILE_WRITE, ",");

  if(fileHandle < 0){
    Print("ファイルハンドルがありません。");
    return;
  }

  // ヘッダー出力
  if(extDisplayHeader){
    FileWrite(fileHandle,
              "注文番号",
              "マジックナンバー",
              "コメント",
              "通貨ペア",
              "取引種別",
              "ロットサイズ",
              "約定時刻",
              "約定価格",
              "決済時刻",
              "決済価格",
              "手数料",
              "スワップ損益",
              "トレード損益",
              "総損益",
              "獲得Pips"
             );
  }

  for(int i = 0; i < historyTotal; i++){
    if(ticket[i] != -1){
      if(OrderSelect(ticket[i], SELECT_BY_TICKET, MODE_HISTORY)){

        int matchFlg = 0;

        //出力フィルタリング
        if(extFilterSwitch){ //AND

          if(extMagicNumberFilter1 == "" && extMagicNumberFilter2 == "" && extMagicNumberFilter3 == ""){
            matchFlg = 1;
          }
          if(extMagicNumberFilter1 != "" && StrToInteger(extMagicNumberFilter1) == OrderMagicNumber()){
            matchFlg = 1;
          }
          if(extMagicNumberFilter2 != "" && StrToInteger(extMagicNumberFilter2) == OrderMagicNumber()){
            matchFlg = 1;
          }
          if(extMagicNumberFilter3 != "" && StrToInteger(extMagicNumberFilter3) == OrderMagicNumber()){
            matchFlg = 1;
          }
          if(matchFlg == 0){
            continue;
          }

          matchFlg = 0;

          if(extCommentFilter1 == "" && extCommentFilter2 == "" && extCommentFilter3 == ""){
            matchFlg = 1;
          }
          if(extCommentFilter1 != "" && StringFind(OrderComment(), extCommentFilter1) != -1){
            matchFlg = 1;
          }
          if(extCommentFilter2 != "" && StringFind(OrderComment(), extCommentFilter2) != -1){
            matchFlg = 1;
          }
          if(extCommentFilter3 != "" && StringFind(OrderComment(), extCommentFilter3) != -1){
            matchFlg = 1;
          }
          if(matchFlg == 0){
            continue;
          }

        }else{ //OR

          if(extMagicNumberFilter1 == "" && extMagicNumberFilter2 == "" && extMagicNumberFilter3 == "" && extCommentFilter1 == "" && extCommentFilter2 == "" && extCommentFilter3 == ""){
            matchFlg = 1;
          }
          if(extMagicNumberFilter1 != "" && StrToInteger(extMagicNumberFilter1) == OrderMagicNumber()){
            matchFlg = 1;
          }
          if(extMagicNumberFilter2 != "" && StrToInteger(extMagicNumberFilter2) == OrderMagicNumber()){
            matchFlg = 1;
          }
          if(extMagicNumberFilter3 != "" && StrToInteger(extMagicNumberFilter3) == OrderMagicNumber()){
            matchFlg = 1;
          }
          if(extCommentFilter1 != "" && StringFind(OrderComment(), extCommentFilter1) != -1){
            matchFlg = 1;
          }
          if(extCommentFilter2 != "" && StringFind(OrderComment(), extCommentFilter2) != -1){
            matchFlg = 1;
          }
          if(extCommentFilter3 != "" && StringFind(OrderComment(), extCommentFilter3) != -1){
            matchFlg = 1;
          }
          if(matchFlg == 0){
            continue;
          }

        }

        string displayOpenTime  = TimeToStr(OrderOpenTime());
        string displayCloseTime = TimeToStr(OrderCloseTime());

        if(StrToTime(displayCloseTime) < extCloseTimeFrom || StrToTime(displayCloseTime) > extCloseTimeTo){
          continue;
        }

        string oTicket = (string)ticket[i];
        string oType = "";
        if(OrderType() == OP_BUY){
          oType = "BUY";
        }else if(OrderType() == OP_SELL){
          oType = "SELL";
        }else{
          oType = "";
        }

        double oPlice = OrderOpenPrice();
        double cPlice = OrderClosePrice();

        double points = 0;
        if(StringFind(OrderSymbol(), "JPY") != -1){
          points = 0.001;
        }else{
          points = 0.00001;
        }

        double total = OrderCommission() + OrderSwap() + OrderProfit();

        int mult = 1;
        if(Digits == 3 || Digits == 5){
          mult = 10;
        }

        double calcPips = 0;
        if(OrderType() == OP_BUY){
          calcPips = (cPlice - oPlice) / (points * mult);
        }else if(OrderType() == OP_SELL){
          calcPips = (oPlice - cPlice) / (points * mult);
        }

        FileSeek(fileHandle, 0, SEEK_END);

        FileWrite(fileHandle,
                  oTicket,
                  OrderMagicNumber(),
                  OrderComment(),
                  OrderSymbol(),
                  oType,
                  OrderLots(),
                  displayOpenTime,
                  oPlice,
                  displayCloseTime,
                  cPlice,
                  OrderCommission(),
                  OrderSwap(),
                  OrderProfit(),
                  total,
                  calcPips
                 );
      }
    }
  }

  FileClose(fileHandle);

  return;
}

//+------------------------------------------------------------------+
//|【関数】文字列置換                                                |
//|                                                                  |
//|【引数】 IN OUT  引数名             説明                          |
//|        --------------------------------------------------------- |
//|         ○      aTarget            対象文字列                    |
//|         ○      aSearch            検索文字列                    |
//|         ○      aReplace           置換文字列                    |
//|                                                                  |
//|【戻値】置換された文字列                                          |
//|                                                                  |
//|【備考】なし                                                      |
//+------------------------------------------------------------------+
string replace(string aTarget, string aSearch, string aReplace = "")
{
  string left;
  string right;
  int start=0;
  int rlen = StringLen(aReplace);
  int nlen = StringLen(aSearch);

  while(start > -1){
    start = StringFind(aTarget, aSearch, start);
    if(start > -1){
      if(start > 0){
        left = StringSubstr(aTarget, 0, start);
      }else{
        left="";
      }
      right = StringSubstr(aTarget, start + nlen);
      aTarget = left + aReplace + right;
      start = start + rlen;
   }
 }
 return(aTarget);
}