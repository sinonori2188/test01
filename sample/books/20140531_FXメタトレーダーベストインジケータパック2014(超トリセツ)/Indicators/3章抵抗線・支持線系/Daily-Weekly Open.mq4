//+------------------------------------------------------------------+
//|                                            Daily-Weekly Open.mq4 |
//|                                           djindyfx@sbcglobal.net |
//|      http://www.learncurrencytrading.com/fxforum/blogs/djindyfx/ |
//+------------------------------------------------------------------+
#property copyright "djindyfx@sbcglobal.net"
#property link      "http://www.learncurrencytrading.com/fxforum/blogs/djindyfx/"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Aqua
#property indicator_color2 Red
//---- buffers
double dailyopen[];
double weeklyopen[];
double line;
double d,w;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE,STYLE_DOT,1);
   SetIndexBuffer(0,dailyopen);
   SetIndexStyle(1,DRAW_LINE,STYLE_DASHDOT,1);
   SetIndexBuffer(1,weeklyopen);
   
   string dopen, wopen;
   dopen = "Daily Open";
   wopen = "Weekly Open";
   
   IndicatorShortName(dopen);
   IndicatorShortName(wopen);
   
   SetIndexLabel(0,dopen);
   SetIndexLabel(1,wopen);
   
   SetIndexDrawBegin(0,1);
   //SetIndexDrawBegin(1,1);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   //ObjectDelete("Weekly Open");
   //ObjectDelete("Daily Open");
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   int limit, i;
   
//----
   if(counted_bars==0)
      {//0
       //d=Period();
       //if (d>240)return(-1);
       ObjectCreate("Weekly Open",OBJ_HLINE,0,0,0);
       ObjectCreate("Daily Open",OBJ_HLINE,0,0,0);
      }//0
   
  
   if(counted_bars<0) return(-1);
   
   limit=(Bars-counted_bars)-1;
   
   for(i=limit; i>=0; i--)
      {//0
       if(1==TimeDayOfWeek(Time[i]) && 1!=TimeDayOfWeek(Time[i+1]))
         {//1
          w=Open[i];
          ObjectMove("Weekly Open",0,Time[i],line);
         }//2
       if (TimeDay(Time[i]) !=TimeDay(Time[i+1]))
         {//3
          d=Open[i];
          ObjectMove("Daily Open",0,Time[i],line);
         }//3
       weeklyopen[i]=w;
       dailyopen[i]=d;
      }//0
   
//----
   return(0);
  }
//+------------------------------------------------------------------+