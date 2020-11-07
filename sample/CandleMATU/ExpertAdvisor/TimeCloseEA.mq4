//+------------------------------------------------------------------+
//|                                                         .mq4 |
//|                                              Copyright 2018 ands |
//|                                                                  |
//+------------------------------------------------------------------+
//こちらで使用可能な制限日時を指定します。
//ここをすぎるとシステムは動作しなくなります。
//理由はこの後で説明します。

string uselimitet = "2018.12.28 00:00";

#property copyright "Copyright 2018 ands"
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

   //init関数で事前に設定した時間と現在の時間がどうかをチェックします。
   datetime ET;
   //string型で日付を用意していたのでそれを時間に変換します。()の中は変換させたい文字列を入れます。
   ET = StrToTime(uselimitet);    
   //今の時間がその時間より大きい、つまりすぎていた場合、Alertを出しinit関数を失敗させます。
   //つまり、EAをチャートに挿入することができなくなります。
   //これが期限による使用制限になり、配布する場合はex4のみを渡すことでユーザーは期限を変更できないので月額利用などをさせることが可能です。
   if( iTime(NULL,0,1) > ET ){
      Alert("Over date");
      return(INIT_FAILED);
   }
   
   //---
   //!は否定でtrueではない時、という意味になります。
   if(!Certification){
      //最下部参照→その口座の番号が登録番号と一致しない時
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
int totalpos=0;
int Adjusted_Slippage=0;
bool Closed, Ticket = false;
double buystop, sellstop;
int ticket;
bool Certification = false;

extern string Note0="";//----------基本設定----------
//extern long UserID =0;//使用者口座番号  
extern int  magicnum = 10;//マジックナンバー
extern double Lots=0.01;  // ロット数
extern int Slippage=3;  // 許容スリッページ
extern int Maxspread = 20;//許容スプレッド
extern bool rison = false;//Pips指定の利確・損切り条件追加
extern int rikaku=100;  //利確Pips
extern int son=50;  //損切Pips
extern int stop = 1;//損切り判定(1:ヒゲ 2:実体)
extern int time1 = 10;//時間指定1
extern int time2 = 12;//時間指定2
extern int time3 = 14;//時間指定3
extern int time4 = 16;//時間指定4
extern int time5 = 18;//時間指定5

//+------------------------------------------------------------------+

int AdjustSlippage(string Currency,int Slippage_Pips)
  {
   int Calculated_Slippage=0;

   int Symbol_Digits=(int)MarketInfo(Currency,MODE_DIGITS);

   if(Symbol_Digits==2 || Symbol_Digits==4)
     {
      Calculated_Slippage=Slippage_Pips;
     }
   else if(Symbol_Digits==3 || Symbol_Digits==5)
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
          
   //損切り
   for(int  i = totalpos-1; i >= 0; i--){
           if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
               if(OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum){
                   if(OrderType() == OP_BUY){
                        if(rison == true){
                           //それぞれ利確・損切り幅を事前に設定して、その値より大きくなった時に決済条件を適用させる形です。
                           if(Bid >= OrderOpenPrice()+rikaku*Point || Bid <= OrderOpenPrice()-son*Point){            
                               Closed = OrderClose(OrderTicket(),OrderLots(), Bid, Adjusted_Slippage,White);
                           }    
                        }
                        //もう一つの決済条件をifを並列させて追加します。
                        //注意が必要なのはelseではないので上のifもこのifもどちらも通ります。（条件を満たせば）
                        //ここでは、事前に保存したbuystopという価格より今の価格が低くなった時に処理を行わせます。
                        if(iClose(NULL,0,0) <= buystop){            
                            Closed = OrderClose(OrderTicket(),OrderLots(), Bid, Adjusted_Slippage,White);
                        }                              
                   }
                   else if(OrderType() == OP_SELL){
                                 if(rison == true){
                                    if(Ask <= OrderOpenPrice()-rikaku*Point || Ask >= OrderOpenPrice()+son*Point){            
                                        Closed = OrderClose(OrderTicket(),OrderLots(), Ask, Adjusted_Slippage,White);                                
                                    } 
                                 }
                                 if(iClose(NULL,0,0) >= sellstop){            
                                     Closed = OrderClose(OrderTicket(),OrderLots(), Ask, Adjusted_Slippage,White);                     
                                 }                                          
                   }              
               }         
           }   
   }
             
            
//+------------------------------------------------------------------+   
if(NowBars < Bars){
    NowBars = Bars;  
    //利確
    for(int  i = totalpos-1; i >= 0; i--){
           if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
               if(OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum){
                   if(OrderType() == OP_BUY || OrderType() == OP_SELL){
                        //OrderProfit()関数は現在の利益・損失額を出す。　>0ということは利益が出ている状態。
                        if(OrderProfit() > 0){            
                            Closed = OrderClose(OrderTicket(),OrderLots(), Bid, Adjusted_Slippage,White);
                            //totalpos = 0;
                        }     
                   }
               }         
           }   
    } 
 
                   
 
//+------------------------------------------------------------------+   
                                        
   //S
   //Time~~関数は今の「チャート時間」のそれぞれの時間を取得する。Hourなら時間、Minuteなら分、Secondなら秒
   //MarketInfoではその通貨ペアのスプレッドも取得できる。またtotalpos==0とすることで１ポジションしか持たないようにする。
      if(iOpen(NULL,0,1) > iClose(NULL,0,1) && 
          ((TimeHour(iTime(NULL,0,1)) == time1 && TimeMinute(iTime(NULL,0,1)) == 00) ||
          (TimeHour(iTime(NULL,0,1)) == time2 && TimeMinute(iTime(NULL,0,1)) == 00) ||
          (TimeHour(iTime(NULL,0,1)) == time3 && TimeMinute(iTime(NULL,0,1)) == 00) ||
          (TimeHour(iTime(NULL,0,1)) == time4 && TimeMinute(iTime(NULL,0,1)) == 00) ||
          (TimeHour(iTime(NULL,0,1)) == time5 && TimeMinute(iTime(NULL,0,1)) == 00)) &&
          MarketInfo(Symbol(),MODE_SPREAD) <= Maxspread && totalpos == 0)
        {
         //ヒゲ先にSL
         if(stop == 1){
             sellstop = iHigh(NULL,0,1);
         }
         //実体にSL
         if(stop == 2){
             sellstop = iOpen(NULL,0,1);
         }         
         //ここで保存しておいたSLを上の損切り箇所で使用する。
         Ticket=OrderSend(NULL,OP_SELL,Lots,Bid,Adjusted_Slippage,0,0,NULL,magicnum,0,Aqua);
        }
   //}
   
   //L
      if(iOpen(NULL,0,1) < iClose(NULL,0,1) &&
          ((TimeHour(iTime(NULL,0,1)) == time1 && TimeMinute(iTime(NULL,0,1)) == 00) ||
          (TimeHour(iTime(NULL,0,1)) == time2 && TimeMinute(iTime(NULL,0,1)) == 00) ||
          (TimeHour(iTime(NULL,0,1)) == time3 && TimeMinute(iTime(NULL,0,1)) == 00) ||
          (TimeHour(iTime(NULL,0,1)) == time4 && TimeMinute(iTime(NULL,0,1)) == 00) ||
          (TimeHour(iTime(NULL,0,1)) == time5 && TimeMinute(iTime(NULL,0,1)) == 00)) &&           
          MarketInfo(Symbol(),MODE_SPREAD) <= Maxspread && totalpos == 0)
        {
         if(stop == 1){
             buystop = iLow(NULL,0,1);
         }
         if(stop == 2){
             buystop = iOpen(NULL,0,1);
         }   
         Ticket=OrderSend(NULL,OP_BUY,Lots,Ask,Adjusted_Slippage,0,0,NULL,magicnum,0,White);
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


long          UserID           =116927;    


bool UseSystem(long userid){
   
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
     ){
      Comment("");
      return true;
   }

   return false;
}