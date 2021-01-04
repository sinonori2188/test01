//+------------------------------------------------------------------+
//|                                                  DateAndTime.mqh |
//|                                     Copyright (c) 2015, りゅーき |
//|                                            https://autofx100.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2015, りゅーき"
#property link      "https://autofx100.com/"
#property version   "1.00"

//+------------------------------------------------------------------+
//| インポート                                                       |
//+------------------------------------------------------------------+
// Windows API
#import "kernel32.dll"
  int GetTimeZoneInformation(int& tzinfo[]);
#import

//+------------------------------------------------------------------+
//| 定数定義                                                         |
//+------------------------------------------------------------------+
// 自動GMT設定
#define TIME_ZONE_ID_UNKNOWN  0 // 不明
#define TIME_ZONE_ID_STANDARD 1 // 標準
#define TIME_ZONE_ID_DAYLIGHT 2 // サマータイム

//+------------------------------------------------------------------+
//|【関数】ローカルタイムのGMTオフセット値を取得する                 |
//|                                                                  |
//|【引数】なし                                                      |
//|                                                                  |
//|【戻値】GMTオフセット値                                           |
//|                                                                  |
//|【備考】MT4を実行するPCのローカルタイムが日本に設定されている場合 |
//|       「9」を返す。                                              |
//+------------------------------------------------------------------+
int getLocalTimeGMT_Offset()
{
  int timeZoneInfo[43];

  // MT4を実行するPCのタイムゾーン取得
  // GetTimeZoneInformation()関数はWindows API
  int tzType = GetTimeZoneInformation(timeZoneInfo);

  // 日本の場合、gTimeZoneInfo[0] = -540 = -9 * 60
  int gmtOffset = timeZoneInfo[0] / 60;

  // 現在サマータイム期間か？
  if(tzType == TIME_ZONE_ID_DAYLIGHT){
    // gTimeZoneInfo[42]はサマータイムで変化する時間（通常=-60分）
    gmtOffset += timeZoneInfo[42] / 60;
  }

  gmtOffset = -gmtOffset;

  return(gmtOffset);
}

//+------------------------------------------------------------------+
//|【関数】ローカルタイムとサーバタイムの時差を計算する              |
//|                                                                  |
//|【引数】 IN OUT  引数名             説明                          |
//|        --------------------------------------------------------- |
//|         ○      aUseAutoGMT_Flg    自動GMT設定有効フラグ         |
//|         ○      aSummerTimeType    サマータイム区分              |
//|         ○      aSummerGMT_Offset  サマータイム時のGMTｵﾌｾｯﾄ値    |
//|         ○      aWinterGMT_Offset  標準時のGMTｵﾌｾｯﾄ値            |
//|         ○      aLocalGMT_Offset   ﾛｰｶﾙﾀｲﾑのGMTｵﾌｾｯﾄ値           |
//|                                                                  |
//|【戻値】ローカルタイムとサーバタイムの時差                        |
//|                                                                  |
//|【備考】なし                                                      |
//+------------------------------------------------------------------+
int calcTimeDifference(bool aUseAutoGMT_Flg, int aSummerTimeType, int aSummerGMT_Offset, int aWinterGMT_Offset, int aLocalGMT_Offset)
{
  int serverGMT_Offset = 0;

  if(aUseAutoGMT_Flg == false || IsTesting() || IsOptimization()){
    bool result = isSummerTime(aSummerTimeType);

    // サマータイムの場合
    if(result){
      int tmp = aSummerGMT_Offset;
    }else{
      tmp = aWinterGMT_Offset;
    }

    serverGMT_Offset = tmp;
  }else{
    // ローカルタイムがサーバタイムより少し遅い場合、1時間不足する不具合が発生。
    // TimeLocal()                 = 2016.08.06 23:25:26
    // TimeCurrent()               = 2016.08.05 10:25:46
    // TimeLocal() - TimeCurrent() = 1970.01.01 12:59:40
    // 時差 = 12h ※本来は13h。TimeHour()で時間hだけを取得するため、59分40秒が切り捨て。結果として、1時間不足する。
    datetime difTime = TimeLocal() - TimeCurrent();

    // それを解消するため、分が30以上なら1時間加算することで暫定対処とする。
    // 美しいロジックではないが、別案が思い浮かばないため。
    if(TimeMinute(difTime) >= 30){
      serverGMT_Offset = aLocalGMT_Offset - (TimeHour(difTime) + 1);
    }else{
      serverGMT_Offset = aLocalGMT_Offset - TimeHour(difTime);
    }
  }

  return(aLocalGMT_Offset - serverGMT_Offset);
}

