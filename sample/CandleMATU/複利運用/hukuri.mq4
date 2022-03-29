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
bool Closed, Ticket = false;
double buystop, sellstop;
int ticket;
bool Certification = false;
double lot,ma141,ma142,ma751,ma752;


enum jpattern{
                    pattern0 = 0,//JPY
                    pattern1 = 1//USD
                    };

extern string Note0="";//----------基本設定----------
extern jpattern pattern = pattern0;//口座通貨タイプ
 
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
   
     if(pattern == pattern0){
      if(AccountBalance()>=1000 && AccountBalance() < 2000000){lot = 0.01;}
      if(AccountBalance()>=2000000 && AccountBalance() < 3000000){lot = 0.02;}
      if(AccountBalance()>=3000000 && AccountBalance() < 4000000){lot = 0.03;}
      if(AccountBalance()>=4000000 && AccountBalance() < 5000000){lot = 0.04;}
      if(AccountBalance()>=5000000 && AccountBalance() < 6000000){lot = 0.05;}
      if(AccountBalance()>=6000000 && AccountBalance() < 7000000){lot = 0.06;}
      if(AccountBalance()>=7000000 && AccountBalance() < 8000000){lot = 0.07;}
      if(AccountBalance()>=8000000 && AccountBalance() < 9000000){lot = 0.08;}
      if(AccountBalance()>=9000000 && AccountBalance() < 10000000){lot = 0.09;}
      if(AccountBalance()>=10000000 && AccountBalance() < 1000000000){lot = 0.1;}
   }
   
   if(pattern == pattern1){
      if(AccountBalance()>=100 && AccountBalance() < 20000){lot = 0.01;} 
      if(AccountBalance()>=20000 && AccountBalance() < 30000){lot = 0.02;}
      if(AccountBalance()>=30000 && AccountBalance() < 40000){lot = 0.03;}
      if(AccountBalance()>=40000 && AccountBalance() < 50000){lot = 0.04;}
      if(AccountBalance()>=50000 && AccountBalance() < 60000){lot = 0.05;}
      if(AccountBalance()>=60000 && AccountBalance() < 70000){lot = 0.06;}
      if(AccountBalance()>=70000 && AccountBalance() < 80000){lot = 0.07;}
      if(AccountBalance()>=80000 && AccountBalance() < 90000){lot = 0.08;}
      if(AccountBalance()>=90000 && AccountBalance() < 100000){lot = 0.09;}
      if(AccountBalance()>=100000 && AccountBalance() < 10000000){lot = 0.1;}
   }
      
   
 
          
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
                        }
                   else if(OrderType() == OP_SELL){
                                 if(rison == true){
                                    if(Ask <= OrderOpenPrice()-rikaku*Point || Ask >= OrderOpenPrice()+son*Point){            
                                        Closed = OrderClose(OrderTicket(),OrderLots(), Ask, Adjusted_Slippage,White);                                
                                    } 
                                 }
                                                                     
                   }              
               }         
           }   
   }
             
            
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
