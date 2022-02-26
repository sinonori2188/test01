//+------------------------------------------------------------------+
//|                                                 MyStochastic.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Purple
#property indicator_color2 Red
#property indicator_style2 STYLE_DOT
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_level1 25
#property indicator_level2 50
#property indicator_level3 75

//�w�W�o�b�t�@
double BufMain[];
double BufSignal[];
double BufHigh[];
double BufLow[];

//�p�����[�^�[
extern int KPeriod = 5;
extern int DPeriod = 3;
extern int Slowing = 3;

//+------------------------------------------------------------------+
//| �������֐�                                                       |
//+------------------------------------------------------------------+
int init()
{
   //�w�W�o�b�t�@�̊��蓖��
   IndicatorBuffers(4);
   SetIndexBuffer(0,BufMain);
   SetIndexBuffer(1,BufSignal);
   SetIndexBuffer(2,BufHigh);
   SetIndexBuffer(3,BufLow);

   //�w�W���x���̐ݒ�
   string label = "Stoch("+KPeriod+","+DPeriod+","+Slowing+")";
   IndicatorShortName(label);
   SetIndexLabel(0,label);
   SetIndexLabel(1,"Signal");

   return(0);
}

//+------------------------------------------------------------------+
//| �w�W�����֐�                                                     |
//+------------------------------------------------------------------+
int start()
{
   int counted_bar = IndicatorCounted();
   int limit = Bars-counted_bar;

   if(counted_bar == 0) limit -= KPeriod;
   for(int i=limit-1; i>=0; i--)
   {
      BufHigh[i] = High[iHighest(NULL,0,MODE_HIGH,KPeriod,i)]; //KPeriod�͈̔͂̍ō��l
      BufLow[i] = Low[iLowest(NULL,0,MODE_LOW,KPeriod,i)];     //KPeriod�͈̔͂̍ň��l
   }

   if(counted_bar == 0) limit -= Slowing-1;
   for(i=limit-1; i>=0; i--)
   {
      double sumlow = 0.0;
      double sumhigh = 0.0;
      for(int k=0; k<Slowing; k++)
      {
         sumlow += Close[i+k]-BufLow[i+k];    //�I�l�ƍň��l�̍�
         sumhigh += BufHigh[i+k]-BufLow[i+k]; //�ō��l�ƍň��l�̍�
      }
      if(sumhigh == 0.0) BufMain[i] = 50;   //sumhigh=0�̏ꍇ
      else BufMain[i] = sumlow/sumhigh*100; //�X�g�L���X�e�B�b�N�X�̌v�Z��
   }

   if(counted_bar == 0) limit -= DPeriod-1;
   for(i=limit-1;i>=0;i--)
   {
      BufSignal[i] = iMAOnArray(BufMain,0,DPeriod,0,MODE_SMA,i); //�X�g�L���X�e�B�b�N�X��SMA
   }
   
   return(0);
}
//+------------------------------------------------------------------+