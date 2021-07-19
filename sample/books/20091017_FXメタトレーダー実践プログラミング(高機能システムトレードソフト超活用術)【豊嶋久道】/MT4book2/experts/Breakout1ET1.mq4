//+------------------------------------------------------------------+
//|                                                 Breakout1ET1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC   20094073
#define COMMENT "Breakout1ET1"

// �O���p�����[�^
extern double Lots = 0.1;
extern int Slippage = 3;

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

// �G�O�W�b�g�֐�
extern int ExpBars = 5; // ���ς̂��߂̃o�[�̌o�ߖ{��
void ExitPosition(int magic)
{
   datetime opentime = 0;
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) break;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != magic) continue;
      if(OrderType() == OP_BUY || OrderType() == OP_SELL)
      {
         opentime = OrderOpenTime();
         break;
      }
   }

   int traded_bar = 0;
   if(opentime > 0) traded_bar = iBarShift(NULL, 0, opentime, false);
   if(traded_bar >= ExpBars) MyOrderClose(Slippage, magic);
}

// �X�^�[�g�֐�
int start()
{
   // �G�O�W�b�g�|�W�V����
   ExitPosition(MAGIC);

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

