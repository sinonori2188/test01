//+------------------------------------------------------------------+
//|                                                 Momentum1PS1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC   20094012
#define COMMENT "Momentum1PS1"

// �O���p�����[�^
extern double Leverage = 2; // �������o���b�W
extern int Slippage = 3;

// ���b�g���̌v�Z
double CalculateLots(double leverage)
{
   string symbol = StringSubstr(Symbol(), 0, 3) + AccountCurrency();

   double conv = iClose(symbol, 0, 0);
   if(conv == 0) conv = 1;
   
   double lots = leverage * AccountFreeMargin() / 100000 / conv;

   double minlots = MarketInfo(Symbol(), MODE_MINLOT);
   double maxlots = MarketInfo(Symbol(), MODE_MAXLOT);
   int lots_digits = MathLog(1.0/minlots)/MathLog(10.0);
   lots = NormalizeDouble(lots, lots_digits);
   if(lots < minlots) lots = minlots;
   if(lots > maxlots) lots = maxlots;

   return(lots);
}

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

// �X�^�[�g�֐�
int start()
{
   // �������b�g���̌v�Z
   double lots = CalculateLots(Leverage); 

   // �G���g���[�V�O�i��
   int sig_entry = EntrySignal(MAGIC);

   // ��������
   if(sig_entry > 0)
   {
      MyOrderClose(Slippage, MAGIC);
      MyOrderSend(OP_BUY, lots, Ask, Slippage, 0, 0, COMMENT, MAGIC);
   }
   // ���蒍��
   if(sig_entry < 0)
   {
      MyOrderClose(Slippage, MAGIC);
      MyOrderSend(OP_SELL, lots, Bid, Slippage, 0, 0, COMMENT, MAGIC);
   }

   return(0);
}

