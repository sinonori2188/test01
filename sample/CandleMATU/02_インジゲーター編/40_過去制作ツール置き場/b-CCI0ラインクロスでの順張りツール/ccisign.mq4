//+------------------------------------------------------------------+
//|                                                      ccisign.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, "
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4

#property indicator_width1 3
#property indicator_color1 Red
#property indicator_width2 3
#property indicator_color2 Aqua
#property indicator_width3 3
#property indicator_color3 White
#property indicator_width4 3
#property indicator_color4 White


double Buffer_0[];
double Buffer_1[];
double Buffer_2[];
double Buffer_3[];
double Buffer_4[];

int OnInit()
  {
   IndicatorBuffers(4);
   SetIndexBuffer(0,Buffer_0);
   SetIndexStyle(0,DRAW_ARROW); 
   SetIndexArrow(0,241);
     
   SetIndexBuffer(1,Buffer_1);  
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,242);

   SetIndexBuffer(2,Buffer_2);
   SetIndexStyle(2,DRAW_ARROW); 
   SetIndexArrow(2,161);
     
   SetIndexBuffer(3,Buffer_3);  
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,251);  
  
    return(INIT_SUCCEEDED);
  }

   
   enum limitdate1{
                    oned,//１日
                    week,//１週間
                    month,//１ヶ月
                    maxbar
                    };
                    
extern limitdate1 limitdate = maxbar;//勝率表示期間
                    
extern int Maxbars = 200000;//対象本数範囲
//extern int mchange = 0;//マーチン回数（0回/1回/2回）
int labelpos2 = 1;//通貨名ラベル位置
int labelhigh2 = 5;//通貨名ラベル高さ
int labelsize2 = 14;//通貨名ラベル大きさ
extern double pips = 0.3;//サイン表示位置調整
color labelcolor2 = Yellow;//通貨名ラベルカラー
int labelpos = 1;//勝率ラベル位置
int labelhigh = 30;//勝率ラベル高さ
int labelsize = 15;//勝率ラベル大きさ
color labelcolor = Yellow;//勝率ラベルカラー
extern int hantei = 1;//判定本数
extern int stopcnt = 0;//停止ロウソク足本数


extern int    CCIPeriod     = 14; //CCI期間
extern int cciline = 0;//ライン
extern int ccisa = 0;//変化値




int point1,point2 =0;
int NowBars, NowBars2, NowBars3, RealBars,a, b, c, d, e, f,t, Timeframe = 0;
int minute, minute2, mminute, m2minute = 0;
int dnminute, dnminute2, dnmminute, dnm2minute = 0;
bool flag1, flag2, upentryflag, dnentryflag, martinflag, martinflag2, dnmartinflag, dnmartinflag2 = false;
double martin1price, martin2price, dnmartin1price, dnmartin2price,boup,bodn,now,cci,cci1;
double eprice, eprice2, upwincnt, uplosecnt, dnwincnt, dnlosecnt, uptotalcnt, dntotalcnt, uppercent, dnpercent, totalpercent, totalwin, totallose;
bool Certification,counted = false;


int upcnt, dncnt, Hantei = 0;
int p,q= 0;
int ST, ET;

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
   
    if(ChartPeriod(0) == 1){Timeframe = 2;}
    if(ChartPeriod(0) == 5){Timeframe = 4;}
    if(ChartPeriod(0) == 15){Timeframe = 6;}
    if(ChartPeriod(0) == 30){Timeframe = 8;}
    if(ChartPeriod(0) == 60){Timeframe = 10;}
    if(ChartPeriod(0) == 240){Timeframe = 15;}
    if(ChartPeriod(0) == 1440){Timeframe = 20;}
    
int limit = Bars - IndicatorCounted()-1;

if(limit == Bars-1){ //チャートを更新したときに勝率計算が2倍に増えるエラーを防ぐための処理
 upwincnt = 0;
 uplosecnt = 0; 
 dnwincnt = 0;
 dnlosecnt = 0;
 uptotalcnt  = 0;
 dntotalcnt = 0; 
 uppercent = 0;
 dnpercent = 0;
 totalpercent = 0; 
 totalwin = 0;
 totallose = 0;
 
}

if(ChartPeriod(0) == 1){
    if(limitdate == oned){
       limit = MathMin(limit,1440);//1440
    }
    if(limitdate == week){
       limit = MathMin(limit,7200);//7200
    }
    if(limitdate == month){
       limit = MathMin(limit,31600);//31600
    }
    if(limitdate == maxbar){
       limit = MathMin(limit, Maxbars);//31600
    }
}
if(ChartPeriod(0) == 5){
    if(limitdate == week){
       limit = MathMin(limit,1440);//7200
    }
    
    if(limitdate == oned){
       limit = MathMin(limit,288);//18800
    }
   
    if(limitdate == month){
       limit = MathMin(limit,6320);//31600
    }
    if(limitdate == maxbar){
       limit = MathMin(limit, Maxbars);
    }
}

