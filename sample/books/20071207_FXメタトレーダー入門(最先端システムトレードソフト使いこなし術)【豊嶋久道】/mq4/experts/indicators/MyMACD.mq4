//+------------------------------------------------------------------+
//|                                                       MyMACD.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Silver
#property indicator_color2 Blue
#property indicator_color3 Red

//�w�W�o�b�t�@
double BufMACD[];
double BufUp[];
double BufDown[];

//�p�����[�^�[
extern int FastEMA = 12;
extern int SlowEMA = 26;
extern int SignalSMA = 9;

//+------------------------------------------------------------------+
//| �������֐�                                                       |
//+------------------------------------------------------------------+
int init()
{
   //�w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0,BufMACD);
   SetIndexBuffer(1,BufUp);
   SetIndexBuffer(2,BufDown);

   //�w�W���x���̐ݒ�
   string label = "MACD("+FastEMA+","+SlowEMA+","+SignalSMA+")";
   IndicatorShortName(label);
   SetIndexLabel(0,label);
   SetIndexLabel(1,"UpSignal");
   SetIndexLabel(2,"DownSignal");

   //�w�W�X�^�C���̐ݒ�
   SetIndexStyle(0,DRAW_HISTOGRAM, STYLE_SOLID, 3, Silver);
   SetIndexStyle(1,DRAW_HISTOGRAM, STYLE_SOLID, 1, Blue);
   SetIndexStyle(2,DRAW_HISTOGRAM, STYLE_SOLID, 1, Red);

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
      if(i == Bars-1) BufMACD[i] = 0;
      else BufMACD[i] = iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)
                       -iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i); //MACD�̌v�Z
   }
   
   if(limit == Bars) limit -= SignalSMA-1;
   for(i=limit-1; i>=0; i--)
   {
      BufUp[i] = 0; BufDown[i] = 0;
      double val = iMAOnArray(BufMACD,0,SignalSMA,0,MODE_SMA,i); //�V�O�i���̌v�Z
      if(BufMACD[i] >= val) BufUp[i] = val; //MACD��val����̏ꍇ
      else BufDown[i] = val;                //MACD��val��艺�̏ꍇ
   }

   return(0);
}
//+------------------------------------------------------------------+