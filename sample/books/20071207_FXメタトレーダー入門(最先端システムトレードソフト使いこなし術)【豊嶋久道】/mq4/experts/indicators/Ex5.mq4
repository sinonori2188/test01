//+------------------------------------------------------------------+
//|                                                          Ex5.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window //<---�T�u�E�C���h�E�ɕ\��
#property indicator_buffers 1
#property indicator_color1 Red

//�w�W�o�b�t�@
double Buf[];

//�������^���̊���
extern int Mom_Period = 14;

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
   if(limit == Bars) limit -= Mom_Period;

   //�w�W�̌v�Z
   for(int i=limit-1; i>=0; i--)
   {
      Buf[i] = Close[i]-Close[i+Mom_Period];
   }

   return(0);
}
//+------------------------------------------------------------------+