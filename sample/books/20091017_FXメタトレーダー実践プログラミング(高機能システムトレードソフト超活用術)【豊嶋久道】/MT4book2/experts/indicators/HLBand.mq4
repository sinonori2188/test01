//+------------------------------------------------------------------+
//|                                                       HLBand.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Purple
#property indicator_color2 LightBlue
#property indicator_color3 Pink

// �w�W�o�b�t�@
double BufMed[];
double BufHigh[];
double BufLow[];

// �O���p�����[�^
extern int BandPeriod = 20;
extern int PriceField = 0;  // 0:High/Low 1:Close/Close

// �������֐�
int init()
{
   // �w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0, BufMed);
   SetIndexBuffer(1, BufHigh);
   SetIndexBuffer(2, BufLow);

   // �w�W���x���̐ݒ�
   SetIndexLabel(0, "HLmed("+BandPeriod+")");
   SetIndexLabel(1, "High("+BandPeriod+")");
   SetIndexLabel(2, "Low("+BandPeriod+")");

   return(0);
}

// �X�^�[�g�֐�
int start()
{
   int limit = Bars-IndicatorCounted();

   for(int i=limit-1; i>=0; i--)
   {
      if(PriceField == 0)
      {
         BufHigh[i] = High[iHighest(NULL, 0, MODE_HIGH, BandPeriod, i)];
         BufLow[i] = Low[iLowest(NULL, 0, MODE_LOW, BandPeriod, i)];
      }
      else
      {
         BufHigh[i] = Close[iHighest(NULL, 0, MODE_CLOSE, BandPeriod, i)];
         BufLow[i] = Close[iLowest(NULL, 0, MODE_CLOSE, BandPeriod, i)];
      }
      BufMed[i] = (BufHigh[i] + BufLow[i])/2;
   }

   return(0);
}

