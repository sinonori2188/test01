//+------------------------------------------------------------------+
//|                                                  KumikomiBB2.mq4 |
//|                                   Copyright (c) 2008, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2008, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 LightBlue
#property indicator_color2 Blue
#property indicator_color3 Blue

// �w�W�o�b�t�@
double BufMain[];
double BufUpper[];
double BufLower[];

// �O���p�����[�^
extern int BandsPeriod = 20;
extern double BandsDeviation = 2.0;

// �������֐�
int init()
{
   // �w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0, BufMain);
   SetIndexBuffer(1, BufUpper);
   SetIndexBuffer(2, BufLower);

   // �w�W���x���̐ݒ�
   SetIndexLabel(0, "BB("+BandsPeriod+")");
   SetIndexLabel(1, "Upper("+DoubleToStr(BandsDeviation,1)+")");
   SetIndexLabel(2, "Lower("+DoubleToStr(BandsDeviation,1)+")");

   return(0);
}

// �X�^�[�g�֐�
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      BufMain[i] = iBands(NULL, 0, BandsPeriod, 1, 0, PRICE_CLOSE, MODE_MAIN, i);
      double dev = iBands(NULL, 0, BandsPeriod, 1, 0, PRICE_CLOSE, MODE_UPPER, i) - BufMain[i];
      BufUpper[i] = BufMain[i] + BandsDeviation * dev;
      BufLower[i] = BufMain[i] - BandsDeviation * dev;
   }

   return(0);
}

