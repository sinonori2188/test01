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

//指標バッファ
double BufRSI[];
double BufPos[];
double BufNeg[];

//パラメーター
extern int RSI_Period = 14;

//+------------------------------------------------------------------+
//| 初期化関数                                                       |
//+------------------------------------------------------------------+
int init()
{
   //指標バッファの割り当て
   IndicatorBuffers(3);
   SetIndexBuffer(0,BufRSI);
   SetIndexBuffer(1,BufPos);
   SetIndexBuffer(2,BufNeg);

   //指標ラベルの設定
   string label = "RSI("+RSI_Period+")";
   IndicatorShortName(label);
   SetIndexLabel(0,label);

   return(0);
}

//+------------------------------------------------------------------+
//| 指標処理関数                                                     |
//+------------------------------------------------------------------+
int start()
{
   int limit = Bars-IndicatorCounted();

   for(int i=limit-1; i>=0; i--)
   {
      BufPos[i] = 0.0; BufNeg[i] = 0.0; //指標バッファの初期化
      if(i == Bars-1) continue; //最初のバーは計算せずスキップ
      double rel = Close[i]-Close[i+1]; //前バーとの差を計算
      if(rel > 0) BufPos[i] = rel; //差がプラスの場合
      else BufNeg[i] = -rel;       //差がマイナスの場合
   }
   
   if(limit == Bars) limit -= RSI_Period-1;
   for(i=limit-1; i>=0; i--)
   {
      double positive = iMAOnArray(BufPos,0,RSI_Period,0,MODE_SMMA,i); //BufPosのSMMAを計算
      double negative = iMAOnArray(BufNeg,0,RSI_Period,0,MODE_SMMA,i); //BufNegのSMMAを計算
      if(negative == 0.0) BufRSI[i] = 0.0; //negative=0の場合、計算できないので０にする
      else BufRSI[i] = 100.0-100.0/(1+positive/negative); //RSIの計算式
   }

   return(0);
}
//+------------------------------------------------------------------+