for(int i = limit; i >= 0; i--){  
      
       
       cci=iCCI(NULL,0,CCIPeriod,PRICE_CLOSE,i);
       cci1=iCCI(NULL,0,CCIPeriod,PRICE_CLOSE,i+1);
       
       
       now = iClose(NULL,0,i); 
       //now1 = iClose(NULL,0,i+1);
          
       
       if(i > 1 || (i == 1 && NowBars < Bars)){ 
          NowBars = Bars;
         
          
                        
          //勝敗判定-----------------------------------------------------------------------------------------------------------------
          //上矢印判定--------------------
          if(upentryflag == true){
              if(p <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(minute == Hantei){        
                  if(eprice < iClose(NULL,0,i)){            
                      Buffer_2[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                      upentryflag = false;
                      upwincnt++;                                 
                  }                  
                  else{
                           Buffer_3[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;   
                           upentryflag = false; 
                          
                           uplosecnt++; 
                                                                                                                                                
                   }
                   minute = 0;
              } 
          minute++;   
          
          }
          
          
           
          //下矢印判定--------------------          
          if(dnentryflag == true){  
              if(q <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(minute2 == Hantei){      
                  if(eprice2 > iClose(NULL,0,i)){           
                     Buffer_2[i] =  iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                     dnentryflag = false;         
                     dnwincnt++;            
                  }
                  
                  else{
                           Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                           dnentryflag = false;
                           t=0;
                           
                           dnlosecnt++; 
                                      
                   }
              minute2 = 0;
              } 
          minute2++;   
          
          }
 
           
                   
      
          if(dncnt >= 1){dncnt++;}
          if(upcnt >= 1){upcnt++;}
          
          if(dncnt > stopcnt){dncnt = 0;}
          if(upcnt > stopcnt){upcnt = 0;}
          
          if(upcnt == 0){
             if(cci1<cciline&&cci>=cciline&& MathAbs(cci-cci1)>=ccisa){
             Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                 upentryflag = true;
                 eprice = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" High Sign");}
                 upcnt = 1;
                 if(p <= 1){p++;}
             }
          }
          
          if(dncnt == 0){
             if(cci1>cciline&&cci<=cciline&& MathAbs(cci-cci1)>=ccisa){
             Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                 dnentryflag = true;
                 eprice2 = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" Low Sign");}
                 dncnt = 1;
                 if(q <= 1){q++;}
             } 
          }                   
          
             ObjectCreate("counttotal",OBJ_LABEL,0,0,0);
             ObjectSet("counttotal",OBJPROP_CORNER,labelpos2);
             ObjectSet("counttotal",OBJPROP_XDISTANCE,5);
             ObjectSet("counttotal",OBJPROP_YDISTANCE,labelhigh2);
                    
             ObjectCreate("counttotal1",OBJ_LABEL,0,0,0);
             ObjectSet("counttotal1",OBJPROP_CORNER,labelpos);
             ObjectSet("counttotal1",OBJPROP_XDISTANCE,5);
             ObjectSet("counttotal1",OBJPROP_YDISTANCE,labelhigh);
             
             ObjectCreate("counttotal2",OBJ_LABEL,0,0,0);
             ObjectSet("counttotal2",OBJPROP_CORNER,labelpos);
             ObjectSet("counttotal2",OBJPROP_XDISTANCE,5);
             ObjectSet("counttotal2",OBJPROP_YDISTANCE,labelhigh+25);     
             
             ObjectCreate("counttotal3",OBJ_LABEL,0,0,0);
             ObjectSet("counttotal3",OBJPROP_CORNER,labelpos);
             ObjectSet("counttotal3",OBJPROP_XDISTANCE,5);
             ObjectSet("counttotal3",OBJPROP_YDISTANCE,labelhigh+50);                        
                   
                   
             uptotalcnt = upwincnt + uplosecnt;      
             dntotalcnt = dnwincnt + dnlosecnt;      
             totalwin = upwincnt+dnwincnt;
             totallose = uplosecnt+dnlosecnt;
                          
             if(upwincnt > 0){uppercent = MathRound((upwincnt / uptotalcnt)*100);} else uppercent = 0;
             if(dnwincnt > 0){dnpercent = MathRound((dnwincnt / dntotalcnt)*100);} else dnpercent = 0;
             if(totalwin > 0){totalpercent = MathRound((totalwin / (totalwin+totallose))*100);} else totalpercent = 0;
             
             ObjectSetText("counttotal",Symbol(), labelsize2, "MS ゴシック",labelcolor2);
             ObjectSetText("counttotal1", "UP: 勝"+upwincnt+" 負"+uplosecnt+" 勝率"+uppercent+"%", labelsize, "MS ゴシック",labelcolor);       
             ObjectSetText("counttotal2", "DN: 勝"+dnwincnt+" 負"+dnlosecnt+" 勝率"+dnpercent+"%", labelsize, "MS ゴシック",labelcolor);     
             ObjectSetText("counttotal3", "TTL: 勝"+totalwin+" 負"+totallose+" 勝率"+totalpercent+"%", labelsize, "MS ゴシック",labelcolor);    
                    
      }//NowBars
      
   }//timeout



   
//--- return value of prev_calculated for next call
   return(rates_total);
 }
//+------------------------------------------------------------------+
 int deinit(){
	
   for(int i = ObjectsTotal()-1; 0 <= i; i--) {
	   string ObjName=ObjectName(i);
	   if(StringFind(ObjName, "counttotal") >= 0)
   	      ObjectDelete(ObjName); 
   	      	
   	if(StringFind(ObjName, "DA") >= 0)
   	      ObjectDelete(ObjName);                     	  
   }


  Comment("");
		
   return(0);
}// end of deinit()
