//+------------------------------------------------------------------+
//|                                                          Ex2.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red       //<--���C���̐F���w��
#property indicator_style1 STYLE_DOT //<--���C���̎�ނ��w��

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