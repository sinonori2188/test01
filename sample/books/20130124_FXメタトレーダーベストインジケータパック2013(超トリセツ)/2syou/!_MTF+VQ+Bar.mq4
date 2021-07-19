//+------------------------------------------------------------------+
//|                                          #MTF Supertrend Bar.mq4 |
//|                                      Copyright © 2006, Eli hayun |
//|                                          http://www.elihayun.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Eli hayun"
#property link      "http://www.elihayun.com"

#property indicator_separate_window
#property indicator_minimum -0.5
//#property indicator_maximum 5
#property indicator_buffers 8
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 Red
#property indicator_color4 Blue
#property indicator_color5 Red
#property indicator_color6 Blue
#property indicator_color7 Red
#property indicator_color8 Blue
//---- buffers
double buf4_up[];
double buf4_down[];
double buf3_up[];
double buf3_down[];
double buf2_up[];
double buf2_down[];
double buf1_up[];
double buf1_down[];

extern double Gap = 1; // Gap between the lines of bars
extern int Period_4 = PERIOD_M5;
extern int Period_3 = PERIOD_M15;
extern int Period_2 = PERIOD_M30;
extern int Period_1 = PERIOD_H1;


extern   bool     Crash = false;

//extern   int      TimeFrame = 0;
extern   int      Length = 5;
extern   int      Method = 3;
extern   int      Smoothing = 2;
extern   int      Filter = 1;

extern   bool     RealTime = true;
extern   bool     Steady  = false;


extern bool AutoDisplay      = false;

string shortname = "";
bool firstTime = true;
int UniqueNum = 228;

int init()
  {
   SetAutoDisplay();
   shortname = "VQ ("+tf2txt(Period_4)+","+tf2txt(Period_3)+","+tf2txt(Period_2)+","+tf2txt(Period_1)+")";
   firstTime = true;
   
   IndicatorShortName(shortname);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,110);
   SetIndexBuffer(0,buf4_up);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,110);
   SetIndexBuffer(1,buf4_down);
   SetIndexEmptyValue(1,0.0);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,110);
   SetIndexBuffer(2,buf3_up);
   SetIndexEmptyValue(2,0.0);
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,110);
   SetIndexBuffer(3,buf3_down);
   SetIndexEmptyValue(3,0.0);
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexArrow(4,110);
   SetIndexBuffer(4,buf2_up);
   SetIndexEmptyValue(4,0.0);
   SetIndexStyle(5,DRAW_ARROW);
   SetIndexArrow(5,110);
   SetIndexBuffer(5,buf2_down);
   SetIndexEmptyValue(5,0.0);
   SetIndexStyle(6,DRAW_ARROW);
   SetIndexArrow(6,110);
   SetIndexBuffer(6,buf1_up);
   SetIndexEmptyValue(6,0.0);
   SetIndexStyle(7,DRAW_ARROW);
   SetIndexArrow(7,110);
   SetIndexBuffer(7,buf1_down);
   SetIndexEmptyValue(7,0.0);
   for(int i=0;i<=7;i++)SetIndexLabel(i,NULL);
   return(0);
  }
int deinit()
  {
   SetAutoDisplay();
   shortname = "VQ ("+tf2txt(Period_4)+","+tf2txt(Period_3)+","+tf2txt(Period_2)+","+tf2txt(Period_1)+")";
   firstTime = true;
   return(0);
  }
