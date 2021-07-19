//+------------------------------------------------------------------+
//|                                             OutputIndicators.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com/"
#property show_inputs

// 外部パラメータ
extern datetime StartTime; // 開始日時
extern datetime EndTime;   // 終了日時

// スタート関数
int start()
{
   // ファイルオープン
   int handle = FileOpen(Symbol()+Period()+".csv", FILE_CSV|FILE_WRITE, ',');
   if(handle < 0) return(-1);

   // 出力範囲の指定
   int iStart = iBarShift(NULL, 0, StartTime);
   if(EndTime == 0) EndTime = TimeCurrent();
   int iEnd = iBarShift(NULL, 0, EndTime);

   // ファイル出力
   FileWrite(handle, "Date", "Time", "Open", "High", "Low", "Close", "MA200");
   for(int i=iStart; i>=iEnd; i--)
   {
      string sDate = TimeYear(Time[i]) + "/" + TimeMonth(Time[i]) + "/" + TimeDay(Time[i]);
      string sTime = TimeHour(Time[i]) + ":" + TimeMinute(Time[i]);
      double ma200 = iMA(NULL, 0, 200, 0, MODE_SMA, PRICE_CLOSE, i);
      FileWrite(handle, sDate, sTime, Open[i], High[i], Low[i], Close[i], ma200);
   }
   
   // ファイルクローズ
   FileClose(handle);

   MessageBox("End of OutputIndicators");

   return(0);
}

