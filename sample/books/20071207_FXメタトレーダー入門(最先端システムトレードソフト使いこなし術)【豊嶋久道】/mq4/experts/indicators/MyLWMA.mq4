//+------------------------------------------------------------------+
//|                                                       MyLWMA.mq4 |
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
   SetIndexLabel(0, "LWMA("+MA_Period+")");

   return(0);
}

//+------------------------------------------------------------------+
//| �w�W�����֐�                                                     |
//+------------------------------------------------------------------+
int start()
{
   int limit = Bars-IndicatorCounted();
   if(limit == Bars) limit -= MA_Period-1;

   for(int i=limit-1; i>=0; i--)
   {
      double sum=0;
      int weight=0;
      for(int k=0; k<MA_Period; k++)
      {
         int w = MA_Period-k; //w = 1 �Ƃ���� SMA
         sum += w*Close[i+k];
         weight += w;
      }
      BufMA[i] = sum/weight;
   }

   return(0);
}
//+------------------------------------------------------------------+