//+------------------------------------------------------------------+
// 時間帯別レンジ表示
//+------------------------------------------------------------------+

#property copyright "Copyright 2015,  Daisuke"
#property link      "http://mt4program.blogspot.jp/"
#property version   "1.10"
#property strict
#property indicator_chart_window

// １時間
#define ONEHOUR (60*60)
// GMTと東アメリカ標準時間の差（-5時間）
#define GMT_TO_AMERICA (-18000)
// オブジェクト名
#define OBJECT_NAME_RANGE "OBJ_TIMERANGE"
// GMTオフセットが有効かどうか
input int GMTOffset = 2;
// サマータイムによる補正が必要かどうか
input bool IsSummerTime = true;
// 矩形の色 日本
input color JapanColor = C'0x11, 0x11, 0xbb';
// 矩形の色 Eu
input color EuColor = C'0x40,0x40,0x0';
// 矩形の色 アメリカ
input color AmericaColor = C'0xaa, 0x0, 0x0';


//------------------------------------------------------------------
//初期化
//------------------------------------------------------------------
int OnInit()
{
    string short_name = "TR";
    IndicatorShortName(short_name);
    return(INIT_SUCCEEDED);
}

//------------------------------------------------------------------
//終了処理
//------------------------------------------------------------------
void OnDeinit( const int reason )
{
    //オブジェクトを作成する。
    long chartId = ChartID();

    int total = ObjectsTotal( chartId );
    //生成したオブジェクトを削除する。
    //０から削除するとインデックス位置がずれて
    //正しく削除できないため、後ろから削除するようにする。
    for( int i = total - 1; i >= 0 ; i--)
    {
        string name = ObjectName( chartId, i );

        // 先頭文字列がRangeRectangleNameと一致する場合、削除する。
        if ( StringFind( name, OBJECT_NAME_RANGE ) == 0 )
        {
            ObjectDelete( chartId, name );
        }
    }
}

//------------------------------------------------------------------
//計算イベント
//------------------------------------------------------------------
int OnCalculate(
const int rates_total        //各レート要素数
,const int prev_calculated    //計算済み要素数
,const datetime &time[]       //要素ごとの時間配列
,const double &open[]         //オープン価格配列
,const double &high[]         //高値配列
,const double &low[]          //安値配列
,const double &close[]        //クローズ価格配列
,const long &tick_volume[]    //ティック数（要素の更新回数）
,const long &volume[]         //実ボリューム（？）
,const int &spread[])         //スプレット
{
if( Period() > PERIOD_H1 ) return rates_total;

int i = 0;
while( !IsStopped() && i < ( rates_total - prev_calculated ) )
{
bool includeTime = false;
// GMTを計算
int offset = GMTOffset * ONEHOUR;
if( IsSummerTime && IsAmericaSummerTime(time[i]) )
{
offset += ONEHOUR;
}
datetime gmt = time[i] - offset;

// 日本時間の矩形を描画する。
// 日本時間
datetime japan = gmt + 9 * ONEHOUR;

MqlDateTime current ;
TimeToStruct(japan, current);

MqlDateTime startStruct ;
startStruct.year = current.year;
startStruct.mon = current.mon;
startStruct.day = current.day;
startStruct.hour = 9;
startStruct.min = 0;
startStruct.sec = 0;
datetime start = StructToTime(startStruct);

MqlDateTime endStruct ;
endStruct.year = current.year;
endStruct.mon = current.mon;
endStruct.day = current.day;
endStruct.hour = 15;
endStruct.min = 0;
endStruct.sec = 0;
datetime end = StructToTime(endStruct);

if( start <= japan && japan < end )
{
datetime chartStart = start + offset - 9 * ONEHOUR;
datetime chartEnd = end + offset - 9 * ONEHOUR;

FourValue result = GetFourValue(Symbol(), PERIOD_M30, chartStart, chartEnd);
if( result.close != 0 && result.open != 0 )
{
string name = GetObjectName("JP", japan);
CreateRectangleObject(name, chartStart, chartEnd, result.high, result.low, JapanColor);
}
while( i < rates_total && time[i] >= chartStart ) i++;
includeTime = true;
}

// フランクフルト～ロンドン時間を描画する。
int summerTimeOffset = 0 ;
if( IsEnglandSummerTime(gmt) )
{
summerTimeOffset = ONEHOUR;
}
datetime eu  = gmt + summerTimeOffset;

TimeToStruct(eu, current);

startStruct.year = current.year;
startStruct.mon = current.mon;
startStruct.day = current.day;
startStruct.hour = 7;
startStruct.min = 0;
startStruct.sec = 0;
start = StructToTime(startStruct);

endStruct.year = current.year;
endStruct.mon = current.mon;
endStruct.day = current.day;
endStruct.hour = 16;
endStruct.min = 30;
endStruct.sec = 0;
end = StructToTime(endStruct);

if( start <= eu && eu < end )
{
datetime chartStart = start + offset - summerTimeOffset;
datetime chartEnd = end + offset - summerTimeOffset;

FourValue result = GetFourValue(Symbol(), PERIOD_M30, chartStart, chartEnd);
if( result.close != 0 && result.open != 0 )
{
string name = GetObjectName("EU", eu);
CreateRectangleObject(name, chartStart, chartEnd, result.high, result.low, EuColor);
}
while( i < rates_total && time[i] >= chartStart ) i++;
includeTime = true;
}

// アメリカ時間を描画する。
summerTimeOffset = 0 ;
if( IsAmericaSummerTime(gmt) )
{
summerTimeOffset = ONEHOUR;
}
datetime america  = gmt + summerTimeOffset - 5 * ONEHOUR;

TimeToStruct(america, current);

startStruct.year = current.year;
startStruct.mon = current.mon;
startStruct.day = current.day;
startStruct.hour = 9;
startStruct.min = 0;
startStruct.sec = 0;
start = StructToTime(startStruct);

endStruct.year = current.year;
endStruct.mon = current.mon;
endStruct.day = current.day;
endStruct.hour = 16;
endStruct.min = 00;
endStruct.sec = 0;
end = StructToTime(endStruct);

if( start <= america && america < end )
{
datetime chartStart = start + offset + 5 * ONEHOUR - summerTimeOffset;
datetime chartEnd = end + offset + 5 * ONEHOUR - summerTimeOffset;

FourValue result = GetFourValue(Symbol(), PERIOD_M30, chartStart, chartEnd);
if( result.close != 0 && result.open != 0 )
{
string name = GetObjectName("NY", eu);
CreateRectangleObject(name, chartStart, chartEnd, result.high, result.low, AmericaColor);
}
while( i < rates_total && time[i] >= chartStart ) i++;
includeTime = true;
}

if( !includeTime ) i++;
}

return(rates_total - 1);
}



