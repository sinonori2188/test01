//+------------------------------------------------------------------+
//|                                                     XXXX0000.mq4 |
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
   
   /*datetime nowtime;
   nowtime = StrToTime(uselimitet);    
   if( iTime(NULL,0,1) > nowtime ){
      Alert("利用期限を過ぎました。");
      return(INIT_FAILED);
   }
   
   if(!Certification){
      if(!UseSystem(AccountNumber())){
         Certification = false;
         Comment("Invalid Account");
         return(INIT_FAILED);
      }
      else{
         Certification = true; 
         Comment("Valid Account");        
      }
   }   */   
   
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
extern int hantei = 1;//判定本数
extern int stopcnt = 5;//停止ロウソク足本数


extern string Note1="";//RSIボリバン
extern int    RSIPeriod     = 14;//RSI期間
extern double    RSIhaba     = 1.0;//RSIとボリバンの剥離
extern int    BandPeriod    = 20;//ボリバン期間
extern double BandDeviation = 2.0;//偏差
extern int    upline    = 70;//上レベル
extern int    dnline    = 30;//下レベル
extern double    bbsa    = 5;//５本前との剥離
extern bool    bbsign    = true;//５本前との剥離onoff

extern string Note2="";//RSI
extern int rsipe = 2;//短期RSI期間
extern int rsipe1 = 6;//中期RSI期間
extern int rsipe1low = 70;//中期RSILOWサイン○○以上
extern int rsipe1high = 30;//中期RSIHIGHサイン○○以下

extern bool rsimsign = true;//中期RSI変化値onnoff(1本前70以下30以上)
//extern double    rsimsa    = 3;//中期RSI1本前との変化値


extern string Note3="";//<ストキャス>-------------------

extern int K = 7;//%K
extern int D = 1;//%D
extern int S = 1;//スローイング
extern int stoup = 95;//lowサイン時○○以上
extern int stodn = 5;//highサイン時○○以下
extern bool rsissign = true;//ストキャス変化値onnoff(1本前70以下30以上)
//extern double    rsissa    = 5;//ストキャス1本前との変化値


