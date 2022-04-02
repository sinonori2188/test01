//+------------------------------------------------------------------+
//|                                                ボリバンマスター.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 9
#property indicator_plots   9
//--- plot ema0
#property indicator_label1  "ema0"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot ema1
#property indicator_label2  "ema1"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrPink
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot ema2
#property indicator_label3  "ema2"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrOrange
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot bbu0
#property indicator_label4  "bbu0"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrWhite
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot bbd0
#property indicator_label5  "bbd0"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrWhite
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//--- plot bbu1
#property indicator_label6  "bbu1"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrYellow
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1
//--- plot bbd1
#property indicator_label7  "bbd1"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrYellow
#property indicator_style7  STYLE_SOLID
#property indicator_width7  1
//--- plot bbu2
#property indicator_label8  "bbu2"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrRed
#property indicator_style8  STYLE_SOLID
#property indicator_width8  1
//--- plot bbd2
#property indicator_label9  "bbd2"
#property indicator_type9   DRAW_LINE
#property indicator_color9  clrRed
#property indicator_style9  STYLE_SOLID
#property indicator_width9  1
//--- indicator buffers
double         ema0Buffer[];
double         ema1Buffer[];
double         ema2Buffer[];
double         bbu0Buffer[];
double         bbd0Buffer[];
double         bbu1Buffer[];
double         bbd1Buffer[];
double         bbu2Buffer[];
double         bbd2Buffer[];

input int range = 10000; //計算期間

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- indicator buffers mapping
   SetIndexBuffer(0,ema0Buffer);
   SetIndexBuffer(1,ema1Buffer);
   SetIndexBuffer(2,ema2Buffer);
   SetIndexBuffer(3,bbu0Buffer);
   SetIndexBuffer(4,bbd0Buffer);
   SetIndexBuffer(5,bbu1Buffer);
   SetIndexBuffer(6,bbd1Buffer);
   SetIndexBuffer(7,bbu2Buffer);
   SetIndexBuffer(8,bbd2Buffer);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int a){
	for(int i=0;i<3;i++)ObjectDelete(0,"BTN:"+(string)i);
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
	int limit = 0;
	if(prev_calculated==0)limit=MathMin(range,Bars-250);
	
	for(int i=limit;i>=0;i--){
		//EMA
		ema0Buffer[i]=iMA(NULL,0,20,0,MODE_EMA,PRICE_CLOSE,i);
		ema1Buffer[i]=iMA(NULL,0,60,0,MODE_EMA,PRICE_CLOSE,i);
		ema2Buffer[i]=iMA(NULL,0,240,0,MODE_EMA,PRICE_CLOSE,i);
		//BB(5分足) "_Period"今表示している時間足を返すので、5÷5=1となり、5分足以上なら機能するということになる。
		for(int j=0;j<5/_Period;j++){
			bbu0Buffer[i+j]=iBands(NULL,5,20,2,0,PRICE_CLOSE,1,iBarShift(NULL,5,Time[i+j]));
			bbd0Buffer[i+j]=iBands(NULL,5,20,2,0,PRICE_CLOSE,2,iBarShift(NULL,5,Time[i+j]));
		}
		//BB(15分足)
		for(int j=0;j<15/_Period;j++){
			bbu1Buffer[i+j]=iBands(NULL,15,20,2,0,PRICE_CLOSE,1,iBarShift(NULL,15,Time[i+j]));
			bbd1Buffer[i+j]=iBands(NULL,15,20,2,0,PRICE_CLOSE,2,iBarShift(NULL,15,Time[i+j]));
		}
		//BB(60分足)
		for(int j=0;j<60/_Period;j++){
			bbu2Buffer[i+j]=iBands(NULL,60,20,2,0,PRICE_CLOSE,1,iBarShift(NULL,60,Time[i+j]));
			bbd2Buffer[i+j]=iBands(NULL,60,20,2,0,PRICE_CLOSE,2,iBarShift(NULL,60,Time[i+j]));
		}
		
	}
	
	if(prev_calculated!=rates_total){
		for(int i=0;i<3;i++){
			string objname="BTN:"+(string)i;
			ObjectCreate(0,objname,OBJ_BUTTON,0,0,0);
			if(i==0)ObjectSetInteger(0,objname,OBJPROP_COLOR,clrWhite);
			if(i==1)ObjectSetInteger(0,objname,OBJPROP_COLOR,clrYellow);
			if(i==2)ObjectSetInteger(0,objname,OBJPROP_COLOR,clrRed);
			ObjectSetInteger(0,objname,OBJPROP_BGCOLOR,clrGray);
			ObjectSetInteger(0,objname,OBJPROP_XDISTANCE,8+65*i);
			ObjectSetInteger(0,objname,OBJPROP_YDISTANCE,18);
			ObjectSetInteger(0,objname,OBJPROP_XSIZE,60);
			ObjectSetInteger(0,objname,OBJPROP_YSIZE,22);
			ObjectSetInteger(0,objname,OBJPROP_FONTSIZE,12);
			ObjectSetString(0,objname,OBJPROP_FONT,"MS ゴシック");
			if(i==0)ObjectSetString(0,objname,OBJPROP_TEXT,"5分");
			if(i==1)ObjectSetString(0,objname,OBJPROP_TEXT,"15分");
			if(i==2)ObjectSetString(0,objname,OBJPROP_TEXT,"1時間");
		}
	}
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
  	if(id==CHARTEVENT_OBJECT_CLICK){
  		for(int i=0;i<3;i++){
	  		if(sparam=="BTN:"+(string)i){
	  			if(ObjectGetInteger(0,sparam,OBJPROP_STATE)){
	  				SetIndexStyle(3+i*2,DRAW_NONE);
	  				SetIndexStyle(4+i*2,DRAW_NONE);
	  			}else{
	  				SetIndexStyle(3+i*2,DRAW_LINE);
	  				SetIndexStyle(4+i*2,DRAW_LINE);
	  			}
	  		}
  		}
  	}
   
  }