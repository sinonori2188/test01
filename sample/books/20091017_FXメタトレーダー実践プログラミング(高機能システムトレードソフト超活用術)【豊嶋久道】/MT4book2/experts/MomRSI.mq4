//+------------------------------------------------------------------+
//|                                                       MomRSI.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC1    20094100
#define MAGIC2    20094101
#define COMMENT1  "MomRSI(Mom)"
#define COMMENT2  "MomRSI(RSI)"

// �O���p�����[�^
extern double Lots = 0.1;
extern int Slippage = 3;

// �G���g���[�֐�(�������^��)
extern int MomPeriod = 20; // �������^���̊���
int EntrySignalMom(int magic)
{
   // �I�[�v���|�W�V�����̌v�Z
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // �������^���̌v�Z
   double mom1 = iMomentum(NULL, 0, MomPeriod, PRICE_CLOSE, 1);

   int ret = 0;
   // �����V�O�i��
   if(pos <= 0 && mom1 > 100) ret = 1;
   // ����V�O�i��
   if(pos >= 0 && mom1 < 100) ret = -1;

   return(ret);
}

// �G���g���[�֐�(RSI)
extern int RSIPeriod = 14; // RSI�̊���
int EntrySignalRSI(int magic)
{
   // �I�[�v���|�W�V�����̌v�Z
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // RSI�̌v�Z
   double rsi1 = iRSI(NULL, 0, RSIPeriod, PRICE_CLOSE, 1);

   int ret = 0;
   // �����V�O�i��
   if(pos <= 0 && rsi1 < 30) ret = 1;
   // ����V�O�i��
   if(pos >= 0 && rsi1 > 70) ret = -1;

   return(ret);
}

// �X�^�[�g�֐�
int start()
{
   // �������^���G���g���[�V�O�i��
   int sig_entry1 = EntrySignalMom(MAGIC1);

   // ��������
   if(sig_entry1 > 0)
   {
      MyOrderClose(Slippage, MAGIC1);
      MyOrderSend(OP_BUY, Lots, Ask, Slippage, 0, 0, COMMENT1, MAGIC1);
   }
   // ���蒍��
   if(sig_entry1 < 0)
   {
      MyOrderClose(Slippage, MAGIC1);
      MyOrderSend(OP_SELL, Lots, Bid, Slippage, 0, 0, COMMENT1, MAGIC1);
   }

   // RSI�G���g���[�V�O�i��
   int sig_entry2 = EntrySignalRSI(MAGIC2);

   // ��������
   if(sig_entry2 > 0)
   {
      MyOrderClose(Slippage, MAGIC2);
      MyOrderSend(OP_BUY, Lots, Ask, Slippage, 0, 0, COMMENT2, MAGIC2);
   }
   // ���蒍��
   if(sig_entry2 < 0)
   {
      MyOrderClose(Slippage, MAGIC2);
      MyOrderSend(OP_SELL, Lots, Bid, Slippage, 0, 0, COMMENT2, MAGIC2);
   }

   return(0);
}

