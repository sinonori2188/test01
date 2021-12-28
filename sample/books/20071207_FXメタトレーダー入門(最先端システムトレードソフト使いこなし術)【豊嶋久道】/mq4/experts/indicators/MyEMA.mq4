//+------------------------------------------------------------------+
//|                                                        MyEMA.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red

//�w�W�o�b�t�@
double BufMA[];

//�p�����[�^�[
extern int MA_Period = 20;

//+------------------------------------------------------------------+
//| �������֐�                                                       |
//+------------------------------------------------------------------+
int init()
{
   //�w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0,BufMA);

   //�w�W���x���̐ݒ�
   SetIndexLabel(0, "EMA("+MA_Period+")");

   return(0);
}

//+------------------------------------------------------------------+
//| �w�W�����֐�                                                     |
//+------------------------------------------------------------------+
int start()
{
   int limit = Bars-IndicatorCounted();

   double a = 2.0/(MA_Period+1); //a = 1.0/MAPeriod �Ƃ���� SMMA

   for(int i=limit-1; i>=0; i--)
   {
      if(i == Bars-1) BufMA[i] = Close[i];
      else BufMA[i] = a*Close[i] + (1-a)*BufMA[i+1];
   }

   return(0);
}
//+------------------------------------------------------------------+