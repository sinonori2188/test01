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
extern datetime st_haneijikan = D'2021.05.01 00:00';//判定開始
extern datetime en_haneijikan = D'2021.05.13 00:00';//判定終了
extern string Note = "その場合は02などデータがある分数に変更してください。";//※稀に00分のデータがないときがありエラーになります。
extern int money = 1000000;//初期残高
extern double payout = 1.85;//ペイアウト率
extern int bet = 10000;//BET額
extern string indiname = "bollicator";//テストインジケーター名
extern int buf1 = 0;//サイン番号1[上向き]
extern int buf2 = 1;//サイン番号2[下向き]
extern zisasentaku zisa1=zero;//日本時間orMT4時間
extern int labelsize = 10;//時間別勝率ラベル大きさ
extern int labelsize1 = 8;//分別勝率ラベル大きさ
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

int uptime,dntime,upmin,upmon,upyear,dnmin,dnmon,dnyear;


//-----------時間別、曜日別は配列に保存-------------

double losecnt0[7],wincnt0[7],totalcnt0[7],percent0[7];
double ul[24],uw[24],dl[24],dw[24];
double t[24],tw[24],to[24];

double mlosecnt0[60],mwincnt0[60],mtotalcnt0[60],mpercent0[60];

int mo=0;
int mon1[1000],year1[1000];
double ylosecnt0[1000],ywincnt0[1000],ytotalcnt0[1000],ypercent0[1000];
int LastMonth,CurrMonth;

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
   
   LastMonth=TimeMonth(st_haneijikan);
   CurrMonth=TimeMonth(st_haneijikan);
   mon1[0]=TimeMonth(st_haneijikan);
   year1[0]=TimeYear(st_haneijikan);  
   
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
      

      if(i > 1 || (i == 1 && NowBars < Bars)){ 
          NowBars = Bars;


//---曜日を保存----
     int ti = TimeDayOfWeek(iTime(NULL,0,i));
     int min=TimeMinute(iTime(NULL,0,i));
     int mon=TimeMonth(iTime(NULL,0,i));
     int year=TimeYear(iTime(NULL,0,i));

   
               
      if(TimeMonth(iTime(NULL,0,i)) < 3 || TimeMonth(iTime(NULL,0,i)) > 10){zisa=zisa1;}
      else{zisa=zisa1-1;}
      
      if(zisa1==0){zisa=zisa1;}
      
      
             
   if(iTime(NULL,0,i)>=st_haneijikan && iTime(NULL,0,i)<=en_haneijikan){//ここに検証したい条件を入れます。                                                           
     
     if(TimeMonth(iTime(NULL,0,i))!=CurrMonth )
        {
         
         LastMonth=CurrMonth;
         CurrMonth=TimeMonth(iTime(NULL,0,i));
         mo++;
         mon1[mo]=TimeMonth(iTime(NULL,0,i));
         year1[mo]=TimeYear(iTime(NULL,0,i));
         
         }    
         
          if(sign1 != 0 && sign1 != EMPTY_VALUE){
              Buffer_0[i] = iLow(NULL,0,i)-Timeframe*5*pips*Point; 
              upentryflag = true;
              uptime=TimeHour(iTime(NULL,0,i)+zisa);
              upmin=TimeMinute(iTime(NULL,0,i));
              upmon=TimeMonth(iTime(NULL,0,i));
              upyear=TimeYear(iTime(NULL,0,i));
              eprice = iClose(NULL,0,i)+(3*Point);
              
              money = money-bet;
              if(p <= 1){p++;}         
          }
          
          if(sign2 != 0 && sign2 != EMPTY_VALUE){
              Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*10*pips*Point;
              dntime=TimeHour(iTime(NULL,0,i)+zisa);
              dnmin=TimeMinute(iTime(NULL,0,i));
              dnmon=TimeMonth(iTime(NULL,0,i));
              dnyear=TimeYear(iTime(NULL,0,i));
              dnentryflag = true; 
              eprice2 = iClose(NULL,0,i);

              money = money-bet;
              if(q <= 1){q++;}
          } 
 
//勝敗判定-----------------------------------------------------------------------------------------------------------------
          if(upentryflag == true){
 
 //---日本時間にして24時以上になったときは-24しておく----             
              if(uptime>=24){uptime=uptime-24;}
          
          
              if(p <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(minute == Hantei+1){       
                  if(eprice < iClose(NULL,0,i)){            
                      Buffer_2[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                      upentryflag = false;
                      wincnt++;//勝ちカウントをプラスする            
                      money += (bet*payout);             
                      win++;
                      lose = 0;
                      rieki = rieki+(bet*payout-bet);        
 //---時間と曜日別のカウントも+1しておく----  
                     
                      wincnt0[ti]++;//月曜ならti=1
                      uw[uptime]++;//時間別も保存
                      mwincnt0[min]++;
                      ywincnt0[mo]++;
 
                  }                  
                  else{
                     Buffer_3[i] = iLow(NULL,0,i)-Timeframe*5*Point;                               
                     losecnt++;                     
                     lose++;
                     win = 0;                  
                     sonsitu = sonsitu+bet; 
                     upentryflag = false;  
                      
                     losecnt0[ti]++;//負けも同じ
                     ul[uptime]++;
                     mlosecnt0[min]++;
                     ylosecnt0[mo]++;
                                                       
                                                                                                      
                   }
                   minute = 0;
              }
          minute++;   
          }  
 
          
          if(dnentryflag == true){
          
              if(dntime>=24){dntime=dntime-24;}
          
              if(q <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(dnminute == Hantei+1){        
                  if(eprice2 > iClose(NULL,0,i)){            
                      Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                      dnentryflag = false;                      
                      wincnt++;              
                      money += (bet*payout);  
                      win++;
                      lose = 0; 
                      rieki = rieki+(bet*payout-bet);
                      wincnt0[ti]++;
                      dw[dntime]++;
                      mwincnt0[min]++;
                      ywincnt0[mo]++;
                                                          
                  }                  
                  else{
                      Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                      losecnt++;         
                      lose++;
                      win = 0;    
                      sonsitu = sonsitu+bet;     
                      dnentryflag = false; 
                     
                      losecnt0[ti]++;    
                      dl[dntime]++; 
                      mlosecnt0[min]++; 
                      ylosecnt0[mo]++;                                       
                                                                                                           
                   }
                   dnminute = 0;
              }
          dnminute++;   
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
                   
                            
//----勝率、成績表示------------
   
   if(testlabel == true ){                   

int jj=20;               
   
   for(int j=0;j<=7;j++){  
    
   ObjectCreate("counttotal"+j,OBJ_LABEL,0,0,0);
   ObjectSet("counttotal"+j,OBJPROP_CORNER,0);
   ObjectSet("counttotal"+j,OBJPROP_XDISTANCE,5);
   ObjectSet("counttotal"+j,OBJPROP_YDISTANCE,jj);
   jj += 20;
   
   }         
                  
   ObjectSetText("counttotal0", "Total:"+totalcnt+"回"+" Win:"+wincnt+"回"+" Lose:"+losecnt+"回"+" 勝率:"+percent+"%", 12, "MS ゴシック",White);      
   ObjectSetText("counttotal1", "残高"+money+"円", 12, "MS ゴシック",White); 
   ObjectSetText("counttotal2", "最大残高"+Max+"円", 12, "MS ゴシック",White);
   ObjectSetText("counttotal3", "最小残高"+Min+"円", 12, "MS ゴシック",White);                                 
   ObjectSetText("counttotal4", "最大連勝"+maxwin+"回", 12, "MS ゴシック",White);
   ObjectSetText("counttotal5", "最大連敗"+maxlose+"回", 12, "MS ゴシック",White);  
   ObjectSetText("counttotal6", "総利益:"+rieki+"円"+" 総損失:-"+sonsitu+"円"+" PF:"+pf, 12, "MS ゴシック",White);  
   ObjectSetText("counttotal7", "最大ドローダウン:-"+maxdd+"円", 12, "MS ゴシック",White); 
  
       
//----時間別勝率計算----- 
//----0時から23時までをfor文で取得  
int ab = 190; 
    
       for(int aa=0;aa<=23;aa++){
       
       t[aa]=dw[aa]+uw[aa]+dl[aa]+ul[aa];//エントリ―数
       tw[aa]=dw[aa]+uw[aa];//勝ち数
       if(t[aa] > 0){to[aa]=MathRound((tw[aa] / t[aa])*100);}else to[aa] = 0;//勝率
       
       ObjectCreate("counttotal0"+aa,OBJ_LABEL,0,0,0);
       ObjectSet("counttotal0"+aa,OBJPROP_CORNER,0);
       ObjectSet("counttotal0"+aa,OBJPROP_XDISTANCE,5);
       ObjectSet("counttotal0"+aa,OBJPROP_YDISTANCE,ab);
       ObjectSetText("counttotal0"+aa, aa+"時: "+t[aa]+"　回 勝率"+to[aa]+" %", labelsize, "MS ゴシック",Yellow);
       
       ab += 20;
       
       }

//----曜日別勝率計算-----      
int bc = 690; 
string youbi ;

       for(int cc=1;cc<=5;cc++){
       
       totalcnt0[cc] = wincnt0[cc]+losecnt0[cc];
       if(wincnt0[cc] > 0){percent0[cc] = MathRound((wincnt0[cc] / totalcnt0[cc])*100);} else percent0[cc] = 0; 
      
       if(cc==1) youbi="月曜日: ";
       if(cc==2) youbi="火曜日: ";
       if(cc==3) youbi="水曜日: ";
       if(cc==4) youbi="木曜日: ";
       if(cc==5) youbi="金曜日: ";
      
       ObjectCreate("Day"+cc,OBJ_LABEL,0,0,0);
       ObjectSet("Day+"+cc,OBJPROP_CORNER,0);
       ObjectSet("Day"+cc,OBJPROP_XDISTANCE,5);
       ObjectSet("Day"+cc,OBJPROP_YDISTANCE,bc);
       ObjectSetText("Day"+cc,youbi+(wincnt0[cc]+losecnt0[cc])+"回" +"　勝"+wincnt0[cc]+" 負"+losecnt0[cc]+ " 勝率"+percent0[cc]+" %", labelsize, "MS ゴシック",Yellow);
      
       bc += 20;
      
       }

//----分別勝率計算-----      
int cd = 10; 


       for(int dd=0;dd<=59;dd++){
       
       mtotalcnt0[dd] = mwincnt0[dd]+mlosecnt0[dd];
       if(mwincnt0[dd] > 0){mpercent0[dd] = MathRound((mwincnt0[dd] / mtotalcnt0[dd])*100);} else mpercent0[dd] = 0; 
      
      
       ObjectCreate("Min"+dd,OBJ_LABEL,0,0,0);
       ObjectSet("Min+"+dd,OBJPROP_CORNER,0);
       ObjectSet("Min"+dd,OBJPROP_XDISTANCE,400);
       ObjectSet("Min"+dd,OBJPROP_YDISTANCE,cd);
       ObjectSetText("Min"+dd,dd+"分: "+(mwincnt0[dd]+mlosecnt0[dd])+"回" +"　勝"+mwincnt0[dd]+" 負"+mlosecnt0[dd]+ " 勝率"+mpercent0[dd]+" %", labelsize1, "MS ゴシック",Yellow);
      
       cd += 15;
      
       }       
       

//----年月別勝率計算-----      
int de = 10; 


       for(int ee=0;ee<=mo;ee++){
       
       ytotalcnt0[ee] = ywincnt0[ee]+ylosecnt0[ee];
       if(ywincnt0[ee] > 0){ypercent0[ee] = MathRound((ywincnt0[ee] / ytotalcnt0[ee])*100);} else ypercent0[ee] = 0; 
      
      
       ObjectCreate("Year"+ee,OBJ_LABEL,0,0,0);
       ObjectSet("Year+"+ee,OBJPROP_CORNER,0);
       ObjectSet("Year"+ee,OBJPROP_XDISTANCE,750);
       ObjectSet("Year"+ee,OBJPROP_YDISTANCE,de);
       ObjectSetText("Year"+ee,year1[ee]+"年"+mon1[ee]+"月: "+(ywincnt0[ee]+ylosecnt0[ee])+"回" +"　勝"+ywincnt0[ee]+" 負"+ylosecnt0[ee]+ " 勝率"+ypercent0[ee]+" %", labelsize1, "MS ゴシック",Yellow);
       
       de += 15;
      
       } 

                
       }//勝率
                  
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
   	if(StringFind(ObjName, "Min") >= 0)
   	      ObjectDelete(ObjName); 
   	if(StringFind(ObjName, "Year") >= 0)
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