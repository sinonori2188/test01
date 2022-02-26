//+------------------------------------------------------------------+
//|                                                  KumikomiMom.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
#property indicator_level1 100

// �w�W�o�b�t�@
double BufMom[];

// �O���p�����[�^
extern int MomPeriod = 20;

// �������֐�
int init()
{
   // �w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0,BufMom);

   // �w�W���x���̐ݒ�
   string label = "Momentum("+MomPeriod+")";
   IndicatorShortName(label);
   SetIndexLabel(0,label);

   return(0);
}

// �X�^�[�g�֐�
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      BufMom[i] = iMomentum(NULL, 0, MomPeriod, PRICE_CLOSE, i);
   }

   return(0);
}

