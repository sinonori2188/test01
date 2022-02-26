//+------------------------------------------------------------------+
//|                                                     BBCross1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC   20094040
#define COMMENT "BBCross1"

// �O���p�����[�^
extern double Lots = 0.1;
extern int Slippage = 3;

// �G���g���[�֐�
extern int BBPeriod = 20;  // �{�����W���[�o���h�̊���
extern int BBDev = 2;      // �W���΍��̔{��
int EntrySignal(int magic)
{
   // �I�[�v���|�W�V�����̌v�Z
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // �{�����W���[�o���h�̌v�Z
   double bbU1 = iBands(NULL, 0, BBPeriod, BBDev, 0, PRICE_CLOSE, MODE_UPPER, 1);
   double bbL1 = iBands(NULL, 0, BBPeriod, BBDev, 0, PRICE_CLOSE, MODE_LOWER, 1);

   int ret = 0;
   // �����V�O�i��
   if(pos <= 0 && Close[2] >= bbL1 && Close[1] < bbL1) ret = 1;
   // ����V�O�i��
   if(pos >= 0 && Close[2] <= bbU1 && Close[1] > bbU1) ret = -1;

   return(ret);
}

// �X�^�[�g�֐�
int start()
{
   // �G���g���[�V�O�i��
   int sig_entry = EntrySignal(MAGIC);

   // ��������
   if(sig_entry > 0)
   {
      MyOrderClose(Slippage, MAGIC);
      MyOrderSend(OP_BUY, Lots, Ask, Slippage, 0, 0, COMMENT, MAGIC);
   }
   // ���蒍��
   if(sig_entry < 0)
   {
      MyOrderClose(Slippage, MAGIC);
      MyOrderSend(OP_SELL, Lots, Bid, Slippage, 0, 0, COMMENT, MAGIC);
   }

   return(0);
}

