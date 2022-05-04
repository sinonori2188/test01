//+------------------------------------------------------------------+
//|                                                         .mq4 |
//|                                              Copyright 2021 ands |
//|                                                                  |
//+------------------------------------------------------------------+

/*

EAの詳細ロジック


通貨ペア：AUDUSD
時間足：15分足

売り専門

【エントリー】
直近32本（8時間）の高値を超えたとき+ADX（14）が20以上+ATR（14）の○○倍の大きさローソク足（実体）が出たとき（1.5倍くらい？）

【ナンピン】
エントリー条件と同条件（Lotも同じ）

【決済】
直近32本の安値を更新+ATR（14）の○○倍の大きさローソク足（実体）が出たとき（1.5倍くらい？）


*/


#property copyright "Copyright 2021 "
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()

  {
//---
   Adjusted_Slippage=
      AdjustSlippage(Symbol(),Slippage);
//---

   /*  if(!Certification){
        if(!UseSystem(AccountNumber())){
           Certification = false;
           Comment("Invalid Account");
           return(INIT_FAILED);
        }
        else{
           Certification = true;
           Comment("Valid Account");
        }
     }

     if(StringSubstr(Symbol(),0,6) != "USDJPY"){
        Comment("Symbol is not 'USDJPY'.");
        return(INIT_FAILED);
     }*/

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int NowBars=0;
int totalpos, a, b, nm,  lm, buy, sell, nm2, rikaku2, lm2=0;
int Adjusted_Slippage=0;
bool Closed, Ticket, flag, flag2, flag3, flag4 = false;
double buystop, sellstop, SL, lot, balance, SL2, lot2, balance2;
int ticket;
bool Certification = false;
datetime time;


string Note0="";//----------基本設定----------
//extern long UserID =0;//使用者口座番号
extern int  magicnum = 101849;//マジックナンバー
extern double Lots=0.1;  // スタートロット数
bool BUY = true;
bool SELL = true;
extern int maxp = 100;//最大ポジション数
int Slippage=10;  // 許容スリッページ
//extern int mininan = 50;//最低ナンピン幅
extern int ueline = 20;//ADX上ライン
extern double At = 1.5;//ATR制御



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int AdjustSlippage(string Currency,int Slippage_Pips)
  {
   int Calculated_Slippage=0;

   int Symbol_Digits=(int)MarketInfo(Currency,MODE_DIGITS);

   if(Symbol_Digits==2 || Symbol_Digits==4)
     {
      Calculated_Slippage=Slippage_Pips;
     }
   else
      if(Symbol_Digits==3 || Symbol_Digits==5)
        {
         Calculated_Slippage=Slippage_Pips*10;
        }

   return(Calculated_Slippage);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   
   totalpos=OrdersTotal();


//足1回だけ通る

   if(time != Time[0])
     {
      time = Time[0];

//使用するインジケーター
      double ADX = iADX(NULL,0,14,PRICE_CLOSE,MODE_MAIN,1);
      double ADX1 = iADX(NULL,0,14,PRICE_CLOSE,MODE_MAIN,2);

      double ATR = iATR(NULL,0,14,1);
      double ATR1 = iATR(NULL,0,14,2);

//高安の位置を取得
      int hp = iHighest(NULL,0,MODE_HIGH,34,2);
      int lp = iLowest(NULL,0,MODE_LOW,34,2);

  int buy = 0;
  int sell = 0;
  
//ポジション数の取得
   for(int  i = totalpos-1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {
         if(OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum)
           {
            buy++;
           }
         if(OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum)
           {
            sell++;
           }
        }
     }

      //決済条件

      if(High[hp]<Close[1] && MathAbs(Open[1]-Close[1])>=ATR1*At)
        {
         for(int i = OrdersTotal()-1; i>=0; i--)
           {
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
              {

               if(OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum)
                 {
                  if(OrderType()==OP_BUY)
                     Closed = OrderClose(OrderTicket(),OrderLots(), Bid, Adjusted_Slippage,White);
                 }
              }
           }
        }
      if(Low[lp]>Close[1] && MathAbs(Open[1]-Close[1])>=ATR1*At)
        {
         for(int i = OrdersTotal()-1; i>=0; i--)
           {
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
              {

               if(OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum)
                 {
                  if(OrderType()==OP_SELL)
                     Closed = OrderClose(OrderTicket(),OrderLots(), Bid, Adjusted_Slippage,White);
                 }
              }
           }
        }


      //ナンピン条件

      if(OrdersTotal() > 0 && OrdersTotal() < maxp)
        {

         if(buy > 0 && Low[lp]>Close[1] && MathAbs(Open[1]-Close[1])>=ATR1*At && ADX>ueline)
           {
            Ticket=OrderSend(NULL,OP_BUY,Lots,Ask,Adjusted_Slippage,0,0,NULL,magicnum,0,White);
           }

         if(sell > 0 && High[hp]<Close[1] && MathAbs(Open[1]-Close[1])>=ATR1*At && ADX>ueline)
           {
            Ticket=OrderSend(NULL,OP_SELL,Lots,Ask,Adjusted_Slippage,0,0,NULL,magicnum,0,White);
           }

        }



      //エントリー条件

      if(BUY == true && OrdersTotal()==0)
        {
         if(Low[lp]>Close[1] && MathAbs(Open[1]-Close[1])>=ATR1*At && ADX>ueline)
           {
            Ticket = OrderSend(NULL,OP_BUY,Lots,Ask,Adjusted_Slippage,0,0,NULL,magicnum,0,White);
           }
        }

      if(SELL == true && OrdersTotal()==0)
        {
         if(High[hp]<Close[1] && MathAbs(Open[1]-Close[1])>=ATR1*At && ADX>ueline)
           {
            Ticket = OrderSend(NULL,OP_SELL,Lots,Bid,Adjusted_Slippage,0,0,NULL,magicnum,0,White);
           }
        }
     }

//+------------------------------------------------------------------+



  }//---OnTick
//+------------------------------------------------------------------+

long          UserID1           =0;
long          UserID2           =0;
long          UserID3           =0;
long          UserID4           =0;
long          UserID5           =0;
long          UserID6           =0;
long          UserID7           =0;
long          UserID8           =0;
long          UserID9           =0;
long          UserID10          =0;
long          UserID11           =0;
long          UserID12           =0;
long          UserID13           =0;
long          UserID14           =0;
long          UserID15           =0;
long          UserID16           =0;
long          UserID17           =0;   //   様
long          UserID18           =0;    //   様
long          UserID19           =0;   //  様
long          UserID20           =0;   //    様
long          UserID21           =0;   //  様
long          UserID22           =0;   //  様
long          UserID23           =0;   //  様
long          UserID24           =0;    //  様
long          UserID25           =0;   //  様
long          UserID26           =0;   //   様
long          UserID27           =0;  //  様
long          UserID28           =0;    //  様
long          UserID29           =0;   //  様
long          UserID30           =0;   //   様
long          UserID31           =0;   //  様
long          UserID32           =0;   //   様
long          UserID33           =0;   //  様
long          UserID34           =0;   //  様
long          UserID35           =0;   //  様
long          UserID36           =0;   //  様
long          UserID37           =0;   //  様
long          UserID38           =0;   //  様
long          UserID39           =0;   //  様
long          UserID40           =0;   //  様
long          UserID41           =0;   // 様
long          UserID42           =0;   // 様
long          UserID43           =0;   // 様
long          UserID44           =0;   // 様
long          UserID45           =0;   // 様
long          UserID46           =0;   // 様
long          UserID47           =0;   // 様
long          UserID48           =0;   // 様
long          UserID49           =0;   // 様


long          UserID           =0;  //あなたのMT4番号


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool UseSystem(long userid)
  {

   if((userid == UserID
       || userid == UserID1
       || userid == UserID2
       || userid == UserID3
       || userid == UserID4
       || userid == UserID5
       || userid == UserID6
       || userid == UserID7
       || userid == UserID8
       || userid == UserID9
       || userid == UserID10
       || userid == UserID11
       || userid == UserID12
       || userid == UserID13
       || userid == UserID14
       || userid == UserID15
       || userid == UserID16
       || userid == UserID17
       || userid == UserID18
       || userid == UserID19
       || userid == UserID20
       || userid == UserID21
       || userid == UserID22
       || userid == UserID23
       || userid == UserID24
       || userid == UserID25
       || userid == UserID26
       || userid == UserID27
       || userid == UserID28
       || userid == UserID29
       || userid == UserID30
       || userid == UserID31
       || userid == UserID32
       || userid == UserID33
       || userid == UserID34
       || userid == UserID35
       || userid == UserID36
       || userid == UserID37
       || userid == UserID38
       || userid == UserID39
       || userid == UserID40
       || userid == UserID41
       || userid == UserID42
       || userid == UserID43
       || userid == UserID44
       || userid == UserID45
       || userid == UserID46
       || userid == UserID47
       || userid == UserID48
       || userid == UserID49
      )
//&& userid == AccountNumber()
     )
     {
      Comment("");
      return true;
     }

   return false;
  }




//+------------------------------------------------------------------+
