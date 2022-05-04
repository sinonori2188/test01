//+------------------------------------------------------------------+
//|                                                     Template.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ands"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots   4

#property indicator_type1  DRAW_ARROW
#property indicator_width1 3
#property indicator_color1 Red
#property indicator_label1  "Buy"

#property indicator_type2  DRAW_ARROW
#property indicator_width2 3
#property indicator_color2 Aqua
#property indicator_label2  "Sell"

#property indicator_type3  DRAW_ARROW
#property indicator_width3 3
#property indicator_color3 White
#property indicator_label3  "MARU"

#property indicator_type4  DRAW_ARROW
#property indicator_width4 3
#property indicator_color4 White
#property indicator_label4  "BATSU"

double HIGHSIGN[];
double LOWSIGN[];
double MARU[];
double BATSU[];



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,HIGHSIGN,INDICATOR_DATA);
   PlotIndexSetInteger(0,PLOT_ARROW,233);
   
   SetIndexBuffer(1,LOWSIGN,INDICATOR_DATA);  
   PlotIndexSetInteger(1,PLOT_ARROW,234);

   SetIndexBuffer(2,MARU,INDICATOR_DATA);
   PlotIndexSetInteger(2,PLOT_ARROW,161); 
   
   SetIndexBuffer(3,BATSU,INDICATOR_DATA);  
   PlotIndexSetInteger(3,PLOT_ARROW,251);
   
   
   
//---
   return(INIT_SUCCEEDED);
  }
  
void OnDeinit(const int reason){
	
   for(i = ObjectsTotal(0,0,OBJ_LABEL)-1; 0 <= i; i--) {
	   string ObjName=ObjectName(0,i,0,OBJ_LABEL);
	   if(StringFind(ObjName, "counttotal") >= 0)
   	      ObjectDelete(0,ObjName); 	               	  
   }


  Comment("");
		

}// end of deinit()

enum limitdate1
  {
   hour1,//1時間
   day1,//１日
   week,//１週間
   month,//１ヶ月
   year,//1年
   maxbar
  };
  
input limitdate1 limitdate = week;//勝率表示期間
input int Maxbars = 1000000;//↑↑【maxbarの時】対象本数範囲
input int labelsize = 10;//勝率ラベル大きさ
input int labelpos = 1;//勝率ラベル表示位置(0~3)
input double pips = 0.2;//サイン表示位置調整
input int mchange = 0;//マーチン回数（0回/1回/2回）
input int hantei = 1;//判定本数
input int stopcnt = 5;//サインを停止させる本数
input bool timeout = false;//指定時間除外適用
input string Note0 = "";//MT4時間------------------
input int startt = 21;//〇〇時~
input int startm = 30;//〇〇分~
input int endt = 22;//~〇〇時
input int endm = 30;//~〇〇分

input string Note1="";//サンプル：<ストキャス>（不要の場合は削除、もしくは別要素に変更）
input int K = 5;//%K
input int D = 3;//%D
input int S = 3;//スローイング
input int stoue = 80;//上レベル
input int stosita = 20;//下レベル


