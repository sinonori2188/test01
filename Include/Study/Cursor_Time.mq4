//+------------------------------------------------------------------+
//|                                                  Cursor_Time.mq4 |
//|                                            Copyright 2015, Rondo |
//|                                  http://fx-dollaryen.seesaa.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Rondo"
#property link      "http://fx-dollaryen.seesaa.net/"
#property version "1.1"
#property description "【注意】夏時間/冬時間には対応しておりません。"
#property strict

#property indicator_chart_window

input int FontSize = 8;            //文字の大きさ
input color FontColor = clrWhite;   //色
input int interval = 5;             //表示時間（秒）

string labelName = "Cursor_Time_Label";

int xCursor, yCursor;
datetime timeCursor;
datetime now;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   EventSetTimer(1);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
  
   EventKillTimer();
   objLabelDelete(labelName);
         
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   
   return(0);
}

//+------------------------------------------------------------------+

void OnTimer(){
   
   string date, day, time;
   
   date = TimeToStr(timeCursor, TIME_DATE);
   
   switch(TimeDayOfWeek(timeCursor)){
   
      case SUNDAY: day = "日"; break;
      case MONDAY: day = "月"; break;
      case TUESDAY: day = "火"; break;
      case WEDNESDAY: day = "水"; break;
      case THURSDAY: day = "木"; break;
      case FRIDAY: day = "金"; break;
      case SATURDAY: day = "土"; break;      
   
   }
   
   time  = TimeToStr(timeCursor, TIME_MINUTES);
   

   if(now<TimeLocal() && TimeLocal()<=now+interval && xCursor>=0 && yCursor>=0 && timeCursor!=0.0){   
      objLabelCreate(labelName, xCursor+15, yCursor, date+" ("+day+") "+time, FontSize, FontColor);
   }
   else objLabelDelete(labelName);
}


void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
//---
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, 0, true);

   if(id == CHARTEVENT_MOUSE_MOVE){

      objLabelDelete(labelName);
      
      xCursor = (int)lparam;
      yCursor = (int)dparam;
      
      int sub_win = 0;
      datetime dt = 0;
      double price = 0;
      
      ChartXYToTimePrice(0, xCursor, yCursor+1, sub_win, dt, price);
      
      if(dt <= 0) timeCursor = 0;
      else timeCursor = dt - (TimeHour(TimeCurrent())-TimeHour(TimeLocal()))*60*60;
      
      now = TimeLocal();

   }
}


//+------------------------------------------------------------------+

void objLabelCreate(string name, int x, int y, string text, int font_size, color clr){

   if(ObjectFind(name)!=0){
      LabelCreate(0, name, 0, x, y, CORNER_LEFT_UPPER, text, "Meiryo", font_size, clr);
   }
   else{
      LabelMove(0, name, x, y);
      LabelTextChange(0, name, text);
   }
   
   ChartRedraw();
   return;
}

void objLabelDelete(string name){

   if(ObjectFind(name)==0){
      LabelDelete(0, name);
      ChartRedraw();
   }
   
   return;
}


//+------------------------------------------------------------------+
//| Create a text label                                              |
//+------------------------------------------------------------------+
bool LabelCreate(const long              chart_ID=0,               // chart's ID
                 const string            name="Label",             // label name
                 const int               sub_window=0,             // subwindow index
                 const int               x=0,                      // X coordinate
                 const int               y=0,                      // Y coordinate
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                 const string            text="Label",             // text
                 const string            font="Arial",             // font
                 const int               font_size=10,             // font size
                 const color             clr=clrRed,               // color
                 const double            angle=0.0,                // text slope
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type
                 const bool              back=false,               // in the background
                 const bool              selection=false,          // highlight to move
                 const bool              hidden=true,              // hidden in the object list
                 const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create a text label
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the slope angle of the text
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
  
//+------------------------------------------------------------------+
//| Move the text label                                              |
//+------------------------------------------------------------------+
bool LabelMove(const long   chart_ID=0,   // chart's ID
               const string name="Label", // label name
               const int    x=0,          // X coordinate
               const int    y=0)          // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--- move the text label
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the label! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the label! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }

//+------------------------------------------------------------------+
//| Change the object text                                           |
//+------------------------------------------------------------------+
bool LabelTextChange(const long   chart_ID=0,   // chart's ID
                     const string name="Label", // object name
                     const string text="Text")  // text
  {
//--- reset the error value
   ResetLastError();
//--- change object text
   if(!ObjectSetString(chart_ID,name,OBJPROP_TEXT,text))
     {
      Print(__FUNCTION__,
            ": failed to change the text! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
  
//+------------------------------------------------------------------+
//| Delete a text label                                              |
//+------------------------------------------------------------------+
bool LabelDelete(const long   chart_ID=0,   // chart's ID
                 const string name="Label") // label name
  {
//--- reset the error value
   ResetLastError();
//--- delete the label
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete a text label! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }


