//+------------------------------------------------------------------+
//|                                                  MACross_Ind.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_color4 Red

//�w�W�o�b�t�@
double BufFastMA[];
double BufSlowMA[];
double BufBuy[];
double BufSell[];

//�p�����[�^
extern int FastMA_Period = 10;
extern int SlowMA_Period = 40;

//+------------------------------------------------------------------+
//| �������֐�                                                       |
//+------------------------------------------------------------------+
int init()
{
   //�w�W�o�b�t�@�̊��蓖��
   SetIndexBuffer(0, BufFastMA);
   SetIndexBuffer(1, BufSlowMA);
   SetIndexBuffer(2, BufBuy);
   SetIndexBuffer(3, BufSell);

   //�w�W���x���̐ݒ�
   SetIndexLabel(0,"FastMA("+FastMA_Period+")");
   SetIndexLabel(1,"SlowMA("+SlowMA_Period+")");
   SetIndexLabel(2,"BuySignal");
   SetIndexLabel(3,"SellSignal");

   //�w�W�X�^�C���̐ݒ�iBuy�V�O�i���j
   SetIndexStyle(2, DRAW_ARROW, STYLE_SOLID, 1, Blue);
   SetIndexArrow(2,233);

   //�w�W�X�^�C���̐ݒ�iSell�V�O�i���j
   SetIndexStyle(3, DRAW_ARROW, STYLE_SOLID, 1, Red);
   SetIndexArrow(3,234);

   return(0);
}

//+------------------------------------------------------------------+
//| �w�W�����֐�                                                     |
//+------------------------------------------------------------------+
int start()
{
   //�w�W�̌v�Z�͈�
   int counted_bar = IndicatorCounted(); 
   int limit = Bars-counted_bar;

   //SMA�̌v�Z
   if(counted_bar == 0) limit -= SlowMA_Period-1;
   for(int i=limit-1; i>=0; i--)
   {
      BufFastMA[i] = iMA(NULL,0,FastMA_Period,0,MODE_SMA,PRICE_CLOSE,i); //10�o�[SMA
      BufSlowMA[i] = iMA(NULL,0,SlowMA_Period,0,MODE_SMA,PRICE_CLOSE,i); //40�o�[SMA
   }

   //�����V�O�i���̐���
   if(counted_bar == 0) limit -= 2;
   for(i=limit-1; i>=0; i--)
   {
      //Buy�V�O�i��
      BufBuy[i] = EMPTY_VALUE;
      if(BufFastMA[i+2] <= BufSlowMA[i+2] && BufFastMA[i+1] > BufSlowMA[i+1]) BufBuy[i] = Open[i];

      //Sell�V�O�i��
      BufSell[i] = EMPTY_VALUE;
      if(BufFastMA[i+2] >= BufSlowMA[i+2] && BufFastMA[i+1] < BufSlowMA[i+1]) BufSell[i] = Open[i];
   }

   return(0);
}
//+------------------------------------------------------------------+