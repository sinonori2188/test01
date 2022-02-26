//+------------------------------------------------------------------+
//|                                                     OCOOrder.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC1  20093030
#define MAGIC2  20093031
#define COMMENT "OCOOrder"

// �O���p�����[�^
extern double OpenPrice1 = 100.00;  // �������i�P
extern double Lots1 = 0.1;          // �������b�g���P�i�{�F�����@�|����j
extern double OpenPrice2 = 100.50;  // �������i�Q
extern double Lots2 = -0.1;         // �������b�g���Q�i�{�F�����@�|����j

// �ҋ@�����̑��M
void PendingOrderSend(double price, double lots, int magic)
{
   double stop_width = MarketInfo(Symbol(), MODE_STOPLEVEL) * Point;
   
   if(lots > 0)   // ��������
   {
      if(price < Ask-stop_width) MyOrderSend(OP_BUYLIMIT, lots, price, 0, 0, 0, COMMENT, magic);
      else if(price > Ask+stop_width) MyOrderSend(OP_BUYSTOP, lots, price, 0, 0, 0, COMMENT, magic);
   }
   else if(lots < 0) // ���蒍��
   {
      if(price > Bid+stop_width) MyOrderSend(OP_SELLLIMIT, -lots, price, 0, 0, 0, COMMENT, magic);
      else if(price <= Bid-stop_width) MyOrderSend(OP_SELLSTOP, -lots, price, 0, 0, 0, COMMENT, magic);
   }
}

// �X�^�[�g�֐�
int start()
{
   // MAGIC1�̃|�W�V��������
   if(MyCurrentOrders(MY_OPENPOS, MAGIC2) == 0)
   {
      if(MyCurrentOrders(MY_ALLPOS, MAGIC1) == 0) PendingOrderSend(OpenPrice1, Lots1, MAGIC1);
   }
   else if(MyCurrentOrders(MY_PENDPOS, MAGIC1) != 0) MyOrderDelete(MAGIC1);

   // MAGIC2�̃|�W�V��������
   if(MyCurrentOrders(MY_OPENPOS, MAGIC1) == 0)
   {
      if(MyCurrentOrders(MY_ALLPOS, MAGIC2) == 0) PendingOrderSend(OpenPrice2, Lots2, MAGIC2);
   }
   else if(MyCurrentOrders(MY_PENDPOS, MAGIC2) != 0) MyOrderDelete(MAGIC2);

   return(0);
}

