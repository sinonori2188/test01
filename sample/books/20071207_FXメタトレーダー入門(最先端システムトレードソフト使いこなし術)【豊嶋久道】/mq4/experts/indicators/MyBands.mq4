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

//指標バッファ
double BufMA[];
double BufUpper[];
double BufLower[];

//パラメーター
extern int BandsPeriod = 20;
extern double BandsDeviations = 2.0;

//+------------------------------------------------------------------+
//| 初期化関数                                                       |
//+------------------------------------------------------------------+
int init()
{
   //指標バッファの割り当て
   SetIndexBuffer(0,BufMA);
   SetIndexBuffer(1,BufUpper);
   SetIndexBuffer(2,BufLower);

   //指標ラベルの設定
   SetIndexLabel(0, "SMA("+BandsPeriod+")");
   SetIndexLabel(1, "Upper("+DoubleToStr(BandsDeviations,1)+")");
   SetIndexLabel(2, "Lower("+DoubleToStr(BandsDeviations,1)+")");

   return(0);
}

//+------------------------------------------------------------------+
//| 指標処理関数                                                     |
//+------------------------------------------------------------------+
int start()
{
   int limit = Bars-IndicatorCounted();
   if(limit == Bars) limit -= BandsPeriod-1;

   for(int i=limit-1; i>=0; i--)
   {
      BufMA[i] = iMA(NULL,0,BandsPeriod,0,MODE_SMA,PRICE_CLOSE,i); //平均

      double sum=0.0;
      for(int k=0; k<BandsPeriod; k++)
      {
         double newres = Close[i+k]-BufMA[i]; //終値と平均の差
         sum += newres*newres; //newresの２乗和
      }
      double deviation = MathSqrt(sum/BandsPeriod); //標準偏差の計算
      BufUpper[i] = BufMA[i]+BandsDeviations*deviation; //上のライン
      BufLower[i] = BufMA[i]-BandsDeviations*deviation; //下のライン
   }

   return(0);
}
//+------------------------------------------------------------------+