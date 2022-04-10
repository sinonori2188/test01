//+------------------------------------------------------------------+
//|                                                kakokensyoRSI.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, "
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 5

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
                    
extern limitdate1 limitdate = week;//勝率表示期間
                    
extern int Maxbars = 1000000;//対象本数範囲
//extern int mchange = 0;//マーチン回数（0回/1回/2回）
extern double pips = 0.3;//サイン表示位置調整
extern int hantei = 1;//判定本数スタート
int hantei1 = 3;//判定本数終了
int stopcnt = hantei-1;//停止ロウソク足本数

extern int    RSIPeriod     = 3; //RSI期間検証スタート
int RSIPeriod01 = RSIPeriod;

extern int    RSIPeriod1     = 14; //RSI期間検証終了
extern int rup = 70;//上ライン検証スタート(下ラインは反対にセット)
extern int rup1 = 95;//上ライン検証終了
extern int rdn = 30;//下ライン

int rup01 = rup;
int rdn01 = rdn;



int point1,point2,limit =0;
int NowBars, NowBars2, NowBars3, RealBars,a, b, c, d, e, f,t, Timeframe = 0;
int minute, minute2, mminute, m2minute = 0;
int dnminute, dnminute2, dnmminute, dnm2minute = 0;
bool flag1, flag2, upentryflag, dnentryflag, martinflag, martinflag2, dnmartinflag, dnmartinflag2 = false;
double martin1price, martin2price, dnmartin1price, dnmartin2price,boup,bodn,now,rsi,rsi1;
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
    

if(ChartPeriod(0) == 1){
    if(limitdate == oned){
       limit = 1440;//1440
    }
    if(limitdate == week){
       limit = 7200;//7200
    }
    if(limitdate == month){
       limit = 31600;//31600
    }
    if(limitdate == maxbar){
       limit =Maxbars;//31600
    }
}
if(ChartPeriod(0) == 5){
    if(limitdate == week){
       limit =1440;//7200
    }
    
    if(limitdate == oned){
       limit =288;//18800
    }
   
    if(limitdate == month){
       limit =6320;//31600
    }
    if(limitdate == maxbar){
       limit =Maxbars;
    }
}

/*for(int A = 0; A<=10;A++){

if(MathAbs(iClose(NULL,0,A)-iClose(NULL,0,A+1))>=100*Point)break;//もし一本前の終値と現在の終値の絶対値が10pips以上あったらfor文終了

if(MathAbs(iClose(NULL,0,A)-iClose(NULL,0,A+1))<=50*Point)continue;//もし一本前の終値と現在の終値の絶対値が5pips以下ならfor文スキップ

if(rsi>=70){};//上の条件を満たさなかった時のみ通る、条件が満たしたらサインなどの文を書いてあげる

}*/


for(int pr = RSIPeriod; pr<=RSIPeriod1;pr++){//RSI期間
   

for(int i = limit; i >= 0; i--){  
      
       
       rsi=iRSI(NULL,0,RSIPeriod,0,i);
       rsi1=iRSI(NULL,0,RSIPeriod,0,i+1);
       
       
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
                           t=0;
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
             if(rsi1>=rdn && rsi<=rdn){
             Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                 upentryflag = true;
                 eprice = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" High Sign");}
                 upcnt = 1;
                 if(p <= 1){p++;}
             }
          }
          
          if(dncnt == 0){
             if(rsi1<=rup && rsi>=rup){
             Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                 dnentryflag = true;
                 eprice2 = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" Low Sign");}
                 dncnt = 1;
                 if(q <= 1){q++;}
             } 
          }                   
          
                                    
                   
                   
             uptotalcnt = upwincnt + uplosecnt;      
             dntotalcnt = dnwincnt + dnlosecnt;      
             totalwin = upwincnt+dnwincnt;
             totallose = uplosecnt+dnlosecnt;
                          
             if(upwincnt > 0){uppercent = NormalizeDouble((upwincnt / uptotalcnt)*100,1);} else uppercent = 0;
             if(dnwincnt > 0){dnpercent = NormalizeDouble((dnwincnt / dntotalcnt)*100,1);} else dnpercent = 0;
             if(totalwin > 0){totalpercent = NormalizeDouble((totalwin / (totalwin+totallose))*100,1);} else totalpercent = 0;
             
              
                    
      }//NowBars
   
