//+------------------------------------------------------------------+
//|                                                  Custom MACD.mq4 |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2007, Herb Spirit, Inc."
#property  link      "http://www.herbspirit.com/mql"

#define INDICATOR_NAME		"MACD_Colored"
#define INDICATOR_VERSION	"v102"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 4
#property  indicator_color1  Lime
#property  indicator_color2  Red
#property  indicator_color3  Yellow
#property  indicator_color4  Silver
#property  indicator_style4  STYLE_DOT
#property  indicator_level1  45	
#property  indicator_level2  30	
#property  indicator_level3  15	
#property  indicator_level4  -15	
#property  indicator_level5  -30	
#property  indicator_level6  -45	
#property  indicator_levelcolor  Gray
#property  indicator_levelstyle  STYLE_DOT
//---- indicator parameters
extern int FastEMA=5;
extern int SlowEMA=13;
extern int SignalSMA=1;
extern double MinDiff=0;
extern int FontSize=8;
extern color FontColor=Silver;
//---- indicator buffers
double     MacdBuffer[];
double     MacdBufferUp[];
double     MacdBufferDn[];
double     MacdBufferEq[];
double     SignalBuffer[];

//bool firsttime=true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexStyle(3,DRAW_LINE);
   SetLevelValue(0,45);
   SetLevelValue(1,30);
   SetLevelValue(2,15);
   SetLevelValue(3,-15);
   SetLevelValue(4,-30);
   SetLevelValue(5,-45);
   SetIndexDrawBegin(1,SignalSMA);
   IndicatorDigits(1);
//---- indicator buffers mapping
   SetIndexBuffer(0,MacdBufferUp);
   SetIndexBuffer(1,MacdBufferDn);
   SetIndexBuffer(2,MacdBufferEq);
   SetIndexBuffer(3,SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName(WindowExpertName()+" ("+FastEMA+","+SlowEMA+","+SignalSMA+")");
   SetIndexLabel(0,"MACD UP");
   SetIndexLabel(1,"MACD DN");
   SetIndexLabel(2,"MACD EQ");
   SetIndexLabel(3,"Signal");
//---- initialization done
   return(0);
}

int deinit()
{
	string objname=WindowExpertName()+","+Symbol()+","+Period();
	ObjectDelete(objname);
}
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   limit=MathMin(Bars-SlowEMA,Bars-counted_bars+1);
//   if(!firsttime)
//   	Print("LIMIT=",limit);
   ArrayResize(MacdBuffer,limit);
   ArraySetAsSeries(MacdBuffer,true);
//---- macd counted in the 1-st buffer
   for(int i=0;i<limit;i++) {
      MacdBuffer[i]=(iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-
      		iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i))/Point;
   }
   for(i=limit-2;i>=0;i--)
   {
   	if(MathAbs(MacdBuffer[i]-MacdBuffer[i+1])<MinDiff)
   	{
  			MacdBufferEq[i]=MacdBuffer[i];
  			MacdBufferUp[i]=0;
  			MacdBufferDn[i]=0;
   	}
   	else
   	{
   		if(MacdBuffer[i]>MacdBuffer[i+1])
	   	{
   			MacdBufferUp[i]=MacdBuffer[i];
   			MacdBufferDn[i]=0;
   			MacdBufferEq[i]=0;
	   	}
   		else
   		{
   			MacdBufferDn[i]=MacdBuffer[i];
	   		MacdBufferUp[i]=0;
   			MacdBufferEq[i]=0;
   		}
   	}
   }
//---- signal line counted in the 2-nd buffer
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(MacdBuffer,Bars,SignalSMA,0,MODE_SMA,i);
//---- change color calculation
	double priMACD=(iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,1)-
      		iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,1))/Point;
   double close[];
   ArrayResize(close,Bars);
   ArraySetAsSeries(close,true);
   ArrayCopy(close,Close,0,0,ArraySize(close));
	double curMACD=(iMAOnArray(close,0,FastEMA,0,MODE_EMA,0)-
      		iMAOnArray(close,0,SlowEMA,0,MODE_EMA,0))/Point;
//   for(int x=0;x<ArraySize(close);x++)
//   	Print(x,"=",close[x]);
	int pips;
//	Print("PRI=",priMACD," BUF=",MacdBuffer[1]);
//	Print("CUR=",curMACD," BUF=",MacdBuffer[0]);
	if(curMACD<priMACD)
	{
		while(curMACD<priMACD)
		{
			pips++;
			close[0]+=Point;
			curMACD=(iMAOnArray(close,0,FastEMA,0,MODE_EMA,0)-
      		iMAOnArray(close,0,SlowEMA,0,MODE_EMA,0))/Point;
//	Print("PIPS=",pips," CLOSE=",close[0]," CUR=",curMACD);
		}
	}
	else
	{
		while(curMACD>priMACD)
		{
			pips--;
			close[0]-=Point;
			curMACD=(iMAOnArray(close,0,FastEMA,0,MODE_EMA,0)-
      		iMAOnArray(close,0,SlowEMA,0,MODE_EMA,0))/Point;
//	Print("PIPS=",pips," CLOSE=",close[0]," CUR=",curMACD);
		}
	}
//   IndicatorShortName(WindowExpertName()+" (Pips "+pips+")");
//	Print(WindowExpertName()," ",
//			WindowFind(WindowExpertName()+" ("+FastEMA+","+SlowEMA+","+SignalSMA+")"));
	string objname=WindowExpertName()+","+Symbol()+","+Period();
	if(ObjectFind(objname)<0)
		ObjectCreate(objname,OBJ_TEXT,
				WindowFind(WindowExpertName()+" ("+FastEMA+","+SlowEMA+","+SignalSMA+")"),
				Time[0]+Period()*60,MacdBuffer[0]/2);
	else
		ObjectMove(objname,0,Time[0]+Period()*60,MacdBuffer[0]/2);
		
	if(pips!=0)
		ObjectSetText(objname,DoubleToStr(pips,0),FontSize,"Courier",FontColor);
	else
		ObjectSetText(objname," ",FontSize,"Courier",FontColor);
//---- done
   return(0);
}
//+------------------------------------------------------------------+