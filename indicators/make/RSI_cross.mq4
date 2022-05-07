//+------------------------------------------------------------------+
//|                                                    RSI_cross.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property strict

#property indicator_chart_window             // 指標をメインウインドウに表示する
//#property indicator_separate_window        // カスタムインジケータをサブウインドウに表示する　※指標は表示されない。

// 引数
input int RSI_Period_Short = 14;             // 短期RSI計算期間
input int RSI_Period_Long  = 32;             // 長期RSI計算期間

// インジケータプロパティ設定
#property  indicator_buffers 4               // カスタムインジケータのバッファ数

// 矢印マーク
#property indicator_width1     5             // 太さ
#property indicator_color1     Blue          // 色
#property indicator_style1     STYLE_SOLID   // 描画スタイル
#property indicator_type1      DRAW_ARROW    // 描画タイプ
#property indicator_width2     5             // 太さ
#property indicator_color2     Red           // 色
#property indicator_style2     STYLE_SOLID   // 描画スタイル
#property indicator_type2      DRAW_ARROW    // 描画タイプ
// RSIインジゲーター
#property indicator_color3     clrRed        // 短期RSIインジケータの色
#property indicator_type3      DRAW_LINE     // 短期RSIインジケータの描画タイプ
#property indicator_style3     STYLE_SOLID   // 短期RSIインジケータの描画スタイル
#property indicator_color4     clrBlue       // 長期RSIインジケータの色
#property indicator_type4      DRAW_LINE     // 長期RSIインジケータの描画タイプ
#property indicator_style4     STYLE_DASH    // 長期RSIインジケータの描画スタイル

// RSIを表示するサブウィンドウのレベル内容
#property indicator_minimum    0             // サブウインドウスケール下限値設定
#property indicator_maximum    100           // サブウインドウスケール上限値設定
#property indicator_level1     20.0          // レベルライン1
#property indicator_level2     80.0          // レベルライン2
#property indicator_levelcolor clrGray       // レベルラインの色
#property indicator_levelstyle STYLE_DOT     // レベルラインの種類
#property indicator_levelwidth 1             // レベルラインの太さ


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
   // インジゲータースタイルの設定
   SetIndexBuffer( 0, Arrow_Buffer_Up );   // 上矢印インジケータ表示用動的配列をインジケータ1にバインドする
   SetIndexArrow( 0, SYMBOL_ARROWUP);      // 上矢印(241)
   SetIndexBuffer( 1, Arrow_Buffer_Down ); // 下矢印インジケータ表示用動的配列をインジケータ2にバインドする
   SetIndexArrow( 1, SYMBOL_ARROWDOWN);    // 下矢印(242)
   SetIndexBuffer( 2, RSI_Buffer_Short );  // 短期RSIインジケータ表示用動的配列をインジケータ3にバインドする
   SetIndexBuffer( 3, RSI_Buffer_Long );   // 長期RSIインジケータ表示用動的配列をインジケータ4にバインドする

   //指標ラベルの設定
   SetIndexLabel(0,"Arrow_Buffer_Up");
   SetIndexLabel(1,"Arrow_Buffer_Down");
   SetIndexLabel(2,"RSI_Buffer_Short("+RSI_Period_Short+")");
   SetIndexLabel(3,"RSI_Buffer_Long("+RSI_Period_Long+")");

   //戻り値
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
   int limit = Bars - prev_calculated-1;       // バー数取得(未計算分)

   for( int icount = limit ; icount >=0; icount-- ) {

      // 短期RSIテクニカルインジケータ算出
      double  RSI_Short0 = iRSI(NULL,             // 通貨ペア
                                PERIOD_CURRENT,   // 時間軸(現在チャートの時間軸:0)
                                RSI_Period_Short, // 計算期間
                                PRICE_CLOSE,      // 適用価格
                                icount            // シフト
                                );
      RSI_Buffer_Short[icount] = RSI_Short0;      // インジケータに算出結果を設定
      double  RSI_Short1 = iRSI(NULL,             // 通貨ペア
                                PERIOD_CURRENT,   // 時間軸(現在チャートの時間軸:0)
                                RSI_Period_Short, // 計算期間
                                PRICE_CLOSE,      // 適用価格
                                icount+1          // シフト
                                );
      // 長期RSIテクニカルインジケータ算出
      double  RSI_Long0 = iRSI(NULL,              // 通貨ペア
                               PERIOD_CURRENT,    // 時間軸(現在チャートの時間軸:0)
                               RSI_Period_Long,   // 計算期間
                               PRICE_CLOSE,       // 適用価格
                               icount             // シフト
                               );
      RSI_Buffer_Long[icount] = RSI_Long0;        // インジケータに算出結果を設定
      double  RSI_Long1 = iRSI(NULL,              // 通貨ペア
                               PERIOD_CURRENT,    // 時間軸(現在チャートの時間軸:0)
                               RSI_Period_Long,   // 計算期間
                               PRICE_CLOSE,       // 適用価格
                               icount+1           // シフト
                               );

      //----- 短期RSIと長期RSIがクロスした時に矢印を出す -----//
      //ゴールデンクロスした時は上矢印を表示する
      if(RSI_Short1 < RSI_Long1 && RSI_Short0 >= RSI_Long0){
         Arrow_Buffer_Up[icount] = iLow(NULL,PERIOD_CURRENT,icount)-20*Point;
      }
      //デッドクロスした時は下矢印を表示する
      if(RSI_Short1 > RSI_Long1 && RSI_Short0 <= RSI_Long0){
         Arrow_Buffer_Down[icount] = iHigh(NULL,PERIOD_CURRENT,icount)+20*Point;
      }
   }
   return( rates_total ); // 戻り値設定：次回OnCalculate関数が呼ばれた時のprev_calculatedの値に渡される
}