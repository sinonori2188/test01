//+------------------------------------------------------------------+
//|                                                      MyBands.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 LightSeaGreen
#property indicator_color2 LightSeaGreen
#property indicator_color3 LightSeaGreen

//�w�W�o�b�t�@
double BufMA[];
double BufUpper[];
double BufLower[];

//�p�����[�^�[
extern int BandsPeriod = 20;
extern double BandsDeviations = 2.0;

//+------------------------------------------------------------------+
//| �������֐�                                                       |
//+------------------------------------------------------------------+
int init()
{
   //�w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0,BufMA);
   SetIndexBuffer(1,BufUpper);
   SetIndexBuffer(2,BufLower);

   //�w�W���x���̐ݒ�
   SetIndexLabel(0, "SMA("+BandsPeriod+")");
   SetIndexLabel(1, "Upper("+DoubleToStr(BandsDeviations,1)+")");
   SetIndexLabel(2, "Lower("+DoubleToStr(BandsDeviations,1)+")");

   return(0);
}

//+------------------------------------------------------------------+
//| �w�W�����֐�                                                     |
//+------------------------------------------------------------------+
int start()
{
   int limit = Bars-IndicatorCounted();
   if(limit == Bars) limit -= BandsPeriod-1;

   for(int i=limit-1; i>=0; i--)
   {
      BufMA[i] = iMA(NULL,0,BandsPeriod,0,MODE_SMA,PRICE_CLOSE,i); //����

      double sum=0.0;
      for(int k=0; k<BandsPeriod; k++)
      {
         double newres = Close[i+k]-BufMA[i]; //�I�l�ƕ��ς̍�
         sum += newres*newres; //newres�̂Q��a
      }
      double deviation = MathSqrt(sum/BandsPeriod); //�W���΍��̌v�Z
      BufUpper[i] = BufMA[i]+BandsDeviations*deviation; //��̃��C��
      BufLower[i] = BufMA[i]-BandsDeviations*deviation; //���̃��C��
   }

   return(0);
}
//+------------------------------------------------------------------+