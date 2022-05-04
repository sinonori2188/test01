//+------------------------------------------------------------------+
//|                                                .mq4 |
//|                                             Copyright 2018, ands |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "Copyright 2020, ands"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 6

#property indicator_width1 3
#property indicator_color1 Orange
#property indicator_width2 3
#property indicator_color2 Magenta
#property indicator_width3 3
#property indicator_color3 White
#property indicator_width4 3
#property indicator_color4 White
#property indicator_width5 3
#property indicator_color5 Red
#property indicator_width6 3
#property indicator_color6 Aqua

double Buffer_0[];
double Buffer_1[];
double Buffer_2[];
double Buffer_3[];
double Buffer_4[];
double Buffer_5[];

enum ENTMODE {
   one = 1, //ハイロー短期
   two = 2, //ハイロー中期
   three = 3, //ハイロー長期
   four = 4, //ターボ1分(1本)
   five = 5, //ターボ3分(3本)
};

enum ENTMODE2 {
   one1 = 1, //ボリンジャーバンドのみ
   two2 = 2, //ストキャスのみ
   three3 = 3, //RSIのみ
   four4 = 4, //ボリンジャーバンド・ストキャス
   five5 = 5, //ボリンジャーバンド・RSI
   six6 = 6,//ボリンジャーバンド・ストキャス・RSI
   seven7 = 7,//なし
};

int OnInit()
  {
   IndicatorBuffers(6);
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
   SetIndexArrow(5,242);   
   
   return(INIT_SUCCEEDED);
  }

extern int labelsize = 10;//勝率ラベル大きさ
extern ENTMODE hantei = three;//判定ターム

extern int kankaku = 5;//エントリー間隔本数
extern double pips = 2;//サイン表示位置調整
extern string Note1 = "";//インジケーター設定---------------------
extern ENTMODE2 ENT =  six6;//1分足適用
extern ENTMODE2 ENT5 =  seven7;//5分足適用
extern int RSIPeriod = 14;//RSI期間
extern int k = 5;//ストキャス%K
extern int d = 3;//ストキャス%D
extern int slow = 3;//ストキャススローイング
extern string Note2 = "";//レベル設定---------------------
extern int rsiup = 80;//RSI上レベル
extern int rsidn = 20;//RSI下レベル
extern int stoup = 80;//ストキャス上レベル
extern int stodn = 20;//ストキャス下レベル

extern string Note3 = "";//BB設定---------------------
extern int bbperiod = 21;//バンド期間
extern double bbsig1 = 2.0;//シグマ

extern string Note4 = "";//MA設定---------------------
extern bool MA01=false;//1分足移動平均線乖離適用
extern bool MA05=false;//5分足移動平均線乖離適用
extern int ma_method = 0;//計算方法：SMA0,EMA1
extern int ma1 = 10;//MA期間
extern int bp =100;//MAから何ポイント離れていたらサイン

int NowBars, NowBars2, NowBars3, RealBars,a, b, c, e, f, p, q, minute, minute2, Timeframe = 0;
bool flag1, flag2, upentryflag, dnentryflag = false;
bool upentryflag2, dnentryflag2 = false;
double eprice, wincnt, losecnt, totalcnt, percent;
double eprice01,eprice02,eprice2;
int minute01,minute02;
bool Certification = false;
bool MAflag1,MAflag5=false;
bool MAflag01,MAflag05=false;
double RSI1, RSI2, Sto1, Sto2, CCI1 , MA1;
double RSI5, Sto51, Sto52, CCI5 , MA5;
double boup1, boup2, boup3, bodn1, bodn2, bodn3, boup5, bodn5;
bool boupflag, bodnflag, boupflag2, bodnflag2 = false;
int Hantei;
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
    