int start()
  {
   int    counted_bars=IndicatorCounted();
   int i=0, y15m=0, y4h=0, y1h=0, y30m=0, yy;
   int limit=Bars-1;//counted_bars;

   datetime TimeArray_4H[], TimeArray_1H[], TimeArray_30M[], TimeArray_15M[];
//----

   if (firstTime || NewBar())
   {
      firstTime = false;
      int win = UniqueNum; // WindowFind(shortname);
      double dif = Time[0] - Time[1];
      for (int ii=ObjectsTotal()-1; ii>-1; ii--)
      {
         if (StringFind(ObjectName(ii),"FF_"+win+"_") >= 0)
            ObjectDelete(ObjectName(ii));
         else 
            ii=-1;
      }
      
      double shift = 0.2;
      for (ii=0; ii<4; ii++)
      {  
         string txt = "??";
         double gp;
         switch (ii)
         {
            case 0: txt = tf2txt(Period_1);  gp = 1 + shift;         break;
            case 1: txt = tf2txt(Period_2);  gp = 1 + Gap + shift;   break;
            case 2: txt = tf2txt(Period_3);  gp = 1 + Gap*2 + shift; break;
            case 3: txt = tf2txt(Period_4);  gp = 1 + Gap*3 + shift; break;
         }
         string name = "FF_"+win+"_"+ii+"_"+txt;
         ObjectCreate(name, OBJ_TEXT, WindowFind(shortname), iTime(NULL,0,0)+dif*3, gp);
         ObjectSetText(name, txt,8,"Arial", DimGray);
      }
   }
   
   ArrayCopySeries(TimeArray_4H,MODE_TIME,Symbol(),Period_4); 
   ArrayCopySeries(TimeArray_1H,MODE_TIME,Symbol(),Period_3); 
   ArrayCopySeries(TimeArray_30M,MODE_TIME,Symbol(),Period_2);
   ArrayCopySeries(TimeArray_15M,MODE_TIME,Symbol(),Period_1); 


int status1=1,status2=1,status3=1,status4=1;


   for(i=0, y15m=0,  y4h=0,  y1h=0,  y30m=0;i<limit;i++)
   {
      if (Time[i]<TimeArray_15M[y15m]) y15m++;
      if (Time[i]<TimeArray_4H[y4h])   y4h++;
      if (Time[i]<TimeArray_1H[y1h])   y1h++;
      if (Time[i]<TimeArray_30M[y30m]) y30m++;

      for (int tf = 0; tf < 4; tf++)
      {
         int prd,status;
         switch (tf)
         {
            case 0: prd = Period_1; yy = y15m; status = status1;   break;
            case 1: prd = Period_2; yy = y30m; status = status2;   break;
            case 2: prd = Period_3; yy = y1h; status = status3;   break;
            case 3: prd = Period_4; yy = y4h; status = status4;   break;
         }
         
         double val1 = iCustom(NULL,0,"VQ",Crash,prd,Length,Method,Smoothing,Filter,RealTime,Steady,1,i);
         double val2 = iCustom(NULL,0,"VQ",Crash,prd,Length,Method,Smoothing,Filter,RealTime,Steady,2,i);

         double dUp = EMPTY_VALUE;
         double dDn = EMPTY_VALUE;
         
         if (val2 != EMPTY_VALUE && val1 == EMPTY_VALUE) dUp = 1;
         if (val2 == EMPTY_VALUE && val1 != EMPTY_VALUE) dDn = 1;
         if (val2 != EMPTY_VALUE && val1 != EMPTY_VALUE && status == -1) dUp = 1;
         if (val2 != EMPTY_VALUE && val1 != EMPTY_VALUE && status == 1) dDn = 1;
         
         
         
         switch (tf)
         {
            case 0: if (dUp == EMPTY_VALUE)  status1=1; else status1=-1; break;
            case 1: if (dUp == EMPTY_VALUE)  status2=1; else status2=-1; break;
            case 2: if (dUp == EMPTY_VALUE)  status3=1; else status3=-1; break;
            case 3: if (dUp == EMPTY_VALUE)  status4=1; else status4=-1; break;
         }
         switch (tf)
         {
            case 0: if (dUp == EMPTY_VALUE)  buf1_down[i] = 1;           else buf1_up[i] = 1;           break;
            case 1: if (dUp == EMPTY_VALUE)  buf2_down[i] = 1 + Gap * 1; else buf2_up[i] = 1 + Gap * 1; break;
            case 2: if (dUp == EMPTY_VALUE)  buf3_down[i] = 1 + Gap * 2; else buf3_up[i] = 1 + Gap * 2; break;
            case 3: if (dUp == EMPTY_VALUE)  buf4_down[i] = 1 + Gap * 3; else buf4_up[i] = 1 + Gap * 3; break;
         }
         if (NewBar())
         {
            string sDir = "";
            if (buf1_up[0] + buf2_up[0] + buf3_up[0] + buf4_up[0] == 4)
               sDir = "Up";
            if (buf1_down[0] + buf2_down[0] + buf3_down[0] + buf4_down[0] == 4)
               sDir = "Down";
            if (sDir != "")
            {
               PlaySound("alert1.wav");
               Print("MTF VQ - Direction ",sDir);
            }
         }         
      }
   }
   return(0);
  }
//+------------------------------------------------------------------+

string tf2txt(int tf)
{
   if (tf == PERIOD_M1)    return("M1");
   if (tf == PERIOD_M5)    return("M5");
   if (tf == PERIOD_M15)   return("M15");
   if (tf == PERIOD_M30)   return("M30");
   if (tf == PERIOD_H1)    return("H1");
   if (tf == PERIOD_H4)    return("H4");
   if (tf == PERIOD_D1)    return("D1");
   if (tf == PERIOD_W1)    return("W1");
   if (tf == PERIOD_MN1)   return("MN1");
   return("??");
}

void SetValues(int p1, int p2, int p3, int p4)
{
   Period_1 = p4;   Period_2 = p3; Period_3 = p2; Period_4 = p1; 
}

void SetAutoDisplay()
{
   if (AutoDisplay)
   {
      switch (Period())
      {
         case PERIOD_M1  :  SetValues(PERIOD_M1,  PERIOD_M5, PERIOD_M15,PERIOD_M30); break;
         case PERIOD_M5  :  SetValues(PERIOD_M5,  PERIOD_M15,PERIOD_M30,PERIOD_H1 ); break;
         case PERIOD_M15 :  SetValues(PERIOD_M5,  PERIOD_M15,PERIOD_M30,PERIOD_H1 ); break;
         case PERIOD_M30 :  SetValues(PERIOD_M5,  PERIOD_M15,PERIOD_M30,PERIOD_H1 ); break;
         case PERIOD_H1  :  SetValues(PERIOD_M15, PERIOD_M30,PERIOD_H1, PERIOD_H4 ); break;
         case PERIOD_H4  :  SetValues(PERIOD_M30, PERIOD_H1, PERIOD_H4, PERIOD_D1 ); break;
         case PERIOD_D1  :  SetValues(PERIOD_H1,  PERIOD_H4, PERIOD_D1, PERIOD_W1 ); break;
         case PERIOD_W1  :  SetValues(PERIOD_H4,  PERIOD_D1, PERIOD_W1, PERIOD_MN1); break;
         case PERIOD_MN1 :  SetValues(PERIOD_H4,  PERIOD_D1, PERIOD_W1, PERIOD_MN1); break;
      }
   }
}

bool NewBar()
{
   static datetime dt = 0;
   if (Time[0] != dt)
   {
      dt = Time[0];
      return(true);
   }
   return(false);
}


