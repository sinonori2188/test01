//+------------------------------------------------------------------+
//|                                                     Anchorfx.mq4 |
//|                                                        forexlion |
//|                                         http://www.anchorfx.com/ |
//+------------------------------------------------------------------+
#property copyright "forexlion"
#property link      "http://www.anchorfx.com/"

#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
ObjectsDeleteAll();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   
//----
ObjectsDeleteAll();
Comment("http://www.anchorfx.com/");
double Hi, Li, C;

double yesterday_high, yesterday_low, yesterday_close, D;
int h = DayOfWeek();

   C = iClose(Symbol(),PERIOD_D1,h+1);
   if (DayOfWeek() != 1) {D=iClose(Symbol(),PERIOD_D1,1);}
   
   Hi = iHighest(Symbol(),PERIOD_D1,MODE_HIGH,6,h+1);
   Li = iLowest(Symbol(),PERIOD_D1,MODE_LOW,6,h+1);

yesterday_high = iHigh(Symbol(),PERIOD_D1,Hi);
yesterday_low = iLow(Symbol(),PERIOD_D1,Li);
yesterday_close = C;

double R = yesterday_high - yesterday_low;//range
double p = (yesterday_high + yesterday_low + yesterday_close)/3;// Standard Pivot
double r3 = p + (R * 1.000);
double r2 = p + (R * 0.618);
double r1 = p + (R * 0.382);
double s1 = p - (R * 0.382);
double s2 = p - (R * 0.618);
double s3 = p - (R * 1.000);
double fp1 = p + (R * 0.236);
double fn1 = p - (R * 0.236);
double fp2 = p + (R * 0.5);
double fn2 = p - (R * 0.5);
double fp3 = p + (R * 0.782);
double fn3 = p - (R * 0.782);


string lbl[15], lbl2[15];
int n = 10;

lbl[3] = "L1";
lbl2[3] = "Pivot : " + DoubleToStr(p,4);
lbl[2] = "L2";
lbl2[2] = "R1 : " + DoubleToStr(r1,4);
lbl[1] = "L3";
lbl2[1] = "R2 : " + DoubleToStr(r2,4);
lbl[0] = "L4";
lbl2[0] = "R3 : " + DoubleToStr(r3,4);

lbl[4] = "L5";
lbl2[4] = "S1 : " + DoubleToStr(s1,4);
lbl[5] = "L6";
lbl2[5] = "S2 : " + DoubleToStr(s2,4);
lbl[6] = "L7";
lbl2[6] = "S3 : " + DoubleToStr(s3,4);

double S1 = MarketInfo(Symbol(), MODE_TICKVALUE) / 10;
double S2 = AccountBalance() / S1;
double cl = iClose(Symbol(),PERIOD_W1,0);
double lw = iLow(Symbol(),PERIOD_W1,0);
double hi = iHigh(Symbol(),PERIOD_W1,0);
double vol = iVolume(Symbol(),PERIOD_W1,0);
double bw = ((cl - lw) * vol)/((cl-lw)+(hi-cl));
double sw = ((hi - cl) * vol)/((cl-lw)+(hi-cl));
double pw;
if (bw > sw) 
{
   pw = bw/sw;
}
if (sw > bw) 
{
   pw = sw/bw;
}
lbl[7] = "L8";
lbl2[7] = "Buyers : " + DoubleToStr(bw,0);
lbl[8] = "L9";
lbl2[8] = "Sellers : " + DoubleToStr(sw,0);
lbl[9] = "L10";
lbl2[9] = "Power : " + DoubleToStr(pw,0);

string signal;
if (Bid < D) {signal = "Short Possible";}
if (Bid > D) {signal = "Long Possible";}
lbl[10] = "L11";
lbl2[10] = signal;

//trend calculation
double trend = (iClose(Symbol(),PERIOD_W1,0)-iOpen(Symbol(),PERIOD_W1,0))/(iHigh(Symbol(),PERIOD_W1,0)-iLow(Symbol(),PERIOD_W1,0));
lbl[11] = "L12";
lbl2[11] = DoubleToStr(trend,4);

