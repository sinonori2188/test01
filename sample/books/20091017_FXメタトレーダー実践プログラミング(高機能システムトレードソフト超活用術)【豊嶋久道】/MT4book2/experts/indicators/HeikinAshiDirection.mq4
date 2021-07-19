//+------------------------------------------------------------------+
//|                                          HeikinAshiDirection.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_width1 3
#property indicator_width2 3
#property indicator_minimum 0
#property indicator_maximum 1

// �w�W�o�b�t�@
double BufUp[];
double BufDown[];

// �������֐�
int init()
{
   // �w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0, BufUp);
   SetIndexBuffer(1, BufDown);

   // �w�W���x���̐ݒ�
   SetIndexLabel(0, "Up");
   SetIndexLabel(1, "Down");

   // �w�W�X�^�C���̐ݒ�
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexStyle(1, DRAW_HISTOGRAM);

   return(0);
}

// �X�^�[�g�֐�
int start()
{
   int limit = Bars-IndicatorCounted();

   for(int i=limit-1; i>=0; i--)
   {
      double valOpen = iCustom(NULL, 0, "HeikinAshi", 0, i);
      double valClose = iCustom(NULL, 0, "HeikinAshi", 1, i);

      BufUp[i] = 0; BufDown[i] = 0;
      if(valClose > valOpen) BufUp[i] = 1; //�z���̏ꍇ
      else if(valClose < valOpen) BufDown[i] = 1; //�A���̏ꍇ
   }

   return(0);
}

