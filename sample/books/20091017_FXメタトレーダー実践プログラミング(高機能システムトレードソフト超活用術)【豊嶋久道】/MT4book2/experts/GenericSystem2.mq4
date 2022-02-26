//+------------------------------------------------------------------+
//|                                               GenericSystem2.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC   20094001
#define COMMENT "GenericSystem2"

// �O���p�����[�^
extern double Lots = 0.1;
extern int Slippage = 3;

// �G���g���[�֐�
int EntrySignal(int magic)
{
   // �I�[�v���|�W�V�����̌v�Z
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   int ret = 0;
   // if(pos <= 0 && �����V�O�i��) ret = 1;
   // if(pos >= 0 && ����V�O�i��) ret = -1;
   return(ret);
}

// �G�O�W�b�g�֐�
void ExitPosition(int magic)
{
   // �I�[�v���|�W�V�����̌v�Z
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   int ret = 0;
   // if(pos < 0 && ����|�W�V�����̌��σV�O�i��) ret = 1;
   // if(pos > 0 && �����|�W�V�����̌��σV�O�i��) ret = -1;

   // �I�[�v���|�W�V�����̌���
   if(ret != 0) MyOrderClose(Slippage, magic);
}

// �X�^�[�g�֐�
int start()
{
   // �����|�W�V�����̃G�O�W�b�g
   ExitPosition(MAGIC);

   // �G���g���[�V�O�i���̐���
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