//+------------------------------------------------------------------+
//|【関数】FX業者のサーバーがサマータイム期間かどうかを判断する      |
//|                                                                  |
//|【引数】 IN OUT  引数名             説明                          |
//|        --------------------------------------------------------- |
//|         ○      aSummerTimeType    サマータイム区分              |
//|                                                                  |
//|【戻値】true ：夏時間                                             |
//|        false：冬時間（標準時間）                                 |
//|                                                                  |
//|【備考】英国夏時間：3月最終日曜AM1:00～10月最終日曜AM1:00         |
//|        米国夏時間：3月第2日曜AM2:00～11月第1日曜AM2:00           |
//+------------------------------------------------------------------+
bool isSummerTime(int aSummerTimeType)
{
  int year  = Year();
  int month = Month();
  int day   = Day();
  int w     = DayOfWeek();
  int hour  = Hour();
  int startMonth;
  int startN;
  int startW;
  int startHour;
  int endMonth;
  int endN;
  int endW;
  int endHour;
  int w1;     // month月１日の曜日
  int dstDay; // 夏時間開始または終了日付

  // 英国夏時間
  if(aSummerTimeType == 1){
    startMonth = 3;
    startW     = 0;
    startHour  = 1;

    int dayOfWeek = TimeDayOfWeek(StrToTime(year + "/" + startMonth + "/01"));
    int tmpDay = NthDayOfWeekToDay(5, 0, dayOfWeek);
    if(tmpDay >= 1 && tmpDay <= 31){
      startN = 5;
    }else{
      startN = 4;
    }

    endMonth   = 10;
    endW       = 0;
    endHour    = 1; // 2時になった瞬間に1時に戻るので「1」

    dayOfWeek = TimeDayOfWeek(StrToTime(year + "/" + endMonth + "/01"));
    tmpDay = NthDayOfWeekToDay(5, 0, dayOfWeek);
    if(tmpDay >= 1 && tmpDay <= 31){
      endN = 5;
    }else{
      endN = 4;
    }
  // 米国夏時間
  }else if(aSummerTimeType == 2){
    if(year <= 2006){
      startMonth = 4;
      startN     = 1;
      startW     = 0;
      startHour  = 2;

      endMonth   = 10;
      endW       = 0;
      endHour    = 1; // 2時になった瞬間に1時に戻るので「1」

      dayOfWeek = TimeDayOfWeek(StrToTime(year + "/" + endMonth + "/01"));
      tmpDay = NthDayOfWeekToDay(5, 0, dayOfWeek);
      if(tmpDay >= 1 && tmpDay <= 31){
        endN = 5;
      }else{
        endN = 4;
      }
    }else{
      startMonth = 3;
      startN     = 2;
      startW     = 0;
      startHour  = 2;

      endMonth   = 11;
      endN       = 1;
      endW       = 0;
      endHour    = 1;
    }
  // サマータイムなし
  }else{
    return(false);
  }

  if(month < startMonth || endMonth < month){
    return(false);
  }

  // month月１日の曜日w1を求める．day＝1 ならば w1＝w で，
  // dayが１日増えるごとにw1は１日前にずれるので，数学的には
  //   w1 = (w - (day - 1)) mod 7
  // しかしＣ言語の場合は被除数が負になるとまずいので，
  // 負にならないようにするための最小の７の倍数35を足して
  w1 = (w + 36 - day) % 7;

  if(month == startMonth){
    // month月のstartN回目のstartW曜日の日付dstDayを求める．
    dstDay = NthDayOfWeekToDay(startN, startW, w1);

    // (day, hour) が (dstDay, startHour) より前ならば夏時間ではない
    if(day < dstDay || (day == dstDay && hour < startHour)){
      return(false);
    }
  }

  if(month == endMonth){
    // month月のendN回目のendW曜日の日付dstDayを求める
    dstDay = NthDayOfWeekToDay(endN, endW, w1);

    // (day, hour) が (dstDay, startHour) 以後ならば夏時間ではない
    if(day > dstDay || (day == dstDay && hour >= endHour)){
      return(false);
    }
  }

  return(true);
}

