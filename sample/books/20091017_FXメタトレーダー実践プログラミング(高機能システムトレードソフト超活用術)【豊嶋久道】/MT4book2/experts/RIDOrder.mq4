//+------------------------------------------------------------------+
//|                                                     RIDOrder.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC   20093010
#define COMMENT "RIDOrder"

// 外部パラメータ
extern double Lots = 0.1;
extern double OpenPrice = 100.00;   // 約定価格
extern double ClosePrice = 101.00;  // 決済価格

// スタート関数
int start()
{
   // 現在のポジションのチェック
   if(MyCurrentOrders(MY_ALLPOS, MAGIC) != 0) return(0);

   // 買い注文
   if(OpenPrice < ClosePrice)
   {
      if(OpenPrice >= Ask)
      {
         Print("OpenPrice >= Ask");
         return(-1);
      }
      MyOrderSend(OP_BUYLIMIT, Lots, OpenPrice, 0, 0, ClosePrice, COMMENT, MAGIC);
   }
   // 売り注文
   else if(OpenPrice > ClosePrice)
   {
      if(OpenPrice <= Bid)
      {
         Print("OpenPrice <= Bid");
         return(-1);
      }
      MyOrderSend(OP_SELLLIMIT, Lots, OpenPrice, 0, 0, ClosePrice, COMMENT, MAGIC);
   }

   return(0);
}

