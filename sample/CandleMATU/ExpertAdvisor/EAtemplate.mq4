//+------------------------------------------------------------------+
//|                                                         .mq4 |
//|                                              Copyright 2018 ands |
//|                                                                  |
//+------------------------------------------------------------------+

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

   datetime ET;
   ET = StrToTime(uselimitet);    
   if( iTime(NULL,0,1) > ET ){
      Alert("利用期限を過ぎました。");
      return(INIT_FAILED);
   }
   
   if(!Certification){
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
          
   //決済条件
   for(int  i = totalpos-1; i >= 0; i--){
           if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
               if(OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum){
                   if(OrderType() == OP_BUY){
                        if(rison == true){
                           if(Bid >= OrderOpenPrice()+rikaku*Point || Bid <= OrderOpenPrice()-son*Point){            
                               Closed = OrderClose(OrderTicket(),OrderLots(), Bid, Adjusted_Slippage,White);
                           }    
                        }
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
    
    //利益が出ている時に決済
    for(int  i = totalpos-1; i >= 0; i--){
           if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
               if(OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum){
                   if(OrderType() == OP_BUY || OrderType() == OP_SELL){
                        if(OrderProfit() > 0){            
                            Closed = OrderClose(OrderTicket(),OrderLots(), Bid, Adjusted_Slippage,White);
                        }     
                   }
               }         
           }   
    } 
 
                   
 
//+------------------------------------------------------------------+   
                                        
   //Short
      /*if()
        {
         //ヒゲ先にSL
         if(stop == 1){
             sellstop = iHigh(NULL,0,1);
         }
         //実体にSL
         if(stop == 2){
             sellstop = iOpen(NULL,0,1);
         }         
         Ticket=OrderSend(NULL,OP_SELL,Lots,Bid,Adjusted_Slippage,0,0,NULL,magicnum,0,Aqua);
       }
   
   //Long
      if()
        {
         if(stop == 1){
             buystop = iLow(NULL,0,1);
         }
         if(stop == 2){
             buystop = iOpen(NULL,0,1);
         }   
         Ticket=OrderSend(NULL,OP_BUY,Lots,Ask,Adjusted_Slippage,0,0,NULL,magicnum,0,White);
      }*/   

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