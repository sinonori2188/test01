//+------------------------------------------------------------------+
//|                                            OutputIndicators2.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com/"
#property indicator_chart_window

// �O���p�����[�^
extern datetime StartTime; // �J�n����

// �t�@�C���o�͊֐�
void WriteIndicators(int handle, int i)
{
   string sDate = TimeYear(Time[i]) + "/" + TimeMonth(Time[i]) + "/" + TimeDay(Time[i]);
   string sTime = TimeHour(Time[i]) + ":" + TimeMinute(Time[i]);
   double ma200 = iMA(NULL, 0, 200, 0, MODE_SMA, PRICE_CLOSE, i);
   FileWrite(handle, sDate, sTime, Open[i], High[i], Low[i], Close[i], ma200);
}

// �������֐�
int init()
{
   // �t�@�C���I�[�v��
   int handle = FileOpen(Symbol()+Period()+".csv", FILE_CSV|FILE_WRITE, ',');
   if(handle < 0) return(-1);

   // �t�@�C���o��
   FileWrite(handle, "Date", "Time", "Open", "High", "Low", "Close", "MA200");
   int iStart = iBarShift(NULL, 0, StartTime);
   for(int i=iStart; i>=1; i--) WriteIndicators(handle, i);
   
   // �t�@�C���N���[�Y
   FileClose(handle);

   return(0);
}

// �X�^�[�g�֐�
int start()
{
   if(Volume[0]>1) return(0);

   // �t�@�C���I�[�v��
   int handle = FileOpen(Symbol()+Period()+".csv", FILE_CSV|FILE_READ|FILE_WRITE, ',');
   if(handle < 0) return(-1);

   // �ǉ��������݂̂��߂̏���
   FileSeek(handle, 0, SEEK_END);
   
   // �t�@�C���o��
   WriteIndicators(handle, 1);
   
   // �t�@�C���N���[�Y
   FileClose(handle);

   return(0);
}

