//+------------------------------------------------------------------+
//|                                                          Ex6.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_level1 20
#property indicator_level2 80
#property indicator_buffers 1
#property indicator_color1 Red

//�w�W�o�b�t�@
double Buf[];

//�ō��l�E�ň��l�̊���
extern int ST_Period = 14;

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
   if(limit == Bars) limit -= ST_Period;

   //�w�W�̌v�Z
   for(int i=limit-1; i>=0; i--)
   {
      double HH=0, LL=10000;
      for(int j=0; j<ST_Period; j++)
      {
         if(High[i+j] > HH) HH = High[i+j];
         if(Low[i+j] < LL) LL = Low[i+j];
      }
      Buf[i] = (Close[i]-LL)/(HH-LL)*100;
   }

   return(0);
}
//+------------------------------------------------------------------+