//------------------------------------------------------------------
//オブジェクト名を生成する。
string GetObjectName( string prefix, datetime localTime )
{
MqlDateTime current ;
TimeToStruct(localTime, current);

MqlDateTime start ;
start.year = current.year;
start.mon = current.mon;
start.day = current.day;
start.hour = 0;
start.min = 0;
start.sec = 0;

return OBJECT_NAME_RANGE + prefix + TimeToString( StructToTime( start ) );
}


//------------------------------------------------------------------
//矩形を生成する。
// 生成成功時 True
bool CreateRectangleObject
( string name
, datetime startTime    // 開始時間
, datetime endTime      // 終了時間
, double top            // 上限価格
, double bottom         // 下限価格
, color backColor       // 背景色
)
{
//オブジェクトを作成する。
long chartId = ChartID();

int index = ObjectFind( chartId, name );
if( index < 0 )
{
if ( ObjectCreate( chartId, name, OBJ_RECTANGLE, 0, startTime, top, endTime, bottom ) == false )
{
return false;
}
}
else
{
ObjectSetInteger( chartId, name, OBJPROP_TIME1, startTime);
ObjectSetInteger( chartId, name, OBJPROP_TIME2, endTime);
ObjectSetDouble( chartId, name, OBJPROP_PRICE1, top);
ObjectSetDouble( chartId, name, OBJPROP_PRICE2, bottom);
}
ObjectSetInteger( chartId, name, OBJPROP_COLOR, backColor );
return true;
}

