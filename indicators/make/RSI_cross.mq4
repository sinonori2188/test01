//+------------------------------------------------------------------+
//|                                                    RSI_cross.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property strict
#property indicator_separate_window          // カスタムインジケータをサブウインドウに表示する

// 引数
input int RSI_Period1 = 14;  // RSI計算期間_1
input int RSI_Period2 = 32;  // RSI計算期間_2

// インジケータプロパティ設定
#property  indicator_buffers    4            // カスタムインジケータのバッファ数

// 矢印マーク
#property indicator_width1 3
#property indicator_color1 Red
#property indicator_width2 3
#property indicator_color2 White

#property  indicator_color1     clrRed       // インジケータ1の色
#property  indicator_type1      DRAW_LINE    // インジケータ1の描画タイプ
#property  indicator_style1     STYLE_SOLID  // インジケータ1の描画スタイル

#property  indicator_color2     clrBlue      // インジケータ2の色
#property  indicator_type2      DRAW_LINE    // インジケータ2の描画タイプ
#property  indicator_style2     STYLE_DASH   // インジケータ2の描画スタイル

// サブウィンドウ内容
#property indicator_level1     20.0
#property indicator_level2     80.0
#property indicator_minimum    0
#property indicator_maximum    100

// インジケータ表示用動的配列
double     _IndBuffer1[];                    // インジケータ1表示用動的配列
double     _IndBuffer2[];                    // インジケータ2表示用動的配列

//+------------------------------------------------------------------+
//| OnInit(初期化)イベント
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer( 0, _IndBuffer1 );     // インジケータ1表示用動的配列をインジケータ1にバインドする
   SetIndexBuffer( 1, _IndBuffer2 );     // インジケータ1表示用動的配列をインジケータ2にバインドする
   return( INIT_SUCCEEDED );             // 戻り値：初期化成功
}

//+------------------------------------------------------------------+
//| OnCalculate(tick受信)イベント
//| カスタムインジケータ専用のイベント関数
//+------------------------------------------------------------------+
int OnCalculate(const int      rates_total,      // 入力された時系列のバー数
                const int      prev_calculated,  // 計算済み(前回呼び出し時)のバー数
                const datetime &time[],          // 時間
                const double   &open[],          // 始値
                const double   &high[],          // 高値
                const double   &low[],           // 安値
                const double   &close[],         // 終値
                const long     &tick_volume[],   // Tick出来高
                const long     &volume[],        // Real出来高
                const int      &spread[])        // スプレッド
{
    int end_index = Bars - prev_calculated;      // バー数取得(未計算分)
    double diff_RSI=0;

    for( int icount = 0 ; icount < end_index ; icount++ ) {

        // テクニカルインジケータ算出１
        double result1 = iRSI(NULL,           // 通貨ペア
                              0,              // 時間軸
                              RSI_Period1,    // 平均期間
                              PRICE_CLOSE,    // 適用価格
                              icount // シフト
                              ); 
       _IndBuffer1[icount] = result1;   // インジケータ1に算出結果を設定

        // テクニカルインジケータ算出２
        double result2 = iRSI(NULL,           // 通貨ペア
                              0,              // 時間軸
                              RSI_Period2,    // 平均期間
                              PRICE_CLOSE,    // 適用価格
                              icount // シフト
                              ); 
       _IndBuffer2[icount] = result2;   // インジケータ1に算出結果を設定

      diff_RSI = result1 - result2; // RSI

    }

   return( rates_total ); // 戻り値設定：次回OnCalculate関数が呼ばれた時のprev_calculatedの値に渡される
}