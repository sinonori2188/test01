//+------------------------------------------------------------------+
//|                                                          Ex1.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 1

//�w�W�o�b�t�@
double Buf[];

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
      Buf[i] = (Close[i]+Close[i+1]+Close[i+2]+Close[i+3])/4;
   }

   return(0);
}
//+------------------------------------------------------------------+