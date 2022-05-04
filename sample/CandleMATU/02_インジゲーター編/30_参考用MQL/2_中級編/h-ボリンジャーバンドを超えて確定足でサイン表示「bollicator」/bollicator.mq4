//+------------------------------------------------------------------+
//|                                                bollicator.mq4 |
//|                                             Copyright 2018, ands |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, ands"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 14
#include <MovingAverages.mqh>

#property indicator_width1 3
#property indicator_color1 Red
#property indicator_width2 3
#property indicator_color2 Aqua
#property indicator_width3 2
#property indicator_color3 White
#property indicator_width4 2
#property indicator_color4 Orange
#property indicator_width5 2
#property indicator_color5 Magenta
#property indicator_color6 LightSeaGreen
#property indicator_color7 LightSeaGreen
#property indicator_color8 LightSeaGreen
#property indicator_color9 Pink
#property indicator_color10 Pink
#property indicator_width11 2
#property indicator_color11 SkyBlue
#property indicator_width12 2
#property indicator_color12 LightSeaGreen
#property indicator_width13 2
#property indicator_color13 White

double Buffer_0[];
double Buffer_1[];
double Buffer_2[];
double Buffer_3[];
double Buffer_4[];
double Buffer_5[];
double Buffer_6[];
double Buffer_7[];

double ExtMovingBuffer[];
double ExtUpperBuffer[];
double ExtLowerBuffer[];
double ExtUpper2Buffer[];
double ExtLower2Buffer[];
double ExtStdDevBuffer[];

int OnInit()
  {
   IndicatorBuffers(14);
   
   SetIndexBuffer(0,Buffer_0);
   SetIndexStyle(0,DRAW_ARROW); 
   SetIndexArrow(0,241);
     
   SetIndexBuffer(1,Buffer_1);  
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,242);

   SetIndexBuffer(2,Buffer_2); //まる
   SetIndexStyle(2,DRAW_ARROW); 
   SetIndexArrow(2,161);
     
   SetIndexBuffer(3,Buffer_3);  //上向きm１
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,225);   
  
   SetIndexBuffer(4,Buffer_4);  //上向きm２
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexArrow(4,233);      
   
   SetIndexBuffer(10,Buffer_5);//下向きm１
   SetIndexStyle(10,DRAW_ARROW); 
   SetIndexArrow(10,226);
     
   SetIndexBuffer(11,Buffer_6);  //下向きm２
   SetIndexStyle(11,DRAW_ARROW);
   SetIndexArrow(11,234);   
  
   SetIndexBuffer(12,Buffer_7);  //バツ
   SetIndexStyle(12,DRAW_ARROW);
   SetIndexArrow(12,251);         
   
//--- middle line
   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,ExtMovingBuffer);
   SetIndexShift(5,InpBandsShift);
   SetIndexLabel(5,"Bands SMA");
//--- upper band
   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(6,ExtUpperBuffer);
   SetIndexShift(6,InpBandsShift);
   SetIndexLabel(6,"Bands Upper");
//--- lower band
   SetIndexStyle(7,DRAW_LINE);
   SetIndexBuffer(7,ExtLowerBuffer);
   SetIndexShift(7,InpBandsShift);
   SetIndexLabel(7,"Bands Lower");
//--- upper2 band
   SetIndexStyle(8,DRAW_LINE);
   SetIndexBuffer(8,ExtUpper2Buffer);
   SetIndexShift(8,InpBandsShift);
   SetIndexLabel(8,"Bands Upper2");
//--- lower2 band
   SetIndexStyle(9,DRAW_LINE);
   SetIndexBuffer(9,ExtLower2Buffer);
   SetIndexShift(9,InpBandsShift);
   SetIndexLabel(9,"Bands Lower2");   
//--- work buffer
   SetIndexBuffer(13,ExtStdDevBuffer);
//--- check for input parameter
     
   
   if(mperiod5<=0)
     {
      Print("Wrong input parameter Bands Period=",mperiod5);
      return(INIT_FAILED);
     }
