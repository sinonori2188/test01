//+------------------------------------------------------------------+
//|                                               BarAverageLine.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//|【概要】平均足とメディアンフィルタを描画
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//#property indicator_separate_window
#property indicator_chart_window

//バッファ数の指定
#property indicator_buffers 2

//プロット情報を記述
//メディアンライン
#property indicator_label1  "RED:Median"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

//移動平均
#property indicator_label2  "AQA:Average"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrAqua
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2

//入力パラメーター
input int FilterLength = 3;     // メディアンフィルター長
input bool IsShowAvg = True;    // 移動平均足を表示するか

//インジケーター バッファ
double    MedianBuffer[]; 
double    AverageBuffer[]; 

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   // メディアンフィルタ長は奇数の必要がある。
   if (FilterLength % 2 == 0) {
        return(INIT_PARAMETERS_INCORRECT);
   }

   // - indicator buffers mapping
   // インジケーターバッファの初期化
   //（第1引数にバッファのインデックス、第2引数に変数として宣言した配列名を指定）
   SetIndexBuffer(0,MedianBuffer);
   SetIndexBuffer(1,AverageBuffer);
 
   // IsShowAvg == falseの場合は、移動平均をグラフ上に表示しない
   if ( !IsShowAvg ) {
        SetIndexStyle(1,DRAW_NONE);
   }

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
    // 0が最新（チャートでいう一番右端のデータ）
    for (int i = 0 ; i < (rates_total - prev_calculated); i++){
        AverageBuffer[i] = iMA(Symbol(),PERIOD_CURRENT,FilterLength,0,MODE_SMA,PRICE_CLOSE,i);
        MedianBuffer[i] = GetMedianValue(close,rates_total,FilterLength,i);
    }
   
    // --- return value of prev_calculated for next call
    //中央値インデックスを計算
    int halfIndex = (FilterLength - (FilterLength % 2)) / 2;
    return(rates_total - 1 - halfIndex);
}

//+------------------------------------------------------------------+
//| メディアンフィルター適用後の値を取得する。
//+------------------------------------------------------------------+
double GetMedianValue(const double &targetValues[], //メディアンフィルタを計算する元配列
                      int valuesCount,              //targetValuesの要素数
                      int filterLength,             //メディアンフィルタ長
                      int targetIndex)              //メディアンフィルタ値取得の対象インデックス
{
    //ソート用領域を確保
    double workValues[];
    ArrayResize(workValues, filterLength);
    
    //中央値インデックスを計算
    int halfIndex = (filterLength - (filterLength % 2)) / 2;

    int setIndex = 0 ;
    // targetIndexを中央値として前後filterLength/2（小数点切り捨て）分だけ取得する。
    for( int i = targetIndex - halfIndex; i <= targetIndex + halfIndex; i++ )
    {
        // データ端対策
        int valueIndex = i ;
        if( i < 0 ) valueIndex = 0;
        if( i >= valuesCount ) valueIndex = valuesCount - 1;

        workValues[setIndex] = targetValues[valueIndex];
        setIndex++;
    }

    //データをソートして、ソート結果の中央値を取得する。
    ArraySort(workValues);
    double returnValue = workValues[halfIndex];

    //領域解放
    ArrayFree(workValues);

    return returnValue;
}


