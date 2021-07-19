//+------------------------------------------------------------------+
//|                                                 Breakout1SL1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC   20094071
#define COMMENT "Breakout1SL1"

// �O���p�����[�^
extern double Lots = 0.1;
extern int Slippage = 3;
extern int SLpips = 100;   // ���؂�l��(pips)
extern int TPpips = 200;   // ���H���l��(pips)

// �G���g���[�֐�
extern int HLPeriod = 20;  // HL�o���h�̊���
int EntrySignal(int magic)
{
   // �I�[�v���|�W�V�����̌v�Z
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // HL�o���h�̌v�Z
   double HH2 = iCustom(NULL, 0, "HLBand", HLPeriod, 1, 2);
   double LL2 = iCustom(NULL, 0, "HLBand", HLPeriod, 2, 2);
   
   int ret = 0;
   // �����V�O�i��
   if(pos <= 0 && Close[2] <= HH2 && Close[1] > HH2) ret = 1;
   // ����V�O�i��
   if(pos >= 0 && Close[2] >= LL2 && Close[1] < LL2) ret = -1;

   return(ret);
}

// �I�[�_�[���M�֐��i���؂�E���H����l���Ŏw��j
bool MyOrderSendSL(int type, double lots, double price, int slippage, int slpips, int tppips, string comment, int magic)
{
   int mult=1;
   if(Digits == 3 || Digits == 5) mult=10;
   slippage *= mult;

   if(type==OP_SELL || type==OP_SELLLIMIT || type==OP_SELLSTOP) mult *= -1;

   double sl=0, tp=0;
   if(slpips > 0) sl = price-slpips*Point*mult;
   if(tppips > 0) tp = price+tppips*Point*mult;

   return(MyOrderSend(type, lots, price, slippage, sl, tp, comment, magic));
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
      MyOrderSendSL(OP_BUY, Lots, Ask, Slippage, SLpips, TPpips, COMMENT, MAGIC);
   }
   // ���蒍��
   if(sig_entry < 0)
   {
      MyOrderClose(Slippage, MAGIC);
      MyOrderSendSL(OP_SELL, Lots, Bid, Slippage, SLpips, TPpips, COMMENT, MAGIC);
   }

   return(0);
}

