//+------------------------------------------------------------------+
//|                                            OutputIndicators2.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com/"
#property indicator_chart_window

// 外部パラメータ
extern datetime StartTime; // 開始日時

// ファイル出力関数
void WriteIndicators(int handle, int i)
{
   string sDate = TimeYear(Time[i]) + "/" + TimeMonth(Time[i]) + "/" + TimeDay(Time[i]);
   string sTime = TimeHour(Time[i]) + ":" + TimeMinute(Time[i]);
   double ma200 = iMA(NULL, 0, 200, 0, MODE_SMA, PRICE_CLOSE, i);
   FileWrite(handle, sDate, sTime, Open[i], High[i], Low[i], Close[i], ma200);
}

// 初期化関数
int init()
{
   // ファイルオープン
   int handle = FileOpen(Symbol()+Period()+".csv", FILE_CSV|FILE_WRITE, ',');
   if(handle < 0) return(-1);

   // ファイル出力
   FileWrite(handle, "Date", "Time", "Open", "High", "Low", "Close", "MA200");
   int iStart = iBarShift(NULL, 0, StartTime);
   for(int i=iStart; i>=1; i--) WriteIndicators(handle, i);
   
   // ファイルクローズ
   FileClose(handle);

   return(0);
}

// スタート関数
int start()
{
   if(Volume[0]>1) return(0);

   // ファイルオープン
   int handle = FileOpen(Symbol()+Period()+".csv", FILE_CSV|FILE_READ|FILE_WRITE, ',');
   if(handle < 0) return(-1);

   // 追加書き込みのための処理
   FileSeek(handle, 0, SEEK_END);
   
   // ファイル出力
   WriteIndicators(handle, 1);
   
   // ファイルクローズ
   FileClose(handle);

   return(0);
}

