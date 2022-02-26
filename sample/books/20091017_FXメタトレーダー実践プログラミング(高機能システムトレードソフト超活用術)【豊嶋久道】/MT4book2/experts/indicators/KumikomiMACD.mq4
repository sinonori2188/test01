//+------------------------------------------------------------------+
//|                                                 KumikomiMACD.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Silver
#property indicator_color2 Red

// �w�W�o�b�t�@
double BufMACD[];
double BufSignal[];

// �O���p�����[�^
extern int FastEMA = 12;
extern int SlowEMA = 26;
extern int SignalSMA = 9;

// �������֐�
int init()
{
   // �w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0, BufMACD);
   SetIndexBuffer(1, BufSignal);

   // �w�W�X�^�C���̐ݒ�
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexStyle(1, DRAW_LINE, STYLE_DOT);
   
   // �w�W���x���̐ݒ�
   SetIndexLabel(0, "MACD("+FastEMA+","+SlowEMA+")");
   SetIndexLabel(1, "Signal("+SignalSMA+")");
   IndicatorShortName("MACD("+FastEMA+","+SlowEMA+","+SignalSMA+")");

   return(0);
}

// �X�^�[�g�֐�
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      BufMACD[i] = iMACD(NULL, 0, FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_MAIN, i);
      BufSignal[i] = iMACD(NULL, 0, FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_SIGNAL, i);
   }

   return(0);
}

