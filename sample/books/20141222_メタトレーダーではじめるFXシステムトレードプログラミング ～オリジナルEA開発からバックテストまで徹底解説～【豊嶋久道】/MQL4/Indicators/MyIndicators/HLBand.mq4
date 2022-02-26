//HLBand カスタム指標プログラム
#property copyright "Copyright (c) 2014, Toyolab FX"
#property link      "http://forex.toyolab.com/"

//プリプロセッサ命令
#property indicator_chart_window      //チャートウィンドウに表示
#property indicator_buffers 2         //指標バッファの数
#property indicator_plots   2         //プロットする指標の数
#property indicator_type1   DRAW_LINE //指標０の種類：実線
#property indicator_type2   DRAW_LINE //指標１の種類：実線
#property indicator_color1  clrBlue   //指標０の色：Blue
#property indicator_color2  clrRed    //指標１の色：Red

#include <MyLib\LibMQL4.mqh> //MQL5用のMQL4ライブラリ関数

//指標バッファ
double BufHigh[]; //上位ライン
double BufLow[];  //下位ライン

//外部パラメータ
input int BandPeriod = 20; //期間

//初期化関数
void OnInit()
{
   SetIndexBuffer(0, BufHigh, INDICATOR_DATA); //指標０の割り当て
   SetIndexBuffer(1, BufLow, INDICATOR_DATA);  //指標１の割り当て
   ArraySetAsSeries(BufHigh, true); //BufHigh[]を時系列配列に
   ArraySetAsSeries(BufLow, true);  //BufLow[]を時系列配列に
}

//指標計算関数
int OnCalculate(const int rates_total,     //バーの総数
                const int prev_calculated, //計算済みのバーの数
                const datetime &time[],    //バーの開始時刻の配列
                const double &open[],      //バーの始値の配列
                const double &high[],      //バーの高値の配列
                const double &low[],       //バーの安値の配列
                const double &close[],     //バーの終値の配列
                const long &tick_volume[], //バーのティック数の配列
                const long &volume[],      //バーの出来高の配列
                const int &spread[])       //バーのスプレッドの配列
{
   ArraySetAsSeries(close, true); //close[]を時系列配列に

   //指標を表示する先頭の位置
   int limit = rates_total - prev_calculated;
   //指標の表示開始位置の補正  
   if(prev_calculated == 0) limit -= BandPeriod;

   for(int i=limit; i>=0; i--) //指標の表示の繰り返し
   {
      //上位ラインの算出
      BufHigh[i] = close[iHighest(_Symbol, 0, MODE_CLOSE, BandPeriod, i)];
      //下位ラインの算出
      BufLow[i] = close[iLowest(_Symbol, 0, MODE_CLOSE, BandPeriod, i)];
   }

   return rates_total;
}
