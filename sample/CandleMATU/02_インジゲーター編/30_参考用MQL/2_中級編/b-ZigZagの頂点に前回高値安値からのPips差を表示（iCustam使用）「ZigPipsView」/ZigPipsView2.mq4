//+------------------------------------------------------------------+
//|                                        中級2.ZigPipsView_view.mq4 |
//|                                            Copyright 2020, Erika |
//|                                                     https://www. |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Erika"
#property link      "https://www."
#property version   "1.00"
#property strict
#property indicator_chart_window

#property description "ZigZagをiCustomで読み込み、高安値を差分をpips換算し表示します。"

//--- input parameters
input int      zigzagDepth=10;//ZIGZAG Depth
input double   dispos=1.5;//表示位置調整
input int      maxbar=3000;//対象ロウソク足本数

//--- variable
int cnt;
double zig_point0, zig_high0, zig_high1, zig_low0, zig_low1;
double zig_diff_HLpips, zig_diff_HHpips, zig_diff_LLpips, digit;
datetime zig_Time0;
string objname;
 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
//--- indicator buffers mapping
   Comment("中級2.ZigPipsView_view");
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
//---
   for(int i=maxbar; i>=0; i--){
   
      if(i == maxbar){
         for(int j=ObjectsTotal()-1; 0<=j; j--){
            string objName = ObjectName(j);
            if(StringFind(objName, "zig")>=0){ObjectDelete(objName);}
         }
      }
      
           
      //---　index
      zig_point0 = iCustom(_Symbol, _Period, "ZigZag", zigzagDepth, 5, 3, 0, i);
      
      
      if(zig_point0 == iHigh(_Symbol, _Period, i)){
         zig_high1 = zig_high0;
         zig_high0 = iHigh(_Symbol, _Period, i);
         zig_Time0 = iTime(_Symbol, _Period, i);

         if(zig_low0 != 0){
            digit = MathPow(10, _Digits);//_Digits通貨が小数点３桁なら、１０のべき乗で10*10*10
            zig_diff_HLpips = MathRound((zig_high0 - zig_low0)* digit);//差分pips換算
            zig_diff_HHpips = MathRound((zig_high0 - zig_high1)* digit);//差分pips換算
         }
         
         //--- ObjetCreate
         objname = "zig_HLpips"+DoubleToString(cnt);
         ObjectCreate(0, objname, OBJ_TEXT, 0, zig_Time0, zig_high0+dispos*10*_Point);
         ObjectSetString(0, objname, OBJPROP_TEXT, DoubleToString(zig_diff_HLpips));
         ObjectSetString(0, objname, OBJPROP_FONT, "MA ゴシック");
         ObjectSetInteger(0, objname, OBJPROP_FONTSIZE, 10);
         ObjectSetInteger(0, objname, OBJPROP_COLOR, clrYellow);
         
         objname = "zig_HHpips"+DoubleToString(cnt);
         ObjectCreate(0, objname, OBJ_TEXT, 0, zig_Time0, zig_high0+(5+dispos)*10*_Point);
         ObjectSetString(0, objname, OBJPROP_TEXT, DoubleToString(zig_diff_HHpips));
         ObjectSetString(0, objname, OBJPROP_FONT, "MA ゴシック");
         ObjectSetInteger(0, objname, OBJPROP_FONTSIZE, 10);
         ObjectSetInteger(0, objname, OBJPROP_COLOR, clrLime);
         cnt++;
      }//if(zig_point0 == iHigh(_Symbol, _Period, i))
      
      
      if(zig_point0 == iLow(_Symbol, _Period, i)){
         zig_low1 = zig_low0;
         zig_low0 = iLow(_Symbol, _Period, i);
         zig_Time0 = iTime(_Symbol, _Period, i);
         
         if(zig_high0 != 0){
            digit = MathPow(10, _Digits);
            zig_diff_HLpips = MathRound((zig_high0 - zig_low0)* digit);
            zig_diff_LLpips = MathRound((zig_low0 - zig_low1)* digit);
         }
         
         //--- ObjetCreate
         objname = "zig_HLpips"+DoubleToString(cnt);
         ObjectCreate(0, objname, OBJ_TEXT, 0, zig_Time0, zig_low0-dispos*10*_Point);
         ObjectSetString(0, objname, OBJPROP_TEXT, DoubleToString(zig_diff_HLpips));
         ObjectSetString(0, objname, OBJPROP_FONT, "MS　ゴシック");
         ObjectSetInteger(0, objname, OBJPROP_FONTSIZE, 10);
         ObjectSetInteger(0, objname, OBJPROP_COLOR, clrYellow);
         
         objname = "zig_LLpips"+DoubleToString(cnt);
         ObjectCreate(0, objname, OBJ_TEXT, 0, zig_Time0, zig_low0-(5+dispos)*10*_Point);
         ObjectSetString(0, objname, OBJPROP_TEXT, DoubleToString(zig_diff_LLpips));
         ObjectSetString(0, objname, OBJPROP_FONT, "MA　ゴシック");
         ObjectSetInteger(0, objname, OBJPROP_FONTSIZE, 10);
         ObjectSetInteger(0, objname, OBJPROP_COLOR, clrLime);
         cnt++;
      }//if(zig_point0 == iLow(_Symbol, _Period, i)    
      
      
   }//for(int i=maxbar; i>=0: i--)
//--- return value of prev_calculated for next call
   return rates_total;
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| deinitialization function                                        |                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
  if(reason == REASON_REMOVE ||reason == REASON_CHARTCHANGE ||reason == REASON_PARAMETERS){//1,3,5
      Comment("");
      for(int i=ObjectsTotal()-1; 0<=i; i--){
         string ObjName = ObjectName(i);
         if(StringFind(ObjName, "zig") >=0){ObjectDelete(ObjName);}
      }
  }
}

