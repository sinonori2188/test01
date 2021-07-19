//+------------------------------------------------------------------+
//|                                                       RSI1F1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC  20094023
#define COMMENT "RSI1F1"

// �O���p�����[�^
extern double Lots = 0.1;
extern int Slippage = 3;

// �G���g���[�֐�
extern int RSIPeriod = 14; // RSI�̊���
int EntrySignal(int magic)
{
   // �I�[�v���|�W�V�����̌v�Z
   double pos = MyCurrentOrders(MY_OPENPOS, magic);

   // RSI�̌v�Z
   double rsi1 = iRSI(Symbol(), 0, RSIPeriod, PRICE_CLOSE, 1);

   int ret = 0;
   // �����V�O�i��
   if(pos <= 0 && rsi1 < 30) ret = 1;
   // ����V�O�i��
   if(pos >= 0 && rsi1 > 70) ret = -1;

   return(ret);
}

// �t�B���^�[�֐�
extern string StartTime = "9:30";   // �J�n����
extern string EndTime = "12:30";    // �I������
int FilterSignal(int signal)
{
   string sdate = TimeToStr(TimeCurrent(), TIME_DATE);
   datetime start_time = StrToTime(sdate+" "+StartTime);
   datetime end_time = StrToTime(sdate+" "+EndTime);

   int ret = 0;
   if(start_time <= end_time)
   {
      if(TimeCurrent() >= start_time && TimeCurrent() < end_time) ret = signal;
      else ret = 0;
   }
   else
   {
      if(TimeCurrent() >= end_time && TimeCurrent() < start_time) ret = 0;
      else ret = signal;
   }

   return(ret);
}

// �G�O�W�b�g�֐�
void ExitPosition(int magic)
{
   string sdate = TimeToStr(TimeCurrent(), TIME_DATE);
   datetime end_time = StrToTime(sdate+" "+EndTime);

   if(TimeCurrent() >= end_time && TimeCurrent() < end_time+600) MyOrderClose(Slippage, magic);
}

// �X�^�[�g�֐�
int start()
{
   // �|�W�V�����̌���
   ExitPosition(MAGIC);

   // �G���g���[�V�O�i���̐���
   int sig_entry = EntrySignal(MAGIC);

   // �G���g���[�̃t�B���^�[
   sig_entry = FilterSignal(sig_entry);

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

