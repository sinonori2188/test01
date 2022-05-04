//+------------------------------------------------------------------+
//|                                                     sokanRSI.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_separate_window

#property indicator_buffers 5
#property indicator_width1 2
#property indicator_color1 Red
#property indicator_width2 2
#property indicator_color2 Aqua
#property indicator_width3 2
#property indicator_color3 Yellow
#property indicator_width4 2
#property indicator_color4 Green
#property indicator_width5 2
#property indicator_color5 Orange
#property indicator_level1 70
#property indicator_level2 30
#property indicator_maximum 100
#property indicator_minimum 0


double JPYRSI[];
double USDRSI[];
double EURRSI[];
double GBPRSI[];
double AUDRSI[];

extern int RSIPeriod     = 7; //RSI期間
extern bool JPY = true;
extern bool USD = true;
extern bool EUR = true;
extern bool GBP = true;
extern bool AUD = true;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   IndicatorBuffers(5);
   SetIndexBuffer(0,JPYRSI);
   SetIndexLabel(0,"JPYRSI");
   
   SetIndexBuffer(1,USDRSI);
   SetIndexLabel(1,"USDRSI");
   
   SetIndexBuffer(2,EURRSI); 
   SetIndexLabel(2,"EURRSI"); 
      
   SetIndexBuffer(3,GBPRSI);
   SetIndexLabel(3,"GBPRSI");
   
   SetIndexBuffer(4,AUDRSI);
   SetIndexLabel(4,"AUDRSI");
  
  ObjectCreate("label",OBJ_LABEL,1,0,0);
  ObjectSet("label",OBJPROP_CORNER,1);
  ObjectSet("label",OBJPROP_XDISTANCE,0);
  ObjectSet("label",OBJPROP_YDISTANCE,0);
  
  
  if(AUD==true)ObjectSetText("label", "AUD", 12, "UD デジタル 教科書体 N-R",Orange);else ObjectDelete("label");
 
  ObjectCreate("label1",OBJ_LABEL,1,0,0);
  ObjectSet("label1",OBJPROP_CORNER,1);
  ObjectSet("label1",OBJPROP_XDISTANCE,40);
  ObjectSet("label1",OBJPROP_YDISTANCE,0);
  
  
  if(GBP==true)ObjectSetText("label1", "GBP", 12, "UD デジタル 教科書体 N-R",Green);else ObjectDelete("label1");
  
  ObjectCreate("label2",OBJ_LABEL,1,0,0);
  ObjectSet("label2",OBJPROP_CORNER,1);
  ObjectSet("label2",OBJPROP_XDISTANCE,80);
  ObjectSet("label2",OBJPROP_YDISTANCE,0);
  
  
  if(EUR==true)ObjectSetText("label2", "EUR", 12, "UD デジタル 教科書体 N-R",Yellow);else ObjectDelete("label2");
  
  ObjectCreate("label3",OBJ_LABEL,1,0,0);
  ObjectSet("label3",OBJPROP_CORNER,1);
  ObjectSet("label3",OBJPROP_XDISTANCE,120);
  ObjectSet("label3",OBJPROP_YDISTANCE,0);
  
  
  if(USD==true)ObjectSetText("label3", "USD", 12, "UD デジタル 教科書体 N-R",Aqua);else ObjectDelete("label3");
  
  ObjectCreate("label4",OBJ_LABEL,1,0,0);
  ObjectSet("label4",OBJPROP_CORNER,1);
  ObjectSet("label4",OBJPROP_XDISTANCE,160);
  ObjectSet("label4",OBJPROP_YDISTANCE,0);
  
  
  if(JPY==true)ObjectSetText("label4", "JPY", 12, "UD デジタル 教科書体 N-R",Red);else ObjectDelete("label4");
  
   return(0);
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


 int limit = Bars - IndicatorCounted()-1;
 for(int i = limit; i >= 0; i--){
 
 double rsi = iRSI(NULL,0,RSIPeriod,0,i);
 
 if(JPY == true){
 double usdjpy0 = MathAbs(iRSI("USDJPY",0,RSIPeriod,0,i)-100);
 double eurjpy0 = MathAbs(iRSI("EURJPY",0,RSIPeriod,0,i)-100);
 double gbpjpy0 = MathAbs(iRSI("GBPJPY",0,RSIPeriod,0,i)-100);
 double audjpy0 = MathAbs(iRSI("AUDJPY",0,RSIPeriod,0,i)-100);
 
 JPYRSI[i]=(usdjpy0+eurjpy0+gbpjpy0+audjpy0)/4;
 
 }
 
 if(EUR == true){
 double eurusd1 = MathAbs(iRSI("EURUSD",0,RSIPeriod,0,i));
 double eurjpy1 = MathAbs(iRSI("EURJPY",0,RSIPeriod,0,i));
 double eurgbp1 = MathAbs(iRSI("EURGBP",0,RSIPeriod,0,i));
 double euraud1 = MathAbs(iRSI("EURAUD",0,RSIPeriod,0,i));
 
 EURRSI[i]=(eurusd1+eurjpy1+eurgbp1+euraud1)/4;
 
 }
 
 if(USD == true){
 double eurusd2 = MathAbs(iRSI("EURUSD",0,RSIPeriod,0,i)-100);
 double usdjpy2 = MathAbs(iRSI("USDJPY",0,RSIPeriod,0,i));
 double gbpusd2 = MathAbs(iRSI("GBPUSD",0,RSIPeriod,0,i)-100);
 double audusd2 = MathAbs(iRSI("AUDUSD",0,RSIPeriod,0,i)-100);
 
 USDRSI[i]=(eurusd2+usdjpy2+gbpusd2+audusd2)/4;
 
 }
 
  if(GBP == true){
 double gbpusd3 = MathAbs(iRSI("GBPUSD",0,RSIPeriod,0,i));
 double gbpjpy3 = MathAbs(iRSI("GBPJPY",0,RSIPeriod,0,i));
 double eurgbp3 = MathAbs(iRSI("EURGBP",0,RSIPeriod,0,i)-100);
 double gbpaud3 = MathAbs(iRSI("GBPAUD",0,RSIPeriod,0,i));
 
 GBPRSI[i]=(gbpusd3+gbpjpy3+eurgbp3+gbpaud3)/4;
 
 }
 
 if(AUD == true){
 double audusd4 = MathAbs(iRSI("AUDUSD",0,RSIPeriod,0,i));
 double audjpy4 = MathAbs(iRSI("AUDJPY",0,RSIPeriod,0,i));
 double euraud4 = MathAbs(iRSI("EURAUD",0,RSIPeriod,0,i)-100);
 double gbpaud4 = MathAbs(iRSI("GBPAUD",0,RSIPeriod,0,i)-100);
 
 AUDRSI[i]=(audusd4+audjpy4+euraud4+gbpaud4)/4;
 }
 
 
 
 }
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }

 int deinit(){
	
   for(int i = ObjectsTotal()-1; 0 <= i; i--) {
	   string ObjName=ObjectName(i);
	   if(StringFind(ObjName, "label") >= 0)
   	      ObjectDelete(ObjName); 	               	  
   }


  Comment("");
		
   return(0);
}// end of deinit()