for (int u=0;u<ArraySize(lbl);u++)
{
ObjectCreate(lbl[u],23,0,Time,PRICE_CLOSE);
ObjectSet(lbl[u],OBJPROP_XDISTANCE,610);
ObjectSet(lbl[u],OBJPROP_YDISTANCE,n);
ObjectSetText(lbl[u],lbl2[u],14,"Arial",Green);
n = n+20;
}

drawLine(r3,"R3", Green,0);
drawLabel("Resistance 3 - " + DoubleToStr(r3,4),r3,Green);
drawLine(r2,"R2", Green,0);
drawLabel("Resistance 2 - " + DoubleToStr(r2,4),r2,Green);
drawLine(r1,"R1", Green,0);
drawLabel("Resistance 1 - " + DoubleToStr(r1,4),r1,Green);

drawLine(p,"PIVOT",Green,1);
drawLabel("PIVOT level - " + DoubleToStr(p,4),p,Green);

drawLine(D,"DAILY",Green,2);
drawLabel("DAILY level - " + DoubleToStr(D,4),D,Green);

drawLine(s1,"S1",Green,0);
drawLabel("Support 1 - " + DoubleToStr(s1,4),s1,Green);
drawLine(s2,"S2",Green,0);
drawLabel("Support 2 - " + DoubleToStr(s2,4),s2,Green);
drawLine(s3,"S3",Green,0);
drawLabel("Support 3 - " + DoubleToStr(s3,4),s3,Green);

drawLine(fp1,"fp1",Yellow,1);
drawLabel("+ 23.6% - " + DoubleToStr(fp1,4),fp1,Green);
drawLine(fn1,"fn1",Yellow,1);
drawLabel("- 23.6% - " + DoubleToStr(fn1,4),fn1,Green);

drawLine(fp2,"fp2",Yellow,1);
drawLabel("+ 50% - " + DoubleToStr(fp2,4),fp2,Green);
drawLine(fn2,"fn2",Yellow,1);
drawLabel("- 50% - " + DoubleToStr(fn2,4),fn2,Green);

drawLine(fp3,"fp3",Yellow,1);
drawLabel("+ 78.2% - " + DoubleToStr(fp3,4),fp3,Green);
drawLine(fn3,"fn3",Yellow,1);
drawLabel("- 78.2% - " + DoubleToStr(fn3,4),fn3,Green);

//----
   return(0);
  }
//+------------------------------------------------------------------+
void drawLabel(string name,double lvl,color Color)
{
    if(ObjectFind(name) != 0)
    {
        ObjectCreate(name, OBJ_TEXT, 0, Time[10], lvl);
        ObjectSetText(name, name, 14, "Arial", EMPTY);
        ObjectSet(name, OBJPROP_COLOR, Color);
    }
    else
    {
        ObjectMove(name, 0, Time[10], lvl);
    }
}


void drawLine(double lvl,string name, color Col,int type)
{
         if(ObjectFind(name) != 0)
         {
            ObjectCreate(name, OBJ_HLINE, 0, Time[0], lvl,Time[0],lvl);
            
            if(type == 1)
            ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
            else
            ObjectSet(name, OBJPROP_STYLE, STYLE_DOT);
            
            ObjectSet(name, OBJPROP_COLOR, Col);
            ObjectSet(name,OBJPROP_WIDTH,1);
            
         }
         else
         {
            ObjectDelete(name);
            ObjectCreate(name, OBJ_HLINE, 0, Time[0], lvl,Time[0],lvl);
            
            if(type == 1)
            ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
            else
            ObjectSet(name, OBJPROP_STYLE, STYLE_DOT);
            
            ObjectSet(name, OBJPROP_COLOR, Col);        
            ObjectSet(name,OBJPROP_WIDTH,1);
          
         }
}