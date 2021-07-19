//+------------------------------------------------------------------+
//|                                                        Pivot.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Red

// 指標バッファ
double PBuf[];
double R1Buf[];
double S1Buf[];
double R2Buf[];
double S2Buf[];
double R3Buf[];
double S3Buf[];

// 初期化関数
int init()
{
   // 指標バッファの割り当て
   SetIndexBuffer(0, PBuf);
   SetIndexBuffer(1, R1Buf);
   SetIndexBuffer(2, S1Buf);
   SetIndexBuffer(3, R2Buf);
   SetIndexBuffer(4, S2Buf);
   SetIndexBuffer(5, R3Buf);
   SetIndexBuffer(6, S3Buf);

   // 指標ラベルの設定
   SetIndexLabel(0, "PIVOT");
   SetIndexLabel(1, "R1");
   SetIndexLabel(2, "S1");
   SetIndexLabel(3, "R2");
   SetIndexLabel(4, "S2");
   SetIndexLabel(5, "HBOP");
   SetIndexLabel(6, "LBOP");

   return(0);
}

// スタート関数
int start()
{
   int limit = Bars-IndicatorCounted();

   for(int i=limit-1; i>=0; i--)
   {
      int shift = iBarShift(NULL, PERIOD_D1, Time[i])+1;
      double lastH = iHigh(NULL, PERIOD_D1, shift);
      double lastL = iLow(NULL, PERIOD_D1, shift);
      double lastC = iClose(NULL, PERIOD_D1, shift);

      double P = (lastH + lastL + lastC)/3;
      PBuf[i] = P;
      R1Buf[i] = P + (P - lastL);
      S1Buf[i] = P - (lastH - P);
      R2Buf[i] = P + (lastH - lastL);
      S2Buf[i] = P - (lastH - lastL);
      R3Buf[i] = lastH + 2*(P - lastL);
      S3Buf[i] = lastL - 2*(lastH - P);
   }

   return(0);
}