int limit = Bars - IndicatorCounted()-1;
for(int i = limit; i >= 0; i--){  

if(i == Bars-1){wincnt=0;losecnt=0;totalcnt=0;}

      RSI1 = iRSI(NULL,PERIOD_M1,RSIPeriod,PRICE_CLOSE,i);
      Sto1 = iStochastic(NULL,PERIOD_M1,k,d,slow,MODE_SMA,0,0,i);
      Sto2 = iStochastic(NULL,PERIOD_M1,k,d,slow,MODE_SMA,0,1,i);
      boup1 = iBands(NULL,PERIOD_M1,bbperiod,bbsig1,0,0,1,i);
      bodn1 = iBands(NULL,PERIOD_M1,bbperiod,bbsig1,0,0,2,i);              
      MA1 = iMA(NULL,0,ma1,PERIOD_M1,ma_method,0,i);
      
      RSI5 = iRSI(NULL,PERIOD_M5,RSIPeriod,PRICE_CLOSE,i);
      Sto51 = iStochastic(NULL,PERIOD_M5,k,d,slow,MODE_SMA,0,0,i);
      Sto52 = iStochastic(NULL,PERIOD_M5,k,d,slow,MODE_SMA,0,1,i);
      boup5 = iBands(NULL,PERIOD_M5,bbperiod,bbsig1,0,0,1,i);
      bodn5 = iBands(NULL,PERIOD_M5,bbperiod,bbsig1,0,0,2,i);              
      MA5 = iMA(NULL,PERIOD_M5,ma1,0,ma_method,0,i);     
      
      MAflag1=false;
      MAflag01=false;
      MAflag5=false;
      MAflag05=false;
      if( (MathAbs(MA1-iClose(NULL,1,i)))>= bp*Point){MAflag1=true;}
      if( (MathAbs(MA1-iClose(NULL,1,i)))>= bp*Point){MAflag01=true;}
      if( (MathAbs(MA5-iClose(NULL,5,i)))>= bp*Point){MAflag5=true;}
      if( (MathAbs(MA5-iClose(NULL,5,i)))>= bp*Point){MAflag05=true;}
      if(MA01==false){MAflag1=true;}
      if(MA01==false){MAflag01=true;}
      if(MA05==false){MAflag5=true;}
      if(MA05==false){MAflag05=true;}  
            
      if(i == 0){
          Buffer_0[i] = EMPTY_VALUE;
          Buffer_0[i] = 0;          
          Buffer_1[i] = EMPTY_VALUE;
          Buffer_1[i] = 0;                                            
      }
      
      

                
      if(i == 0){ 
          if(
          (
          (ENT==1 && bodn1 >= iClose(NULL,1,i) && MAflag1==true && a > kankaku)||
          (ENT==2 && Sto1 <= stodn && Sto2 <= stodn && MAflag1==true && a > kankaku)||
          (ENT==3 && RSI1 <= rsidn && MAflag1==true && a > kankaku)||
          (ENT==4 && Sto1 <= stodn && Sto2 <= stodn && bodn1 >= iClose(NULL,0,i) && MAflag1==true && a > kankaku)||
          (ENT==5 && RSI1 <= rsidn && bodn1 >= iClose(NULL,1,i) && MAflag1==true && a > kankaku)||
          (ENT==6 && Sto1 <= stodn && Sto2 <= stodn && RSI1 <= rsidn && bodn1 >= iClose(NULL,1,i) && MAflag1==true && a > kankaku)||
          (ENT==7)
          )
          &&
          (
          (ENT5==1 && bodn5 >= iClose(NULL,5,i) && MAflag5==true && a > kankaku)||
          (ENT5==2 && Sto51 <= stodn && Sto52 <= stodn && MAflag5==true && a > kankaku)||
          (ENT5==3 && RSI5 <= rsidn && MAflag5==true && a > kankaku)||
          (ENT5==4 && Sto51 <= stodn && Sto52 <= stodn && bodn5 >= iClose(NULL,5,i) && MAflag5==true && a > kankaku)||
          (ENT5==5 && RSI5 <= rsidn && bodn5 >= iClose(NULL,5,i) && MAflag5==true && a > kankaku)||
          (ENT5==6 && Sto51 <= stodn && Sto52 <= stodn && RSI5 <= rsidn && bodn1 >= iClose(NULL,5,i) && MAflag5==true && a > kankaku)||
          (ENT5==7)
          )       
          
          ){          
                          Buffer_0[i] = iLow(NULL,0,i)-5*pips*Point;
                          if(i==0 && RealBars < Bars){Alert(Symbol()+" M"+Period()+" Real Time High"); RealBars = Bars;}                         
              
          }
          
          if(
          (
          (ENT==1 && boup1 <= iClose(NULL,0,i)  && MAflag01==true && b > kankaku)||
          (ENT==2 && Sto1 >= stoup && Sto2 >= stoup && MAflag01==true && b > kankaku)||
          (ENT==3 && RSI1 >= rsiup && MAflag01==true && b > kankaku)||
          (ENT==4 && Sto1 >= stoup && Sto2 >= stoup && boup1 <= iClose(NULL,0,i)  && MAflag01==true && b > kankaku)||
          (ENT==5 && RSI1 >= rsiup && boup1 <= iClose(NULL,0,i)  && MAflag01==true && b > kankaku)||
          (ENT==6 && Sto1 >= stoup && Sto2 >= stoup && RSI1 >= rsiup && boup1 <= iClose(NULL,0,i)  && MAflag01==true && b > kankaku)||
          (ENT==7)
          )&&

          (
          (ENT5==1 && boup5 <= iClose(NULL,5,i)  && MAflag05==true && b > kankaku)||
          (ENT5==2 && Sto51 >= stoup && Sto52 >= stoup && MAflag05==true && b > kankaku)||
          (ENT5==3 && RSI5 >= rsiup && MAflag05==true && b > kankaku)||
          (ENT5==4 && Sto51 >= stoup && Sto52 >= stoup && boup5 <= iClose(NULL,5,i)  && MAflag05==true && b > kankaku)||
          (ENT5==5 && RSI5 >= rsiup && boup5 <= iClose(NULL,5,i)  && MAflag05==true && b > kankaku)||
          (ENT5==6 && Sto51 >= stoup && Sto52 >= stoup && RSI5 >= rsiup && boup5 <= iClose(NULL,5,i)  && MAflag05==true && b > kankaku)||
          (ENT5==7)
          )         
          
          ){
                          Buffer_1[i] = iHigh(NULL,0,i)+10*pips*Point;
                          if(i==0 && RealBars < Bars){Alert(Symbol()+" M"+Period()+" Real Time Low"); RealBars = Bars;}              
          }       
      }
          
      if(i > 1 || (i == 1 && NowBars2 < Bars)){ 
          NowBars2 = Bars;      
          a++; b++;
       
      MAflag1=false;
      MAflag01=false;
      MAflag5=false;
      MAflag05=false;
      if( (MathAbs(MA1-iClose(NULL,1,i)))>= bp*Point){MAflag1=true;}
      if( (MathAbs(MA1-iClose(NULL,1,i)))>= bp*Point){MAflag01=true;}
      if( (MathAbs(MA5-iClose(NULL,5,i)))>= bp*Point){MAflag5=true;}
      if( (MathAbs(MA5-iClose(NULL,5,i)))>= bp*Point){MAflag05=true;}
      if(MA01==false){MAflag1=true;}
      if(MA01==false){MAflag01=true;}
      if(MA05==false){MAflag5=true;}
      if(MA05==false){MAflag05=true;}  
                              
          //勝敗判定-----------------------------------------------------------------------------------------------------------------
         
//勝敗判定-----------------------------------------------------------------------------------------------------------------
       //上側矢印判定--------------------
       if(upentryflag == true){
            
           if(hantei==1 || hantei==2 || hantei==3){ 
           if(MathMod(TimeMinute(iTime(NULL,0,i)), 5) == 4)minute++;   
           if(MathMod(TimeMinute(iTime(NULL,0,i)), 5) == 0 && minute == 0){minute= 1;}   
           }
           if(hantei==4 || hantei==5){minute++;}
           
           if(minute == hantei || (hantei==4 && minute==1) || (hantei==5 && minute==3)){     
               if(eprice > iClose(NULL,0,i)){            
                   Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*pips*5*Point;
                   upentryflag = false;  
                   wincnt++;                             
               }                  
               else{
                        Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*pips*5*Point;   
                        upentryflag = false;  
                        losecnt++;                                                                                                                                                     
                }
                minute = 0;
           } 
       }

       if(upentryflag2 == true){
            
           if(hantei==1 || hantei==2 || hantei==3){ 
           if(MathMod(TimeMinute(iTime(NULL,0,i)), 5) == 4)minute01++;   
           if(MathMod(TimeMinute(iTime(NULL,0,i)), 5) == 0 && minute01 == 0){minute01= 1;}   
           }
           if(hantei==4 || hantei==5){minute01++;}
           
           if(minute01 == hantei || (hantei==4 && minute01==1) || (hantei==5 && minute01==3)){     
               if(eprice01 > iClose(NULL,0,i)){            
                   Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*pips*5*Point;
                   upentryflag2 = false;  
                   wincnt++;                             
               }                  
               else{
                        Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*pips*5*Point;   
                        upentryflag2 = false;  
                        losecnt++;                                                                                                                                                     
                }
                minute01 = 0;
           } 
       }
       
                 
       //下側矢印判定--------------------          
       if(dnentryflag == true){
       
       if(hantei==1 || hantei==2 || hantei==3){     
           if(MathMod(TimeMinute(iTime(NULL,0,i)), 5) == 4)minute2++;   
           if(MathMod(TimeMinute(iTime(NULL,0,i)), 5) == 0 && minute2 == 0){minute2 = 1;}   
           }
           if(hantei==4 || hantei==5){minute2++;}

           if(minute2 == hantei || (hantei==4 && minute2==1) || (hantei==5 && minute2==3)){      
               if(eprice2 < iClose(NULL,0,i)){           
                  Buffer_2[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                  dnentryflag = false;    
                  wincnt++;              
               }
               
               else{
                        Buffer_3[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                        dnentryflag = false;  
                        losecnt++;                         
                }
                minute2 = 0;
           } 
       }   
               
       if(dnentryflag2 == true){
       
       if(hantei==1 || hantei==2 || hantei==3){     
           if(MathMod(TimeMinute(iTime(NULL,0,i)), 5) == 4)minute02++;   
           if(MathMod(TimeMinute(iTime(NULL,0,i)), 5) == 0 && minute02 == 0){minute02 = 1;}   
           }
           if(hantei==4 || hantei==5){minute02++;}

           if(minute02 == hantei || (hantei==4 && minute02==1) || (hantei==5 && minute02==3)){      
               if(eprice02 < iClose(NULL,0,i)){           
                  Buffer_2[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                  dnentryflag2 = false;    
                  wincnt++;              
               }
               
               else{
                        Buffer_3[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                        dnentryflag2 = false;  
                        losecnt++;                         
                }
                minute02 = 0;
           } 
       }                                             
               ObjectCreate("counttotal",OBJ_LABEL,0,0,0);
               ObjectSet("counttotal",OBJPROP_CORNER,1);
               ObjectSet("counttotal",OBJPROP_XDISTANCE,5);
               ObjectSet("counttotal",OBJPROP_YDISTANCE,15);
                     
               totalcnt = wincnt + losecnt;      
               if(wincnt > 0){percent = MathRound((wincnt / totalcnt)*100);} else percent = 0;
               
               ObjectSetText("counttotal", "Win"+wincnt+"回"+" Lose: "+losecnt+"回"+" 勝率: "+percent+"%", labelsize, "MS ゴシック",White);  





          if(
          (
          (ENT==1 && bodn1 >= iClose(NULL,1,i) && MAflag1==true && a > kankaku)||
          (ENT==2 && Sto1 <= stodn && Sto2 <= stodn && MAflag1==true && a > kankaku)||
          (ENT==3 && RSI1 <= rsidn && MAflag1==true && a > kankaku)||
          (ENT==4 && Sto1 <= stodn && Sto2 <= stodn && bodn1 >= iClose(NULL,0,i) && MAflag1==true && a > kankaku)||
          (ENT==5 && RSI1 <= rsidn && bodn1 >= iClose(NULL,1,i) && MAflag1==true && a > kankaku)||
          (ENT==6 && Sto1 <= stodn && Sto2 <= stodn && RSI1 <= rsidn && bodn1 >= iClose(NULL,1,i) && MAflag1==true && a > kankaku)||
          (ENT==7)
          )
          &&
          (
          (ENT5==1 && bodn5 >= iClose(NULL,5,i) && MAflag5==true && a > kankaku)||
          (ENT5==2 && Sto51 <= stodn && Sto52 <= stodn && MAflag5==true && a > kankaku)||
          (ENT5==3 && RSI5 <= rsidn && MAflag5==true && a > kankaku)||
          (ENT5==4 && Sto51 <= stodn && Sto52 <= stodn && bodn5 >= iClose(NULL,5,i) && MAflag5==true && a > kankaku)||
          (ENT5==5 && RSI5 <= rsidn && bodn5 >= iClose(NULL,5,i) && MAflag5==true && a > kankaku)||
          (ENT5==6 && Sto51 <= stodn && Sto52 <= stodn && RSI5 <= rsidn && bodn1 >= iClose(NULL,5,i) && MAflag5==true && a > kankaku)||
          (ENT5==7)
          )       
          
          ){
           
                            Buffer_0[i] = iLow(NULL,0,i)-5*pips*Point;
                            
                            if(dnentryflag==true && dnentryflag2==false){dnentryflag2 = true;eprice02 = iClose(NULL,0,i); }
                            if(dnentryflag==false && dnentryflag2==false){dnentryflag = true;eprice2 = iClose(NULL,0,i); }
                             
                            a = 0;           
                            p++;
                         
          }

          
          if(
          (
          (ENT==1 && boup1 <= iClose(NULL,0,i)  && MAflag01==true && b > kankaku)||
          (ENT==2 && Sto1 >= stoup && Sto2 >= stoup && MAflag01==true && b > kankaku)||
          (ENT==3 && RSI1 >= rsiup && MAflag01==true && b > kankaku)||
          (ENT==4 && Sto1 >= stoup && Sto2 >= stoup && boup1 <= iClose(NULL,0,i)  && MAflag01==true && b > kankaku)||
          (ENT==5 && RSI1 >= rsiup && boup1 <= iClose(NULL,0,i)  && MAflag01==true && b > kankaku)||
          (ENT==6 && Sto1 >= stoup && Sto2 >= stoup && RSI1 >= rsiup && boup1 <= iClose(NULL,0,i)  && MAflag01==true && b > kankaku)||
          (ENT==7)
          )&&

          (
          (ENT5==1 && boup5 <= iClose(NULL,5,i)  && MAflag05==true && b > kankaku)||
          (ENT5==2 && Sto51 >= stoup && Sto52 >= stoup && MAflag05==true && b > kankaku)||
          (ENT5==3 && RSI5 >= rsiup && MAflag05==true && b > kankaku)||
          (ENT5==4 && Sto51 >= stoup && Sto52 >= stoup && boup5 <= iClose(NULL,5,i)  && MAflag05==true && b > kankaku)||
          (ENT5==5 && RSI5 >= rsiup && boup5 <= iClose(NULL,5,i)  && MAflag05==true && b > kankaku)||
          (ENT5==6 && Sto51 >= stoup && Sto52 >= stoup && RSI5 >= rsiup && boup5 <= iClose(NULL,5,i)  && MAflag05==true && b > kankaku)||
          (ENT5==7)
          )         
          
          ){
          
                            Buffer_1[i] = iHigh(NULL,0,i)+10*pips*Point;
                            
                            if(upentryflag==true && upentryflag2 == false){upentryflag2 = true;eprice01 = iClose(NULL,0,i);}
                            if(upentryflag==false && upentryflag2 == false){upentryflag = true;eprice = iClose(NULL,0,i);}

                            b = 0;         
                            q++;     
          }                  
          }       


}

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
