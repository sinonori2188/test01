//+------------------------------------------------------------------+
//|                                         level_sensor_116_GFF.mq4 |
//| Modified by                                          googolyenfx |
//|                               http://googolyenfx.blog18.fc2.com/ |
//|                                                                  |
//| Original source code                        level_sensor_116.mq4 |
//| Original copyright                       Copyright © 2005, Sfen  |
//+------------------------------------------------------------------+
#property copyright "googolyenfx"
#property link      "http://googolyenfx.blog18.fc2.com/"

#property indicator_chart_window
// input parameters
extern int MAX_HISTORY = 500;
extern int STEP = 1;
extern color Clr = Red;
//----
string OBJECT_PREFIX = "LEVELS";
int ObjectId = 0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CSH(int shift)
  {
   return (MathMax(Open[shift], Close[shift]));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CSL(int shift)
  {
   return (MathMin(Open[shift],Close[shift]));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ObGetUniqueName(int id)
{
	return (OBJECT_PREFIX + " " + DoubleToStr(id, 0));
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ObDeleteObjectsByPrefix()
{
	for (int i = 0; i < ObjectId; i++) {
		string name = ObGetUniqueName(i);
		if (ObjectFind(name) != -1) {
			ObjectDelete(name);
		}
	}
	ObjectId = 0;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObDeleteObjectsByPrefix();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
{
	if (IndicatorCounted() != 0 && !IsNewCandle()) {
		return (0);
	}
	
	ObDeleteObjectsByPrefix();
	
	int History = MathMin(Bars,MAX_HISTORY);
	int i;
	double HH = MathMax(Close[iHighest(Symbol(), Period(), MODE_CLOSE, History, 1)],
						Open[iHighest(Symbol(), Period(), MODE_OPEN, History, 1)]
					);
	double LL = MathMin(Close[iLowest(Symbol(), Period(), MODE_CLOSE, History, 1)],
						Open[iLowest(Symbol(), Period(), MODE_OPEN, History, 1)]
					);
	int NumberOfPoints = (HH - LL) / (1.0*Point*STEP) + 1;
	int Count[1];
	ArrayResize(Count, NumberOfPoints);
	ArrayInitialize(Count, 0);
	
	for(i = 1; i < History; i++) {
		double fin = CSH(i);
		for (double C = CSL(i); C < fin; C += 1.0*Point*STEP) {
			int Index = (C-LL) / (1.0*Point*STEP);
			Count[Index]++;
		}
	}
	
	for(i = 0; i < NumberOfPoints; i++) {
		double StartX = Time[5];
		double StartY = LL + 1.0*Point*STEP*i;
		double EndX   = Time[5+Count[i]];
		double EndY   = StartY;
		string ObjName = ObGetUniqueName(ObjectId);
		ObjectDelete(ObjName);
		ObjectCreate(ObjName, OBJ_TREND, 0, StartX, StartY, EndX, EndY);
		ObjectSet(ObjName, OBJPROP_RAY, 0);
		ObjectSet(ObjName, OBJPROP_COLOR, Clr);
		ObjectId++;
	}
	return(0);
}
//+------------------------------------------------------------------+

bool IsNewCandle()
{
	static datetime dt = 0;
	
	if (Time[0] != dt) {
		dt = Time[0];
		return(true);
	}
	return(false);
}