//+------------------------------------------------------------------+
//|【関数】ある月のn回目のdow曜日の日付を求める                      |
//|                                                                  |
//|【引数】 IN OUT  引数名             説明                          |
//|        --------------------------------------------------------- |
//|         ○      n                  n週目（1～5）                 |
//|         ○      dow                曜日（0：日曜，…，6：土曜）  |
//|         ○      dow1               その月の1日の曜日             |
//|                                                                  |
//|【戻値】その月のn回目のdow曜日の日にち                          |
//|                                                                  |
//|【備考】2007/3：1日は木曜(4)で，第3金曜(5)は16日                  |
//|        NthDayOfWeekToDay(3, 5, 4) = 16                           |
//+------------------------------------------------------------------+
int NthDayOfWeekToDay(int n, int dow, int dow1)
{
  int day;

  // day ← (最初の dow 曜日の日付)－１
  if(dow < dow1){
    dow += 7;
  }

  day = dow - dow1;

  // day ← ｎ回目の dow 曜日の日付 (day + 7 * (n - 1) + 1)
  day += 7 * n - 6;

  return(day);
}

//+------------------------------------------------------------------+
//|【関数】ローカルタイム時刻（時）⇒サーバタイム時刻（時）変換      |
//|                                                                  |
//|【引数】 IN OUT  引数名             説明                          |
//|        --------------------------------------------------------- |
//|         ○      aHour              ﾛｰｶﾙﾀｲﾑの時刻（時）           |
//|         ○      aTimeDiff          ﾛｰｶﾙﾀｲﾑとｻｰﾊﾞﾀｲﾑの時差        |
//|                                                                  |
//|【戻値】サーバ時刻（時）                                          |
//|                                                                  |
//|【備考】なし                                                      |
//+------------------------------------------------------------------+
int convertLocalToServerTime(int aHour, int aTimeDiff)
{
  int serverHour = aHour - aTimeDiff;

  if(serverHour < 0){
    serverHour += 24;
  }else if(serverHour > 23){
    serverHour -= 24;
  }

  return(serverHour);
}

//+------------------------------------------------------------------+
//|【関数】EA稼働時間外判断                                          |
//|                                                                  |
//|【引数】 IN OUT  引数名             説明                          |
//|        --------------------------------------------------------- |
//|         ○      aHour              ﾛｰｶﾙﾀｲﾑの時刻（時）           |
//|         ○      aTimeDiff          ﾛｰｶﾙﾀｲﾑとｻｰﾊﾞﾀｲﾑの時差        |
//|                                                                  |
//|【戻値】true:  EA稼働時間外                                       |
//|        false: EA稼働時間                                         |
//|                                                                  |
//|【備考】稼働時間パラメータを文字列にして、MQL内部で時刻に変換する |
//|        方法もあるが、文字列の変換は遅いことが知られているため、  |
//|        数値を直接入力する方式を採用。                            |
//+------------------------------------------------------------------+
bool isOverTime(int aSvEntryStartHour, int aEntryStartMinute, int aSvEntryEndHour, int aEntryEndMinute)
{
  string errMsg = "開始時刻と終了時刻が同じ値です。異なる値を設定してください。"; 

  // 時分を整数で表現する（例 8:30 ⇒ 830、12:15 ⇒ 1215）
  int startTime = aSvEntryStartHour * 100 + aEntryStartMinute;
  int endTime   = aSvEntryEndHour   * 100 + aEntryEndMinute;

  int currentTime = Hour() * 100 + Minute();

  // 日をまたがないケース
  if(startTime < endTime){
    if(currentTime < startTime || currentTime >= endTime){
      return(true);
    }
  // 日をまたぐケース
  }else if(startTime > endTime){
    if(currentTime >= endTime && currentTime < startTime){
      return(true);
    }
  // 同一日時を指定したケース
  }else{
    Print(errMsg);
    Alert(errMsg);
    return(true);
  }

  return(false);
}
