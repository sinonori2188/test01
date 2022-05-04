//+------------------------------------------------------------------+
//|                                                     airlogic.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, "
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 8

#property indicator_width1 3
#property indicator_color1 Red
#property indicator_width2 3
#property indicator_color2 Aqua
#property indicator_width3 3
#property indicator_color3 White
#property indicator_width4 3
#property indicator_color4 White
#property indicator_width5 3
#property indicator_color5 Orange
#property indicator_width6 3
#property indicator_color6 Magenta
#property indicator_width7 3
#property indicator_color7 Lime
#property indicator_width8 3
#property indicator_color8 Purple

double Buffer_0[];
double Buffer_1[];
double Buffer_2[];
double Buffer_3[];
double Buffer_4[];
double Buffer_5[];
double Buffer_6[];
double Buffer_7[];

int OnInit()
  {
   IndicatorBuffers(8);
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
   
   SetIndexBuffer(4,Buffer_4);
   SetIndexStyle(4,DRAW_ARROW); 
   SetIndexArrow(4,241);
     
   SetIndexBuffer(5,Buffer_5);  
   SetIndexStyle(5,DRAW_ARROW);
   SetIndexArrow(5,241);
   
   SetIndexBuffer(6,Buffer_6);
   SetIndexStyle(6,DRAW_ARROW); 
   SetIndexArrow(6,242);
     
   SetIndexBuffer(7,Buffer_7);  
   SetIndexStyle(7,DRAW_ARROW);
   SetIndexArrow(7,242);      
   
  /*  datetime nowtime;
   nowtime = StrToTime(uselimitet);    
   if( iTime(NULL,0,1) > nowtime ){
      Alert("利用期限を過ぎました。");
      return(INIT_FAILED);
   }*/
   
   return(INIT_SUCCEEDED);
  }



enum limitdate1{
                    oned,//１日
                    week,//１週間
                    month,//１ヶ月
                    maxbar
                    };
extern limitdate1 limitdate = week;//勝率表示期間

extern int Maxbars = 2000;//対象本数範囲
extern int mchange = 0;//マーチン回数（0回/1回/2回）
extern int labelpos2 = 1;//通貨名ラベル位置
extern int labelhigh2 = 15;//通貨名ラベル高さ
extern int labelsize2 = 10;//通貨名ラベル大きさ
extern double pips = 0.3;//サイン表示位置調整
extern color labelcolor2 = Yellow;//通貨名ラベルカラー
extern int labelpos = 1;//勝率ラベル位置
extern int labelhigh = 30;//勝率ラベル高さ
extern int labelsize = 10;//勝率ラベル大きさ
extern color labelcolor = Yellow;//勝率ラベルカラー
extern int hantei = 0;//判定本数
extern int stopcnt = 0;//停止ロウソク足本数
extern bool haikei = true;//背景onoff 
extern color signcolor= Red;//サインの背景色

extern string Note1="";//移動平均線
extern int ma_period = 3;//移動平均線の期間
extern int ma_method = 1;//（SMA0EMA1）
extern int bopoint =0;//MA何ポイント離れていたらサイン

extern string Note2="";//RSI
extern int RSIPeriod = 5;//RSIの期間
extern int rsiup = 55;//RSIlowサイン○○以上
extern int rsidn = 45;//RSIhighサイン○○以下

int point1,point2 =0;
int NowBars, NowBars2, NowBars3, RealBars,a, b, c, d, e, f, Timeframe = 0;
int minute, minute2, mminute, m2minute = 0;
int dnminute, dnminute2, dnmminute, dnm2minute = 0;
bool flag1, flag2, upentryflag, dnentryflag, martinflag, martinflag2, dnmartinflag, dnmartinflag2 = false;
double martin1price, martin2price, dnmartin1price, dnmartin2price;
double eprice, eprice2, upwincnt, uplosecnt, dnwincnt, dnlosecnt, uptotalcnt, dntotalcnt, uppercent, dnpercent, totalpercent, totalwin, totallose;
bool Certification = false;


int upcnt, dncnt, Hantei = 0;
int p,q= 0;
int ST, ET;
double ma1,rsi;

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
   /*if(!Certification){
      if(!UseSystem(AccountNumber())){
         Certification = false;
         Comment("Invalid Account");
         return(0);
      }
      else{
         Certification = true; 
         Comment("Valid Account");        
      }
   }
   
   datetime ET;
   ET = StrToTime(uselimitet);    
   if( TimeCurrent() > ET ) return(0);*/
   
    if(ChartPeriod(0) == 1){Timeframe = 2;}
    if(ChartPeriod(0) == 5){Timeframe = 4;}
    if(ChartPeriod(0) == 15){Timeframe = 6;}
    if(ChartPeriod(0) == 30){Timeframe = 8;}
    if(ChartPeriod(0) == 60){Timeframe = 10;}
    if(ChartPeriod(0) == 240){Timeframe = 15;}
    if(ChartPeriod(0) == 1440){Timeframe = 20;}
    