int NowBars, NowBars2, NowBars3, RealBars,a, b, c, d, e, f, Timeframe,i,to_copy,limit = 0;
int minute, minute2, mminute, m2minute = 0;
int dnminute, dnminute2, dnmminute, dnm2minute = 0;
bool flag1, flag2, upentryflag, dnentryflag, martinflag, martinflag2, dnmartinflag, dnmartinflag2 = false;
double martin1price, martin2price, dnmartin1price, dnmartin2price;
double eprice, eprice2, upwincnt, uplosecnt, dnwincnt, dnlosecnt, uptotalcnt, dntotalcnt, uppercent, dnpercent, totalpercent, totalwin, totallose;
bool Certification = false;
//定番のRSI/ボリバン/ストキャスの変数はあらかじめ用意
double rsi, boup, bodn, rsi1, boup1, bodn1, boliup, bolidown, boup2, bodn2, stoa, stob;
int upcnt, dncnt, Hantei = 0;
int p,q= 0;
int ST, ET;
double stomain[],stosignal[];
  
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
   if(ChartPeriod(0) == PERIOD_M1){Timeframe = 2;}
   if(ChartPeriod(0) == PERIOD_M5){Timeframe = 4;}
   if(ChartPeriod(0) == PERIOD_M15){Timeframe = 6;}
   if(ChartPeriod(0) == PERIOD_M30){Timeframe = 8;}
   if(ChartPeriod(0) == PERIOD_H1){Timeframe = 10;}
   if(ChartPeriod(0) == PERIOD_H4){Timeframe = 15;}
   if(ChartPeriod(0) == PERIOD_D1){Timeframe = 20;}
   
  
   
   int STO_Handle=iStochastic(NULL,0,K,D,S,MODE_SMA,STO_LOWHIGH);
   if(STO_Handle==INVALID_HANDLE) Print(" Failed to get handle of the Stochastic indicator");
   
   
   if(BarsCalculated(STO_Handle)<rates_total) return(0);
   
   
   limit=rates_total-prev_calculated; 
   limit = MathMin(limit, rates_total-2);
   
   if(limitdate == hour1)
     {
      limit = MathMin(limit,60/Period());
     }
   if(limitdate == day1)
     {
      limit = MathMin(limit,1440/Period());
     }
   if(limitdate == week)
     {
      limit = MathMin(limit,7200/Period());
     }
   if(limitdate == month)
     {
      limit = MathMin(limit,31600/Period());
     }
   if(limitdate == year)
     {
      limit = MathMin(limit,396000/Period());
     }  
   if(limitdate == maxbar)
     {
      limit = MathMin(limit, Maxbars);
     }
   
   
   to_copy=limit+2;
   
   
   if(CopyBuffer(STO_Handle,MAIN_LINE,0,to_copy,stomain)<=0) return(0);
   if(CopyBuffer(STO_Handle,SIGNAL_LINE,0,to_copy,stosignal)<=0) return(0);
   
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(close,true);
   
   ArraySetAsSeries(HIGHSIGN,true);
   ArraySetAsSeries(LOWSIGN,true);
   ArraySetAsSeries(MARU,true);
   ArraySetAsSeries(BATSU,true);
   
   ArraySetAsSeries(stomain,true);
   ArraySetAsSeries(stosignal,true);
   
   
   
   for(i=limit; i>=0 && !IsStopped(); i--)
     {
     
   if(timeout == true){         
       int hour2, hour3, hour4,zikan,hun;
       MqlDateTime h1,m1;
       TimeToStruct(iTime(NULL,PERIOD_CURRENT,i),h1);
       TimeToStruct(iTime(NULL,PERIOD_CURRENT,i),m1);
       
       zikan =h1.hour;
       hun = m1.min;
       
       Comment(zikan);
       
       hour2 = zikan + 0;
       if(24 <= hour2 ){
          hour2 = hour2 - 24;
       }
       
       int ST = startt;
       int ET = endt;

       
       if(ST+1 == 24){hour3 = 0;}
       else{hour3 = ST+1;}
      
       if(ET+1 == 24){hour4 = 0;}
       else{hour4 = ET+1;}

       if(startt < endt){            
          if(flag1 == false && ((hour2 == ST && hun >= startm) || hour2 >= hour3)){
              flag1 = true;
          }
          
          if(flag1 == true && 
              ((hour2 == ET && hun >= endm) || (hour2 >= hour4)/* || sflag == true*/)
              ){
              flag1 = false;                  
          }     
       }
       if(startt > endt){
          if(flag1 == false && ((hour2 == ST && hun >= startm) || hour2 >= hour3)){
              flag1 = true;
          }
                
          if(flag1 == true && hour2 < ST &&
              ((hour2 == ET && hun >= endm) || (hour2 >= hour4)/* || sflag == true*/)            
              ){
              flag1 = false;                
          }             
       } 
      }
      else{flag1 = false;}
      
    
      
     if(flag1==false){ 
   
    
    if(i == 0){ //リアルタイムでサインを出したり消したりしたい場合はこちらも使う。if文の中は下の出の記述と同じでOK  

       /*   HIGH[i] = EMPTY_VALUE;
          LOW[i] = EMPTY_VALUE;                             
          
          if(dncnt == 0){
             if(){
                 HIGH[i] = iLow(NULL,0,i)-Timeframe*pips*5*_Point;
                 if(RealBars < rates_total){
                     Alert(Symbol()+" M"+Period()+" High Sign");
                     RealBars = rates_total;
                 }
             }
          }
          
          if(upcnt == 0){
             if(){
                 LOW[i] = iHigh(NULL,0,i)+Timeframe*pips*5*_Point;
                 if(RealBars < rates_total){
                     Alert(Symbol()+" M"+Period()+" Low Sign");
                     RealBars = rates_total; 
                 }
             } 
          }*/                      
       }
   
     if(i > 1 || (i == 1 && NowBars < rates_total)){ 
          NowBars = rates_total;
         
                         
          //勝敗判定-----------------------------------------------------------------------------------------------------------------
          //上矢印判定--------------------
          if(upentryflag == true){
              if(p <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(minute == Hantei){        
                  if(eprice < iClose(NULL,0,i)){            
                      MARU[i] = iLow(NULL,0,i)-Timeframe*pips*5*_Point;
                      upentryflag = false;
                      upwincnt++;                                 
                  }                  
                  else{
                           BATSU[i] = iLow(NULL,0,i)-Timeframe*pips*5*_Point;   
                           upentryflag = false; 
                           if(mchange == 1 || mchange == 2){
                              martinflag = true;
                              martin1price = iClose(NULL,0,i);                                                  
                              if(i == 1){Alert(Symbol()," M"+_Period,"  FirstMartin HIGH  ");}     
                           }
                           if(mchange == 0){
                              uplosecnt++; 
                           }                                                                                                                        
                   }
                   minute = 0;
              } 
          minute++;   
          mminute = 0;
          m2minute = 0;
          }
          
          //マーチン1回目--------------------
          if(martinflag == true){
              if(mminute == hantei){                          
                  if(martin1price < iClose(NULL,0,i)){  
                      MARU[i] = iLow(NULL,0,i)-Timeframe*pips*5*_Point;
                      upwincnt++;                  
                      martinflag = false;              
                  }
                  else{
                           BATSU[i] = iLow(NULL,0,i)-Timeframe*pips*5*_Point;                           
                           martinflag = false;  
                           if(mchange == 2){
                              martin2price = iClose(NULL,0,i);              
                              martinflag2 = true;                                    
                              if(i == 1){Alert(Symbol()," M"+_Period,"  SecondMartin HIGH  ");}   
                           }
                           if(mchange == 1){
                              uplosecnt++; 
                           }                                                                                                                                                            
                  }  
                  mminute = 0;                
              }
              mminute++;
          }
          
          //マーチン2回目--------------------
          if(martinflag2 == true){
              if(m2minute == hantei){    
                  if(martin2price < iClose(NULL,0,i)){  
                      MARU[i] = iLow(NULL,0,i)-Timeframe*pips*5*_Point;
                      upwincnt++;                  
                      martinflag2 = false;              
                  }
                  else{
                           BATSU[i] = iLow(NULL,0,i)-Timeframe*pips*5*_Point;                                             
                           martinflag2 = false;                
                           uplosecnt++;                                                                                                             
                  }    
                  m2minute = 0;              
              }
              m2minute++;
          }     
          
           
          //下矢印判定--------------------          
          if(dnentryflag == true){  
              if(q <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(minute2 == Hantei){      
                  if(eprice2 > iClose(NULL,0,i)){           
                     MARU[i] = iHigh(NULL,0,i)+Timeframe*pips*10*_Point;
                     dnentryflag = false;         
                     dnwincnt++;            
                  }
                  
                  else{
                           BATSU[i] = iHigh(NULL,0,i)+Timeframe*pips*10*_Point;
                           dnentryflag = false;
                           if(mchange == 1 || mchange == 2){
                              dnmartinflag = true;
                              dnmartin1price = iClose(NULL,0,i);                                                  
                              if(i == 1){Alert(Symbol()," M"+_Period,"  FirstMartin LOW  ");}    
                           } 
                           if(mchange == 0){
                              dnlosecnt++; 
                           }            
                   }
              minute2 = 0;
              } 
          minute2++;   
          dnmminute = 0;
          dnm2minute = 0;
          }
 
          //マーチン1回目--------------------
          if(dnmartinflag == true){
              if(dnmminute == hantei){                          
                  if(dnmartin1price > iClose(NULL,0,i)){  
                      MARU[i] = iHigh(NULL,0,i)+Timeframe*pips*10*_Point;
                      dnwincnt++;                  
                      dnmartinflag = false;              
                  }
                  else{
                           BATSU[i] = iHigh(NULL,0,i)+Timeframe*pips*10*_Point;                           
                           dnmartinflag = false; 
                           if(mchange == 2){
                              dnmartin2price = iClose(NULL,0,i);              
                              dnmartinflag2 = true;                                    
                              if(i == 1){Alert(Symbol()," M"+_Period,"  SecondMartin LOW  ");}   
                           }
                           if(mchange == 1){
                              dnlosecnt++; 
                           }                                                                                                                                                         
                  }  
                  dnmminute = 0;                
              }
              dnmminute++;
          }
          
          //マーチン2回目--------------------
          if(dnmartinflag2 == true){
              if(dnm2minute == hantei){    
                  if(dnmartin2price > iClose(NULL,0,i)){  
                      MARU[i] = iHigh(NULL,0,i)+Timeframe*pips*10*_Point;
                      dnwincnt++;                  
                      dnmartinflag2 = false;              
                  }
                  else{
                           BATSU[i] = iHigh(NULL,0,i)+Timeframe*pips*10*_Point;                                             
                           dnmartinflag2 = false;                
                           dnlosecnt++;                                                                                                             
                  }    
                  dnm2minute = 0;              
              }
              dnm2minute++;
          }   
                   
      
          if(dncnt >= 1){dncnt++;}
          if(upcnt >= 1){upcnt++;}
          
          if(dncnt > stopcnt){dncnt = 0;}
          if(upcnt > stopcnt){upcnt = 0;}
          
          if(upcnt == 0){//プログラムの際はこちらのコメントアウトを解除してif文の中を書きましょう。
             if(stomain[i+1]>stosita&&stomain[i]<=stosita){
                 HIGHSIGN[i] = iLow(NULL,0,i)-Timeframe*pips*5*_Point;
                 upentryflag = true;
                 eprice = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" High Sign");}
                 upcnt = 1;
                 if(p <= 1){p++;}
             }
          }
          
          if(dncnt == 0){
             if(stomain[i+1]<stoue&&stomain[i]>=stoue){
                 LOWSIGN[i] = iHigh(NULL,0,i)+Timeframe*pips*5*_Point;
                 dnentryflag = true;
                 eprice2 = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" Low Sign");}
                 dncnt = 1;
                 if(q <= 1){q++;}
             } 
          }                    
          
                    
             
             ObjectCreate(0,"counttotal1",OBJ_LABEL,0,0,0);
             ObjectSetInteger(0,"counttotal1",OBJPROP_CORNER,labelpos);
             ObjectSetInteger(0,"counttotal1",OBJPROP_XDISTANCE,5);
             ObjectSetInteger(0,"counttotal1",OBJPROP_YDISTANCE,30);
             ObjectSetInteger(0,"counttotal1",OBJPROP_FONTSIZE,labelsize);
             ObjectSetString(0,"counttotal1",OBJPROP_FONT,"MS ゴシック");
             ObjectSetInteger(0,"counttotal1",OBJPROP_COLOR,Yellow);
             
             ObjectCreate(0,"counttotal2",OBJ_LABEL,0,0,0);
             ObjectSetInteger(0,"counttotal2",OBJPROP_CORNER,labelpos);
             ObjectSetInteger(0,"counttotal2",OBJPROP_XDISTANCE,5);
             ObjectSetInteger(0,"counttotal2",OBJPROP_YDISTANCE,45);  
             ObjectSetInteger(0,"counttotal2",OBJPROP_FONTSIZE,labelsize);
             ObjectSetString(0,"counttotal2",OBJPROP_FONT,"MS ゴシック");
             ObjectSetInteger(0,"counttotal2",OBJPROP_COLOR,Yellow);   
             
             ObjectCreate(0,"counttotal3",OBJ_LABEL,0,0,0);
             ObjectSetInteger(0,"counttotal3",OBJPROP_CORNER,labelpos);
             ObjectSetInteger(0,"counttotal3",OBJPROP_XDISTANCE,5);
             ObjectSetInteger(0,"counttotal3",OBJPROP_YDISTANCE,60);                        
             ObjectSetInteger(0,"counttotal3",OBJPROP_FONTSIZE,labelsize);
             ObjectSetString(0,"counttotal3",OBJPROP_FONT,"MS ゴシック");
             ObjectSetInteger(0,"counttotal3",OBJPROP_COLOR,Yellow);     
                   
             uptotalcnt = upwincnt + uplosecnt;      
             dntotalcnt = dnwincnt + dnlosecnt;      
             totalwin = upwincnt+dnwincnt;
             totallose = uplosecnt+dnlosecnt;
                          
             if(upwincnt > 0){uppercent = MathRound((upwincnt / uptotalcnt)*100);} else uppercent = 0;
             if(dnwincnt > 0){dnpercent = MathRound((dnwincnt / dntotalcnt)*100);} else dnpercent = 0;
             if(totalwin > 0){totalpercent = MathRound((totalwin / (totalwin+totallose))*100);} else totalpercent = 0;

             ObjectSetString(0,"counttotal1", OBJPROP_TEXT,"UP: 勝"+DoubleToString(upwincnt,0)+" 負"+DoubleToString(uplosecnt,0)+" 勝率"+DoubleToString(uppercent,0)+"%");       
             ObjectSetString(0,"counttotal2", OBJPROP_TEXT, "DN: 勝"+DoubleToString(dnwincnt,0)+" 負"+DoubleToString(dnlosecnt,0)+" 勝率"+DoubleToString(dnpercent,0)+"%");     
             ObjectSetString(0,"counttotal3", OBJPROP_TEXT,  "TTL: 勝"+DoubleToString(totalwin,0)+" 負"+DoubleToString(totallose,0)+" 勝率"+DoubleToString(totalpercent,0)+"%");
      }//NowBars
   
   
   }
   
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
