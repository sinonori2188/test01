//+------------------------------------------------------------------+
//|                                                         CBPB.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC   20094080
#define COMMENT "CBPB"

// �O���p�����[�^
extern double Lots = 0.1;
extern int Slippage = 3;

// �G���g���[�֐�
extern int PBPeriod = 5;   // �v���o�b�N�pHL�o���h�̊���
int EntrySignal(int magic)
{
   // �I�[�v���|�W�V�����̌v�Z
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // �v���o�b�N�̃`�F�b�N
   double HH2 = iCustom(Symbol(), 0, "HLBand", PBPeriod, 0, 1, 2);
   double LL2 = iCustom(Symbol(), 0, "HLBand", PBPeriod, 0, 2, 2);

   int ret = 0;
   // �����V�O�i��
   if(pos <= 0 && Low[2] >= LL2 && Low[1] < LL2) ret = 1;
   // ����V�O�i��
   if(pos >= 0 && High[2] <= HH2 && High[1] > HH2) ret = -1;

   return(ret);
}

// �t�B���^�[�֐�
extern int BOPeriod = 40;  // �u���C�N�A�E�g�pHL�o���h�̊���
int FilterSignal(int signal)
{
   for(int i=0; i<5; i++)
   {
      // HL�o���h�̂̌v�Z
      double HH2 = iCustom(Symbol(), 0, "HLBand", BOPeriod, 1, 1, i+2);
      double LL2 = iCustom(Symbol(), 0, "HLBand", BOPeriod, 1, 2, i+2);
   
      int ret = signal;
      // �����V�O�i��
      if(signal > 0 && Close[i+2] <= HH2 && Close[i+1] > HH2) break;
      // ����V�O�i��
      if(signal < 0 && Close[i+2] >= LL2 && Close[i+1] < LL2) break;
      ret = 0;
   }

   return(ret);
}

// HL�o���h�g���C�����O�X�g�b�v
extern int TSPeriod = 20;  // �g���C�����O�X�g�b�v�pHL�o���h�̊���
void MyTrailingStopHL(int period, int magic)
{
   double spread = Ask-Bid;
   double HH = iCustom(Symbol(), 0, "HLBand", period, 1, 1)+spread;
   double LL = iCustom(Symbol(), 0, "HLBand", period, 2, 1);

   if(MyCurrentOrders(OP_BUY, magic) != 0) MyOrderModify(LL, 0, magic);
   if(MyCurrentOrders(OP_SELL, magic) != 0) MyOrderModify(HH, 0, magic);
}

// �X�^�[�g�֐�
int start()
{
   // �G���g���[�V�O�i���̐���
   int sig_entry = EntrySignal(MAGIC);

   // �G���g���[�̃t�B���^�[
   sig_entry = FilterSignal(sig_entry);

   // ��������
   if(sig_entry > 0) MyOrderSend(OP_BUY, Lots, Ask, Slippage, 0, 0, COMMENT, MAGIC);
   // ���蒍��
   if(sig_entry < 0) MyOrderSend(OP_SELL, Lots, Bid, Slippage, 0, 0, COMMENT, MAGIC);

   // HL�o���h�g���C�����O�X�g�b�v
   MyTrailingStopHL(TSPeriod, MAGIC);
   
   return(0);
}

