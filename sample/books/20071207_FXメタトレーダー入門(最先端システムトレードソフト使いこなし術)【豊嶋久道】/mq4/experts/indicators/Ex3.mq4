//+------------------------------------------------------------------+
//|                                                          Ex3.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red

//�w�W�o�b�t�@
double Buf[];

//�ړ����ς̊���
extern int MA_Period = 4; //<--�u�p�����[�^�[�̓��́v�ŕύX�ł���

//+------------------------------------------------------------------+
//| �������֐�                                                       |
//+------------------------------------------------------------------+
int init()
{
   //�w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0,Buf);

   return(0);
}

//+------------------------------------------------------------------+
//| �w�W�����֐�                                                     |
//+------------------------------------------------------------------+
int start()
{
   //�w�W�̌v�Z�͈�
   int limit = Bars-IndicatorCounted();

   //�w�W�̌v�Z
   for(int i=limit-1; i>=0; i--)
   {
      Buf[i] = 0;
      for(int j=0; j<MA_Period; j++)
      {
         Buf[i] += Close[i+j];
      }
      Buf[i] /= MA_Period;
   }

   return(0);
}
//+------------------------------------------------------------------+