//---
   SetIndexDrawBegin(5,mperiod5+InpBandsShift);
   SetIndexDrawBegin(6,mperiod5+InpBandsShift);
   SetIndexDrawBegin(7,mperiod5+InpBandsShift);  
   SetIndexDrawBegin(8,mperiod5+InpBandsShift);
   SetIndexDrawBegin(9,mperiod5+InpBandsShift);       
   
   wincnt = 0;
   losecnt = 0;
   ObjectDelete("counttotal");
   
   return(INIT_SUCCEEDED);
  }

enum limitdate1{
                    day,//１日
                    week,//１週間
                    month,//１ヶ月
                    year,//１年
                    };
extern limitdate1 limitdate = month;//勝率表示期間
extern int labelsize = 10;//勝率ラベル大きさ
extern double pips = 0.5;//サイン表示位置調整
int hantei = 1;//判定本数
extern int stopcnt = 5;//サイン停止本数(最低1~)
extern int martin = 2;//マーチン回数(２回まで)
//ボリンジャーバンド-------------------------------------------------------------------
extern string Note05 = "";//ボリンジャーバンド-----------------------------------------
extern ENUM_APPLIED_PRICE price5 = 0;//計算方法
extern int mperiod5 = 5;//ミドルライン期間
extern double hensa5 = 1.5;//内側偏差        
extern double hensa5a = 3.0;//外側偏差  
enum naname5{
                    zero5=0,//斜線
                    one5= 1,//塗りつぶし
                    };
naname5 boliline5 = 0;//ゾーンタイプ1
enum style5{
                    solid5=STYLE_SOLID,//実線
                    dot5=STYLE_DOT,//点線
                    };
extern style5 bolistyle5;//ゾーン線種類
extern color bolicolor5 = Orange;//ゾーン色

int NowBars, RealBars,a, b, c, d, e, f, j, Timeframe = 0;
int minute, minute2, mminute, m2minute = 0;
int dnminute, dnminute2, dnmminute, dnm2minute = 0;
bool flag1, flag2, upentryflag, dnentryflag, martinflag, martinflag2, dnmartinflag, dnmartinflag2 = false;
double eprice, eprice2, wincnt, losecnt, totalcnt, percent, martin1price, martin2price, dnmartin1price, dnmartin2price;
bool Certification = false;

int    InpBandsShift=0;// バンドシフト
double boli1up, boli2up, boli1down, boli2down;
int bolicnt, p, q, Hantei = 0;

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
   
    if(ChartPeriod(0) == 1){Timeframe = 2;}
    if(ChartPeriod(0) == 5){Timeframe = 4;}
    if(ChartPeriod(0) == 15){Timeframe = 6;}
    if(ChartPeriod(0) == 30){Timeframe = 8;}
    if(ChartPeriod(0) == 60){Timeframe = 10;}
    if(ChartPeriod(0) == 240){Timeframe = 15;}
    if(ChartPeriod(0) == 1440){Timeframe = 20;}
    Timeframe = Timeframe*pips;

