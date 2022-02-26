//+------------------------------------------------------------------+
//|                                                    MAKairiSM.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
#property indicator_level1 0

// 指標バッファ
double BufKairiSM[];
double BufKairi[];

// 外部パラメータ
extern int MAPeriod = 13;
extern int Smooth = 5;

// 初期化関数
int init()
{
   IndicatorBuffers(2); 

   // 指標バッファの割り当て
   SetIndexBuffer(0, BufKairiSM);
   SetIndexBuffer(1, BufKairi);

   // 指標ラベルの設定
   string label = "MAKairiSM("+MAPeriod+","+Smooth+")";
   IndicatorShortName(label);
   SetIndexLabel(0, label);

   return(0);
}

// スタート関数
int start()
{
   int limit = Bars-IndicatorCounted();
   
   for(int i=limit-1; i>=0; i--)
   {
      double ma = iMA(NULL, 0, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, i);
      if(ma != 0) BufKairi[i] = (Close[i]-ma)/ma*100;
   }

   // BufKairi[]の平滑化
   for(i=limit-1; i>=0; i--)
   {
      BufKairiSM[i] = iMAOnArray(BufKairi, 0, Smooth, 0, MODE_EMA, i);
   }

   return(0);
}

