//+------------------------------------------------------------------+
//|                                                        MACD1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC   20094060
#define COMMENT "MACD1"

// �O���p�����[�^
extern double Lots = 0.1;
extern int Slippage = 3;

// �G���g���[�֐�
extern int FastEMAPeriod = 12;   // �Z��EMA�̊���
extern int SlowEMAPeriod = 26;   // ����EMA�̊���
extern int SignalPeriod = 9;     // MACD��SMA��������
int EntrySignal(int magic)
{
   // �I�[�v���|�W�V�����̌v�Z
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // MACD�̌v�Z
   double macd1 = iMACD(NULL, 0, FastEMAPeriod, SlowEMAPeriod, SignalPeriod, PRICE_CLOSE, MODE_MAIN, 1);
   double macd2 = iMACD(NULL, 0, FastEMAPeriod, SlowEMAPeriod, SignalPeriod, PRICE_CLOSE, MODE_MAIN, 2);
   double macdsig1 = iMACD(NULL, 0, FastEMAPeriod, SlowEMAPeriod, SignalPeriod, PRICE_CLOSE, MODE_SIGNAL, 1);
   double macdsig2 = iMACD(NULL, 0, FastEMAPeriod, SlowEMAPeriod, SignalPeriod, PRICE_CLOSE, MODE_SIGNAL, 2);

   int ret = 0;
   // �����V�O�i��
   if(pos <= 0 && macd2 <= macdsig2 && macd1 > macdsig1) ret = 1;
   // ����V�O�i��
   if(pos >= 0 && macd2 >= macdsig2 && macd1 < macdsig1) ret = -1;

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