//勝率出力-----------------------------
   
   if(i<=0){
   
   Print(
                   "RSIsign  "," バックテスト本数  =",limit," RSI期間  =",RSIPeriod," 上ライン  =",rup," 下ライン  =",rdn," 判定本数  =",hantei," 停止本数  =",stopcnt,"\n" ,
                   " UP: 勝", upwincnt ," 負", uplosecnt , "勝率" , uppercent,"%","\n" ,
                   " DN: 勝", dnwincnt ," 負", dnlosecnt , "勝率" , dnpercent,"%","\n" ,
                   " TTL: 勝", totalwin ," 負", totallose , "勝率" , totalpercent,"%","\n" 
                   );
                   
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
   
   
      
   }//for
   
    
  
  for(int pr1 = rup; pr1<=rup1;pr1++){//RSIライン
   
   

for(int i = limit; i >= 0; i--){  
      
       
       rsi=iRSI(NULL,0,RSIPeriod,0,i);
       rsi1=iRSI(NULL,0,RSIPeriod,0,i+1);
       
       
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
                           t=0;
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
             if(rsi1>=rdn && rsi<=rdn){
             Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                 upentryflag = true;
                 eprice = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" High Sign");}
                 upcnt = 1;
                 if(p <= 1){p++;}
             }
          }
          
          if(dncnt == 0){
             if(rsi1<=rup && rsi>=rup){
             Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                 dnentryflag = true;
                 eprice2 = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" Low Sign");}
                 dncnt = 1;
                 if(q <= 1){q++;}
             } 
          }                   
          
                                    
                   
                   
             uptotalcnt = upwincnt + uplosecnt;      
             dntotalcnt = dnwincnt + dnlosecnt;      
             totalwin = upwincnt+dnwincnt;
             totallose = uplosecnt+dnlosecnt;
                          
             if(upwincnt > 0){uppercent = NormalizeDouble((upwincnt / uptotalcnt)*100,1);} else uppercent = 0;
             if(dnwincnt > 0){dnpercent = NormalizeDouble((dnwincnt / dntotalcnt)*100,1);} else dnpercent = 0;
             if(totalwin > 0){totalpercent = NormalizeDouble((totalwin / (totalwin+totallose))*100,1);} else totalpercent = 0;
             
              
                    
      }//NowBars
   
//勝率出力-----------------------------
   
   if(i<=0){
   
   Print(
                   "RSIsign  "," バックテスト本数  =",limit," RSI期間  =",RSIPeriod," 上ライン  =",rup," 下ライン  =",rdn," 判定本数  =",hantei," 停止本数  =",stopcnt,"\n" ,
                   " UP: 勝", upwincnt ," 負", uplosecnt , "勝率" , uppercent,"%","\n" ,
                   " DN: 勝", dnwincnt ," 負", dnlosecnt , "勝率" , dnpercent,"%","\n" ,
                   " TTL: 勝", totalwin ," 負", totallose , "勝率" , totalpercent,"%","\n" 
                   );
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
   
                   
   
      
   }//for
   
   
   rup++;
   rdn--;
   if(RSIPeriod>RSIPeriod1 && rup>rup1) break; 
   else if(rup>rup1){ 
   rup=rup01;
   rdn=rdn01;
   }
   
   }//RSIライン
   
   
    RSIPeriod++;
   if(RSIPeriod>RSIPeriod1 && rup>rup1) break; 
   
   
   }//RSI期間
   
   
   
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