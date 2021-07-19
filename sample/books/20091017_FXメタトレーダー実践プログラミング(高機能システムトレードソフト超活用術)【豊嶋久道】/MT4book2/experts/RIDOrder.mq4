//+------------------------------------------------------------------+
//|                                                     RIDOrder.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC   20093010
#define COMMENT "RIDOrder"

// �O���p�����[�^
extern double Lots = 0.1;
extern double OpenPrice = 100.00;   // ��艿�i
extern double ClosePrice = 101.00;  // ���ω��i

// �X�^�[�g�֐�
int start()
{
   // ���݂̃|�W�V�����̃`�F�b�N
   if(MyCurrentOrders(MY_ALLPOS, MAGIC) != 0) return(0);

   // ��������
   if(OpenPrice < ClosePrice)
   {
      if(OpenPrice >= Ask)
      {
         Print("OpenPrice >= Ask");
         return(-1);
      }
      MyOrderSend(OP_BUYLIMIT, Lots, OpenPrice, 0, 0, ClosePrice, COMMENT, MAGIC);
   }
   // ���蒍��
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

