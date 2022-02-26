//+------------------------------------------------------------------+
//|                                                  KumikomiSto.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_level1 20
#property indicator_level2 80

// �w�W�o�b�t�@
double BufSto[];
double BufSignal[];

// �O���p�����[�^
extern int KPeriod = 10;
extern int DPeriod = 3;
extern int Slowing = 3;

// �������֐�
int init()
{
   // �w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0, BufSto);
   SetIndexBuffer(1, BufSignal);

   // �w�W�X�^�C���̐ݒ�
   SetIndexStyle(1, DRAW_LINE, STYLE_DOT);
   
   // �w�W���x���̐ݒ�
   SetIndexLabel(0, "Stoch("+KPeriod+","+Slowing+")");
   SetIndexLabel(1, "Signal("+DPeriod+")");
   IndicatorShortName("Stoch("+KPeriod+","+DPeriod+","+Slowing+")");

   return(0);
}

// �X�^�[�g�֐�
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      BufSto[i] = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, i);
      BufSignal[i] = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_SIGNAL, i);
   }

   return(0);
}

