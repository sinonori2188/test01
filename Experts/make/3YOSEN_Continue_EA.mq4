//+------------------------------------------------------------------+
//|                                                 EA_make_1.00.mq4 |
//|                                                        FXantenna |
//|                                            https://fxantenna.com |
//+------------------------------------------------------------------+
#property copyright "fxantenna"
#property link      "https://fxantenna.com"
#property version   "1.00"
#property strict

input ulong Magic = 71952000;  // EAマジックナンバー
static int TicketNumber;
static int Bar[2];
    
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    Bar[1] = Bar[0];
    Bar[0] = iBars(NULL,PERIOD_CURRENT);
    if (Bar[0] != Bar[1])
    {
        // エントリー条件：ポジションが無く、陽線が３本続いたらエントリ。
        if (OrdersTotal() == 0)
        {
            if( iOpen(Symbol(),0,1) < iClose(Symbol(),0,1) &&    // １つ前のローソク足が陽線
                iOpen(Symbol(),0,2) < iClose(Symbol(),0,2) &&    // ２つ前のローソク足が陽線
                iOpen(Symbol(),0,3) < iClose(Symbol(),0,3))      // ３つ前のローソク足が陽線
            {
                TicketNumber = OrderSend(Symbol(),OP_BUY,0.1,Ask,3,0,0,"EA",Magic,0,Red);
            }
        }
    }

   // 決済条件：ポジションが１つ以上で７時か１９時になったら
   if( OrdersTotal() > 0 && ( Hour() == 7 || Hour() == 19)){
      OrderClose(TicketNumber,0.1,Bid,3,Yellow);
   }

   // コメント表示
   Comment(WindowExpertName( )+"\n"+
         "MagicNumber: "+TicketNumber+"\n"+
         "\n"+
         "PC    : "+TimeToStr(TimeLocal(),TIME_DATE|TIME_MINUTES)+"\n"+
         "Server: "+TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES)+"\n"+
         "\n"+
         "Trade Company : "+AccountCompany()+"\n"+
         "Server : "+AccountServer()+"\n"+
         "\n"+
         "Spread : "+MarketInfo(Symbol(),MODE_SPREAD)+"\n"+
         "Stop Level : "+MarketInfo(Symbol(),MODE_STOPLEVEL)+"\n"+
         "\n"+
         "Swap Long  : "+MarketInfo(Symbol(),MODE_SWAPLONG)+"\n"+
         "Swap Short  : "+MarketInfo(Symbol(),MODE_SWAPSHORT)+"\n"+
         "\n"+
         "Max Leverage : "+AccountLeverage()+"\n"+
         "Currency : "+AccountCurrency()+"\n"+
         "Equity : "+AccountEquity()+"\n"+
         "\n");

}
//+------------------------------------------------------------------+
