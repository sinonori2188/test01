//+------------------------------------------------------------------+
//|                                                         GMMA.mq4 |
//|                                       Copyright(C) 2015, PeakyFx |
//|                                      http://peakyfx.blogspot.jp/ |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2018 ands"  // 作成者(著作者)の名前
#property link        ""                     // 作成者のwebサイトへのリンク
#property version     "1.00"                 // プログラムのバージョン(上限31文字)
#property description ""                     // プログラムの簡単な説明文(上限511文字)
#property strict                             // 厳格なコンパイルモード用のコンパイラ指令

//---- indicator settings
#property indicator_chart_window  // カスタムインジケータをチャートウインドウに表示
#property indicator_buffers 12    // インジケータ計算と表示用のバッファ数(範囲:1～512)
#property indicator_plots 12

//---- input parameters 
extern ENUM_MA_METHOD     extMethod       = MODE_EMA;
extern ENUM_APPLIED_PRICE extAppliedPrice = PRICE_CLOSE;
extern color extFastMAColor1 = clrYellow;
extern color extFastMAColor2 = clrYellow;
extern color extSlowMAColor1 = clrPink;
extern color extSlowMAColor2 = clrPink;

//---- indicator buffers
double Ma3[],  Ma5[],  Ma8[],  Ma10[], Ma12[], Ma15[];
double Ma30[], Ma35[], Ma40[], Ma45[], Ma50[], Ma60[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    //--- indicator buffers mapping
    int index = 0;
    SetMaBuffer(index++, Ma3,   3, extFastMAColor1);
    SetMaBuffer(index++, Ma5,   5, extFastMAColor1);
    SetMaBuffer(index++, Ma8,   8, extFastMAColor1);
    SetMaBuffer(index++, Ma10, 10, extFastMAColor2);
    SetMaBuffer(index++, Ma12, 12, extFastMAColor2);
    SetMaBuffer(index++, Ma15, 15, extFastMAColor2);
    SetMaBuffer(index++, Ma30, 30, extSlowMAColor1);
    SetMaBuffer(index++, Ma35, 35, extSlowMAColor1);
    SetMaBuffer(index++, Ma40, 40, extSlowMAColor1);
    SetMaBuffer(index++, Ma45, 45, extSlowMAColor2);
    SetMaBuffer(index++, Ma50, 50, extSlowMAColor2);
    SetMaBuffer(index++, Ma60, 60, extSlowMAColor2);

    //---- name for DataWindow and indicator subwindow label
    // カスタムインジケータの短縮名は、データウインドウとチャートサブウインドウの左上に表示される
    IndicatorShortName("GMMA(3,5,8,10,12,15/30,35,40,45,50,60)");

    //---- initialization done
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| SetMaBuffer function                                             |
//+------------------------------------------------------------------+
void SetMaBuffer(int index, 
                 double &buffer[],
                 int period,
                 color clr)
{
    //double型の1次元配列データをインジケータバッファにバインド
    SetIndexBuffer(index, buffer);
    //インジケータライン用に、新しいタイプ・スタイル・幅・色を設定
    SetIndexStyle(index, DRAW_LINE, STYLE_SOLID, 1, clr);
    //データウインドウとツールチップで表示する描画ラインラベルを設定
    SetIndexLabel(index, StringFormat("MA(%d)", period));
    //インジケータライン描画開始し始めるバー番号を設定
    SetIndexDrawBegin(index, period);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int      rates_total,      // チャートのバー数(最初は画面バー総数、バーが増えると要素が+1)
                const int      prev_calculated,  // 前回呼び出し時の計算済みバー数(最初は0、計算し終えるとrates_totalと同じ)
                const datetime &time[],          // 時間 ※要素0は最新でチャート上は右端、バーが増えると要素が+1シフト)
                const double   &open[],          // 始値
                const double   &high[],          // 高値
                const double   &low[],           // 安値
                const double   &close[],         // 終値
                const long     &tick_volume[],   // Tick出来高 (Tickの更新回数)
                const long     &volume[],        // Real出来高 (FXでは未使用)
                const int      &spread[])        // スプレッド (MT4では未使用)
{
    int limit = rates_total - MathMax(prev_calculated, 1);

    for (int i = limit; i >= 0; i--)
    {
        Ma3[i]  = iMA(NULL,             // 通貨ペア(NULLは現在の通貨ぺア))
                      0,                // 時間軸(0は現在の時間軸)
                      3,                // MAの平均期間
                      0,                // MAシフト、指定した時間軸のバー数でオフセット。
                      extMethod,        // MAの平均化メソッド
                      extAppliedPrice,  // 適用価格
                      i);               // 現在バーを基準にして、指定した時間軸のバー数分を過去方向へシフト
        Ma5[i]  = iMA(NULL, 0,   5, 0, extMethod, extAppliedPrice, i);
        Ma8[i]  = iMA(NULL, 0,   8, 0, extMethod, extAppliedPrice, i);
        Ma10[i] = iMA(NULL, 0,  10, 0, extMethod, extAppliedPrice, i);
        Ma12[i] = iMA(NULL, 0,  12, 0, extMethod, extAppliedPrice, i);
        Ma15[i] = iMA(NULL, 0,  15, 0, extMethod, extAppliedPrice, i);

        Ma30[i] = iMA(NULL, 0,  30, 0, extMethod, extAppliedPrice, i);
        Ma35[i] = iMA(NULL, 0,  35, 0, extMethod, extAppliedPrice, i);
        Ma40[i] = iMA(NULL, 0,  40, 0, extMethod, extAppliedPrice, i);
        Ma45[i] = iMA(NULL, 0,  45, 0, extMethod, extAppliedPrice, i);
        Ma50[i] = iMA(NULL, 0,  50, 0, extMethod, extAppliedPrice, i);
        Ma60[i] = iMA(NULL, 0,  60, 0, extMethod, extAppliedPrice, i);
    }

    //--- return value of prev_calculated for next call
    return(rates_total);
}