int point1,point2 =0;
int NowBars, NowBars2, NowBars3, RealBars,a, b, c, d, e, f, Timeframe = 0;
int minute, minute2, mminute, m2minute = 0;
int dnminute, dnminute2, dnmminute, dnm2minute = 0;
bool flag1, flag2, upentryflag, dnentryflag, martinflag, martinflag2, dnmartinflag, dnmartinflag2 = false;
double martin1price, martin2price, dnmartin1price, dnmartin2price;
double eprice, eprice2, upwincnt, uplosecnt, dnwincnt, dnlosecnt, uptotalcnt, dntotalcnt, uppercent, dnpercent, totalpercent, totalwin, totallose;
bool Certification = false;
double rsi,rsiboliup,rsibolidn,rsiboli,rsiboli5,bolisa,stoa,stob,rsis,rsim,boup,bodn,rsis1,rsim1,ssa,msa,stoa1,stosa;

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
         
      
       rsis = iRSI(NULL,0,rsipe,0,i);//短期RSI
       rsis1 = iRSI(NULL,0,rsipe,0,i+1);//短期RSI
       
       rsim = iRSI(NULL,0,rsipe1,0,i);//中期RSI
       rsim1 = iRSI(NULL,0,rsipe1,0,i+1);//中期RSI
       
       stoa = iStochastic(NULL,0,K,D,S,0,0,0,i);
       stoa1 = iStochastic(NULL,0,K,D,S,0,0,0,i+1);
       //stob = iStochastic(NULL,0,K,D,S,0,0,1,i);
       rsi = iCustom(NULL,0,"RSI-Bollinger",RSIPeriod,BandPeriod,BandDeviation,0,i);
       rsiboli = iCustom(NULL,0,"RSI-Bollinger",RSIPeriod,BandPeriod,BandDeviation,3,i);
       rsiboli5 = iCustom(NULL,0,"RSI-Bollinger",RSIPeriod,BandPeriod,BandDeviation,3,i+5);
       rsiboliup = iCustom(NULL,0,"RSI-Bollinger",RSIPeriod,BandPeriod,BandDeviation,1,i);
       rsibolidn = iCustom(NULL,0,"RSI-Bollinger",RSIPeriod,BandPeriod,BandDeviation,2,i);
       
       bolisa=rsiboli-rsiboli5;
       ssa=rsis-rsis1;
       msa=rsim-rsim1;
       stosa=stoa-stoa1;
            
       if(i == 0){
          
          Buffer_0[i] = EMPTY_VALUE;
          Buffer_0[i] = 0;
          Buffer_1[i] = EMPTY_VALUE;
          Buffer_1[i] = 0;                                 
          
          if(upcnt == 0){
              if((stoa<rsis&&rsis<rsim&&stoa<stodn&&rsim<rsipe1high)&&
               (rsiboliup<upline&&rsibolidn>dnline&&rsiboliup>rsi+RSIhaba&&rsibolidn<rsi-RSIhaba)&&
               (bbsign==false||bbsign==true&&bbsa>=MathAbs(bolisa))&&
               (rsissign==false||rsissign==true&&stoa1>=30)&&
               (rsimsign==false||rsimsign==true&&rsim1>=30)
               ){
                 Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                 if(RealBars < Bars){
                     Alert(Symbol()+" M"+Period()+" High Sign");
                     RealBars = Bars;
                     SendMail("High Sign", "High Sign");
                 }
             }
          }
          
          if(dncnt == 0){
            if((stoa>rsis&&rsis>rsim&&stoa>stoup&&rsim>rsipe1low)&&
               (rsiboliup<upline&&rsibolidn>dnline&&rsiboliup>rsi+RSIhaba&&rsibolidn<rsi-RSIhaba)&&
                (bbsign==false||bbsign==true&&bbsa>=MathAbs(bolisa))&&
                (rsissign==false||rsissign==true&&stoa1<=70)&&
                (rsimsign==false||rsimsign==true&&rsim1<=70)
                ){
                 Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                 if(RealBars < Bars){
                     Alert(Symbol()+" M"+Period()+" Low Sign");
                     RealBars = Bars;
                     SendMail("Low Sign", "Low Sign");    
                 }
             } 
          }                      
       }
              
                
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
                           if(mchange == 1 || mchange == 2){
                              martinflag = true;
                              martin1price = iClose(NULL,0,i);                                                  
                              if(i == 1){Alert(Symbol()," M"+Period(),"  FirstMartin HIGH  ");}     
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
                      Buffer_2[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                      upwincnt++;                  
                      martinflag = false;              
                  }
                  else{
                           Buffer_3[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;                           
                           martinflag = false;  
                           if(mchange == 2){
                              martin2price = iClose(NULL,0,i);              
                              martinflag2 = true;                                    
                              if(i == 1){Alert(Symbol()," M"+Period(),"  SecondMartin HIGH  ");}   
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
                      Buffer_2[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                      upwincnt++;                  
                      martinflag2 = false;              
                  }
                  else{
                           Buffer_3[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;                                             
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
                     Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                     dnentryflag = false;         
                     dnwincnt++;            
                  }
                  
                  else{
                           Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*pips*15*Point;
                           dnentryflag = false;
                           if(mchange == 1 || mchange == 2){
                              dnmartinflag = true;
                              dnmartin1price = iClose(NULL,0,i);                                                  
                              if(i == 1){Alert(Symbol()," M"+Period(),"  FirstMartin LOW  ");}    
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
                      Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*pips*15*Point;
                      dnwincnt++;                  
                      dnmartinflag = false;              
                  }
                  else{
                           Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*pips*15*Point;                           
                           dnmartinflag = false; 
                           if(mchange == 2){
                              dnmartin2price = iClose(NULL,0,i);              
                              dnmartinflag2 = true;                                    
                              if(i == 1){Alert(Symbol()," M"+Period(),"  SecondMartin LOW  ");}   
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
                      Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*pips*15*Point;
                      dnwincnt++;                  
                      dnmartinflag2 = false;              
                  }
                  else{
                           Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*pips*15*Point;                                             
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
          
          if(upcnt == 0){
            if((stoa<rsis&&rsis<rsim&&stoa<stodn&&rsim<rsipe1high)&&
               (rsiboliup<upline&&rsibolidn>dnline&&rsiboliup>rsi+RSIhaba&&rsibolidn<rsi-RSIhaba)&&
               (bbsign==false||bbsign==true&&bbsa>=MathAbs(bolisa))&&
               (rsissign==false||rsissign==true&&stoa1>=30)&&
               (rsimsign==false||rsimsign==true&&rsim1>=30)
               ){
                 Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                 upentryflag = true;
                 eprice = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" High Sign");}
                 upcnt = 1;
                 if(p <= 1){p++;}
             }
          }
          
          if(dncnt == 0){
              if((stoa>rsis&&rsis>rsim&&stoa>stoup&&rsim>rsipe1low)&&
               (rsiboliup<upline&&rsibolidn>dnline&&rsiboliup>rsi+RSIhaba&&rsibolidn<rsi-RSIhaba)&&
                (bbsign==false||bbsign==true&&bbsa>=MathAbs(bolisa))&&
                (rsissign==false||rsissign==true&&stoa1<=70)&&
                (rsimsign==false||rsimsign==true&&rsim1<=70)
                ){
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
             ObjectSet("counttotal2",OBJPROP_YDISTANCE,labelhigh+15);     
             
             ObjectCreate("counttotal3",OBJ_LABEL,0,0,0);
             ObjectSet("counttotal3",OBJPROP_CORNER,labelpos);
             ObjectSet("counttotal3",OBJPROP_XDISTANCE,5);
             ObjectSet("counttotal3",OBJPROP_YDISTANCE,labelhigh+30);                        
                   
                   
             uptotalcnt = upwincnt + uplosecnt;      
             dntotalcnt = dnwincnt + dnlosecnt;      
             totalwin = upwincnt+dnwincnt;
             totallose = uplosecnt+dnlosecnt;
                          
             if(upwincnt > 0){uppercent = MathRound((upwincnt / uptotalcnt)*100);} else uppercent = 0;
             if(dnwincnt > 0){dnpercent = MathRound((dnwincnt / dntotalcnt)*100);} else dnpercent = 0;
             if(totalwin > 0){totalpercent = NormalizeDouble(((totalwin / (totalwin+totallose))*100),1);} else totalpercent = 0;
             
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
   }


  Comment("");
		
   return(0);
}// end of deinit()
