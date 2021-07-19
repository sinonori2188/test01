//+------------------------------------------------------------------+
//|                                                  KumikomiSAR.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Blue

// �w�W�o�b�t�@
double BufSAR[];

// �O���p�����[�^
extern double Step = 0.02;
extern double Maximum = 0.2;

// �������֐�
int init()
{
   // �w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0,BufSAR);

   // �w�W���x���̐ݒ�
   SetIndexLabel(0, "SAR("+DoubleToStr(Step,2)+","+DoubleToStr(Maximum,1)+")");

   // �w�W�X�^�C���̐ݒ�
   SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID, 1, Blue);
   SetIndexArrow(0, 159);

   return(0);
}

// �X�^�[�g�֐�
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      BufSAR[i] = iSAR(NULL, 0, Step, Maximum, i);
   }

   return(0);
}

