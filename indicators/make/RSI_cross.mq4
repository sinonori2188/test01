//+------------------------------------------------------------------+
//|                                                    RSI_cross.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property strict
#property indicator_separate_window          // カスタムインジケータをサブウインドウに表示する

// 引数
input int RSI_Period_Short = 14; // 短期RSI計算期間
input int RSI_Period_Long = 32;  // 長期RSI計算期間

// インジケータプロパティ設定
#property  indicator_buffers 4   // カスタムインジケータのバッファ数

// 矢印マーク
#property indicator_width1 3
#property indicator_color1 Red
#property indicator_style1 DRAW_ARROW
#property indicator_width2 3
#property indicator_color2 White
#property indicator_style2 DRAW_ARROW

// RSIインジゲーター
#property  indicator_color3     clrRed       // 短期RSIインジケータの色
#property  indicator_type3      DRAW_LINE    // 短期RSIインジケータの描画タイプ
#property  indicator_style3     STYLE_SOLID  // 短期RSIインジケータの描画スタイル
#property  indicator_color4     clrBlue      // 長期RSIインジケータの色
#property  indicator_type4      DRAW_LINE    // 長期RSIインジケータの描画タイプ
#property  indicator_style4     STYLE_DASH   // 長期RSIインジケータの描画スタイル

// RSIを表示するサブウィンドウ内容
#property indicator_level1     20.0
#property indicator_level2     80.0
#property indicator_minimum    0
#property indicator_maximum    100

// インジケータ表示用動的配列
double Arrow_Buffer_Up[];    // 上矢印インジケータ表示用動的配列
double Arrow_Buffer_Down[];  // 下矢印インジケータ表示用動的配列
double RSI_Buffer_Short[];   // 短期RSIインジケータ表示用動的配列
double RSI_Buffer_Long[];    // 長期RSIインジケータ表示用動的配列

//+------------------------------------------------------------------+
//| OnInit(初期化)イベント
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer( 0, Arrow_Buffer_Up );   // 上矢印インジケータ表示用動的配列をインジケータ1にバインドする
   SetIndexArrow( 0, 241);                 // 上矢印
   SetIndexBuffer( 1, Arrow_Buffer_Down ); // 下矢印インジケータ表示用動的配列をインジケータ2にバインドする
   SetIndexArrow( 1, 242);                 // 下矢印
   SetIndexBuffer( 2, RSI_Buffer_Short );  // 短期RSIインジケータ表示用動的配列をインジケータ3にバインドする
   SetIndexBuffer( 3, RSI_Buffer_Long );   // 長期RSIインジケータ表示用動的配列をインジケータ4にバインドする
   return( INIT_SUCCEEDED );               // 戻り値：初期化成功
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

      // 短期RSIテクニカルインジケータ算出
      double result1 = iRSI(NULL,             // 通貨ペア
                            0,                // 時間軸
                            RSI_Period_Short, // 計算期間
                            PRICE_CLOSE,      // 適用価格
                            icount            // シフト
                            ); 
      RSI_Buffer_Short[icount] = result1;     // インジケータに算出結果を設定

      // 長期RSIテクニカルインジケータ算出
      double result2 = iRSI(NULL,            // 通貨ペア
                            0,               // 時間軸
                            RSI_Period_Long, // 計算期間
                            PRICE_CLOSE,     // 適用価格
                            icount           // シフト
                            ); 
      RSI_Buffer_Long[icount] = result2;     // インジケータに算出結果を設定

      // 矢印を設定
      diff_RSI = result1 - result2;          // RSI

      Arrow_Buffer_Up[icount] = iLow(NULL,0,icount)-20*Point;

      Arrow_Buffer_Down[icount] = iHigh(NULL,0,icount)+20*Point
   }

   return( rates_total ); // 戻り値設定：次回OnCalculate関数が呼ばれた時のprev_calculatedの値に渡される
}