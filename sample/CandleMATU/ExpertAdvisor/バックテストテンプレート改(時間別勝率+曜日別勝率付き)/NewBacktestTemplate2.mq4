//+------------------------------------------------------------------+
//|                                                .mq4 |
//|                                             Copyright 2018, ands |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, ands"
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

enum zisasentaku{
                    zero=0,//MT4時間
                    nihon= 7,//日本時間
                    };
                    
                    
extern int hantei = 1;//判定本数
extern int martin = 0;//マーチン回数(現状では1回まで)
extern double pips = 2;//サイン表示位置調整
extern bool testlabel = true;//バックテストラベル表示
extern datetime st_haneijikan = D'2015.01.01 00:00';//判定開始
extern datetime en_haneijikan = D'2019.12.31 00:00';//判定終了
extern string Note = "その場合は02などデータがある分数に変更してください。";//※稀に00分のデータがないときがありエラーになります。
extern int money = 1000000;//初期残高
extern double payout = 1.85;//ペイアウト率
extern int bet = 10000;//BET額
extern string indiname = " ";//テストインジケーター名
extern int buf1 = 0;//サイン番号1[上向き]
extern int buf2 = 1;//サイン番号2[下向き]
extern zisasentaku zisa1=zero;//日本時間orMT4時間
extern int labelsize = 10;//時間別勝率ラベル大きさ
int DC = 3;//曜日別勝率位置

int NowBars, RealBars,a, b, c, d, e, f, j, p, q, Timeframe, Hantei,Hantei2,Hantei3 = 0;
int minute,minute01,minute001, minute2, mminute, m2minute = 0;
int dnminute, dnminute2, dnminute3,dnmminute, dnm2minute = 0;
bool flag1, flag2, upentryflag,upentryflag2, upentryflag3,dnentryflag,dnentryflag2, dnentryflag3,martinflag, martinflag2, dnmartinflag, dnmartinflag2 = false;
double eprice, eprice01,eprice001,eprice2,eprice02,eprice002, wincnt, losecnt, totalcnt, percent, martin1price, martin2price, dnmartin1price, dnmartin2price;
bool Certification = false;

int pastbar, pastbar2;
datetime pasttime, pasttime2;


int Max, Min = 0;
int Money = 0;
int win, lose, maxwin, maxlose = 0;
double rieki, sonsitu, pf = 0;
int dd, maxdd = 0;
int handle,zisa;
string entrylog = " ";
double sign1, sign2;

int uptime,dntime;
double uw0,uw1,uw2,uw3,uw4,uw5,uw6,uw7,uw8,uw9,uw10,uw11,uw12,uw13,uw14,uw15,uw16,uw17,uw18,uw19,uw20,uw21,uw22,uw23;
double ul0,ul1,ul2,ul3,ul4,ul5,ul6,ul7,ul8,ul9,ul10,ul11,ul12,ul13,ul14,ul15,ul16,ul17,ul18,ul19,ul20,ul21,ul22,ul23;
double dw0,dw1,dw2,dw3,dw4,dw5,dw6,dw7,dw8,dw9,dw10,dw11,dw12,dw13,dw14,dw15,dw16,dw17,dw18,dw19,dw20,dw21,dw22,dw23;
double dl0,dl1,dl2,dl3,dl4,dl5,dl6,dl7,dl8,dl9,dl10,dl11,dl12,dl13,dl14,dl15,dl16,dl17,dl18,dl19,dl20,dl21,dl22,dl23;
double upw0,upw1,upw2,upw3,upw4,upw5,upw6,upw7,upw8,upw9,upw10,upw11,upw12,upw13,upw14,upw15,upw16,upw17,upw18,upw19,upw20,upw21,upw22,upw23;
double dnw0,dnw1,dnw2,dnw3,dnw4,dnw5,dnw6,dnw7,dnw8,dnw9,dnw10,dnw11,dnw12,dnw13,dnw14,dnw15,dnw16,dnw17,dnw18,dnw19,dnw20,dnw21,dnw22,dnw23;
double t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,t21,t22,t23;
double to0,to1,to2,to3,to4,to5,to6,to7,to8,to9,to10,to11,to12,to13,to14,to15,to16,to17,to18,to19,to20,to21,to22,to23;

