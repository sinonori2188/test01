//+------------------------------------------------------------------+
//|                                                         GMMA.mq4 |
//|                                       Copyright(C) 2015, PeakyFx |
//|                                      http://peakyfx.blogspot.jp/ |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2018 ands"
#property link        ""
#property version     "1.00"
#property description ""
#property strict

//---- indicator settings
#property indicator_chart_window
#property indicator_buffers 12
#property indicator_plots   12

//---- input parameters 
extern ENUM_MA_METHOD     Method       = MODE_EMA;
extern ENUM_APPLIED_PRICE AppliedPrice = PRICE_CLOSE;
extern color FastMAColor1 = clrYellow;
extern color FastMAColor2 = clrYellow;
extern color SlowMAColor1 = clrPink;
extern color SlowMAColor2 = clrPink;

//---- indicator buffers
double Ma3[],  Ma5[],  Ma8[],  Ma10[], Ma12[], Ma15[];
double Ma30[], Ma35[], Ma40[], Ma45[], Ma50[], Ma60[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
//--- indicator buffers mapping
	int index = 0;
	SetMaBuffer(index++, Ma3,   3, FastMAColor1);
	SetMaBuffer(index++, Ma5,   5, FastMAColor1);
	SetMaBuffer(index++, Ma8,   8, FastMAColor1);
	SetMaBuffer(index++, Ma10, 10, FastMAColor2);
	SetMaBuffer(index++, Ma12, 12, FastMAColor2);
	SetMaBuffer(index++, Ma15, 15, FastMAColor2);
	
	SetMaBuffer(index++, Ma30, 30, SlowMAColor1);
	SetMaBuffer(index++, Ma35, 35, SlowMAColor1);
	SetMaBuffer(index++, Ma40, 40, SlowMAColor1);
	SetMaBuffer(index++, Ma45, 45, SlowMAColor2);
	SetMaBuffer(index++, Ma50, 50, SlowMAColor2);
	SetMaBuffer(index++, Ma60, 60, SlowMAColor2);
	
//---- name for DataWindow and indicator subwindow label
	IndicatorShortName("GMMA(3,5,8,10,12,15/30,35,40,45,50,60)");
	
//---- initialization done
	return(INIT_SUCCEEDED);
}

void SetMaBuffer(int index, double& buffer[], int period, color clr)
{
	SetIndexBuffer(index, buffer);
	SetIndexStyle(index, DRAW_LINE, STYLE_SOLID, 1, clr);
	SetIndexLabel(index, StringFormat("MA(%d)", period));
	SetIndexDrawBegin(index, period);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int      rates_total,
                const int      prev_calculated,
                const datetime &time[],
                const double   &open[],
                const double   &high[],
                const double   &low[],
                const double   &close[],
                const long     &tick_volume[],
                const long     &volume[],
                const int      &spread[])
{
	int limit = rates_total - MathMax(prev_calculated, 1);
	
	for (int i = limit; i >= 0; i--)
	{
		Ma3[i]  = iMA(NULL, 0,   3, 0, Method, AppliedPrice, i);
		Ma5[i]  = iMA(NULL, 0,   5, 0, Method, AppliedPrice, i);
		Ma8[i]  = iMA(NULL, 0,   8, 0, Method, AppliedPrice, i);
		Ma10[i] = iMA(NULL, 0,  10, 0, Method, AppliedPrice, i);
		Ma12[i] = iMA(NULL, 0,  12, 0, Method, AppliedPrice, i);
		Ma15[i] = iMA(NULL, 0,  15, 0, Method, AppliedPrice, i);
		
		Ma30[i] = iMA(NULL, 0,  30, 0, Method, AppliedPrice, i);
		Ma35[i] = iMA(NULL, 0,  35, 0, Method, AppliedPrice, i);
		Ma40[i] = iMA(NULL, 0,  40, 0, Method, AppliedPrice, i);
		Ma45[i] = iMA(NULL, 0,  45, 0, Method, AppliedPrice, i);
		Ma50[i] = iMA(NULL, 0,  50, 0, Method, AppliedPrice, i);
		Ma60[i] = iMA(NULL, 0,  60, 0, Method, AppliedPrice, i);
	}
	
//--- return value of prev_calculated for next call
	return(rates_total);
}
//+------------------------------------------------------------------+
