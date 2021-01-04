//+------------------------------------------------------------------+
//|                                                       Sample.mq4 |
//|                                     Copyright (c) 2015, りゅーき |
//|                                           https://autofx100.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2015, りゅーき"
#property link      "https://autofx100.com/"
#property version   "1.00"

//+------------------------------------------------------------------+
//| ライブラリ                                                       |
//+------------------------------------------------------------------+
#include <stderror.mqh>
#include <stdlib.mqh>
#include <WinUser32.mqh>
#include <Original/Basic.mqh>
#include <Original/DateAndTime.mqh>
#include <Original/OrderHandle.mqh>
#include <Original/OrderReliable.mqh>

//+------------------------------------------------------------------+
//| EAパラメータ設定情報                                             |
//+------------------------------------------------------------------+
extern string Note01            = "=== General ==================================================";
extern int    MagicNumber       = 7777777;
extern int    SlippagePips      = 5;
extern double LotSize           = 0.01;
extern string Comments          = "";

extern string Note02            = "=== Entry ====================================================";
extern string Note02_1          = "--- GMT ------------------------------------------------------";
extern string Note02_2          = "True:Auto  False:Manual";
extern bool   UseAutoGMT_Flg    = true;
extern string Note02_3          = "0:Not Summer Time  1:London  2:N.Y.";
extern int    SummerTimeType    = 2;
extern int    SummerGMT_Offset  = 3;
extern int    WinterGMT_Offset  = 2;
extern string Note02_4          = "--- Entry Time 1-3 -------------------------------------------";
extern string Note02_5          = "Entry Time 1 (Local Time)";
extern bool   UseEntryTimeFlg1  = true;
extern int    EntryStartHour1   = 6; // 仕掛け開始時刻（時） ローカルタイム
extern int    EntryStartMinute1 = 0; // 仕掛け開始時刻（分） ローカルタイム
extern int    EntryEndHour1     = 9; // 仕掛け終了時刻（時） ローカルタイム
extern int    EntryEndMinute1   = 0; // 仕掛け終了時刻（分） ローカルタイム
extern string Note02_6          = "Entry Time 2 (Local Time)";
extern bool   UseEntryTimeFlg2  = true;
extern int    EntryStartHour2   = 16;
extern int    EntryStartMinute2 = 0;
extern int    EntryEndHour2     = 19;
extern int    EntryEndMinute2   = 0;
extern string Note02_7          = "Entry Time 3 (Local Time)";
extern bool   UseEntryTimeFlg3  = true;
extern int    EntryStartHour3   = 21;
extern int    EntryStartMinute3 = 0;
extern int    EntryEndHour3     = 0;
extern int    EntryEndMinute3   = 0;
extern string Note02_8          = "--- Max Position Number --------------------------------------";
extern bool   UseMaxPosition    = true;
extern int    MaxPositionNumber = 3;
extern string Note02_9          = "--- entry only once per 1 bar --------------------------------";
extern bool   UseEntryPer1Bar   = true;

extern string Note03            = "=== Exit =====================================================";
extern double InitialSL_Pips    = 50.0;
extern string Note03_1          = "--- Trailing Stop --------------------------------------------";
extern double TS_StartPips      = 10.0;
extern double TS_StopPips       = 5.0;

