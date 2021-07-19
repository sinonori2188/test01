//+------------------------------------------------------------------+
//|                                                      HLBand2.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 LightBlue
#property indicator_color2 Pink
#property indicator_color3 Blue
#property indicator_color4 Red
#property indicator_width3 2
#property indicator_width4 2

// �w�W�o�b�t�@
double BufHigh1[];
double BufLow1[];
double BufHigh2[];
double BufLow2[];

// �O���p�����[�^
extern int BandPeriod1 = 5;
extern int BandPeriod2 = 20;

// �������֐�
int init()
{
   // �w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0, BufHigh1);
   SetIndexBuffer(1, BufLow1);
   SetIndexBuffer(2, BufHigh2);
   SetIndexBuffer(3, BufLow2);

   // �w�W���x���̐ݒ�
   SetIndexLabel(0, "High("+BandPeriod1+")");
   SetIndexLabel(1, "Low("+BandPeriod1+")");
   SetIndexLabel(2, "High("+BandPeriod2+")");
   SetIndexLabel(3, "Low("+BandPeriod2+")");

   return(0);
}

// �X�^�[�g�֐�
int start()
{
   int limit = Bars-IndicatorCounted();

   for(int i=limit-1; i>=0; i--)
   {
      BufHigh1[i] = iCustom(NULL, 0, "HLBand", BandPeriod1, 1, i);
      BufLow1[i] = iCustom(NULL, 0, "HLBand", BandPeriod1, 2, i);
      BufHigh2[i] = iCustom(NULL, 0, "HLBand", BandPeriod2, 1, i);
      BufLow2[i] = iCustom(NULL, 0, "HLBand", BandPeriod2, 2, i);
   }

   return(0);
}