double wincnt01,wincnt02,wincnt03,wincnt04,wincnt05;
double losecnt01,losecnt02,losecnt03,losecnt04,losecnt05;
double percent01,percent02,percent03,percent04,percent05;
double totalcnt01,totalcnt02,totalcnt03,totalcnt04,totalcnt05;

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
int stop = 0;
if(stop == 0){    
int limit = Bars - IndicatorCounted()-1;
for(int i = limit; i >= 0; i--){  
     
      if(i == 0){stop = 1;}
      sign1 = iCustom(Symbol(),0,indiname, buf1, i);
      sign2 = iCustom(Symbol(),0,indiname, buf2, i);
      
      //if(i == 0 && RealBars < Bars){}
      if(i > 1 || (i == 1 && NowBars < Bars)){ 
          NowBars = Bars;

     int ti = TimeDayOfWeek(iTime(NULL,0,i));
    
      
      if(TimeMonth(iTime(NULL,0,i)) < 3 || TimeMonth(iTime(NULL,0,i)) > 10){zisa=zisa1;}
      else{zisa=zisa1-1;}
      
      if(zisa1==0){zisa=zisa1;}
      
      /*uptime=TimeHour(iTime(NULL,0,i))+zisa;
      dntime=TimeHour(iTime(NULL,0,i))+zisa;
      if(uptime>24){uptime=uptime-24;}

 Comment( uptime+" "+TimeHour(iTime(NULL,0,i))+" "+zisa); */ 
             
   if(iTime(NULL,0,i)>=st_haneijikan && iTime(NULL,0,i)<=en_haneijikan){//ここに検証したい条件を入れます。                                                           
          if(sign1 != 0 && sign1 != EMPTY_VALUE){
              Buffer_0[i] = iLow(NULL,0,i)-Timeframe*5*pips*Point; 
              uptime=TimeHour(iTime(NULL,0,i)+zisa);
              if(upentryflag == true && upentryflag2 == true && upentryflag3 == false){upentryflag3 = true; eprice001 = iClose(NULL,0,i);}                           
              if(upentryflag == true && upentryflag2 == false){upentryflag2 = true; eprice01 = iClose(NULL,0,i);}                           
              if(upentryflag == false){upentryflag = true; eprice = iClose(NULL,0,i);}
             
              money = money-bet;
              if(p <= 1){p++;}         
          }
          
          if(sign2 != 0 && sign2 != EMPTY_VALUE){
              Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*10*pips*Point;
              dntime=TimeHour(iTime(NULL,0,i)+zisa);
              if(dnentryflag == true && dnentryflag2 == true && dnentryflag3 == false){dnentryflag3 = true; eprice002 = iClose(NULL,0,i);}                 
              if(dnentryflag == true && dnentryflag2 == false){dnentryflag2 = true; eprice02 = iClose(NULL,0,i);}                           
              if(dnentryflag == false){dnentryflag = true; eprice2 = iClose(NULL,0,i);}

              money = money-bet;
              if(q <= 1){q++;}
          } 
 
          //勝敗判定-----------------------------------------------------------------------------------------------------------------
          if(upentryflag == true){
              
              if(uptime>=24){uptime=uptime-24;}
          
          
              if(p <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(minute == Hantei+1){       
                  if(eprice < iClose(NULL,0,i)){            
                      Buffer_2[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                      upentryflag = false;
                      wincnt++;            
                      money = money+(bet*payout);             
                      win++;
                      lose = 0;        
                      rieki = rieki+(bet*payout-bet);
                      if(ti==1){wincnt01++;}
                      if(ti==2){wincnt02++;}
                      if(ti==3){wincnt03++;}
                      if(ti==4){wincnt04++;}
                      if(ti==5){wincnt05++;}                     
                      if(uptime==0){uw0++;}
                   if(uptime==1){uw1++;}
                   if(uptime==2){uw2++;}
                   if(uptime==3){uw3++;}
                   if(uptime==4){uw4++;}
                   if(uptime==5){uw5++;}
                   if(uptime==6){uw6++;}
                   if(uptime==7){uw7++;}
                   if(uptime==8){uw8++;}
                   if(uptime==9){uw9++;}
                   if(uptime==10){uw10++;}
                   if(uptime==11){uw11++;}
                   if(uptime==12){uw12++;}
                   if(uptime==13){uw13++;}
                   if(uptime==14){uw14++;}
                   if(uptime==15){uw15++;}
                   if(uptime==16){uw16++;}
                   if(uptime==17){uw17++;}
                   if(uptime==18){uw18++;}
                   if(uptime==19){uw19++;}
                   if(uptime==20){uw20++;}
                   if(uptime==21){uw21++;}
                   if(uptime==22){uw22++;}
                   if(uptime==23){uw23++;} 
                   
                  }                  
                  else{
                           Buffer_3[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                           
                           if(martin >= 1){
                               martinflag = true;
                               martin1price = iClose(NULL,0,i);                                                  
                               //if(i == 1){Alert(Symbol()," M"+Period(),"  FirstMartin HIGH  ");}     
                               upentryflag = false;                      
                               money = money-(bet*2);    
                           }                  
                           else{                               
                                     losecnt++;                     
                                     lose++;
                                     win = 0;                  
                                     sonsitu = sonsitu+bet; 
                                     upentryflag = false;  
                                     if(uptime==0){ul0++;}
                      if(ti==1){losecnt01++;}
                      if(ti==2){losecnt02++;}
                      if(ti==3){losecnt03++;}
                      if(ti==4){losecnt04++;}
                      if(ti==5){losecnt05++;}                                       
                   if(uptime==0){ul0++;}
                   if(uptime==1){ul1++;}
                   if(uptime==2){ul2++;}
                   if(uptime==3){ul3++;}
                   if(uptime==4){ul4++;}
                   if(uptime==5){ul5++;}
                   if(uptime==6){ul6++;}
                   if(uptime==7){ul7++;}
                   if(uptime==8){ul8++;}
                   if(uptime==9){ul9++;}
                   if(uptime==10){ul10++;}
                   if(uptime==11){ul11++;}
                   if(uptime==12){ul12++;}
                   if(uptime==13){ul13++;}
                   if(uptime==14){ul14++;}
                   if(uptime==15){ul15++;}
                   if(uptime==16){ul16++;}
                   if(uptime==17){ul17++;}
                   if(uptime==18){ul18++;}
                   if(uptime==19){ul19++;}
                   if(uptime==20){ul20++;}
                   if(uptime==21){ul21++;}
                   if(uptime==22){ul22++;}
                   if(uptime==23){ul23++;}                                   
                           }                                                                            
                   }
                   minute = 0;
              }
          minute++;   
          }  

          if(upentryflag2 == true){
              if(p <= 1){Hantei2 = hantei-1;}
              else{Hantei2 = hantei;}              
              if(minute01 == Hantei2+1){       
                  if(eprice01 < iClose(NULL,0,i)){            
                      Buffer_2[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                      upentryflag2 = false;
                      wincnt++;            
                      money = money+(bet*payout);             
                      win++;
                      lose = 0;        
                      rieki = rieki+(bet*payout-bet);
                      if(ti==1){wincnt01++;}
                      if(ti==2){wincnt02++;}
                      if(ti==3){wincnt03++;}
                      if(ti==4){wincnt04++;}
                      if(ti==5){wincnt05++;}                  
                   if(uptime==0){uw0++;}
                   if(uptime==1){uw1++;}
                   if(uptime==2){uw2++;}
                   if(uptime==3){uw3++;}
                   if(uptime==4){uw4++;}
                   if(uptime==5){uw5++;}
                   if(uptime==6){uw6++;}
                   if(uptime==7){uw7++;}
                   if(uptime==8){uw8++;}
                   if(uptime==9){uw9++;}
                   if(uptime==10){uw10++;}
                   if(uptime==11){uw11++;}
                   if(uptime==12){uw12++;}
                   if(uptime==13){uw13++;}
                   if(uptime==14){uw14++;}
                   if(uptime==15){uw15++;}
                   if(uptime==16){uw16++;}
                   if(uptime==17){uw17++;}
                   if(uptime==18){uw18++;}
                   if(uptime==19){uw19++;}
                   if(uptime==20){uw20++;}
                   if(uptime==21){uw21++;}
                   if(uptime==22){uw22++;}
                   if(uptime==23){uw23++;} 
                   
                  }                  
                  else{
                           Buffer_3[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                           
                           if(martin >= 1){
                               martinflag = true;
                               martin1price = iClose(NULL,0,i);                                                  
                               //if(i == 1){Alert(Symbol()," M"+Period(),"  FirstMartin HIGH  ");}     
                               upentryflag2 = false;                      
                               money = money-(bet*2);    
                           }                  
                           else{                               
                                     losecnt++;                     
                                     lose++;
                                     win = 0;                  
                                     sonsitu = sonsitu+bet; 
                                     upentryflag2 = false;  
                     if(ti==1){losecnt01++;}
                      if(ti==2){losecnt02++;}
                      if(ti==3){losecnt03++;}
                      if(ti==4){losecnt04++;}
                      if(ti==5){losecnt05++;}                                        
                                     if(uptime==0){ul0++;}
                   if(uptime==1){ul1++;}
                   if(uptime==2){ul2++;}
                   if(uptime==3){ul3++;}
                   if(uptime==4){ul4++;}
                   if(uptime==5){ul5++;}
                   if(uptime==6){ul6++;}
                   if(uptime==7){ul7++;}
                   if(uptime==8){ul8++;}
                   if(uptime==9){ul9++;}
                   if(uptime==10){ul10++;}
                   if(uptime==11){ul11++;}
                   if(uptime==12){ul12++;}
                   if(uptime==13){ul13++;}
                   if(uptime==14){ul14++;}
                   if(uptime==15){ul15++;}
                   if(uptime==16){ul16++;}
                   if(uptime==17){ul17++;}
                   if(uptime==18){ul18++;}
                   if(uptime==19){ul19++;}
                   if(uptime==20){ul20++;}
                   if(uptime==21){ul21++;}
                   if(uptime==22){ul22++;}
                   if(uptime==23){ul23++;}                                   
                           }                                                                            
                   }
                   minute01 = 0;
              }
          minute01++;   
          }   
          if(upentryflag3 == true){
              if(p <= 1){Hantei3 = hantei-1;}
              else{Hantei3 = hantei;}              
              if(minute001 == Hantei3+1){       
                  if(eprice001< iClose(NULL,0,i)){            
                      Buffer_2[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                      upentryflag3 = false;
                      wincnt++;            
                      money = money+(bet*payout);             
                      win++;
                      lose = 0;        
                      rieki = rieki+(bet*payout-bet);
                      if(ti==1){wincnt01++;}
                      if(ti==2){wincnt02++;}
                      if(ti==3){wincnt03++;}
                      if(ti==4){wincnt04++;}
                      if(ti==5){wincnt05++;}                      
                      if(uptime==0){uw0++;}
                   if(uptime==1){uw1++;}
                   if(uptime==2){uw2++;}
                   if(uptime==3){uw3++;}
                   if(uptime==4){uw4++;}
                   if(uptime==5){uw5++;}
                   if(uptime==6){uw6++;}
                   if(uptime==7){uw7++;}
                   if(uptime==8){uw8++;}
                   if(uptime==9){uw9++;}
                   if(uptime==10){uw10++;}
                   if(uptime==11){uw11++;}
                   if(uptime==12){uw12++;}
                   if(uptime==13){uw13++;}
                   if(uptime==14){uw14++;}
                   if(uptime==15){uw15++;}
                   if(uptime==16){uw16++;}
                   if(uptime==17){uw17++;}
                   if(uptime==18){uw18++;}
                   if(uptime==19){uw19++;}
                   if(uptime==20){uw20++;}
                   if(uptime==21){uw21++;}
                   if(uptime==22){uw22++;}
                   if(uptime==23){uw23++;} 
                  }                  
                  else{
                           Buffer_3[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                           
                           if(martin >= 1){
                               martinflag = true;
                               martin1price = iClose(NULL,0,i);                                                  
                               //if(i == 1){Alert(Symbol()," M"+Period(),"  FirstMartin HIGH  ");}     
                               upentryflag3 = false;                      
                               money = money-(bet*2);    
                           }                  
                           else{                               
                                     losecnt++;                     
                                     lose++;
                                     win = 0;                  
                                     sonsitu = sonsitu+bet; 
                                     upentryflag3 = false; 
                      if(ti==1){losecnt01++;}
                      if(ti==2){losecnt02++;}
                      if(ti==3){losecnt03++;}
                      if(ti==4){losecnt04++;}
                      if(ti==5){losecnt05++;}                                     
                                     if(uptime==0){ul0++;}
                   if(uptime==1){ul1++;}
                   if(uptime==2){ul2++;}
                   if(uptime==3){ul3++;}
                   if(uptime==4){ul4++;}
                   if(uptime==5){ul5++;}
                   if(uptime==6){ul6++;}
                   if(uptime==7){ul7++;}
                   if(uptime==8){ul8++;}
                   if(uptime==9){ul9++;}
                   if(uptime==10){ul10++;}
                   if(uptime==11){ul11++;}
                   if(uptime==12){ul12++;}
                   if(uptime==13){ul13++;}
                   if(uptime==14){ul14++;}
                   if(uptime==15){ul15++;}
                   if(uptime==16){ul16++;}
                   if(uptime==17){ul17++;}
                   if(uptime==18){ul18++;}
                   if(uptime==19){ul19++;}
                   if(uptime==20){ul20++;}
                   if(uptime==21){ul21++;}
                   if(uptime==22){ul22++;}
                   if(uptime==23){ul23++;}                                    
                           }                                                                            
                   }
                   minute001 = 0;
              }
          minute001++;   
          }  



         
          if(martinflag == true){
              if(mminute == hantei+1){                          
                  if(martin1price < iClose(NULL,0,i)){  
                      Buffer_2[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                      wincnt++;                  
                      martinflag = false;    
                      money = money+(bet*2*payout);        
                      win++;
                      lose = 0;  
                      rieki = rieki+(bet*2*payout-(bet*2+bet));
                      if(ti==1){wincnt01++;}
                      if(ti==2){wincnt02++;}
                      if(ti==3){wincnt03++;}
                      if(ti==4){wincnt04++;}
                      if(ti==5){wincnt05++;}                       
                   if(uptime==0){uw0++;}
                   if(uptime==1){uw1++;}
                   if(uptime==2){uw2++;}
                   if(uptime==3){uw3++;}
                   if(uptime==4){uw4++;}
                   if(uptime==5){uw5++;}
                   if(uptime==6){uw6++;}
                   if(uptime==7){uw7++;}
                   if(uptime==8){uw8++;}
                   if(uptime==9){uw9++;}
                   if(uptime==10){uw10++;}
                   if(uptime==11){uw11++;}
                   if(uptime==12){uw12++;}
                   if(uptime==13){uw13++;}
                   if(uptime==14){uw14++;}
                   if(uptime==15){uw15++;}
                   if(uptime==16){uw16++;}
                   if(uptime==17){uw17++;}
                   if(uptime==18){uw18++;}
                   if(uptime==19){uw19++;}
                   if(uptime==20){uw20++;}
                   if(uptime==21){uw21++;}
                   if(uptime==22){uw22++;}
                   if(uptime==23){uw23++;} 
                  }
                  else{
                           Buffer_3[i] = iLow(NULL,0,i)-Timeframe*5*Point;                           
                           martin2price = iClose(NULL,0,i);              
                           martinflag2 = true;                                    
                           //if(i == 1){Alert(Symbol()," M"+Period(),"  SecondMartin HIGH  ");}   
                           martinflag = false;                                      
                           losecnt++;                     
                           lose++;
                           win = 0;                  
                           sonsitu = sonsitu+bet*3;  
                      if(ti==1){losecnt01++;}
                      if(ti==2){losecnt02++;}
                      if(ti==3){losecnt03++;}
                      if(ti==4){losecnt04++;}
                      if(ti==5){losecnt05++;}                              
                           if(uptime==0){ul0++;}
                   if(uptime==1){ul1++;}
                   if(uptime==2){ul2++;}
                   if(uptime==3){ul3++;}
                   if(uptime==4){ul4++;}
                   if(uptime==5){ul5++;}
                   if(uptime==6){ul6++;}
                   if(uptime==7){ul7++;}
                   if(uptime==8){ul8++;}
                   if(uptime==9){ul9++;}
                   if(uptime==10){ul10++;}
                   if(uptime==11){ul11++;}
                   if(uptime==12){ul12++;}
                   if(uptime==13){ul13++;}
                   if(uptime==14){ul14++;}
                   if(uptime==15){ul15++;}
                   if(uptime==16){ul16++;}
                   if(uptime==17){ul17++;}
                   if(uptime==18){ul18++;}
                   if(uptime==19){ul19++;}
                   if(uptime==20){ul20++;}
                   if(uptime==21){ul21++;}
                   if(uptime==22){ul22++;}
                   if(uptime==23){ul23++;}                                              
                  }  
                  mminute = 0;                
              }
              mminute++;
          }
          
          
          if(dnentryflag == true){
          
              if(dntime>=24){dntime=dntime-24;}
          
              if(q <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(dnminute == Hantei+1){        
                  if(eprice2 > iClose(NULL,0,i)){            
                      Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                      dnentryflag = false;
                     if(ti==1){wincnt01++;}
                      if(ti==2){wincnt02++;}
                      if(ti==3){wincnt03++;}
                      if(ti==4){wincnt04++;}
                      if(ti==5){wincnt05++;}                       
                      wincnt++;              
                      money = money+(bet*payout);  
                      win++;
                      lose = 0; 
                      rieki = rieki+(bet*payout-bet);
                      if(dntime==0){dw0++;}
                  if(dntime==1){dw1++;}
                  if(dntime==2){dw2++;}
                  if(dntime==3){dw3++;}
                  if(dntime==4){dw4++;}
                  if(dntime==5){dw5++;}
                  if(dntime==6){dw6++;}
                  if(dntime==7){dw7++;}
                  if(dntime==8){dw8++;}
                  if(dntime==9){dw9++;}
                  if(dntime==10){dw10++;}
                  if(dntime==11){dw11++;}
                  if(dntime==12){dw12++;}
                  if(dntime==13){dw13++;}
                  if(dntime==14){dw14++;}
                  if(dntime==15){dw15++;}
                  if(dntime==16){dw16++;}
                  if(dntime==17){dw17++;}
                  if(dntime==18){dw18++;}
                  if(dntime==19){dw19++;}
                  if(dntime==20){dw20++;}
                  if(dntime==21){dw21++;}
                  if(dntime==22){dw22++;}
                  if(dntime==23){dw23++;}                                           
                  }                  
                  else{
                           Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                           
                           if(martin >= 1){
                               dnmartinflag = true;
                               dnmartin1price = iClose(NULL,0,i);                                                  
                               //if(i == 1){Alert(Symbol()," M"+Period(),"  FirstMartin LOW  ");}     
                               dnentryflag = false;        
                               money = money-(bet*2);      
                           }         
                           else{
                                     losecnt++;         
                                     lose++;
                                     win = 0;    
                                     sonsitu = sonsitu+bet;     
                                     dnentryflag = false; 
                     if(ti==1){losecnt01++;}
                      if(ti==2){losecnt02++;}
                      if(ti==3){losecnt03++;}
                      if(ti==4){losecnt04++;}
                      if(ti==5){losecnt05++;}                                       
                                      if(dntime==0){dl0++;}
                  if(dntime==1){dl1++;}
                  if(dntime==2){dl2++;}
                  if(dntime==3){dl3++;}
                  if(dntime==4){dl4++;}
                  if(dntime==5){dl5++;}
                  if(dntime==6){dl6++;}
                  if(dntime==7){dl7++;}
                  if(dntime==8){dl8++;}
                  if(dntime==9){dl9++;}
                  if(dntime==10){dl10++;}
                  if(dntime==11){dl11++;}
                  if(dntime==12){dl12++;}
                  if(dntime==13){dl13++;}
                  if(dntime==14){dl14++;}
                  if(dntime==15){dl15++;}
                  if(dntime==16){dl16++;}
                  if(dntime==17){dl17++;}
                  if(dntime==18){dl18++;}
                  if(dntime==19){dl19++;}
                  if(dntime==20){dl20++;}
                  if(dntime==21){dl21++;}
                  if(dntime==22){dl22++;}
                  if(dntime==23){dl23++;}                         
                           }                                                                                                   
                   }
                   dnminute = 0;
              }
          dnminute++;   
          }  




          if(dnentryflag2 == true){
              if(q <= 1){Hantei2 = hantei-1;}
              else{Hantei2 = hantei;}              
              if(dnminute2 == Hantei2+1){        
                  if(eprice02 > iClose(NULL,0,i)){            
                      Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                      dnentryflag2 = false;
                      
                      wincnt++;              
                      money = money+(bet*payout);  
                      win++;
                      lose = 0; 
                      rieki = rieki+(bet*payout-bet);  
                      if(ti==1){wincnt01++;}
                      if(ti==2){wincnt02++;}
                      if(ti==3){wincnt03++;}
                      if(ti==4){wincnt04++;}
                      if(ti==5){wincnt05++;}                      
                      if(dntime==0){dw0++;}
                  if(dntime==1){dw1++;}
                  if(dntime==2){dw2++;}
                  if(dntime==3){dw3++;}
                  if(dntime==4){dw4++;}
                  if(dntime==5){dw5++;}
                  if(dntime==6){dw6++;}
                  if(dntime==7){dw7++;}
                  if(dntime==8){dw8++;}
                  if(dntime==9){dw9++;}
                  if(dntime==10){dw10++;}
                  if(dntime==11){dw11++;}
                  if(dntime==12){dw12++;}
                  if(dntime==13){dw13++;}
                  if(dntime==14){dw14++;}
                  if(dntime==15){dw15++;}
                  if(dntime==16){dw16++;}
                  if(dntime==17){dw17++;}
                  if(dntime==18){dw18++;}
                  if(dntime==19){dw19++;}
                  if(dntime==20){dw20++;}
                  if(dntime==21){dw21++;}
                  if(dntime==22){dw22++;}
                  if(dntime==23){dw23++;}                                         
                  }                  
                  else{
                           Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                           
                           if(martin >= 1){
                               dnmartinflag = true;
                               dnmartin1price = iClose(NULL,0,i);                                                  
                               //if(i == 1){Alert(Symbol()," M"+Period(),"  FirstMartin LOW  ");}     
                               dnentryflag2 = false;        
                               money = money-(bet*2);      
                           }         
                           else{
                                     losecnt++;         
                                     lose++;
                                     win = 0;    
                                     sonsitu = sonsitu+bet;     
                                     dnentryflag2 = false; 
                                      if(dntime==0){dl0++;}
                      if(ti==1){losecnt01++;}
                      if(ti==2){losecnt02++;}
                      if(ti==3){losecnt03++;}
                      if(ti==4){losecnt04++;}
                      if(ti==5){losecnt05++;}                                         
                  if(dntime==1){dl1++;}
                  if(dntime==2){dl2++;}
                  if(dntime==3){dl3++;}
                  if(dntime==4){dl4++;}
                  if(dntime==5){dl5++;}
                  if(dntime==6){dl6++;}
                  if(dntime==7){dl7++;}
                  if(dntime==8){dl8++;}
                  if(dntime==9){dl9++;}
                  if(dntime==10){dl10++;}
                  if(dntime==11){dl11++;}
                  if(dntime==12){dl12++;}
                  if(dntime==13){dl13++;}
                  if(dntime==14){dl14++;}
                  if(dntime==15){dl15++;}
                  if(dntime==16){dl16++;}
                  if(dntime==17){dl17++;}
                  if(dntime==18){dl18++;}
                  if(dntime==19){dl19++;}
                  if(dntime==20){dl20++;}
                  if(dntime==21){dl21++;}
                  if(dntime==22){dl22++;}
                  if(dntime==23){dl23++;}                         
                           }                                                                                                   
                   }
                   dnminute2 = 0;
              }
          dnminute2++;   
          }   

          if(dnentryflag3 == true){
              if(q <= 1){Hantei3 = hantei-1;}
              else{Hantei3 = hantei;}              
              if(dnminute3 == Hantei3+1){        
                  if(eprice002 > iClose(NULL,0,i)){            
                      Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                      dnentryflag3 = false;
                      
                      wincnt++;              
                      money = money+(bet*payout);  
                      win++;
                      lose = 0; 
                      rieki = rieki+(bet*payout-bet);   
                      if(ti==1){wincnt01++;}
                      if(ti==2){wincnt02++;}
                      if(ti==3){wincnt03++;}
                      if(ti==4){wincnt04++;}
                      if(ti==5){wincnt05++;}                       
                      if(dntime==0){dw0++;}
                  if(dntime==1){dw1++;}
                  if(dntime==2){dw2++;}
                  if(dntime==3){dw3++;}
                  if(dntime==4){dw4++;}
                  if(dntime==5){dw5++;}
                  if(dntime==6){dw6++;}
                  if(dntime==7){dw7++;}
                  if(dntime==8){dw8++;}
                  if(dntime==9){dw9++;}
                  if(dntime==10){dw10++;}
                  if(dntime==11){dw11++;}
                  if(dntime==12){dw12++;}
                  if(dntime==13){dw13++;}
                  if(dntime==14){dw14++;}
                  if(dntime==15){dw15++;}
                  if(dntime==16){dw16++;}
                  if(dntime==17){dw17++;}
                  if(dntime==18){dw18++;}
                  if(dntime==19){dw19++;}
                  if(dntime==20){dw20++;}
                  if(dntime==21){dw21++;}
                  if(dntime==22){dw22++;}
                  if(dntime==23){dw23++;}                                        
                  }                  
                  else{
                           Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                           
                           if(martin >= 1){
                               dnmartinflag = true;
                               dnmartin1price = iClose(NULL,0,i);                                                  
                               //if(i == 1){Alert(Symbol()," M"+Period(),"  FirstMartin LOW  ");}     
                               dnentryflag3 = false;        
                               money = money-(bet*2);      
                           }         
                           else{
                                     losecnt++;         
                                     lose++;
                                     win = 0;    
                                     sonsitu = sonsitu+bet;     
                                     dnentryflag3 = false;  
                      if(ti==1){losecnt01++;}
                      if(ti==2){losecnt02++;}
                      if(ti==3){losecnt03++;}
                      if(ti==4){losecnt04++;}
                      if(ti==5){losecnt05++;}                                        
                                      if(dntime==0){dl0++;}
                  if(dntime==1){dl1++;}
                  if(dntime==2){dl2++;}
                  if(dntime==3){dl3++;}
                  if(dntime==4){dl4++;}
                  if(dntime==5){dl5++;}
                  if(dntime==6){dl6++;}
                  if(dntime==7){dl7++;}
                  if(dntime==8){dl8++;}
                  if(dntime==9){dl9++;}
                  if(dntime==10){dl10++;}
                  if(dntime==11){dl11++;}
                  if(dntime==12){dl12++;}
                  if(dntime==13){dl13++;}
                  if(dntime==14){dl14++;}
                  if(dntime==15){dl15++;}
                  if(dntime==16){dl16++;}
                  if(dntime==17){dl17++;}
                  if(dntime==18){dl18++;}
                  if(dntime==19){dl19++;}
                  if(dntime==20){dl20++;}
                  if(dntime==21){dl21++;}
                  if(dntime==22){dl22++;}
                  if(dntime==23){dl23++;}                        
                           }                                                                                                   
                   }
                   dnminute3 = 0;
              }
          dnminute3++;   
          }  



         
          if(dnmartinflag == true){
              if(dnmminute == hantei+1){                          
                  if(dnmartin1price > iClose(NULL,0,i)){  
                      Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                      wincnt++;                  
                      dnmartinflag = false;  
                      money = money+(bet*2*payout);       
                      win++;
                      lose = 0; 
                      if(ti==1){wincnt01++;}
                      if(ti==2){wincnt02++;}
                      if(ti==3){wincnt03++;}
                      if(ti==4){wincnt04++;}
                      if(ti==5){wincnt05++;}                     
                      
                      rieki = rieki+(bet*2*payout-(bet*2+bet));  
                      if(dntime==0){dw0++;}
                  if(dntime==1){dw1++;}
                  if(dntime==2){dw2++;}
                  if(dntime==3){dw3++;}
                  if(dntime==4){dw4++;}
                  if(dntime==5){dw5++;}
                  if(dntime==6){dw6++;}
                  if(dntime==7){dw7++;}
                  if(dntime==8){dw8++;}
                  if(dntime==9){dw9++;}
                  if(dntime==10){dw10++;}
                  if(dntime==11){dw11++;}
                  if(dntime==12){dw12++;}
                  if(dntime==13){dw13++;}
                  if(dntime==14){dw14++;}
                  if(dntime==15){dw15++;}
                  if(dntime==16){dw16++;}
                  if(dntime==17){dw17++;}
                  if(dntime==18){dw18++;}
                  if(dntime==19){dw19++;}
                  if(dntime==20){dw20++;}
                  if(dntime==21){dw21++;}
                  if(dntime==22){dw22++;}
                  if(dntime==23){dw23++;}                              
                  }
                  else{
                           Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*15*Point;                           
                           dnmartin2price = iClose(NULL,0,i);              
                           dnmartinflag2 = true;                                    
                           //if(i == 1){Alert(Symbol()," M"+Period(),"  SecondMartin LOW  ");}   
                           dnmartinflag = false;      
                           losecnt++;         
                           lose++;
                           win = 0;    
                           sonsitu = sonsitu+bet*3;   
                            if(dntime==0){dl0++;}
                      if(ti==1){losecnt01++;}
                      if(ti==2){losecnt02++;}
                      if(ti==3){losecnt03++;}
                      if(ti==4){losecnt04++;}
                      if(ti==5){losecnt05++;}                               
                  if(dntime==1){dl1++;}
                  if(dntime==2){dl2++;}
                  if(dntime==3){dl3++;}
                  if(dntime==4){dl4++;}
                  if(dntime==5){dl5++;}
                  if(dntime==6){dl6++;}
                  if(dntime==7){dl7++;}
                  if(dntime==8){dl8++;}
                  if(dntime==9){dl9++;}
                  if(dntime==10){dl10++;}
                  if(dntime==11){dl11++;}
                  if(dntime==12){dl12++;}
                  if(dntime==13){dl13++;}
                  if(dntime==14){dl14++;}
                  if(dntime==15){dl15++;}
                  if(dntime==16){dl16++;}
                  if(dntime==17){dl17++;}
                  if(dntime==18){dl18++;}
                  if(dntime==19){dl19++;}
                  if(dntime==20){dl20++;}
                  if(dntime==21){dl21++;}
                  if(dntime==22){dl22++;}
                  if(dntime==23){dl23++;}                                                                                                              
                  }  
                  dnmminute = 0;                
              }
              dnmminute++;
          }           
          

          
          if(Max == 0){Max = money;}
          if(Max != 0){
              Max = MathMax(Max, money);
          }
          
          dd = Max - money;
          maxdd = MathMax(dd, maxdd); 
          
          if(Min == 0){Min = money;}
          if(Min != 0){
              Min = MathMin(Min, money);
          }     
 
          if(maxwin == 0){maxwin = win;}
          if(maxwin != 0){
              maxwin = MathMax(maxwin, win);
          }
          
          if(maxlose == 0){maxlose = lose;}
          if(maxlose != 0){
              maxlose = MathMax(maxlose, lose);
          }                      

           totalcnt = wincnt + losecnt;      
           if(wincnt > 0){percent = MathRound((wincnt / totalcnt)*100);} else percent = 0;
           if(rieki != 0 && sonsitu != 0){pf = NormalizeDouble(rieki/sonsitu, 2);}
           
           if(Buffer_2[i] != EMPTY_VALUE || Buffer_3[i] != EMPTY_VALUE){
                //filewrite(entrylog);
           }         
                            
           if(testlabel == true){                   
               ObjectCreate("counttotal",OBJ_LABEL,0,0,0);
               ObjectSet("counttotal",OBJPROP_CORNER,0);
               ObjectSet("counttotal",OBJPROP_XDISTANCE,5);
               ObjectSet("counttotal",OBJPROP_YDISTANCE,10);
  
               ObjectCreate("counttotal2",OBJ_LABEL,0,0,0);
               ObjectSet("counttotal2",OBJPROP_CORNER,0);
               ObjectSet("counttotal2",OBJPROP_XDISTANCE,5);
               ObjectSet("counttotal2",OBJPROP_YDISTANCE,30);
               
               ObjectCreate("counttotal3",OBJ_LABEL,0,0,0);
               ObjectSet("counttotal3",OBJPROP_CORNER,0);
               ObjectSet("counttotal3",OBJPROP_XDISTANCE,5);
               ObjectSet("counttotal3",OBJPROP_YDISTANCE,50);
               
               ObjectCreate("counttotal4",OBJ_LABEL,0,0,0);
               ObjectSet("counttotal4",OBJPROP_CORNER,0);
               ObjectSet("counttotal4",OBJPROP_XDISTANCE,5);
               ObjectSet("counttotal4",OBJPROP_YDISTANCE,70);             
                                  
               ObjectCreate("counttotal5",OBJ_LABEL,0,0,0);
               ObjectSet("counttotal5",OBJPROP_CORNER,0);
               ObjectSet("counttotal5",OBJPROP_XDISTANCE,5);
               ObjectSet("counttotal5",OBJPROP_YDISTANCE,90);
               
               ObjectCreate("counttotal6",OBJ_LABEL,0,0,0);
               ObjectSet("counttotal6",OBJPROP_CORNER,0);
               ObjectSet("counttotal6",OBJPROP_XDISTANCE,5);
               ObjectSet("counttotal6",OBJPROP_YDISTANCE,110);   
  
               ObjectCreate("counttotal7",OBJ_LABEL,0,0,0);
               ObjectSet("counttotal7",OBJPROP_CORNER,0);
               ObjectSet("counttotal7",OBJPROP_XDISTANCE,5);
               ObjectSet("counttotal7",OBJPROP_YDISTANCE,130);   
  
               ObjectCreate("counttotal8",OBJ_LABEL,0,0,0);
               ObjectSet("counttotal8",OBJPROP_CORNER,0);
               ObjectSet("counttotal8",OBJPROP_XDISTANCE,5);
               ObjectSet("counttotal8",OBJPROP_YDISTANCE,150); 
               
               
               
               //------------------------------------------------------------   
   ObjectCreate("counttotal00",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal00",OBJPROP_CORNER,0);
   ObjectSet("counttotal00",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal00",OBJPROP_YDISTANCE,170);
    
   ObjectCreate("counttotal01",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal01",OBJPROP_CORNER,0);
   ObjectSet("counttotal01",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal01",OBJPROP_YDISTANCE,190);     
    
   ObjectCreate("counttotal02",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal02",OBJPROP_CORNER,0);
   ObjectSet("counttotal02",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal02",OBJPROP_YDISTANCE,210); 
   
   ObjectCreate("counttotal03",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal03",OBJPROP_CORNER,0);
   ObjectSet("counttotal03",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal03",OBJPROP_YDISTANCE,230);
    
   ObjectCreate("counttotal04",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal04",OBJPROP_CORNER,0);
   ObjectSet("counttotal04",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal04",OBJPROP_YDISTANCE,250);     
    
   ObjectCreate("counttotal05",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal05",OBJPROP_CORNER,0);
   ObjectSet("counttotal05",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal05",OBJPROP_YDISTANCE,270);
   
   ObjectCreate("counttotal06",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal06",OBJPROP_CORNER,0);
   ObjectSet("counttotal06",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal06",OBJPROP_YDISTANCE,290);
    
   ObjectCreate("counttotal07",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal07",OBJPROP_CORNER,0);
   ObjectSet("counttotal07",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal07",OBJPROP_YDISTANCE,310);     
    
   ObjectCreate("counttotal08",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal08",OBJPROP_CORNER,0);
   ObjectSet("counttotal08",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal08",OBJPROP_YDISTANCE,330); 
   
   ObjectCreate("counttotal09",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal09",OBJPROP_CORNER,0);
   ObjectSet("counttotal09",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal09",OBJPROP_YDISTANCE,350);
    
   ObjectCreate("counttotal10",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal10",OBJPROP_CORNER,0);
   ObjectSet("counttotal10",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal10",OBJPROP_YDISTANCE,370);     
    
   ObjectCreate("counttotal11",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal11",OBJPROP_CORNER,0);
   ObjectSet("counttotal11",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal11",OBJPROP_YDISTANCE,390);     
   
   ObjectCreate("counttotal12",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal12",OBJPROP_CORNER,0);
   ObjectSet("counttotal12",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal12",OBJPROP_YDISTANCE,410);
    
   ObjectCreate("counttotal13",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal13",OBJPROP_CORNER,0);
   ObjectSet("counttotal13",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal13",OBJPROP_YDISTANCE,430);     
    
   ObjectCreate("counttotal14",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal14",OBJPROP_CORNER,0);
   ObjectSet("counttotal14",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal14",OBJPROP_YDISTANCE,450); 
   
   ObjectCreate("counttotal15",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal15",OBJPROP_CORNER,0);
   ObjectSet("counttotal15",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal15",OBJPROP_YDISTANCE,470);
    
   ObjectCreate("counttotal16",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal16",OBJPROP_CORNER,0);
   ObjectSet("counttotal16",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal16",OBJPROP_YDISTANCE,490);     
    
   ObjectCreate("counttotal17",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal17",OBJPROP_CORNER,0);
   ObjectSet("counttotal17",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal17",OBJPROP_YDISTANCE,510);
   
   ObjectCreate("counttotal18",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal18",OBJPROP_CORNER,0);
   ObjectSet("counttotal18",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal18",OBJPROP_YDISTANCE,530);
    
   ObjectCreate("counttotal19",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal19",OBJPROP_CORNER,0);
   ObjectSet("counttotal19",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal19",OBJPROP_YDISTANCE,550);     
    
   ObjectCreate("counttotal20",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal20",OBJPROP_CORNER,0);
   ObjectSet("counttotal20",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal20",OBJPROP_YDISTANCE,570); 
   
   ObjectCreate("counttotal21",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal21",OBJPROP_CORNER,0);
   ObjectSet("counttotal21",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal21",OBJPROP_YDISTANCE,590);
    
   ObjectCreate("counttotal22",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal22",OBJPROP_CORNER,0);
   ObjectSet("counttotal22",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal22",OBJPROP_YDISTANCE,610);     
    
   ObjectCreate("counttotal23",OBJ_LABEL,0,0,0);
   ObjectSet("counttotal23",OBJPROP_CORNER,0);
   ObjectSet("counttotal23",OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal23",OBJPROP_YDISTANCE,630); 

   ObjectCreate("Day1",OBJ_LABEL,0,0,0);
   ObjectSet("Day1",OBJPROP_CORNER,DC);
   ObjectSet("Day1",OBJPROP_XDISTANCE,5);
   ObjectSet("Day1",OBJPROP_YDISTANCE,750); 
   
   ObjectCreate("Day2",OBJ_LABEL,0,0,0);
   ObjectSet("Day2",OBJPROP_CORNER,DC);
   ObjectSet("Day2",OBJPROP_XDISTANCE,5);
   ObjectSet("Day2",OBJPROP_YDISTANCE,730);       

   ObjectCreate("Day3",OBJ_LABEL,0,0,0);
   ObjectSet("Day3",OBJPROP_CORNER,DC);
   ObjectSet("Day3",OBJPROP_XDISTANCE,5);
   ObjectSet("Day3",OBJPROP_YDISTANCE,710); 
   
   ObjectCreate("Day4",OBJ_LABEL,0,0,0);
   ObjectSet("Day4",OBJPROP_CORNER,DC);
   ObjectSet("Day4",OBJPROP_XDISTANCE,5);
   ObjectSet("Day4",OBJPROP_YDISTANCE,690); 
   
   ObjectCreate("Day5",OBJ_LABEL,0,0,0);
   ObjectSet("Day5",OBJPROP_CORNER,DC);
   ObjectSet("Day5",OBJPROP_XDISTANCE,5);
   ObjectSet("Day5",OBJPROP_YDISTANCE,670);   
   
                  
               ObjectSetText("counttotal", "Total:"+totalcnt+"回"+" Win:"+wincnt+"回"+" Lose:"+losecnt+"回"+" 勝率:"+percent+"%", 12, "MS ゴシック",White);      
               ObjectSetText("counttotal2", "残高"+money+"円", 12, "MS ゴシック",White); 
               ObjectSetText("counttotal3", "最大残高"+Max+"円", 12, "MS ゴシック",White);
               ObjectSetText("counttotal4", "最小残高"+Min+"円", 12, "MS ゴシック",White);                                 
               ObjectSetText("counttotal5", "最大連勝"+maxwin+"回", 12, "MS ゴシック",White);
               ObjectSetText("counttotal6", "最大連敗"+maxlose+"回", 12, "MS ゴシック",White);  
               ObjectSetText("counttotal7", "総利益:"+rieki+"円"+" 総損失:-"+sonsitu+"円"+" PF:"+pf, 12, "MS ゴシック",White);  
               ObjectSetText("counttotal8", "最大ドローダウン:-"+maxdd+"円", 12, "MS ゴシック",White); 
               
                t0=dw0+uw0+dl0+ul0;
       t1=dw1+uw1+dl1+ul1;
       t2=dw2+uw2+dl2+ul2;
       t3=dw3+uw3+dl3+ul3;
       t4=dw4+uw4+dl4+ul4;
       t5=dw5+uw5+dl5+ul5;
       t6=dw6+uw6+dl6+ul6;
       t7=dw7+uw7+dl7+ul7;
       t8=dw8+uw8+dl8+ul8;
       t9=dw9+uw9+dl9+ul9;
       t10=dw10+uw10+dl10+ul10;
       t11=dw11+uw11+dl11+ul11;
       t12=dw12+uw12+dl12+ul12;
       t13=dw13+uw13+dl13+ul13;
       t14=dw14+uw14+dl14+ul14;
       t15=dw15+uw15+dl15+ul15;
       t16=dw16+uw16+dl16+ul16;
       t17=dw17+uw17+dl17+ul17;
       t18=dw18+uw18+dl18+ul18;
       t19=dw19+uw19+dl19+ul19;
       t20=dw20+uw20+dl20+ul20;
       t21=dw21+uw21+dl21+ul21;
       t22=dw22+uw22+dl22+ul22;
       t23=dw23+uw23+dl23+ul23;
       
       int tw0=dw0+uw0;
       int tw1=dw1+uw1;
       int tw2=dw2+uw2;
       int tw3=dw3+uw3;
       int tw4=dw4+uw4;
       int tw5=dw5+uw5;
       int tw6=dw6+uw6;
       int tw7=dw7+uw7;
       int tw8=dw8+uw8;
       int tw9=dw9+uw9;
       int tw10=dw10+uw10;
       int tw11=dw11+uw11;
       int tw12=dw12+uw12;
       int tw13=dw13+uw13;
       int tw14=dw14+uw14;
       int tw15=dw15+uw15;
       int tw16=dw16+uw16;
       int tw17=dw17+uw17;
       int tw18=dw18+uw18;
       int tw19=dw19+uw19;
       int tw20=dw20+uw20;
       int tw21=dw21+uw21;
       int tw22=dw22+uw22;
       int tw23=dw23+uw23;

totalcnt01 = wincnt01+losecnt01;
totalcnt02 = wincnt02+losecnt02;
totalcnt03 = wincnt03+losecnt03;
totalcnt04 = wincnt04+losecnt04;
totalcnt05 = wincnt05+losecnt05;

if(wincnt01 > 0){percent01 = MathRound((wincnt01 / totalcnt01)*100);} else percent01 = 0;   
if(wincnt02 > 0){percent02 = MathRound((wincnt02 / totalcnt02)*100);} else percent02 = 0;
if(wincnt03 > 0){percent03 = MathRound((wincnt03 / totalcnt03)*100);} else percent03 = 0;
if(wincnt04 > 0){percent04 = MathRound((wincnt04 / totalcnt04)*100);} else percent04 = 0;
if(wincnt05 > 0){percent05 = MathRound((wincnt05 / totalcnt05)*100);} else percent05 = 0;        
       
       //Comment(t0);
       //時間別勝率
       if(t0 > 0){to0=MathRound((tw0 / t0)*100);}else to0 = 0;
       if(t1 > 0){to1=MathRound((tw1 / t1)*100);}else to1 = 0;
       if(t2 > 0){to2=MathRound((tw2 / t2)*100);}else to2 = 0;
       if(t3 > 0){to3=MathRound((tw3 / t3)*100);}else to3 = 0;
       if(t4 > 0){to4=MathRound((tw4 / t4)*100);}else to4 = 0;
       if(t5 > 0){to5=MathRound((tw5 / t5)*100);}else to5 = 0;
       if(t6 > 0){to6=MathRound((tw6 / t6)*100);}else to6 = 0;
       if(t7 > 0){to7=MathRound((tw7 / t7)*100);}else to7 = 0;
       if(t8 > 0){to8=MathRound((tw8 / t8)*100);}else to8 = 0;
       if(t9 > 0){to9=MathRound((tw9 / t9)*100);}else to9 = 0;
       if(t10 > 0){to10=MathRound((tw10/ t10)*100);}else to10 = 0;
       if(t11 > 0){to11=MathRound((tw11 / t11)*100);}else to11 = 0;
       if(t12 > 0){to12=MathRound((tw12 / t12)*100);}else to12 = 0;
       if(t13 > 0){to13=MathRound((tw13 / t13)*100);}else to13 = 0;
       if(t14 > 0){to14=MathRound((tw14 / t14)*100);}else to14 = 0;
       if(t15 > 0){to15=MathRound((tw15 / t15)*100);}else to15 = 0;
       if(t16 > 0){to16=MathRound((tw16 / t16)*100);}else to16 = 0;
       if(t17 > 0){to17=MathRound((tw17 / t17)*100);}else to17 = 0;
       if(t18 > 0){to18=MathRound((tw18 / t18)*100);}else to18 = 0;
       if(t19 > 0){to19=MathRound((tw19 / t19)*100);}else to19 = 0;
       if(t20 > 0){to20=MathRound((tw20 / t20)*100);}else to20 = 0;
       if(t21 > 0){to21=MathRound((tw21 / t21)*100);}else to21 = 0;
       if(t22 > 0){to22=MathRound((tw22 / t22)*100);}else to22 = 0;
       if(t23 > 0){to23=MathRound((tw23 / t23)*100);}else to23 = 0;
       
      
       
       ObjectSetText("counttotal00", "0時: "+t0+"　回 勝率"+to0+" %", labelsize, "MS ゴシック",Yellow);  
       ObjectSetText("counttotal01", "1時: "+t1+"　回 勝率"+to1+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("counttotal02", "2時: "+t2+"　回 勝率"+to2+" %", labelsize, "MS ゴシック",Yellow);  
       ObjectSetText("counttotal03", "3時: "+t3+"　回 勝率"+to3+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("counttotal04", "4時: "+t4+"　回 勝率"+to4+" %", labelsize, "MS ゴシック",Yellow);  
       ObjectSetText("counttotal05", "5時: "+t5+"　回 勝率"+to5+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("counttotal06", "6時: "+t6+"　回 勝率"+to6+" %", labelsize, "MS ゴシック",Yellow);  
       ObjectSetText("counttotal07", "7時: "+t7+"　回 勝率"+to7+" %", labelsize, "MS ゴシック",Yellow); 
       ObjectSetText("counttotal08", "8時: "+t8+"　回 勝率"+to8+" %", labelsize, "MS ゴシック",Yellow);  
       ObjectSetText("counttotal09", "9時: "+t9+"　回 勝率"+to9+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("counttotal10", "10時: "+t10+"　回 勝率"+to10+" %", labelsize, "MS ゴシック",Yellow);  
       ObjectSetText("counttotal11", "11時: "+t11+"　回 勝率"+to11+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("counttotal12", "12時: "+t12+"　回 勝率"+to12+" %", labelsize, "MS ゴシック",Yellow);  
       ObjectSetText("counttotal13", "13時: "+t13+"　回 勝率"+to13+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("counttotal14", "14時: "+t14+"　回 勝率"+to14+" %", labelsize, "MS ゴシック",Yellow);  
       ObjectSetText("counttotal15", "15時: "+t15+"　回 勝率"+to15+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("counttotal16", "16時: "+t16+"　回 勝率"+to16+" %", labelsize, "MS ゴシック",Yellow);  
       ObjectSetText("counttotal17", "17時: "+t17+"　回 勝率"+to17+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("counttotal18", "18時: "+t18+"　回 勝率"+to18+" %", labelsize, "MS ゴシック",Yellow);  
       ObjectSetText("counttotal19", "19時: "+t19+"　回 勝率"+to19+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("counttotal20", "20時: "+t20+"　回 勝率"+to20+" %", labelsize, "MS ゴシック",Yellow);  
       ObjectSetText("counttotal21", "21時: "+t21+"　回 勝率"+to21+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("counttotal22", "22時: "+t22+"　回 勝率"+to22+" %", labelsize, "MS ゴシック",Yellow);  
       ObjectSetText("counttotal23", "23時: "+t23+"　回 勝率"+to23+" %", labelsize, "MS ゴシック",Yellow);    

       ObjectSetText("Day1","月曜日: "+(wincnt01+losecnt01)+"回" +"　勝"+wincnt01+" 負"+losecnt01+ " 勝率"+percent01+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("Day2","火曜日: "+(wincnt02+losecnt02)+"回" +"　勝"+wincnt02+" 負"+losecnt02+ " 勝率"+percent02+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("Day3","水曜日: "+(wincnt03+losecnt03)+"回" +"　勝"+wincnt03+" 負"+losecnt03+ " 勝率"+percent03+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("Day4","木曜日: "+(wincnt04+losecnt04)+"回" +"　勝"+wincnt04+" 負"+losecnt04+ " 勝率"+percent04+" %", labelsize, "MS ゴシック",Yellow);
       ObjectSetText("Day5","金曜日: "+(wincnt05+losecnt05)+"回" +"　勝"+wincnt05+" 負"+losecnt05+ " 勝率"+percent05+" %", labelsize, "MS ゴシック",Yellow);


                
             }           
        }
                                         
     }


}    
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
	   if(StringFind(ObjName, "rbhline") >= 0)
   	      ObjectDelete(ObjName); 
   	if(StringFind(ObjName, "Day") >= 0)
   	      ObjectDelete(ObjName);       	    	                	  
   }


  Comment("");
		
   return(0);
}// end of deinit()


void filewrite(string entrylog)
{
    
    int handle = FileOpen("BacktestDate.csv", FILE_CSV | FILE_WRITE);
    FileSeek(handle,0,SEEK_END);
    //FileWrite(handle,Symbol(),s,highlow);
    FileWrite(handle,"Total:"+totalcnt+"回","Win:"+wincnt+"回","Lose:"+losecnt+"回","勝率:"+percent+"%",
                      "残高"+money+"円", "最大残高"+Max+"円", "最小残高"+Min+"円", "最大連勝"+maxwin+"円", "最大連敗"+maxlose+"円",
                      "総利益:"+rieki+"円","総損失:-"+sonsitu+"円","PF:"+pf, "最大ドローダウン:-"+maxdd+"円");
    FileClose(handle);
}