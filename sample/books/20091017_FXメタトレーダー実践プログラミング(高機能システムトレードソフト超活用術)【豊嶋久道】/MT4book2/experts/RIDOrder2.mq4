//+------------------------------------------------------------------+
//|                                                    RIDOrder2.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC   20093020
#define COMMENT "RIDOrder2"

// �O���p�����[�^
extern double Lots = 0.1;
extern int Positions = 5;  // �����̌�
extern double OpenPrice = 100.00;   // ��艿�i
extern double ClosePrice = 101.00;  // ���ω��i
extern double PriceDiff = 0.20;  // ���i�̒l��

// �X�^�[�g�֐�
int start()
{
   for(int i=0; i<Positions; i++)
   {
      // ���݂̃|�W�V�����̃`�F�b�N
      if(MyCurrentOrders(MY_ALLPOS, MAGIC+i) != 0) continue;

      // ��������
      if(OpenPrice < ClosePrice)
      {
         if(OpenPrice-PriceDiff*i >= Ask)
         {
            Print("OpenPrice >= Ask");
            return(-1);
         }
         MyOrderSend(OP_BUYLIMIT, Lots, OpenPrice-PriceDiff*i, 0, 0, ClosePrice-PriceDiff*i, COMMENT, MAGIC+i);
      }
      // ���蒍��
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

