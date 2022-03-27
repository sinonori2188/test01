//+------------------------------------------------------------------+
//|                                                             .mq4 |
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
  Adjusted_Slippage = AdjustSlippage(Symbol(),Slippage);
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
double ma141,ma142,ma751,ma752;
int lm,lm2=0;
double LTP,LSL,STP,SSL;

enum jpattern{
  pattern0 = 0,//JPY
  pattern1 = 1//USD
};

extern string Note0="";             //----------基本設定----------
extern jpattern pattern = pattern0; //口座通貨タイプ
extern double  lot = 0.01;          //ロット
extern int  magicnum = 10;          //マジックナンバー
extern int Slippage=3;              //許容スリッページ
extern int Maxspread = 20;          //許容スプレッド
extern bool rison = true;           //Pips指定の利確・損切り条件追加
extern int rikaku=50;               //利確Pips
extern int son=500;                 //損切Pips
extern int maxp = 10;               //最大ポジション数

//+------------------------------------------------------------------+
int AdjustSlippage(string Currency,int Slippage_Pips)
{
   int Calculated_Slippage=0;
   int Symbol_Digits=(int)MarketInfo(Currency,MODE_DIGITS);

  if(Symbol_Digits==2 || Symbol_Digits==4){
    Calculated_Slippage=Slippage_Pips;
  }else if(Symbol_Digits==3 || Symbol_Digits==5){
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

  int buy = 0;
  int sell = 0;

  for(int i = totalpos-1; i >= 0; i--){
    if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
      if(OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum){
        buy++;
      }
      if(OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum){
        sell++;
      }
    }
  }

  //マーチンしたい場合
  //ロングナンピン----------------------------------------   
  if(buy == 0){lm = 1;}
  if(buy == 1){lm = 2;}
  if(buy == 2){lm = 4;}
  if(buy == 3){lm = 8;}
  if(buy == 4){lm = 16;}
  if(buy == 5){lm = 32;}
  if(buy == 6){lm = 64;}
  if(buy == 7){lm = 128;}
  if(buy == 8){lm = 256;}
  if(buy == 9){lm = 512;}
  if(buy == 10){lm = 1024;}
  //ショートナンピン------------------------------------------
  if(sell == 0){lm2 = 1;}
  if(sell == 1){lm2 = 2;}
  if(sell == 2){lm2 = 4;}
  if(sell == 3){lm2 = 8;}
  if(sell == 4){lm2 = 16;}
  if(sell == 5){lm2 = 32;}
  if(sell == 6){lm2 = 64;}
  if(sell == 7){lm2 = 128;}
  if(sell == 8){lm2 = 256;}
  if(sell == 9){lm2 = 512;}
  if(sell == 10){lm2 = 1024;}

  //決済条件
  for(int i = totalpos-1; i >= 0; i--){
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

  //ナンピン条件
  if(buy <= maxp-1 && sell <= maxp-1){
    for(int  i = totalpos-1; i >= 0; i--){
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
        if(OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum){
          if(Ask <= OrderOpenPrice()-(50*Point)){
            Ticket=OrderSend(NULL,OP_BUY,lot*lm,Ask,Adjusted_Slippage,0,0,NULL,magicnum,0,White);
          }
          break;
        }
      }
    }
    for(int  i = totalpos-1; i >= 0; i--){
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
        if(OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum){
          if(Bid >= OrderOpenPrice()+(50*Point)){
            Ticket=OrderSend(NULL,OP_SELL,lot*lm2,Ask,Adjusted_Slippage,0,0,NULL,magicnum,0,White);
          }
          break;
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

    //新規の場合
    if(totalpos == 0){
      //Short
      if(ma752<ma142&&ma751>=ma141){
        //Ticket = OrderSend(NULL,OP_SELL,lot,Bid,Adjusted_Slippage,Bid+(500*Point),Bid-(50*Point),NULL,magicnum,0,White);   
        Ticket = OrderSend(NULL,OP_SELL,lot,Bid,Adjusted_Slippage,0,0,NULL,magicnum,0,White);
      }
      //Long
      if(ma752>ma142&&ma751<=ma141){
        //Ticket= OrderSend(NULL,OP_BUY,lot,Ask,Adjusted_Slippage,Ask-500*Point,Ask+50*Point,NULL,magicnum,0,White);
        Ticket= OrderSend(NULL,OP_BUY,lot,Ask,Adjusted_Slippage,0,0,NULL,magicnum,0,White);
      }
    }//totalpos
  }
}

//---OnTick
