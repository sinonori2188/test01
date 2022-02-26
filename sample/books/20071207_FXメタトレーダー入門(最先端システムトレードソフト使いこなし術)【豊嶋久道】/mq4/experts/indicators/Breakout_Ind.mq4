//+------------------------------------------------------------------+
//|                                                 Breakout_Ind.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_width3 2
#property indicator_color4 Red
#property indicator_width4 2
#property indicator_color5 Blue
#property indicator_color6 Red
#property indicator_color7 Purple

//指標バッファ
double BufFastHH[];
double BufFastLL[];
double BufSlowHH[];
double BufSlowLL[];
double BufBuy[];
double BufSell[];
double BufClose[];

//パラメーター
extern int Fast_Period = 20;
extern int Slow_Period = 40;

//オープンポジション数
int Position = 0;

//+------------------------------------------------------------------+
//| 指標初期化関数                                                   |
//+------------------------------------------------------------------+
int init()
{
//指標バッファの割り当て
   SetIndexBuffer(0, BufFastHH);
   SetIndexBuffer(1, BufFastLL);
   SetIndexBuffer(2, BufSlowHH);
   SetIndexBuffer(3, BufSlowLL);
   SetIndexBuffer(4, BufBuy);
   SetIndexBuffer(5, BufSell);
   SetIndexBuffer(6, BufClose);

//指標ラベルの設定
   SetIndexLabel(0,"FastHH");
   SetIndexLabel(1,"FastLL");
   SetIndexLabel(2,"SlowHH");
   SetIndexLabel(3,"SlowLL");
   SetIndexLabel(4,"BuySignal");
   SetIndexLabel(5,"SellSignal");
   SetIndexLabel(6,"CloseSignal");

//指標スタイルの設定（Buyシグナル）
   SetIndexStyle(4, DRAW_ARROW, STYLE_SOLID, 1, Blue);
   SetIndexArrow(4,233);

//指標スタイルの設定（Sellシグナル）
   SetIndexStyle(5, DRAW_ARROW, STYLE_SOLID, 1, Red);
   SetIndexArrow(5,234);

//指標スタイルの設定（Closeシグナル）
   SetIndexStyle(6, DRAW_ARROW, STYLE_SOLID, 1, Purple);
   SetIndexArrow(6,232);

   return(0);
}
//+------------------------------------------------------------------+
//| 指標処理関数                                                     |
//+------------------------------------------------------------------+
int start()
{
   //指標の計算範囲
   int counted_bar = IndicatorCounted(); 
   int limit = Bars-counted_bar;

   //指標の計算
   if(counted_bar == 0) limit -= Slow_Period;
   for(int i=limit-1; i>=0; i--)
   {
      BufFastHH[i] = Close[iHighest(NULL,0,MODE_CLOSE,Fast_Period,i)];
      BufFastLL[i] = Close[iLowest(NULL,0,MODE_CLOSE,Fast_Period,i)];
      BufSlowHH[i] = Close[iHighest(NULL,0,MODE_CLOSE,Slow_Period,i)];
      BufSlowLL[i] = Close[iLowest(NULL,0,MODE_CLOSE,Slow_Period,i)];
   }

   //売買シグナルの生成
   if(counted_bar == 0) limit -= 2;
   for(i=limit-1; i>=0; i--)
   {
      //買いシグナル 
      BufBuy[i] = EMPTY_VALUE;
      if(Position <= 0 && Close[i+2] <= BufSlowHH[i+2] && Close[i+1] > BufSlowHH[i+2])
      {
         BufBuy[i] = Open[i];
         Position = 1;
         continue;
      }
      //売りシグナル
      BufSell[i] = EMPTY_VALUE;
      if(Position >= 0 && Close[i+2] >= BufSlowLL[i+2] && Close[i+1] < BufSlowLL[i+2])
      {
         BufSell[i] = Open[i];
         Position = -1;
         continue;
      }
      //買いポジションの決済
      BufClose[i] = EMPTY_VALUE;
      if(Position > 0 && Close[i+2] >= BufFastLL[i+2] && Close[i+1] < BufFastLL[i+2])
      {
         BufClose[i] = Open[i];
         Position = 0;
         continue;
      }
      //売りポジションの決済
      if(Position < 0 && Close[i+2] <= BufFastHH[i+2] && Close[i+1] > BufFastHH[i+2])
      {
         BufClose[i] = Open[i];
         Position = 0;
         continue;
      }
   }

   return(0);
}
//+------------------------------------------------------------------+