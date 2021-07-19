//+------------------------------------------------------------------+
//|                                                   KumikomiBB.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
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
extern int BandsDeviation = 2;

// �������֐�
int init()
{
   // �w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0, BufMain);
   SetIndexBuffer(1, BufUpper);
   SetIndexBuffer(2, BufLower);

   // �w�W���x���̐ݒ�
   SetIndexLabel(0, "BB("+BandsPeriod+")");
   SetIndexLabel(1, "Upper("+BandsDeviation+")");
   SetIndexLabel(2, "Lower("+BandsDeviation+")");

   return(0);
}

// �X�^�[�g�֐�
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      BufMain[i] = iBands(NULL, 0, BandsPeriod, BandsDeviation, 0, PRICE_CLOSE, MODE_MAIN, i);
      BufUpper[i] = iBands(NULL, 0, BandsPeriod, BandsDeviation, 0, PRICE_CLOSE, MODE_UPPER, i);
      BufLower[i] = iBands(NULL, 0, BandsPeriod, BandsDeviation, 0, PRICE_CLOSE, MODE_LOWER, i);
   }

   return(0);
}

