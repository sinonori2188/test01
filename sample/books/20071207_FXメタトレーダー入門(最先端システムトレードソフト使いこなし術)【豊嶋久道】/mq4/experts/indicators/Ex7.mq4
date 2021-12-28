//+------------------------------------------------------------------+
//|                                                          Ex7.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue

//�w�W�o�b�t�@
double Buf0[];
double Buf1[];

//�ړ����ς̊���
extern int MA_Period = 10;

//+------------------------------------------------------------------+
//| �������֐�                                                       |
//+------------------------------------------------------------------+
int init()
{
   //�w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0,Buf0);
   SetIndexBuffer(1,Buf1);

   return(0);
}

//+------------------------------------------------------------------+
//| �w�W�����֐�                                                     |
//+------------------------------------------------------------------+
int start()
{
   //�w�W�̌v�Z�͈�
   int limit = Bars-IndicatorCounted();
   if(limit == Bars) limit -= MA_Period-1;

   //�w�W�̌v�Z
   for(int i=limit-1; i>=0; i--)
   {
      Buf0[i] = iMA(NULL,0,MA_Period,0,MODE_SMA,PRICE_CLOSE,i); //SMA
      Buf1[i] = iMA(NULL,0,MA_Period,0,MODE_EMA,PRICE_CLOSE,i); //EMA
   }

   return(0);
}
//+------------------------------------------------------------------+