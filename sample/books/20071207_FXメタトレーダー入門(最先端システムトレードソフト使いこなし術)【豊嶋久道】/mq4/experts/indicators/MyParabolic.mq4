//+------------------------------------------------------------------+
//|                                                  MyParabolic.mq4 |
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Blue

//指標バッファ
double BufSAR[];

//パラメーター
extern double Step = 0.02;
extern double Maximum = 0.2;

//+------------------------------------------------------------------+
//| 初期化関数                                                       |
//+------------------------------------------------------------------+
int init()
{
   //指標バッファの割り当て
   SetIndexBuffer(0,BufSAR);

   //指標ラベルの設定
   SetIndexLabel(0, "SAR("+DoubleToStr(Step,2)+","+DoubleToStr(Maximum,1)+")");

   //指標スタイルの設定
   SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,1,Blue);
   SetIndexArrow(0,159);

   return(0);
}
//+------------------------------------------------------------------+
//| 指標処理関数                                                     |
//+------------------------------------------------------------------+
int start()
{
   int last_period=1;    //最高値・最安値を求める期間
   bool dir_long = true; //モード
   double step=Step;     //ステップ幅
   double Ep0;           //現在の最高値・最安値     
   double Ep1;           //1バー前の最高値・最安値     

   int limit=Bars;
   BufSAR[limit-1] = Low[limit-1];

   for(int i=limit-2; i>=0; i--)
   {
      if(dir_long == true) //上昇モード
      {
         Ep1 = High[iHighest(NULL,0,MODE_HIGH,last_period,i+1)]; //1バー前の最高値
         BufSAR[i] = BufSAR[i+1]+step*(Ep1-BufSAR[i+1]); //SARの計算式
         Ep0 = MathMax(Ep1, High[i]);  //現在の最高値
         if(Ep0 > Ep1 && step+Step <= Maximum) step += Step; //ステップ幅の更新
         if(BufSAR[i] > Low[i]) //モードの切り替え
         {
            dir_long = false;
            BufSAR[i] = Ep0;
            last_period=1;
            step=Step;
            continue;
         }
      }
      else //下降モード
      {
         Ep1 = Low[iLowest(NULL,0,MODE_LOW,last_period,i+1)]; //1バー前の最安値
         BufSAR[i] = BufSAR[i+1]+step*(Ep1-BufSAR[i+1]); //SARの計算式
         Ep0 = MathMin(Ep1, Low[i]); //現在の最安値
         if(Ep0 < Ep1 && step+Step <= Maximum) step += Step; //ステップ幅の更新
         if(BufSAR[i] < High[i]) //モードの切り替え
         {
            dir_long = true;
            BufSAR[i] = Ep0;
            last_period=1;
            step=Step;
            continue;
         }
      }
      last_period++;      
   }

   return(0);
}
//+------------------------------------------------------------------+