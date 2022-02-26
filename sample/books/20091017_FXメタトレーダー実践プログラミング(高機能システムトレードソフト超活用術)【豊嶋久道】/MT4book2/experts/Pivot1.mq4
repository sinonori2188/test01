//+------------------------------------------------------------------+
//|                                                       Pivot1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// �}�C���C�u�����[
#include <MyLib.mqh>

// �}�W�b�N�i���o�[
#define MAGIC1  20094090
#define MAGIC2  20094091
#define COMMENT "Pivot1"

// �O���p�����[�^
extern double Lots = 0.1;
extern int Slippage = 3;

// �G���g���[�֐�
extern string StartTime = "0:00";   //�G���g���[����
void EntryPosition()
{
   // PIVOT�̌v�Z
   double pivot = iCustom(NULL, 0, "Pivot", 0, 0);
   double reg1 = iCustom(NULL, 0, "Pivot", 1, 0);
   double sup1 = iCustom(NULL, 0, "Pivot", 2, 0);
   double reg2 = iCustom(NULL, 0, "Pivot", 3, 0);
   double sup2 = iCustom(NULL, 0, "Pivot", 4, 0);
   double spread = Ask-Bid;

   string sdate = TimeToStr(TimeCurrent(), TIME_DATE);
   datetime start_time = StrToTime(sdate+" "+StartTime);
   
   if(TimeCurrent() >= start_time && TimeCurrent() < start_time+600)
   {
      // �w�l��������
      if(MyCurrentOrders(MY_BUYPOS, MAGIC1) == 0)
      {
         MyOrderSend(OP_BUYLIMIT, Lots, sup1+spread, Slippage, sup2, pivot, COMMENT, MAGIC1);
      }
      // �w�l���蒍��
      if(MyCurrentOrders(MY_SELLPOS, MAGIC2) == 0)
      {
         MyOrderSend(OP_SELLLIMIT, Lots, reg1, Slippage, reg2+spread, pivot+spread, COMMENT, MAGIC2);
      }
   }   
}

// �G�O�W�b�g�֐�
extern string EndTime = "22:00"; // �G�O�W�b�g����
void ExitPosition(int magic)
{
   string sdate = TimeToStr(TimeCurrent(), TIME_DATE);
   datetime end_time = StrToTime(sdate+" "+EndTime);

   if(TimeCurrent() >= end_time && TimeCurrent() < end_time+600)
   {
      MyOrderClose(Slippage, magic);
      MyOrderDelete(magic);
   }
}

// �X�^�[�g�֐�
int start()
{
   // �w�l�����G���g���[
   EntryPosition();

   // OCO����
   if(MyCurrentOrders(MY_OPENPOS, MAGIC1) != 0 && MyCurrentOrders(MY_PENDPOS, MAGIC2) != 0) MyOrderDelete(MAGIC2);
   if(MyCurrentOrders(MY_OPENPOS, MAGIC2) != 0 && MyCurrentOrders(MY_PENDPOS, MAGIC1) != 0) MyOrderDelete(MAGIC1);

   // �|�W�V�����̌���
   ExitPosition(MAGIC1);
   ExitPosition(MAGIC2);

   return(0);
}

