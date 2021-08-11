//+------------------------------------------------------------------+
//|                                          MedianMovingAverage.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#include <Custom/MedianFilter.mqh>

//インジケータの描画データを格納するバッファの数を予約
#property indicator_buffers 3

//チャート上に描画する指標の数を予約
#property indicator_plots 1

//移動平均
#property   indicator_label1 "Average"
#property   indicator_type1 DRAW_LINE
#property   indicator_color1 clrAqua
#property   indicator_width1 2
#property   indicator_style1 STYLE_SOLID

#property   indicator_type2 DRAW_NONE
#property   indicator_type3 DRAW_NONE

//入力パラメーター
input int FilterLength = 3;       //メディアンフィルター長
input int AveragePeriod = 5;      //移動平均の計算期間
input int MaShift = 0;            //移動平均の表示移動
input ENUM_MA_METHOD Mamethod;    //移動平均の種別
input ENUM_APPLIED_PRICE MaPrice; //移動平均の適用価格

//インジケーターバッファ
double avgBuffer[];
double baseValues[];
double medianBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
    // メディアンフィルタ長は奇数の必要がある。
    if( FilterLength % 2 == 0 || FilterLength < 3 )
    {
        return(INIT_PARAMETERS_INCORRECT);
    }

    //インジケーターバッファを初期化する。
    SetIndexBuffer(0,avgBuffer);
    SetIndexBuffer(1,baseValues);
    SetIndexBuffer(2,medianBuffer);

    return(INIT_SUCCEEDED);

  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,      //各レート要素数
                const int prev_calculated,  //計算済み要素数
                const datetime &time[],     //要素ごとの時間配列
                const double &open[],       //オープン価格配列
                const double &high[],       //高値配列
                const double &low[],        //安値配列
                const double &close[],      //クローズ価格配列
                const long &tick_volume[],  //ティック数（要素の更新回数）
                const long &volume[],       //実ボリューム（？）
                const int &spread[])        //スプレット
{

   //-----（１）元となる値を計算。
   for (int i = 0; i < rates_total - prev_calculated; i++){
        switch (MaPrice) {
            case PRICE_OPEN:
                baseValues[i] = open[i];
                break;
            case PRICE_HIGH:
                baseValues[i] = high[i];
                break;
            case PRICE_LOW:
                baseValues[i] = low[i];
                break;
            case PRICE_CLOSE:
                baseValues[i] = close[i];
                break;
            case PRICE_MEDIAN:
                baseValues[i] = (high[i] + low[i])/2;
                break;
            case PRICE_TYPICAL:
                baseValues[i] = (high[i] + low[i] + close[i])/3;
                break;
            case PRICE_WEIGHTED:
                baseValues[i] = (high[i] + low[i] + close[i] + close[i])/4;
                break;
            default:
                baseValues[i] = close[i];
                break;
        }

    }
    //-----（２）[要素数-処理済み要素数-1]～0のデータを更新
    //

   return(rates_total);
}
//+------------------------------------------------------------------+
