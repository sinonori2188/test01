//+------------------------------------------------------------------+
//|                                                 OutputDataD1.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com/"
#property show_inputs

// �O���p�����[�^
extern datetime StartTime; // �J�n����
extern datetime EndTime;   // �I������

// �X�^�[�g�֐�
int start()
{
   // �t�@�C���I�[�v��
   int handle = FileOpen(Symbol()+Period()+".csv", FILE_CSV|FILE_WRITE, ',');
   if(handle < 0) return(-1);

   // �o�͔͈͂̎w��
   int iStart = iBarShift(NULL, 0, StartTime);
   if(EndTime == 0) EndTime = TimeCurrent();
   int iEnd = iBarShift(NULL, 0, EndTime);

   // �t�@�C���o��
   FileWrite(handle, "Date", "Open", "High", "Low", "Close", "MA200");
   for(int i=iStart; i>=iEnd; i--)
   {
      // �s�v�ȃo�[�̃X�L�b�v
      if(TimeDayOfWeek(Time[i]) == 0 || TimeDayOfWeek(Time[i]) == 6) continue;
      
      string sDate = TimeYear(Time[i]) + "/" + TimeMonth(Time[i]) + "/" + TimeDay(Time[i]);
      double ma200 = iMA(NULL, 0, 200, 0, MODE_SMA, PRICE_CLOSE, i);
      FileWrite(handle, sDate, Open[i], High[i], Low[i], Close[i], ma200);
   }
   
   // �t�@�C���N���[�Y
   FileClose(handle);

   MessageBox("End of OutputDataD1");

   return(0);
}

