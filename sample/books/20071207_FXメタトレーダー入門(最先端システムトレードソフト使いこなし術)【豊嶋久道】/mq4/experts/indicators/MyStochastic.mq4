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

//指標バッファ
double BufMain[];
double BufSignal[];
double BufHigh[];
double BufLow[];

//パラメーター
extern int KPeriod = 5;
extern int DPeriod = 3;
extern int Slowing = 3;

//+------------------------------------------------------------------+
//| 初期化関数                                                       |
//+------------------------------------------------------------------+
int init()
{
   //指標バッファの割り当て
   IndicatorBuffers(4);
   SetIndexBuffer(0,BufMain);
   SetIndexBuffer(1,BufSignal);
   SetIndexBuffer(2,BufHigh);
   SetIndexBuffer(3,BufLow);

   //指標ラベルの設定
   string label = "Stoch("+KPeriod+","+DPeriod+","+Slowing+")";
   IndicatorShortName(label);
   SetIndexLabel(0,label);
   SetIndexLabel(1,"Signal");

   return(0);
}

//+------------------------------------------------------------------+
//| 指標処理関数                                                     |
//+------------------------------------------------------------------+
int start()
{
   int counted_bar = IndicatorCounted();
   int limit = Bars-counted_bar;

   if(counted_bar == 0) limit -= KPeriod;
   for(int i=limit-1; i>=0; i--)
   {
      BufHigh[i] = High[iHighest(NULL,0,MODE_HIGH,KPeriod,i)]; //KPeriodの範囲の最高値
      BufLow[i] = Low[iLowest(NULL,0,MODE_LOW,KPeriod,i)];     //KPeriodの範囲の最安値
   }

   if(counted_bar == 0) limit -= Slowing-1;
   for(i=limit-1; i>=0; i--)
   {
      double sumlow = 0.0;
      double sumhigh = 0.0;
      for(int k=0; k<Slowing; k++)
      {
         sumlow += Close[i+k]-BufLow[i+k];    //終値と最安値の差
         sumhigh += BufHigh[i+k]-BufLow[i+k]; //最高値と最安値の差
      }
      if(sumhigh == 0.0) BufMain[i] = 50;   //sumhigh=0の場合
      else BufMain[i] = sumlow/sumhigh*100; //ストキャスティックスの計算式
   }

   if(counted_bar == 0) limit -= DPeriod-1;
   for(i=limit-1;i>=0;i--)
   {
      BufSignal[i] = iMAOnArray(BufMain,0,DPeriod,0,MODE_SMA,i); //ストキャスティックスのSMA
   }
   
   return(0);
}
//+------------------------------------------------------------------+