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

//extern int labelsize = 10;//勝率ラベル大きさ
extern int hantei = 1;//判定本数
extern int martin = 0;//マーチン回数(現状では1回まで)
extern double pips = 2;//サイン表示位置調整
extern bool testlabel = true;//バックテストラベル表示
extern datetime st_haneijikan = D'2015.01.01 00:00';//判定開始
extern datetime en_haneijikan = D'2019.12.31 00:00';//判定終了
extern string Note = "その場合は02などデータがある分数に変更してください。";//※稀に00分のデータがないときがありエラーになります。
extern int money = 1000000;//初期残高
extern double payout = 1.88;//ペイアウト率
extern int bet = 10000;//BET額
extern string indiname = " ";//テストインジケーター名
extern int buf1 = 0;//サイン番号1[上向き]
extern int buf2 = 1;//サイン番号2[下向き]

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
int handle;
string entrylog = " ";
double sign1, sign2;


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

     if(iTime(NULL,0,i)>=st_haneijikan && iTime(NULL,0,i)<=en_haneijikan){//ここに検証したい条件を入れます。
                                                         
          if(sign1 != 0 && sign1 != EMPTY_VALUE){
              Buffer_0[i] = iLow(NULL,0,i)-Timeframe*5*pips*Point;  
              if(upentryflag == true && upentryflag2 == true && upentryflag3 == false){upentryflag3 = true; eprice001 = iClose(NULL,0,i);}                           
              if(upentryflag == true && upentryflag2 == false){upentryflag2 = true; eprice01 = iClose(NULL,0,i);}                           
              if(upentryflag == false){upentryflag = true; eprice = iClose(NULL,0,i);}

              money = money-bet;
              if(p <= 1){p++;}         
          }
          
          if(sign2 != 0 && sign2 != EMPTY_VALUE){
              Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*10*pips*Point;
              
              if(dnentryflag == true && dnentryflag2 == true && dnentryflag3 == false){dnentryflag3 = true; eprice002 = iClose(NULL,0,i);}                 
              if(dnentryflag == true && dnentryflag2 == false){dnentryflag2 = true; eprice02 = iClose(NULL,0,i);}                           
              if(dnentryflag == false){dnentryflag = true; eprice2 = iClose(NULL,0,i);}

              money = money-bet;
              if(q <= 1){q++;}
          } 
 
          //勝敗判定-----------------------------------------------------------------------------------------------------------------
          if(upentryflag == true){
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
                  }  
                  mminute = 0;                
              }
              mminute++;
          }
          
          
          if(dnentryflag == true){
              if(q <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(dnminute == Hantei+1){        
                  if(eprice2 > iClose(NULL,0,i)){            
                      Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*15*Point;
                      dnentryflag = false;
                      
                      wincnt++;              
                      money = money+(bet*payout);  
                      win++;
                      lose = 0; 
                      rieki = rieki+(bet*payout-bet);                                          
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
                      rieki = rieki+(bet*2*payout-(bet*2+bet));                               
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
               
               ObjectSetText("counttotal", "Total:"+totalcnt+"回"+" Win:"+wincnt+"回"+" Lose:"+losecnt+"回"+" 勝率:"+percent+"%", 12, "MS ゴシック",White);      
               ObjectSetText("counttotal2", "残高"+money+"円", 12, "MS ゴシック",White); 
               ObjectSetText("counttotal3", "最大残高"+Max+"円", 12, "MS ゴシック",White);
               ObjectSetText("counttotal4", "最小残高"+Min+"円", 12, "MS ゴシック",White);                                 
               ObjectSetText("counttotal5", "最大連勝"+maxwin+"回", 12, "MS ゴシック",White);
               ObjectSetText("counttotal6", "最大連敗"+maxlose+"回", 12, "MS ゴシック",White);  
               ObjectSetText("counttotal7", "総利益:"+rieki+"円"+" 総損失:-"+sonsitu+"円"+" PF:"+pf, 12, "MS ゴシック",White);  
               ObjectSetText("counttotal8", "最大ドローダウン:-"+maxdd+"円", 12, "MS ゴシック",White);  
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