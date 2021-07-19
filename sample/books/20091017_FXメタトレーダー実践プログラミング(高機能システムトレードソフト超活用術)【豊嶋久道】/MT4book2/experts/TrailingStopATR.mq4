//+------------------------------------------------------------------+
//|                                              TrailingStopATR.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC  0

// �O���p�����[�^
extern int ATRPeriod = 5;     // ATR�̊���
extern double ATRMult = 2.0;  // ATR�̔{��

// �X�^�[�g�֐�
int start()
{
   double spread = Ask-Bid;
   double atr = iATR(NULL, 0, ATRPeriod, 1) * ATRMult;
   double HH = Low[1] + atr + spread;
   double LL = High[1] - atr;

   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MAGIC) continue;

      if(OrderType() == OP_BUY)
      {
         if(LL > OrderStopLoss()) MyOrderModify(LL, 0, MAGIC);
         break;
      }
   
      if(OrderType() == OP_SELL)
      {
         if(HH < OrderStopLoss() || OrderStopLoss() == 0) MyOrderModify(HH, 0, MAGIC);
         break;
      }
   }

   return(0);
}