int limit = Bars - IndicatorCounted()-1;

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
      
      
      
    ma1 = iMA(NULL,0,ma_period,0,ma_method,0,i);
    rsi = iRSI(NULL,0,RSIPeriod,0,i+1);
    double now = iClose(NULL,0,i); 
    double open = iOpen(NULL,0,i); 
    double close = iClose(NULL,0,i); 
   // Comment(rsi);      
       if(i == 0){ //リアルタイムでサインを出したり消したりしたい場合はこちらも使う。if文の中は下の出の記述と同じでOK  

          Buffer_0[i] = EMPTY_VALUE;
          Buffer_0[i] = 0;
          Buffer_1[i] = EMPTY_VALUE;
          Buffer_1[i] = 0;                                 
           ChartSetInteger(0,CHART_COLOR_BACKGROUND,Black);
           
          if(upcnt == 0){
             if( open+bopoint*Point<ma1 && close+bopoint*Point<ma1 && rsi<=rsidn){
                 Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                 if(RealBars < Bars){
                     Alert(Symbol()+" M"+Period()+" High Sign");
                     if(haikei==true){ ChartSetInteger(0,CHART_COLOR_BACKGROUND,signcolor);}
                     RealBars = Bars;
                     SendMail("High Sign", "High Sign");
                 }
             }
          }
          
          if(dncnt == 0){
             if( open>ma1+bopoint*Point && close>ma1+bopoint*Point && rsi>=rsiup){
                 Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                 if(RealBars < Bars){
                     Alert(Symbol()+" M"+Period()+" Low Sign");
                     if(haikei==true){ ChartSetInteger(0,CHART_COLOR_BACKGROUND,signcolor);}
                     RealBars = Bars;
                     SendMail("Low Sign", "Low Sign");    
                 }
             } 
          }                     
       }
              
                
      if(i > 1 || (i == 1 && NowBars < Bars)){ 
          NowBars = Bars;
         
                         
            //勝敗判定-----------------------------------------------------------------------------------------------------------------
          if(upentryflag == true){
              if(p <= 1){Hantei = hantei;}
              else{Hantei = hantei+1;}  
              //if(p <= 1){hantei = hantei-1;}            
              if(minute == Hantei){  
                  if(eprice < iClose(NULL,0,i)){            
                      Buffer_2[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                      upentryflag = false;
                      upwincnt++;                                 
                  }                  
                  else{ 
                           upentryflag = false;
                          
                           uplosecnt++; 
                               
                                                                                                                                                                                                       
                   }
                   minute = 0;
              }
          minute++;   
          
          }  
          
          
          
          if(dnentryflag == true){
              if(q <= 1){Hantei = hantei;}
              else{Hantei = hantei+1;}              
              if(dnminute == Hantei){                    
                  if(eprice2 > iClose(NULL,0,i)){            
                      Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*pips*15*Point;
                      dnentryflag = false;
                      dnwincnt++;                                 
                  }                  
                  else{       
                           dnentryflag = false;
                          
                           
                              dnlosecnt++; 
                                                                                                                                                                              
                   }
                   dnminute = 0;
              }
          dnminute++;   
          
          }  
          
          
          
                        
//-------確定足サイン---------                
                
          if(i > 0){         
             if(dncnt >= 1){dncnt++;}
             if(upcnt >= 1){upcnt++;}
             
             if(dncnt >= stopcnt+2){dncnt = 0;}
             if(upcnt >= stopcnt+2){upcnt = 0;}   
         
             if(upcnt == 0){
             if( open+bopoint*Point<ma1 && close+bopoint*Point<ma1 && rsi<=rsidn){
                 Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                 upentryflag = true;
                 eprice = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" High Sign");}
                 upcnt = 1;
                 if(p <= 1){p++;}
             }
          }
          
          if(dncnt == 0){
             if( open>ma1+bopoint*Point && close>ma1+bopoint*Point && rsi>=rsiup){
                 Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                 dnentryflag = true;
                 eprice2 = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" Low Sign");}
                 dncnt = 1;
                 if(q <= 1){q++;}
             } 
          }    
          }                
          
                    
             ObjectCreate("counttotal1",OBJ_LABEL,0,0,0);
             ObjectSet("counttotal1",OBJPROP_CORNER,labelpos);
             ObjectSet("counttotal1",OBJPROP_XDISTANCE,5);
             ObjectSet("counttotal1",OBJPROP_YDISTANCE,30);
             
             ObjectCreate("counttotal2",OBJ_LABEL,0,0,0);
             ObjectSet("counttotal2",OBJPROP_CORNER,labelpos);
             ObjectSet("counttotal2",OBJPROP_XDISTANCE,5);
             ObjectSet("counttotal2",OBJPROP_YDISTANCE,45);     
             
             ObjectCreate("counttotal3",OBJ_LABEL,0,0,0);
             ObjectSet("counttotal3",OBJPROP_CORNER,labelpos);
             ObjectSet("counttotal3",OBJPROP_XDISTANCE,5);
             ObjectSet("counttotal3",OBJPROP_YDISTANCE,60);                        
                   
                   
             uptotalcnt = upwincnt + uplosecnt;      
             dntotalcnt = dnwincnt + dnlosecnt;      
             totalwin = upwincnt+dnwincnt;
             totallose = uplosecnt+dnlosecnt;
                          
             if(upwincnt > 0){uppercent = MathRound((upwincnt / uptotalcnt)*100);} else uppercent = 0;
             if(dnwincnt > 0){dnpercent = MathRound((dnwincnt / dntotalcnt)*100);} else dnpercent = 0;
             if(totalwin > 0){totalpercent = MathRound((totalwin / (totalwin+totallose))*100);} else totalpercent = 0;

             ObjectSetText("counttotal1", "UP: 勝"+upwincnt+" 負"+uplosecnt+" 勝率"+uppercent+"%", labelsize, "MS ゴシック",Yellow);       
             ObjectSetText("counttotal2", "DN: 勝"+dnwincnt+" 負"+dnlosecnt+" 勝率"+dnpercent+"%", labelsize, "MS ゴシック",Yellow);     
             ObjectSetText("counttotal3", "TTL: 勝"+totalwin+" 負"+totallose+" 勝率"+totalpercent+"%", labelsize, "MS ゴシック",Yellow);     
                    
      }//NowBars
      
   
   
   


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


  Comment("");
		
   return(0);
}// end of deinit()------------+
