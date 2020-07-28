//+------------------------------------------------------------------+
//|                                                RSI-Diversign.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                         https://fx-tradesite.com |
//+------------------------------------------------------------------+
#property copyright "copyright 2019, Ands.llc"
#property link      "https://fx-tradesite.com/"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2

#property indicator_width1 5
#property indicator_color1 Red
#property indicator_width2 5
#property indicator_color2 Red

double Buffer_0[];
double Buffer_1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init(){

	IndicatorBuffers(2);
	SetIndexBuffer(0,Buffer_0);
    SetIndexStyle(0,DRAW_ARROW);
    SetIndexArrow(0,242);
    
    SetIndexBuffer(1,Buffer_1);
    SetIndexStyle(1,DRAW_ARROW);
    SetIndexArrow(1,241);
    
    return(0);

}


//extern int Maxpars = 2000; // 対象本数範囲
extern int range = 100; //ブレイク対象範囲
extern double pips = 1; //サイン表示位置調整
extern bool vline = true; //縦線表示
extern int RSIPeriod = 14; //RSI期間
extern int RSIue = 70; //RSI上ライン
extern int RSIsita = 30; //RSI下ライン

int NowBars, NowABars, NowBar3, RealBars, a, b, c, d, e, f, Timeframe = 0;
int indexhigh, indexlow;
double HPrice, LPrice, highrsi, lowrsi, rsi, now, nowopen;
//+------------------------------------------------------------------+
//| Custom indicator interation function                             |
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

	int limit = Bars - IndicatorCounted() - 1;
    //limit = MathMin(limit, Maxbars);
    
    for(int i = limit; i >= 0; i--) {
    	
        indexhigh = iHighest(NULL, 0 , MODE_HIGH, range, i+2);
        indexlow = iLowest(NULL, 0 , MODE_LOW, range, i+2);
        
        HPrice = iHigh(NULL, 0, indexhigh);
    		//Highext_Time = iTime(NULL, 0, indexhigh);
            
    	  LPrice = iLow(NULL, 0, indexlow);
        	//Lowest_Time = iTime(NULL, 0, indexlow);
    	
        highrsi = iRSI(NULL,0,RSIPeriod,0,indexhigh);
        lowrsi = iRSI(NULL,0,RSIPeriod,0,indexlow);
        
        rsi = iRSI(NULL,0,RSIPeriod,0,i);
        now = iClose(NULL,0,i);
        nowopen = iOpen(NULL,0,i);
        
        Comment(HPrice + "\n" +
               (i + 100) + "\n" +
                i);
    	
        if(i > 1 || (i == 1 && NowBars < Bars)){
        	NowBars = Bars;
            
            if(HPrice < nowopen && HPrice < now && highrsi > rsi && rsi >= RSIue){
            	Buffer_0[i] = iHigh(NULL,0,i) + pips * 10 * Point;
                if(vline == true){
                	//ObjectDelete("Kikana" + IntegerToStringf(b-1);
                    ObjectSet("Kikana" + IntegerToString(b), OBJPROP_COLOR, Red);
                    ObjectSet("Kikana" + IntegerToString(b), OBJPROP_STYLE, STYLE_DOT);
                    b++;
                    
                    //ObjectDelete("kikana" + IntegerToString(a-1));
                    ObjectCreate("Kikanb" + IntegerToString(a), OBJ_VLINE, 0, iTime(NULL,0,indexhigh),0);
                    ObjectSet("kikanb" + IntegerToString(a), OBJPROP_COLOR, Yellow);
                    ObjectSet("kikanb" + IntegerToString(a), OBJPROP_STYLE, STYLE_DOT);
                    a++;
                }
                //if(i==1){Alert(Symbol() + " M" + Period() + " Diver Low Sign");}
            }
                
            if(LPrice > nowopen && LPrice > now && lowrsi > rsi && rsi <= RSIsita){
            	Buffer_1[i] = iLow(NULL, 0, i) - pips*10*Point;
                if(vline == true){
                	//ObjectDelete("kikanb" + IntegerToString(c-1));
                    ObjectCreate("kikanc" + IntegerToString(c), OBJ_VLINE, 0, iTime(NULL,0,i),0);
                    ObjectSet("kikanc" + IntegerToString(c), OBJPROP_COLOR, Red);
                    ObjectSet("kikanc" + IntegerToString(c), OBJPROP_STYLE, STYLE_DOT);
                    c++;
                    
                	//ObjectDelete("kikanb" + IntegerToString(d-1));
                    ObjectCreate("kikanc" + IntegerToString(d), OBJ_VLINE, 0, iTime(NULL,0,indexlow),0);
                    ObjectSet("kikanc" + IntegerToString(d), OBJPROP_COLOR, Yellow);
                    ObjectSet("kikanc" + IntegerToString(d), OBJPROP_STYLE, STYLE_DOT);
                    d++;
                }
            	//if(i==1){Alert(Symbol() + " M" + Period() + " Diver High Sign");}
            }

			if(vline == true){
            	ObjectDelete("kikan");
                ObjectCreate("kikan", OBJ_VLINE, 0, iTime(NULL, 0, range+2), 0);
                ObjectSet("kikan", OBJPROP_COLOR, Red);
            }
        }
    }
    
    return(rates_total);
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
int deinit(){

    ObjectDelete("kikan");

    for(int i = ObjectsTotal(); 1<=i; i--) {
        string objName=ObjectName(i);
        if(StringFind(objName, "counttotal") !=-1)
        	ObjectDelete(objName);
	}

	for(int i = ObjectsTotal()-1; 0<=i; i--) {
    	string objName=ObjectName(i);
        if(StringFind(objName, "kikan") >= 0)
        	ObjectDelete(objName);
    }
    
    Comment("");
    return(0);
        
}




