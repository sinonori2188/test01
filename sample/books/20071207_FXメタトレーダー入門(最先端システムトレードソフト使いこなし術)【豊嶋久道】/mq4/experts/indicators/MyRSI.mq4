//+------------------------------------------------------------------+
//|                                                        MyRSI.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_level1 30
#property indicator_level2 70

//�w�W�o�b�t�@
double BufRSI[];
double BufPos[];
double BufNeg[];

//�p�����[�^�[
extern int RSI_Period = 14;

//+------------------------------------------------------------------+
//| �������֐�                                                       |
//+------------------------------------------------------------------+
int init()
{
   //�w�W�o�b�t�@�̊��蓖��
   IndicatorBuffers(3);
   SetIndexBuffer(0,BufRSI);
   SetIndexBuffer(1,BufPos);
   SetIndexBuffer(2,BufNeg);

   //�w�W���x���̐ݒ�
   string label = "RSI("+RSI_Period+")";
   IndicatorShortName(label);
   SetIndexLabel(0,label);

   return(0);
}

//+------------------------------------------------------------------+
//| �w�W�����֐�                                                     |
//+------------------------------------------------------------------+
int start()
{
   int limit = Bars-IndicatorCounted();

   for(int i=limit-1; i>=0; i--)
   {
      BufPos[i] = 0.0; BufNeg[i] = 0.0; //�w�W�o�b�t�@�̏�����
      if(i == Bars-1) continue; //�ŏ��̃o�[�͌v�Z�����X�L�b�v
      double rel = Close[i]-Close[i+1]; //�O�o�[�Ƃ̍����v�Z
      if(rel > 0) BufPos[i] = rel; //�����v���X�̏ꍇ
      else BufNeg[i] = -rel;       //�����}�C�i�X�̏ꍇ
   }
   
   if(limit == Bars) limit -= RSI_Period-1;
   for(i=limit-1; i>=0; i--)
   {
      double positive = iMAOnArray(BufPos,0,RSI_Period,0,MODE_SMMA,i); //BufPos��SMMA���v�Z
      double negative = iMAOnArray(BufNeg,0,RSI_Period,0,MODE_SMMA,i); //BufNeg��SMMA���v�Z
      if(negative == 0.0) BufRSI[i] = 0.0; //negative=0�̏ꍇ�A�v�Z�ł��Ȃ��̂łO�ɂ���
      else BufRSI[i] = 100.0-100.0/(1+positive/negative); //RSI�̌v�Z��
   }

   return(0);
}
//+------------------------------------------------------------------+