int i;    
int limit = Bars - IndicatorCounted()-1;
if(limitdate == day){
   limit = MathMin(limit,1440/Period());
}
if(limitdate == week){
   limit = MathMin(limit,7200/Period());
}
if(limitdate == month){
   limit = MathMin(limit,33000/Period());
}
if(limitdate == year){
   limit = MathMin(limit,396000/Period());
}
for(i = limit; i >= 0; i--){  
      //if(i == 0 && RealBars < Bars){}
      if(i > 1 || (i == 1 && NowBars < Bars)){ 
          NowBars = Bars;
          
          boli1up = iBands(NULL,0,mperiod5,hensa5,0,price5,1,i);
          boli2up = iBands(NULL,0,mperiod5,hensa5a,0,price5,1,i);
          boli1down = iBands(NULL,0,mperiod5,hensa5,0,price5,2,i);
          boli2down = iBands(NULL,0,mperiod5,hensa5a,0,price5,2,i);
          
                 
          //勝敗判定-----------------------------------------------------------------------------------------------------------------
          if(martinflag2 == true){
              if(m2minute == Hantei){    
                  if(martin2price < iClose(NULL,0,i)){  
                      Buffer_2[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                      wincnt++;                  
                      martinflag2 = false;              
                  }
                  else{
                           Buffer_7[i] = iLow(NULL,0,i)-Timeframe*5*Point;                                             
                           martinflag2 = false;                
                           losecnt++;                                                                                                             
                  }    
                  m2minute = 0;              
              }
              m2minute++;
          }       
          
          if(martinflag == true){          
              if(mminute == Hantei){                          
                  if(martin1price < iClose(NULL,0,i)){  
                      Buffer_2[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                      wincnt++;                  
                      martinflag = false;              
                  }
                  else{
                           if(martin == 1){
                               Buffer_7[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                               losecnt++;
                               martinflag = false;
                           }
                           if(martin == 2){
                               Buffer_4[i] = iLow(NULL,0,i)-Timeframe*5*Point;                           
                               martin2price = iClose(NULL,0,i);              
                               martinflag2 = true;                                    
                               if(i == 1){Alert(Symbol()," M"+Period(),"  SecondMartin HIGH  ");}   
                               martinflag = false;
                           }                                                                                                                             
                  }  
                  mminute = 0;                
              }
              mminute++;
          }

          if(upentryflag == true){
              if(p <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(minute == Hantei){        
                  if(eprice < iClose(NULL,0,i)){            
                      Buffer_2[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                      upentryflag = false;
                      wincnt++;                                 
                  }                  
                  else{
                           if(martin == 0){
                               Buffer_7[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                               losecnt++;
                               upentryflag = false;
                           }
                           if(martin == 1 || martin == 2){
                               Buffer_3[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                               martinflag = true;
                               martin1price = iClose(NULL,0,i);                                                  
                               if(i == 1){Alert(Symbol()," M"+Period(),"  FirstMartin HIGH  ");}     
                               upentryflag = false;                  
                           }                                                                                                      
                   }
                   minute = 0;
              }
          minute++;   
          }  
                                    
//-------------------------------------------------------------------
          if(dnmartinflag2 == true){
              if(dnm2minute == Hantei){    
                  if(dnmartin2price > iClose(NULL,0,i)){  
                      Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                      wincnt++;                  
                      dnmartinflag2 = false;              
                  }
                  else{
                           Buffer_7[i] = iHigh(NULL,0,i)+Timeframe*15*Point;                                             
                           dnmartinflag2 = false;                
                           losecnt++;                                                                                                             
                  }    
                  dnm2minute = 0;              
              }
              dnm2minute++;
          }       
          
          if(dnmartinflag == true){
              if(dnmminute == Hantei){                          
                  if(dnmartin1price > iClose(NULL,0,i)){  
                      Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                      wincnt++;                  
                      dnmartinflag = false;              
                  }
                  else{
                           if(martin == 1){
                               Buffer_7[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                               losecnt++;
                               dnmartinflag = false;
                           }
                           if(martin == 2){
                               Buffer_6[i] = iHigh(NULL,0,i)+Timeframe*15*Point;                           
                               dnmartin2price = iClose(NULL,0,i);              
                               dnmartinflag2 = true;                                    
                               if(i == 1){Alert(Symbol()," M"+Period(),"  SecondMartin LOW  ");}   
                               dnmartinflag = false;       
                           }                                                                                                                      
                  }  
                  dnmminute = 0;                
              }
              dnmminute++;
          }
          
          if(dnentryflag == true){
              if(q <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(dnminute == Hantei){  
                  if(eprice2 > iClose(NULL,0,i)){            
                      Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                      dnentryflag = false;
                      wincnt++;                                 
                  }                  
                  else{
                           if(martin == 0){
                               Buffer_7[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                               losecnt++;
                               dnentryflag = false;
                           }
                           if(martin == 1 || martin == 2){
                               Buffer_5[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                               dnmartinflag = true;
                               dnmartin1price = iClose(NULL,0,i);                                                  
                               if(i == 1){Alert(Symbol()," M"+Period(),"  FirstMartin LOW  ");}     
                               dnentryflag = false;   
                           }                                                                                                                     
                   }
                   dnminute = 0;
              }
          dnminute++;   
          }  
          


          if(bolicnt >= 1){
              bolicnt++;
          }
          if(bolicnt == stopcnt+2){
              bolicnt = 0;
          }
              
          if(iClose(NULL,0,i) < boli1down && bolicnt == 0){
              Buffer_0[i] = iLow(NULL,0,i)-Timeframe*5*Point;
              upentryflag = true;
              eprice = iClose(NULL,0,i);
              if(i==1){Alert(Symbol()+" M"+Period()+" High Sign");}
              bolicnt++;
              if(p <= 1){p++;}
          }
          
          if(iClose(NULL,0,i) > boli1up && bolicnt == 0){
              Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*10*Point;
              dnentryflag = true;
              eprice2 = iClose(NULL,0,i);
              if(i==1){Alert(Symbol()+" M"+Period()+" Low Sign");}
              bolicnt++;
              if(q <= 1){q++;}
          }
          
                 
             ObjectCreate("counttotal",OBJ_LABEL,0,0,0);
             ObjectSet("counttotal",OBJPROP_CORNER,1);
             ObjectSet("counttotal",OBJPROP_XDISTANCE,5);
             ObjectSet("counttotal",OBJPROP_YDISTANCE,15);
                   
             totalcnt = wincnt + losecnt;      
             if(wincnt > 0){percent = MathRound((wincnt / totalcnt)*100);} else percent = 0;
             
             ObjectSetText("counttotal", "Win"+wincnt+"回"+" Lose: "+losecnt+"回"+" 勝率: "+percent+"%", labelsize, "MS ゴシック",White);         
      
      

       //if(i < 5000){      
          
          j++;
          ObjectCreate(0,"boliup"+IntegerToString(j),OBJ_TREND,0,0,0,0,0);
          ObjectSetDouble(0,"boliup"+IntegerToString(j),OBJPROP_PRICE1,boli1up);
          ObjectSetInteger(0,"boliup"+IntegerToString(j),OBJPROP_TIME1,iTime(NULL,0,i+boliline5));
          ObjectSetDouble(0,"boliup"+IntegerToString(j),OBJPROP_PRICE2,boli2up);
          ObjectSetInteger(0,"boliup"+IntegerToString(j),OBJPROP_TIME2,iTime(NULL,0,i));
          ObjectSetInteger(0,"boliup"+IntegerToString(j),OBJPROP_RAY,false);
          ObjectSetInteger(0,"boliup"+IntegerToString(j),OBJPROP_STYLE,bolistyle5);
          ObjectSetInteger(0,"boliup"+IntegerToString(j),OBJPROP_COLOR,bolicolor5);  
          ObjectSetInteger(0,"boliup"+IntegerToString(j),OBJPROP_WIDTH,1);  
          ObjectSetInteger(0,"boliup"+IntegerToString(j),OBJPROP_BACK,true);           // オブジェクトの背景表示設定
          ObjectSetInteger(0,"boliup"+IntegerToString(j),OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定  
          ObjectSetInteger(0,"boliup"+IntegerToString(j),OBJPROP_HIDDEN,true); 
                
          ObjectCreate(0,"bolidown"+IntegerToString(j),OBJ_TREND,0,0,0,0,0);
          ObjectSet("bolidown"+IntegerToString(j),OBJPROP_PRICE1,boli1down);
          ObjectSet("bolidown"+IntegerToString(j),OBJPROP_TIME1,iTime(NULL,0,i+boliline5));
          ObjectSet("bolidown"+IntegerToString(j),OBJPROP_PRICE2,boli2down);
          ObjectSet("bolidown"+IntegerToString(j),OBJPROP_TIME2,iTime(NULL,0,i));
          ObjectSet("bolidown"+IntegerToString(j),OBJPROP_RAY,false);
          ObjectSet("bolidown"+IntegerToString(j),OBJPROP_STYLE,bolistyle5);
          ObjectSet("bolidown"+IntegerToString(j),OBJPROP_COLOR,bolicolor5);  
          ObjectSet("bolidown"+IntegerToString(j),OBJPROP_WIDTH,1);        
          ObjectSetInteger(0,"bolidown"+IntegerToString(j),OBJPROP_BACK,true);           // オブジェクトの背景表示設定
          ObjectSetInteger(0,"bolidown"+IntegerToString(j),OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定  
          ObjectSetInteger(0,"bolidown"+IntegerToString(j),OBJPROP_HIDDEN,true);      
       //}      
      }//NowBars
}      
      
   int pos;
   if(rates_total<=mperiod5 || mperiod5<=0)
      return(0);
//--- counting from 0 to rates_total
   ArraySetAsSeries(ExtMovingBuffer,false);
   ArraySetAsSeries(ExtUpperBuffer,false);
   ArraySetAsSeries(ExtLowerBuffer,false);
   ArraySetAsSeries(ExtUpper2Buffer,false);
   ArraySetAsSeries(ExtLower2Buffer,false);   
   ArraySetAsSeries(ExtStdDevBuffer,false);
   ArraySetAsSeries(close,false);
//--- initial zero
   if(prev_calculated<1)
     {
      for(i=0; i<mperiod5; i++)
        {
         ExtMovingBuffer[i]=EMPTY_VALUE;
         ExtUpperBuffer[i]=EMPTY_VALUE;
         ExtLowerBuffer[i]=EMPTY_VALUE;
         ExtUpper2Buffer[i]=EMPTY_VALUE;
         ExtLower2Buffer[i]=EMPTY_VALUE;         
        }
     }
//--- starting calculation
   if(prev_calculated>1)
      pos=prev_calculated-1;
   else
      pos=0;
//--- main cycle
   for(i=pos; i<rates_total && !IsStopped(); i++)
     {
      //--- middle line
      ExtMovingBuffer[i]=SimpleMA(i,mperiod5,close);
      //--- calculate and write down StdDev
      ExtStdDevBuffer[i]=StdDev_Func(i,close,ExtMovingBuffer,mperiod5);
      //--- upper line
      ExtUpperBuffer[i]=ExtMovingBuffer[i]+hensa5*ExtStdDevBuffer[i];
      //--- lower line
      ExtLowerBuffer[i]=ExtMovingBuffer[i]-hensa5*ExtStdDevBuffer[i];
      //--- upper2 line
      ExtUpper2Buffer[i]=ExtMovingBuffer[i]+hensa5a*ExtStdDevBuffer[i];
      //--- lower2 line
      ExtLower2Buffer[i]=ExtMovingBuffer[i]-hensa5a*ExtStdDevBuffer[i];      
      //---
     }  
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
 int deinit(){
	
   for(int i = ObjectsTotal()-1; 0 <= i; i--) {
	   string ObjName=ObjectName(i);
	   if(StringFind(ObjName, "counttotal") >= 0)
   	      ObjectDelete(ObjName); 	               	  
   }
   
   for(int i = ObjectsTotal()-1; 0 <= i; i--) {
	   string ObjName=ObjectName(i);
	   if(StringFind(ObjName, "price") >= 0)
   	      ObjectDelete(ObjName);
	   if(StringFind(ObjName, "prev") >= 0)
   	      ObjectDelete(ObjName);
	   if(StringFind(ObjName, "bosys") >= 0)
   	      ObjectDelete(ObjName);   	      
	   if(StringFind(ObjName, "boliup") >= 0)
   	      ObjectDelete(ObjName);   	      
	   if(StringFind(ObjName, "bolidown") >= 0)
   	      ObjectDelete(ObjName);   	               	  
   }   


  Comment("");
		
   return(0);
}// end of deinit()

//+------------------------------------------------------------------+
double StdDev_Func(int position,const double &price[],const double &MAprice[],int period)
  {
//--- variables
   double StdDev_dTmp=0.0;
//--- check for position
   if(position>=period)
     {
      //--- calcualte StdDev
      for(int i=0; i<period; i++)
         StdDev_dTmp+=MathPow(price[position-i]-MAprice[position],2);
      StdDev_dTmp=MathSqrt(StdDev_dTmp/period);
     }
//--- return calculated value
   return(StdDev_dTmp);
  }
//+------------------------------------------------------------------+