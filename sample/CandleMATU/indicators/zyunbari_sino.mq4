//+------------------------------------------------------------------+
//|                                                   zyunbari02.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ands"
#property link      ""
#property version   "1.00"

#property strict                 //厳密モード
#property indicator_chart_window //チャート表示
#property indicator_buffers 4    //バッファ数4(使用する矢印の数)

#property indicator_width1 3
#property indicator_color1 Orange
#property indicator_width2 3
#property indicator_color2 Aqua
#property indicator_width3 3
#property indicator_color3 White
#property indicator_width4 3
#property indicator_color4 White

double buf0_SymbolArrowUp[];
double buf1_SymbolArrowDown[];
double buf2_SymbolArrow161[];
double buf3_SymbolStopSign[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function(ロードした時のイベント) |
//+------------------------------------------------------------------+
int OnInit()
{
  
   IndicatorBuffers(4);//使用する矢印の数
   
   SetIndexBuffer(0,buf0_SymbolArrowUp);  //ボリバン上ラインタッチかつRSI60以上
   SetIndexStyle(0,DRAW_ARROW);           //矢印描画
   SetIndexArrow(0,SYMBOL_ARROWUP);       //上矢印(SYMBOL_ARROWUP(241):矢印アップ)
     
   SetIndexBuffer(1,buf1_SymbolArrowDown);//ボリバン下ラインタッチかつRSI40以下
   SetIndexStyle(1,DRAW_ARROW);           //矢印描画
   SetIndexArrow(1,SYMBOL_ARROWDOWN);     //下矢印(SYMBOL_ARROWDOWN(242):矢印ダウン)

   SetIndexBuffer(2,buf2_SymbolArrow161); //次足で順張り方向に動いていたら〇
   SetIndexStyle(2,DRAW_ARROW);           //矢印描画
   SetIndexArrow(2,161);                  //丸(SYMBOL_MARU?(161):丸サイン)　
     
   SetIndexBuffer(3,buf3_SymbolStopSign); //次足で反発したら×
   SetIndexStyle(3,DRAW_ARROW);           //矢印を描画
   SetIndexArrow(3,SYMBOL_STOPSIGN);      //バツ(SYMBOL_STOPSIGN(251):ストップサイン)

   return(INIT_SUCCEEDED);

}

//「パラメーターの入力」で外部から変更したいパラメーター
extern int     extLabelSize = 10;         //勝率ラベル大きさ
extern int     extOutcomeBars = 1;        //判定本数
extern double  extSignDispPips = 2;       //サイン表示位置調整
extern int     extMaxCalcBars = 500000;   //対象本数範囲

extern string  Note1="";                  //インジケーター設定
extern int     extBandPeriod = 20;        //ボリバン期間
extern double  extBandSigma = 2.0;        //σ
extern int     extUpperLimit60 = 60;      //上ライン
extern int     extUpperLimit70 = 70;      //ハイエントリー終了ライン
extern int     extLowerLimit40 = 40;      //下ライン
extern int     extLowerLimit30 = 30;      //ローエントリー終了ライン
extern int     extRsiPeriod = 9;          //RSI期間

int cntHighSignal, cntLowSignal, cntHighOutcome, cntLowOutcome, tmpOutcomeBars = 0;
bool flgHighSignal, flgLowSignal, flgHighEntry, flgLowEntry = false;
double priceHighEntry, priceLowEntry;  //ハイエントリー、ローエントリー時の価格保存
double qtyWinDealings, qtyLoseDealings, qtyTotalDealings, perWin; //勝率ラベル表示用


//+------------------------------------------------------------------+
//| Custom indicator iteration function(tick受信イベント)             |
//+------------------------------------------------------------------+
int OnCalculate(const int        rates_total,      //入力された時系列のバー数
                const int        prev_calculated,  //計算済み(前回呼び出し時)のバー数
                const datetime   &time[],          //時間
                const double     &open[],          //始値
                const double     &high[],          //高値
                const double     &low[],           //安値
                const double     &close[],         //終値
                const long       &tick_volume[],   //Tick出来高
                const long       &volume[],        //Real出来高
                const int        &spread[])        //スプレッド
{

   //全バー本数から、確定したバーのうち計算済みバーの総数を差し引いて、最新バー(カレントバー)も差し引く
   int qtyLimit = Bars - IndicatorCounted()-1;
   qtyLimit = MathMin(qtyLimit, extMaxCalcBars);


   //【TickイベントでForループ】確定バーのうち未計算バー処理　⇒　初回起動時か新規確定バーが出現した時に処理
   for(int i = qtyLimit; i > 0; i--){

      /*-----------------------------------------*/
      // 勝敗判定＜2回目(次足判定)以降のForループで処理＞
      /*-----------------------------------------*/
      //上矢印の勝敗判定
      if(flgHighEntry == TRUE){
         if(cntHighSignal <= 1){
            tmpOutcomeBars = extOutcomeBars-1;
         }else{
            tmpOutcomeBars = extOutcomeBars;
         }
         if(cntHighOutcome == tmpOutcomeBars){
            if(priceHighEntry < iClose(NULL,0,i)){
               buf2_SymbolArrow161[i] = iLow(NULL,0,i)-5*Point;   //順行したため勝ち(○)を表示
               flgHighEntry = FALSE;
               qtyWinDealings++;
            }else{
               buf3_SymbolStopSign[i] = iLow(NULL,0,i)-5*Point;   //逆行したため負け(×)を表示
               flgHighEntry = FALSE;
               qtyLoseDealings++;
            }
            cntHighOutcome = 0;
         }
         cntHighOutcome++;
      }

      //下矢印の勝敗判定
      if(flgLowEntry == TRUE){
         if(cntLowSignal <= 1){
            tmpOutcomeBars = extOutcomeBars-1;
         }else{
            tmpOutcomeBars = extOutcomeBars;
         }
         if(cntLowOutcome == tmpOutcomeBars){        
            if(priceLowEntry > iClose(NULL,0,i)){
               buf2_SymbolArrow161[i] = iHigh(NULL,0,i)+5*Point;   //順行したため勝ち(○)を表示
               flgLowEntry = FALSE;
               qtyWinDealings++;
            }else{
               buf3_SymbolStopSign[i] = iHigh(NULL,0,i)+5*Point;   //逆行したため負け(×)を表示
               flgLowEntry = FALSE;
               qtyLoseDealings++;
            }
            cntLowOutcome = 0;
         }
         cntLowOutcome++;
      }


      /*-----------------------------*/
      // iCustum関数
      /*-----------------------------*/
      //最新のRSI値
      double rsiShift0=iRSI(NULL,                  //通貨ペア(NULL(0):現在の通貨ぺア)
                            PERIOD_CURRENT,        //時間軸(PERIOD_CURRENT(0):現在チャートの時間軸)
                            extRsiPeriod,          //平均期間(extRsiPeriod(9):外部変数)
                            PRICE_CLOSE,           //適用価格(PRICE_CLOSE(0):終値)
                            i);                    //シフト(現在バーを基準にして、指定した時間軸のバー数分を過去方向へシフト)
      
      //1本前のRSI値
      double rsiShift1=iRSI(NULL,                   //通貨ペア(NULL(0):現在の通貨ぺア)
                            PERIOD_CURRENT,         //時間軸(PERIOD_CURRENT(0):現在チャートの時間軸)
                            extRsiPeriod,           //平均期間(extRsiPeriod(9):外部変数)
                            PRICE_CLOSE,            //適用価格(PRICE_CLOSE(0):終値)
                            i+1);                   //シフト(現在バーを基準にして、指定した時間軸のバー数分を過去方向へシフト)
      
      //上バンド
      double bandsUpperLine = iBands(NULL,          //通貨ペア(NULL(0):現在の通貨ぺア)
                                     PERIOD_CURRENT,//時間軸(PERIOD_CURRENT(0):現在チャートの時間軸)
                                     extBandPeriod, //平均期間(extBandPeriod(20):外部変数)
                                     extBandSigma,  //標準偏差(extBandSigma(2.0σ):外部変数)
                                     0,             //バンドシフト
                                     PRICE_CLOSE,   //適用価格(PRICE_CLOSE(0):終値)
                                     MODE_UPPER,    //ラインインデックス(MODE_UPPER(1):上のライン)
                                     i);            //シフト(現在バーを基準にして、指定した時間軸のバー数分を過去方向へシフト)
      //下バンド
      double bandsLowerLine = iBands(NULL,          //通貨ペア(NULL(0):現在の通貨ぺア)
                                     PERIOD_CURRENT,//時間軸(PERIOD_CURRENT(0):現在チャートの時間軸)
                                     extBandPeriod, //平均期間(extBandPeriod(20):外部変数)
                                     extBandSigma,  //標準偏差(extBandSigma(2.0σ):外部変数)
                                     0,             //バンドシフト
                                     PRICE_CLOSE,   //適用価格(PRICE_CLOSE(0):終値)
                                     MODE_LOWER,    //ラインインデックス(MODE_UPPER(2):下のライン
                                     i);            //シフト(現在バーを基準にして、指定した時間軸のバー数分を過去方向へシフト)


      /*----------------*/
      // 上矢印の条件判定
      /*----------------*/
      //RSI60未満でfalse
      if(rsiShift0<extUpperLimit60) flgHighSignal=FALSE;
      
      //ボリバン上タッチかつRSI60以上でtrue
      if(bandsUpperLine<=iHigh(NULL,PERIOD_CURRENT,i) &&
         rsiShift0>=extUpperLimit60) flgHighSignal=TRUE;

      //RSIが70超過から70以下になったらfalse
      if(rsiShift1>extUpperLimit70 &&
         rsiShift0<=extUpperLimit70) flgHighSignal=FALSE;

      //flgHighSignalがtrueの時
      if(flgHighSignal==TRUE ){
         buf0_SymbolArrowUp[i] = iLow(NULL,0,i)-5*extSignDispPips*Point;   //上矢印を安値の下に出す
         flgHighEntry = TRUE;                //エントリー時にflagをtrueにし、判定コードを通るようにする
         priceHighEntry = iClose(NULL,0,i);  //エントリー時の価格を判定用に保存(現通貨、現時間足、シフト0)
         cntHighSignal++;                    //サインが出た数をカウント
      }

      /*----------------*/
      // 下矢印の条件判定
      /*----------------*/
      //RSI40を超過した時falseに
      if(rsiShift0>extLowerLimit40) flgLowSignal=FALSE;
      
      //ボリバン下タッチかつRSI40以下でtrue
      if(bandsLowerLine>=iLow(NULL,PERIOD_CURRENT,i) &&
         rsiShift0<=extLowerLimit40) flgLowSignal=TRUE;
      
      //RSIが30未満から30以上になったらfalse
      if(rsiShift1<extLowerLimit30 && 
         rsiShift0>=extLowerLimit30) flgLowSignal=FALSE;

      //flgLowSignalがtrueの時
      if(flgLowSignal==TRUE){
         buf1_SymbolArrowDown[i] = iHigh(NULL,0,i)+10*extSignDispPips*Point; //下矢印を高値の上に出す
         flgLowEntry = TRUE;                 //エントリー時にflagをtrueにし、判定コードを通るようにする
         priceLowEntry = iClose(NULL,0,i);   //エントリー時の価格を判定用に保存(現通貨、現時間足、シフト0
         cntLowSignal++;                     //サインが出た数をカウント
      }


      /*-----------------------------------------*/
      // ラベル(勝ち回数、負け回数、勝率)を表示
      /*-----------------------------------------*/
      //テキストラベルオブジェクト生成
      ObjectCreate("counttotal", //オブジェクト名
                   OBJ_LABEL,    //オブジェクトタイプ
                   0,            //チャートサブウインドウの番号(0はメインチャートウインドウ)
                   0,            //1番目の時間のアンカーポイント
                   0);           //1番目の価格のアンカーポイント

      //ボタン配置の起点(チャートの左上を座標の中心にする)
      ObjectSet("counttotal",OBJPROP_CORNER,CORNER_LEFT_UPPER);
      // テキストラベルオブジェクトX軸位置設定
      ObjectSet("counttotal",OBJPROP_XDISTANCE,5);
      // テキストラベルオブジェクトY軸位置設定
      ObjectSet("counttotal",OBJPROP_YDISTANCE,15);

      //取引回数を計算
      qtyTotalDealings = qtyWinDealings + qtyLoseDealings;
      //勝率を四捨五入で丸めて算出
      if(qtyWinDealings > 0){
         perWin = MathRound((qtyWinDealings / qtyTotalDealings)*100);
       }else{
         perWin = 0;
       }
       
      //テキストラベルに、勝ち回数・負け回数・勝率を表示
      ObjectSetText("counttotal", "Win"+qtyWinDealings+"回"+" Lose: "+qtyLoseDealings+"回"+" 勝率: "+perWin+"%", extLabelSize, "MS ゴシック",White);


   }
   
   //--- return value of prev_calculated for next call
   return(rates_total);

}

//+------------------------------------------------------------------+
//| expert deinitialization function(アンロードした時のイベント)     |
//+------------------------------------------------------------------+
 int deinit(){

   //オブジェクト削除
   for(int i = ObjectsTotal()-1; 0 <= i; i--) {
      string ObjName=ObjectName(i);
      if(StringFind(ObjName, "counttotal") >= 0) ObjectDelete(ObjName);
   }

   Comment("");

   return(0);

}