//+------------------------------------------------------------------+
//| グローバル変数                                                   |
//+------------------------------------------------------------------+
// 共通
double gPipsPoint           = 0.0;
int    gSlippage            = 0;
color  gArrowColor[6]       = {Blue, Red, Blue, Red, Blue, Red}; //BUY: Blue, SELL: Red
// 自動GMT設定
int    gLocalGMT_Offset     = 0;
// 仕掛け時間帯指定
int    gSvEntryStartHour1   = 0;
int    gSvEntryEndHour1     = 0;
int    gSvEntryStartHour2   = 0;
int    gSvEntryEndHour2     = 0;
int    gSvEntryStartHour3   = 0;
int    gSvEntryEndHour3     = 0;
int    gEntryTimeFlgTrueCnt = 0;
// １本の足で１回だけ仕掛ける
int    gPrvBars             = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
  gPipsPoint = currencyUnitPerPips(Symbol());
  gSlippage = getSlippage(Symbol(), SlippagePips);

  // 自動GMT設定
  gLocalGMT_Offset = getLocalTimeGMT_Offset();

  // 仕掛け時間帯指定
  gEntryTimeFlgTrueCnt = 0; // ここで初期化しないと、時間足等を変更した際にOnInitが再度呼び出されて累積されてしまう

  if(UseEntryTimeFlg1){
    gEntryTimeFlgTrueCnt += 1;
  }

  if(UseEntryTimeFlg2){
    gEntryTimeFlgTrueCnt += 1;
  }

  if(UseEntryTimeFlg3){
    gEntryTimeFlgTrueCnt += 1;
  }

  gPrvBars = Bars;

  return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
  int currentBars = Bars;

  // -----------------------------------------------------------------
  // 仕切り
  // -----------------------------------------------------------------
  // トレイリングストップ
  trailingStopGeneral(MagicNumber, TS_StartPips, TS_StopPips);

  // -----------------------------------------------------------------
  // 自動GMT設定
  // -----------------------------------------------------------------
  int timeDiff = calcTimeDifference(UseAutoGMT_Flg, SummerTimeType, SummerGMT_Offset, WinterGMT_Offset, gLocalGMT_Offset);

  // -----------------------------------------------------------------
  // 仕掛け時間帯指定
  // -----------------------------------------------------------------
  // ローカルタイム時刻（時）⇒サーバタイム時刻（時）変換
  gSvEntryStartHour1 = convertLocalToServerTime(EntryStartHour1, timeDiff);
  gSvEntryEndHour1   = convertLocalToServerTime(EntryEndHour1,   timeDiff);

  gSvEntryStartHour2 = convertLocalToServerTime(EntryStartHour2, timeDiff);
  gSvEntryEndHour2   = convertLocalToServerTime(EntryEndHour2,   timeDiff);

  gSvEntryStartHour3 = convertLocalToServerTime(EntryStartHour3, timeDiff);
  gSvEntryEndHour3   = convertLocalToServerTime(EntryEndHour3,   timeDiff);

  // -----------------------------------------------------------------
  // 仕掛けフィルター（仕掛け時間帯指定）
  // -----------------------------------------------------------------
  int overCnt = 0;

  if(UseEntryTimeFlg1 && isOverTime(gSvEntryStartHour1, EntryStartMinute1, gSvEntryEndHour1, EntryEndMinute1)){
    overCnt += 1;
  }

  if(UseEntryTimeFlg2 && isOverTime(gSvEntryStartHour2, EntryStartMinute2, gSvEntryEndHour2, EntryEndMinute2)){
    overCnt += 1;
  }

  if(UseEntryTimeFlg3 && isOverTime(gSvEntryStartHour3, EntryStartMinute3, gSvEntryEndHour3, EntryEndMinute3)){
    overCnt += 1;
  }

  // 仕掛け時間外なら、仕掛けない
  if(overCnt == gEntryTimeFlgTrueCnt){
    gPrvBars = currentBars;
    return;
  }

  // -----------------------------------------------------------------
  // 仕掛けフィルター（最大ポジション数制限）
  // -----------------------------------------------------------------
  if(UseMaxPosition){
    // ポジション数合計
    double positionNumber = sumOrderNumberOrLotSize(OP_OPEN, MagicNumber, SUM_ORDER_NUMBER);

    // 現在のポジション数が既定ポジション数以上の間は仕掛けない
    if(positionNumber >= MaxPositionNumber){
      Print("ポジション数が最大数（", MaxPositionNumber, "）に到達したため、新規の仕掛けは不可");
      gPrvBars = currentBars;
      return;
    }
  }

  // -----------------------------------------------------------------
  // 仕掛けフィルター（１本の足で１回だけ仕掛ける）
  // -----------------------------------------------------------------
  if(UseEntryPer1Bar){
    // 新しい足を生成した時ではない場合は、仕掛けない
    if(currentBars == gPrvBars){
      gPrvBars = currentBars;
      return;
    }
  }

  // -----------------------------------------------------------------
  // 仕掛け
  // -----------------------------------------------------------------
  // 成行注文
  int ticket = orderSendReliableRange(Symbol(), OP_BUY, LotSize, Ask, gSlippage, InitialSL_Pips, 0.0, Comments, MagicNumber, 0, gArrowColor[OP_BUY]);

  // 本来はticketの値によって後続の処理を制御する必要があるが、簡単のため、ここでは無視

  gPrvBars = currentBars;
}
