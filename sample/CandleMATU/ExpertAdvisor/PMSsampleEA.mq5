//MQL5ではパラメーター設定の際extern~ではなく、inputを使います。
//似たようなものでsinputというのがありますがsinputは最適化の際に変更できないので変更されたくないものはsinputにしておくといいかと思います。
//基本的な違いは公式の記事に目を通しておくことをおすすめします
//https://www.mql5.com/ja/docs/migration
//https://www.mql5.com/ja/articles/81

sinput int magicnum = 10;//マジックナンバー
input double Lots = 0.1;   //売買ロット数
input int RSIPeriod = 7;  //RSI期間
input int ue = 70;  //○○以上で売り
input int sita = 30;  //○○以下で買い
input int rikaku = 50;  //利確ポイント
input int son = 50;  //損切ポイント


//変数の宣言

int Ticket = 0; //チケット番号
int NowBars;
bool Entry,Closed;

double RSI[];  //RSI配列
double Price;
int RSIHandle; //RSI用ハンドル
bool BUY,SELL = false;


int OnInit()
{
   //テクニカル指標の初期化・ハンドルを定義
   RSIHandle = iRSI(_Symbol,0, RSIPeriod, PRICE_CLOSE);
   
   //MQL5では配列の順番が逆（最新足がすべてのバーの数）なのでArraySetAsSeriesを使い配列の順番を逆にします
   ArraySetAsSeries(RSI, true);
   
   return 0;
}

//ティック時実行関数

void OnTick()
{
   //RSIの値をハンドルを使いCopyBufferという関数を使い呼び出します。
   CopyBuffer(RSIHandle, 0, 0, 3, RSI);//過去3本分のRSIを取得


//Barsの呼び出し方が違うので注意   
   int Bar=Bars(_Symbol,_Period);
   
   BUY = false;
   SELL = false;
   
//ASKとBIDの呼び出し方もMQL4と違います（ややこしいですね） 
//MQL5では構造体というのがよく出現します。（MqlTickなど）
//MqlTick→https://www.mql5.com/ja/docs/constants/structures/mqltick
//構造体というのは簡単に説明すると複数のデータが保存できる箱みたいなものです。
//配列は一つの型でしか値を保存できませんが構造体は複数の型を複数個保存しておくことができます。
//last_tickという構造体にSymbolInfoTickを使い現在の価格を保存
//そこからASK、BIDの値を保存するという流れになります。
// 
   MqlTick last_tick;
   SymbolInfoTick(_Symbol,last_tick);
   double Ask=last_tick.ask;
   double Bid=last_tick.bid;
   
   
//PositionSelectByTicket(Ticket)はMQL4でいう OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADE)です。
//PositionGetInteger, PositionGetDoubleでポジション情報を取得できます。

   if(PositionSelectByTicket(Ticket))
   {
   
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) { //買いポジション
      BUY = true;
      Price = PositionGetDouble(POSITION_PRICE_OPEN);
      }
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL){ //売りポジション
      SELL = true; //売りポジション
      Price = PositionGetDouble(POSITION_PRICE_OPEN);
      }
   }


//ここからオーダー関数に入ります
//MQL5ではMqlTradeRequest(取引の詳細)・MqlTradeResult(取引操作の結果)の構造体を送信することでオーダー、クローズ処理ができます。
//クローズ処理ではrequestという構造体の中に詳細を入れてそれをOrderSendで実行していくという流れです。
//MqlTradeRequest⇒https://www.mql5.com/ja/docs/constants/structures/mqltraderequest
 
  
  if(BUY == true){
  if(Bid >= Price+rikaku*_Point || Bid <= Price-son*_Point){  //買いポジションの決済条件
         MqlTradeRequest request = {0};//構造体の初期化
         MqlTradeResult result = {0}; 
         request.action = TRADE_ACTION_DEAL;//取引操作の種類、成行注文の場合はTRADE_ACTION_DEALです。その他の種類はコチラ⇒https://www.mql5.com/ja/docs/constants/tradingconstants/enum_trade_request_actions
         request.symbol = _Symbol;
         request.volume = Lots;
         request.price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         request.type = ORDER_TYPE_SELL;
         request.position = Ticket;//チケット番号
         Closed = OrderSend(request, result);//オーダーセンドでMqlTradeRequest(取引の詳細)・MqlTradeResult(取引操作の結果)を送信
         if(result.retcode == TRADE_RETCODE_DONE) BUY = false;//決済されたのでfalseに 
  
  }
  }
  
  if(SELL == true){
   if(Ask <= Price-rikaku*_Point || Ask >= Price+son*_Point){ 
         MqlTradeRequest request = {0};
         MqlTradeResult result = {0}; 
         request.action = TRADE_ACTION_DEAL;
         request.symbol = _Symbol;
         request.volume = Lots;
         request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         request.type = ORDER_TYPE_BUY;
         request.position = Ticket;
         Closed = OrderSend(request, result);
         if(result.retcode == TRADE_RETCODE_DONE) SELL = false; 
   
   }
   } 
   
//確定足 
  if( NowBars < Bar){ 
       NowBars = Bar;
       
//エントリ―も同様に構造体を使い、行っていきます。
//       
   if(RSI[2] >= sita && RSI[1] < sita) //買いシグナル
   {
      //ポジションがなければ買い注文
      if(BUY == false && SELL==false)
      {
         MqlTradeRequest request = {0};
         MqlTradeResult result = {0}; 
         request.action = TRADE_ACTION_DEAL;
         request.symbol = _Symbol;
         request.volume = Lots;
         request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         request.type = ORDER_TYPE_BUY;
         request.magic = magicnum;
         //request.type_filling=ORDER_FILLING_IOC;
         Entry = OrderSend(request, result);
         if(result.retcode == TRADE_RETCODE_DONE) Ticket = result.deal;//注文が成功したらチケット番号を保存
      }
   }
   
   
   if(RSI[2] <= ue && RSI[1] > ue) //売りシグナル
   {
      //ポジションがなければ売り注文
      if(BUY == false && SELL==false)
      {
         MqlTradeRequest request = {0};
         MqlTradeResult result = {0}; 
         request.action = TRADE_ACTION_DEAL;
         request.symbol = _Symbol;
         request.volume = Lots;
         request.price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         request.type = ORDER_TYPE_SELL;
         request.magic = magicnum;
         //request.type_filling=ORDER_FILLING_IOC;
         Entry = OrderSend(request, result);
         if(result.retcode == TRADE_RETCODE_DONE) Ticket = result.deal;
      }
   }
   
   }//NowBars
}
