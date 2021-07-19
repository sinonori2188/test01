//+------------------------------------------------------------------+
//|                                                  Momentum1F1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC   20094011
#define COMMENT "Momentum1F1"

// �O���p�����[�^
extern double Lots = 0.1;
extern int Slippage = 3;

// �G���g���[�֐�
extern int MomPeriod = 20; // �������^���̊���
int EntrySignal(int magic)
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

// �t�B���^�[�֐�
extern int SMAPeriod = 200;   // �ړ����ς̊���
int FilterSignal(int signal)
{
   double sma1 = iMA(NULL, 0, SMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);

   int ret = 0;
   if(signal > 0 && Close[1] > sma1) ret = signal;
   if(signal < 0 && Close[1] < sma1) ret = signal;

   return(ret);
}

// �X�^�[�g�֐�
int start()
{
   // �G���g���[�V�O�i��
   int sig_entry = EntrySignal(MAGIC);

   // �|�W�V�����̌���
   if(sig_entry != 0) MyOrderClose(Slippage, MAGIC);

   // �G���g���[�V�O�i���̃t�B���^�[
   sig_entry = FilterSignal(sig_entry);

   // ��������
   if(sig_entry > 0) MyOrderSend(OP_BUY, Lots, Ask, Slippage, 0, 0, COMMENT, MAGIC);
   // ���蒍��
   if(sig_entry < 0) MyOrderSend(OP_SELL, Lots, Bid, Slippage, 0, 0, COMMENT, MAGIC);

   return(0);
}

