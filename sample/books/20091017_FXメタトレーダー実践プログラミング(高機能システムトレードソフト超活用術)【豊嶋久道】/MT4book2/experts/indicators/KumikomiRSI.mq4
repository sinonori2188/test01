//+------------------------------------------------------------------+
//|                                                  KumikomiRSI.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_level1 30
#property indicator_level2 70

// �w�W�o�b�t�@
double BufRSI[];

// �O���p�����[�^
extern int RSI_Period = 14;

// �������֐�
int init()
{
   // �w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0, BufRSI);

   // �w�W���x���̐ݒ�
   string label = "RSI("+RSI_Period+")";
   IndicatorShortName(label);
   SetIndexLabel(0, label);

   return(0);
}

// �X�^�[�g�֐�
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      BufRSI[i] = iRSI(NULL, 0, RSI_Period, PRICE_CLOSE, i);
   }

   return(0);
}

