//+------------------------------------------------------------------+
//|                                               BarAverageLine.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//|【概要】時間足の平均値を描画するサンプル
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict     //基本記載しておけば間違いない
//#property indicator_separate_window

//バッファ数の指定（C言語でいうところの配列を１個使用するという宣言）
#property indicator_buffers 1

//プロット情報を記述
#property indicator_label1  "Center"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

//インジケーター バッファ（インジケーター用のバッファをグローバル変数として宣言）
double    centerBuffer[]; 

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
  
   // - indicator buffers mapping
   // インジケーターバッファの初期化
   //（第1引数にバッファのインデックス、第2引数に変数として宣言した配列名を指定）
   SetIndexBuffer(0,centerBuffer);

   // 戻り値の種類一覧候補
   // ・INIT_SUCCEEDED：成功(0)
   // ・INIT_FAILED：初期化失敗
   // ・INIT_PARAMETERS_INCORRECT：パラメータ異常
   // ・INIT_AGENT_NOT_SUITABLE：動作環境が適していない。メモリが足りない。
   return(INIT_SUCCEEDED);

  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,          //各レート要素数
                const int prev_calculated,      //計算済み要素数
                const datetime &time[],         //要素ごとの時間配列
                const double &open[],           //オープン価格配列
                const double &high[],           //高値配列
                const double &low[],            //安値配列
                const double &close[],          //クローズ価格配列
                const long &tick_volume[],      //ティック数（要素の更新回数）
                const long &volume[],           //実ボリューム（？）
                const int &spread[])            //スプレット
{
    //【説明】
    // 0が最新（チャートでいう一番右端のデータ）
    // 未処理である最新のデータだけを更新したい場合、0からrates_total-prev_calculated-1のインデックスまで配列を更新
    for (int i = 0 ; i < (rates_total - prev_calculated); i++){
        centerBuffer[i] = (low[i] + high[i])/2;
    }
   
    // --- return value of prev_calculated for next call
    // 戻り値は、OnCalculateで処理した要素数を指定する。
    // この値は、次回OnCalculateが呼び出される際に、prev_calculatedへ設定される。
    // OnCalculateはチャートのtick値が更新されるたびに呼び出されるので、
    // そのたびに最新バー値を更新するため、rates_total-1に指定する。
    //return(rates_total);
    return(rates_total - 1);
}
//+------------------------------------------------------------------+