//------------------------------------------------------------------
// サマータイム指定日時がサマータイムかどうか
// return 指定GMT時間がサマータイムの場合 true
bool IsAmericaSummerTime(
datetime gmt         // GMT
)
{
datetime americaTime = gmt + GMT_TO_AMERICA;

MqlDateTime dt;
TimeToStruct(americaTime, dt);

//夏時間判定
datetime startSummerTime;
datetime endSummerTime;
MqlDateTime work;
int week;
if( dt.year < 2007 )
{
// 標準時ベースで4月第1日曜日 AM2：00　~ 10月最終日曜日AM1:00
work.year = dt.year;
work.mon = 4;
work.day = 1;
work.hour = 2;
work.min = 0 ;
work.sec = 0 ;
week = TimeDayOfWeek(StructToTime(work));

if( week != SUNDAY )
work.day = work.day + 7 - week;
startSummerTime = StructToTime(work) ;

work.mon = 10;
work.day = EndOfMonth(work.year, work.mon);
work.hour = 2;
work.min =  0;
work.sec = 0 ;
week = TimeDayOfWeek(StructToTime(work));
work.day = work.day - week;

endSummerTime = StructToTime(work) ;
}
else
{
// 標準時ベースで3月第2日曜日 AM2：00　~ 11月第1日曜日AM1:00
work.year = dt.year;
work.mon = 3;
work.day = 8;
work.hour = 2;
work.min = 0 ;
work.sec = 0 ;

week = TimeDayOfWeek(StructToTime(work));
if( week != SUNDAY )
work.day = work.day + 7 - week;
startSummerTime = StructToTime(work) ;

work.mon = 11;
work.day = 1;
work.hour = 2;
work.min = 0 ;
work.sec = 0 ;
week = TimeDayOfWeek(StructToTime(work));
if( week != SUNDAY )
work.day = work.day + 7 - week;
endSummerTime = StructToTime(work) ;
}

return startSummerTime <= americaTime && americaTime < endSummerTime ;
}

//------------------------------------------------------------------
// 指定日時がEUサマータイムかどうか
// return 指定GMT時間がサマータイムの場合 true
bool IsEnglandSummerTime(
datetime gmt         // GMT
)
{
datetime londonTime = gmt;

MqlDateTime dt;
TimeToStruct(londonTime, dt);

//夏時間判定
datetime startSummerTime;
datetime endSummerTime;
MqlDateTime work;
int week;

// 標準時ベースで3月最終日曜日 AM1：00　~ 10月最終日曜日AM1:00
work.year = dt.year;
work.mon = 3;
work.day = EndOfMonth(work.year, work.mon);;
work.hour = 1;
work.min = 0 ;
work.sec = 0 ;
week = TimeDayOfWeek(StructToTime(work));
work.day = work.day - week;

startSummerTime = StructToTime(work) ;

work.mon = 10;
work.day = EndOfMonth(work.year, work.mon);
work.hour = 1;
work.min = 0 ;
work.sec = 0 ;
week = TimeDayOfWeek(StructToTime(work));
work.day = work.day - week;

endSummerTime = StructToTime(work) ;

return startSummerTime <= londonTime && londonTime < endSummerTime;
}


//------------------------------------------------------------------
//指定月の最終日を返す
int EndOfMonth(
int year,      // 年
int month      // 月
)
{
MqlDateTime work;
work.year = year;
work.mon = month + 1;
work.day = 1;
work.hour = 0;
work.min = 0 ;
work.sec = 0 ;

if( work.mon >= 13)
{
work.mon = 1;
work.year = work.year + 1;
}
return TimeDay( StructToTime(work) - 1 );
}

// ４本値構造体
struct FourValue
{
// オープン
double open;
// クローズ
double close;
// 高値
double high;
// 安値
double low;
};

//------------------------------------------------------------------
//指定期間の4本値を返す。
FourValue GetFourValue(
string symbol           // 対象の通貨ペア
, ENUM_TIMEFRAMES timeframe  // 分解能
, datetime startTime      // 開始時間（開始時間は含む）
, datetime endTime        // 終了時間（終了時間は含まない）
)
{
FourValue result;
result.open = 0;
result.close = 0;
result.high = 0;
result.low = 0;


datetime lastTime = iTime( symbol, timeframe, 0);
int i = 0 ;
if( lastTime > endTime )
{
i = iBarShift( symbol, timeframe, endTime - PeriodSeconds(timeframe), true) ;
if( i < 0 )
{
// 値が取れない場合は０
return result ;
}
}

i--;
if( i < 0 ) i = 0 ;

double close = 0 ;
double open = 0 ;
double low = iClose(symbol, timeframe, 0 ) * 1000;
double high = 0;
while( !IsStopped() )
{
datetime current = iTime(symbol, timeframe, i);
if( current <= 0 ) break ;

if( startTime <= current && current < endTime )
{
if( close == 0 ) close = iClose( symbol, timeframe, i);
open = iOpen( symbol, timeframe, i);
double currentHigh = iHigh(symbol, timeframe, i);
double currentLow = iLow(symbol, timeframe, i);

if( low > currentLow ) low = currentLow;
if( high < currentHigh ) high = currentHigh;
}
if( current < startTime ) break ;
i++;
}

result.open = open;
result.close = close;
result.high = high;
result.low = low;

return result;
}
