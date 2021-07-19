//+------------------------------------------------------------------+
//|                                                    RIDOrder2.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// マイライブラリー
#include <MyLib.mqh>

// マジックナンバー
#define MAGIC   20093020
#define COMMENT "RIDOrder2"

// 外部パラメータ
extern double Lots = 0.1;
extern int Positions = 5;  // 注文の個数
extern double OpenPrice = 100.00;   // 約定価格
extern double ClosePrice = 101.00;  // 決済価格
extern double PriceDiff = 0.20;  // 価格の値幅

// スタート関数
int start()
{
   for(int i=0; i<Positions; i++)
   {
      // 現在のポジションのチェック
      if(MyCurrentOrders(MY_ALLPOS, MAGIC+i) != 0) continue;

      // 買い注文
      if(OpenPrice < ClosePrice)
      {
         if(OpenPrice-PriceDiff*i >= Ask)
         {
            Print("OpenPrice >= Ask");
            return(-1);
         }
         MyOrderSend(OP_BUYLIMIT, Lots, OpenPrice-PriceDiff*i, 0, 0, ClosePrice-PriceDiff*i, COMMENT, MAGIC+i);
      }
      // 売り注文
      else if(OpenPrice > ClosePrice)
      {
         if(OpenPrice+PriceDiff*i <= Bid)
         {
            Print("OpenPrice <= Bid");
            return(-1);
         }
         MyOrderSend(OP_SELLLIMIT, Lots, OpenPrice+PriceDiff*i, 0, 0, ClosePrice+PriceDiff*i, COMMENT, MAGIC+i);
      }
   }

   return(0);
}

