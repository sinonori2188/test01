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

//指標バッファ
double BufFastMA[];
double BufSlowMA[];
double BufBuy[];
double BufSell[];

//パラメータ
extern int FastMA_Period = 10;
extern int SlowMA_Period = 40;

//+------------------------------------------------------------------+
//| 初期化関数                                                       |
//+------------------------------------------------------------------+
int init()
{
   //指標バッファの割り当て
   SetIndexBuffer(0, BufFastMA);
   SetIndexBuffer(1, BufSlowMA);
   SetIndexBuffer(2, BufBuy);
   SetIndexBuffer(3, BufSell);

   //指標ラベルの設定
   SetIndexLabel(0,"FastMA("+FastMA_Period+")");
   SetIndexLabel(1,"SlowMA("+SlowMA_Period+")");
   SetIndexLabel(2,"BuySignal");
   SetIndexLabel(3,"SellSignal");

   //指標スタイルの設定（Buyシグナル）
   SetIndexStyle(2, DRAW_ARROW, STYLE_SOLID, 1, Blue);
   SetIndexArrow(2,233);

   //指標スタイルの設定（Sellシグナル）
   SetIndexStyle(3, DRAW_ARROW, STYLE_SOLID, 1, Red);
   SetIndexArrow(3,234);

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

   //SMAの計算
   if(counted_bar == 0) limit -= SlowMA_Period-1;
   for(int i=limit-1; i>=0; i--)
   {
      BufFastMA[i] = iMA(NULL,0,FastMA_Period,0,MODE_SMA,PRICE_CLOSE,i); //10バーSMA
      BufSlowMA[i] = iMA(NULL,0,SlowMA_Period,0,MODE_SMA,PRICE_CLOSE,i); //40バーSMA
   }

   //売買シグナルの生成
   if(counted_bar == 0) limit -= 2;
   for(i=limit-1; i>=0; i--)
   {
      //Buyシグナル
      BufBuy[i] = EMPTY_VALUE;
      if(BufFastMA[i+2] <= BufSlowMA[i+2] && BufFastMA[i+1] > BufSlowMA[i+1]) BufBuy[i] = Open[i];

      //Sellシグナル
      BufSell[i] = EMPTY_VALUE;
      if(BufFastMA[i+2] >= BufSlowMA[i+2] && BufFastMA[i+1] < BufSlowMA[i+1]) BufSell[i] = Open[i];
   }

   return(0);
}
//+------------------------------------------------------------------+