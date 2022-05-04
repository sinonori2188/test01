//+------------------------------------------------------------------+
//|                                                       tatene.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
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
bool Closed, Ticket,ch = false;
double buystop, sellstop;
int ticket;
bool Certification = false;
double ma141,ma142,ma751,ma752;




extern string Note0="";//----------基本設定----------
extern bool tatene = true;//建値移動
extern int tateneP = 10;//建値移動幅±
extern double lot = 0.01;//Lot数
extern int  magicnum = 10;//マジックナンバー
extern int Slippage=3;  // 許容スリッページ
extern int Maxspread = 20;//許容スプレッド
extern bool rison = true;//Pips指定の利確・損切り条件追加
extern int rikaku=100;  //利確Pips
extern int son=50;  //損切Pips


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
                       double TATE = OrderOpenPrice() + tateneP*Point;//建値移動値
                       if(tatene == true && Bid > TATE){ //建値移動
                        
                        ch = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),OrderExpiration(),Red);                              
                        }    
                        
                        if(rison == true){
                           if(Bid >= OrderOpenPrice()+rikaku*Point || Bid <= OrderOpenPrice()-son*Point){            
                               Closed = OrderClose(OrderTicket(),OrderLots(), Bid, Adjusted_Slippage,White);
                           }    
                        }
                        }
                   else if(OrderType() == OP_SELL){
                               
                                double TATE2 = OrderOpenPrice() - tateneP*Point;//建値移動値 
                                if(tatene == true && Ask < TATE2){ //売り時建値移動
                              
                                ch = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),OrderExpiration(),Aqua);
                                }                              
                                if(rison == true){
                                    if(Ask <= OrderOpenPrice()-rikaku*Point || Ask >= OrderOpenPrice()+son*Point){            
                                        Closed = OrderClose(OrderTicket(),OrderLots(), Ask, Adjusted_Slippage,White);                                
                                    } 
                                 }
                                                                     
                   }              
               }         
           }   
   }
   int  er =GetLastError();          
   //Comment(er);         
//+------------------------------------------------------------------+   
if(NowBars < Bars){
    NowBars = Bars;  
  
      ma141 = iMA(NULL,0,14,0,0,0,0);
      ma142 = iMA(NULL,0,14,0,0,0,1);
      ma751 = iMA(NULL,0,75,0,0,0,0);
      ma752 = iMA(NULL,0,75,0,0,0,1);
   
   totalpos=OrdersTotal();
        

     if(totalpos == 0){
                                           
   //Short
      if(ma752<ma142&&ma751>=ma141)
        {
           
         Ticket=OrderSend(NULL,OP_SELL,lot,Bid,Adjusted_Slippage,0,0,NULL,magicnum,0,Aqua);
       }
   
   //Long
      if(ma752>ma142&&ma751<=ma141)
        {
         
         Ticket=OrderSend(NULL,OP_BUY,lot,Ask,Adjusted_Slippage,0,0,NULL,magicnum,0,White);
      }   

      }//totalpos
}
//+------------------------------------------------------------------+



}//---OnTick
//+------------------------------------------------------------------+    

