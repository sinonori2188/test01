//+------------------------------------------------------------------+
//|                                                      MAKairi.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
#property indicator_level1 0

// �w�W�o�b�t�@
double BufKairi[];

// �O���p�����[�^
extern int MAPeriod = 13;

// �������֐�
int init()
{
   // �w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0, BufKairi);

   // �w�W���x���̐ݒ�
   string label = "MAKairi("+MAPeriod+")";
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
      double ma = iMA(NULL, 0, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, i);
      if(ma != 0) BufKairi[i] = (Close[i]-ma)/ma*100;
   }

   return(0);
}

