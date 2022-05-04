//+------------------------------------------------------------------+
//|                                                         角度.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
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

double value1 =iClose(NULL,0,20); //y座標1
double value2 =iClose(NULL,0,0); //y座標2
int kankaku = 20;//座標間隔（ローソク足が隣同士の場合は1）

double kakudo = MathArctan((value2 - value1) / (Point * 10 * kankaku)) * 180 / M_PI; //角度を求める式（MathArctanによりラジアンを求め、180をかけて度に直し円周率で割っています）

Comment(kakudo);//コメントに角度表示
  
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+


