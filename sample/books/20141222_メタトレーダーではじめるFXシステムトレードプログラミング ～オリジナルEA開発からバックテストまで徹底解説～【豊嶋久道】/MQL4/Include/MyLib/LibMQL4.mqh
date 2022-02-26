//LibMQL4.mqh for MQL5
#ifdef __MQL5__

//for iHighest() and iLowest()
#define MODE_OPEN 0
#define MODE_LOW 1
#define MODE_HIGH 2
#define MODE_CLOSE 3

#define MY_BUFFER_SIZE 1000

double iOpen(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
   double buf[1];
   CopyOpen(symbol, timeframe, shift, 1, buf);
   return buf[0];
}

double iLow(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
   double buf[1];
   CopyLow(symbol, timeframe, shift, 1, buf);
   return buf[0];
}

double iHigh(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
   double buf[1];
   CopyHigh(symbol, timeframe, shift, 1, buf);
   return buf[0];
}

double iClose(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
   double buf[1];
   CopyClose(symbol, timeframe, shift, 1, buf);
   return buf[0];
}

datetime iTime(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
   datetime buf[1];
   CopyTime(symbol, timeframe, shift, 1, buf);
   return buf[0];
}

long iVolume(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
   long buf[1];
   CopyTickVolume(symbol, timeframe, shift, 1, buf);
   return buf[0];
}

int iHighest(string symbol, ENUM_TIMEFRAMES timeframe, int type,
             int count, int start)
{
   double buf[MY_BUFFER_SIZE];
   switch(type)
   {
      case MODE_OPEN:
         CopyOpen(symbol, timeframe, start, count, buf);
         break;
      case MODE_LOW:
         CopyLow(symbol, timeframe, start, count, buf);
         break;
      case MODE_HIGH:
         CopyHigh(symbol, timeframe, start, count, buf);
         break;
      case MODE_CLOSE:
         CopyClose(symbol, timeframe, start, count, buf);
         break;
   }
   return count-1-ArrayMaximum(buf, 0, count)+start;
}

int iLowest(string symbol, ENUM_TIMEFRAMES timeframe, int type,
            int count, int start)
{
   double buf[MY_BUFFER_SIZE];
   switch(type)
   {
      case MODE_OPEN:
         CopyOpen(symbol, timeframe, start, count, buf);
         break;
      case MODE_LOW:
         CopyLow(symbol, timeframe, start, count, buf);
         break;
      case MODE_HIGH:
         CopyHigh(symbol, timeframe, start, count, buf);
         break;
      case MODE_CLOSE:
         CopyClose(symbol, timeframe, start, count, buf);
         break;
   }
   return count-1-ArrayMinimum(buf, 0, count)+start;
}

int Year()
{
   MqlDateTime dt;
   TimeCurrent(dt);
   return dt.year;
}

int Month()
{
   MqlDateTime dt;
   TimeCurrent(dt);
   return dt.mon;
}

int Day()
{
   MqlDateTime dt;
   TimeCurrent(dt);
   return dt.day;
}

int Hour()
{
   MqlDateTime dt;
   TimeCurrent(dt);
   return dt.hour;
}

int Minute()
{
   MqlDateTime dt;
   TimeCurrent(dt);
   return dt.min;
}

int Seconds()
{
   MqlDateTime dt;
   TimeCurrent(dt);
   return dt.sec;
}

int DayOfWeek()
{
   MqlDateTime dt;
   TimeCurrent(dt);
   return dt.day_of_week;
}

int DayOfYear()
{
   MqlDateTime dt;
   TimeCurrent(dt);
   return dt.day_of_year;
}

int TimeYear(datetime val)
{
   MqlDateTime dt;
   TimeToStruct(val, dt);
   return dt.year;
}

int TimeMonth(datetime val)
{
   MqlDateTime dt;
   TimeToStruct(val, dt);
   return dt.mon;
}

int TimeDay(datetime val)
{
   MqlDateTime dt;
   TimeToStruct(val, dt);
   return dt.day;
}

int TimeHour(datetime val)
{
   MqlDateTime dt;
   TimeToStruct(val, dt);
   return dt.hour;
}

int TimeMinute(datetime val)
{
   MqlDateTime dt;
   TimeToStruct(val, dt);
   return dt.min;
}

int TimeSeconds(datetime val)
{
   MqlDateTime dt;
   TimeToStruct(val, dt);
   return dt.sec;
}

int TimeDayOfWeek(datetime val)
{
   MqlDateTime dt;
   TimeToStruct(val, dt);
   return dt.day_of_week;
}

int TimeDayOfYear(datetime val)
{
   MqlDateTime dt;
   TimeToStruct(val, dt);
   return dt.day_of_year;
}

#endif
