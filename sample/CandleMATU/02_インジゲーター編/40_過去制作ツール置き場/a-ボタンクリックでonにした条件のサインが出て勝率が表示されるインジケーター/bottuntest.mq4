//+------------------------------------------------------------------+
//|                                                      RSIsign.mq4 |
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
   
   
int    chart_id = 0;
      
         ObjectCreate(chart_id,               
                                   "onbutton",                    
                                   OBJ_BUTTON,    
                                   0,                            
                                   0,                            
                                   0                             
          );
          
          ObjectSet("onbutton",OBJPROP_COLOR,clrBlack);    
          ObjectSet("onbutton",OBJPROP_BACK,false);           
          ObjectSet("onbutton",OBJPROP_SELECTABLE,false);    
          ObjectSet("onbutton",OBJPROP_SELECTED,false);      
          ObjectSet("onbutton",OBJPROP_HIDDEN,true);         
          ObjectSet("onbutton",OBJPROP_ZORDER,0);            
            
          ObjectSetString(chart_id,"onbutton",OBJPROP_TEXT,"RSI on");           
          ObjectSetString(chart_id,"onbutton",OBJPROP_FONT,"UD デジタル 教科書体 N-R");          
      
          ObjectSet("onbutton",OBJPROP_FONTSIZE,9);                  
          ObjectSet("onbutton",OBJPROP_CORNER,1);                       
          ObjectSet("onbutton",OBJPROP_XDISTANCE,140);                
          ObjectSet("onbutton",OBJPROP_YDISTANCE,45);                 
          ObjectSet("onbutton",OBJPROP_XSIZE, 130);                    
          ObjectSet("onbutton",OBJPROP_YSIZE,25);                     
          ObjectSet("onbutton",OBJPROP_BGCOLOR,clrLime);             
          ObjectSet("onbutton",OBJPROP_BORDER_COLOR,Black);       
          ObjectSet("onbutton",OBJPROP_STATE,false);                  
          
          
          
          
          
          ObjectCreate(chart_id,               
                                   "onbutton1",                    
                                   OBJ_BUTTON,    
                                   0,                            
                                   0,                            
                                   0                             
          );
          
          ObjectSet("onbutton1",OBJPROP_COLOR,clrBlack);    
          ObjectSet("onbutton1",OBJPROP_BACK,false);            
          ObjectSet("onbutton1",OBJPROP_SELECTABLE,false);     
          ObjectSet("onbutton1",OBJPROP_SELECTED,false);      
          ObjectSet("onbutton1",OBJPROP_HIDDEN,true);         
          ObjectSet("onbutton1",OBJPROP_ZORDER,0);            
            
          ObjectSetString(chart_id,"onbutton1",OBJPROP_TEXT,"ストキャスon");            
          ObjectSetString(chart_id,"onbutton1",OBJPROP_FONT,"UD デジタル 教科書体 N-R");          
      
          ObjectSet("onbutton1",OBJPROP_FONTSIZE,9);                  
          ObjectSet("onbutton1",OBJPROP_CORNER,1);
          ObjectSet("onbutton1",OBJPROP_XDISTANCE,140);                
          ObjectSet("onbutton1",OBJPROP_YDISTANCE,80);                 
          ObjectSet("onbutton1",OBJPROP_XSIZE, 130);                   
          ObjectSet("onbutton1",OBJPROP_YSIZE,25);                     
          ObjectSet("onbutton1",OBJPROP_BGCOLOR,clrLime);              
          ObjectSet("onbutton1",OBJPROP_BORDER_COLOR,Black);       
          ObjectSet("onbutton1",OBJPROP_STATE,false);                  

   
   
   EventSetMillisecondTimer(500);
    
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
int labelhigh2 = 15;//通貨名ラベル高さ
int labelsize2 = 15;//通貨名ラベル大きさ
extern double pips = 0.3;//サイン表示位置調整
color labelcolor2 = Yellow;//通貨名ラベルカラー
int labelpos = 1;//勝率ラベル位置
int labelhigh = 30;//勝率ラベル高さ
int labelsize = 10;//勝率ラベル大きさ
color labelcolor = Yellow;//勝率ラベルカラー
extern int hantei = 1;//判定本数
extern int stopcnt = 0;//停止ロウソク足本数


extern int    RSIPeriod     =3 ; //RSI期間
extern int rup = 80;//上ライン
extern int rdn = 20;//下ライン

extern int    K     = 7;
extern int    D     = 1;
extern int    S     = 1;
extern int stoue = 80;//上ライン
extern int stosita = 20;//下ライン


int point1,point2 =0;
int NowBars, NowBars2, NowBars3, RealBars,a, b, c, d, e, f,t, Timeframe = 0;
int minute, minute2, mminute, m2minute = 0;
int dnminute, dnminute2, dnmminute, dnm2minute = 0;
bool flag1, flag2, upentryflag, dnentryflag, martinflag, martinflag2, dnmartinflag, dnmartinflag2 = false;
double martin1price, martin2price, dnmartin1price, dnmartin2price,boup,bodn,now;
double eprice, eprice2, upwincnt, uplosecnt, dnwincnt, dnlosecnt, uptotalcnt, dntotalcnt, uppercent, dnpercent, totalpercent, totalwin, totallose;
bool Certification,counted = false;

int limit = 0;
bool areat = true;
bool rsisign = true;
bool stosign = true;
double rsi,rsi1,sto,sto1;
int ba,ba1;
int upcnt, dncnt, Hantei = 0;
int p,q= 0;
int ST, ET;

 void OnChartEvent(const int chart_id, const long& lparam,const double& dparam,const string& sparam)
{


    if(chart_id == CHARTEVENT_OBJECT_CLICK){ 
    
    if(sparam == "onbutton"){
               ba++;
               if(ba == 1){

               areat = true; //クリックカウントが１の時  
               rsisign = false;         
               ObjectSet("onbutton",OBJPROP_BGCOLOR,clrYellow); //
               ObjectSetString(0,"onbutton",OBJPROP_TEXT,"RSI OFF");     	               	  
                    }                         
               
               
               if(ba == 2){
                   
                   areat = true ;  //クリックカウントが２の時
                   rsisign = true;         
                   ObjectSet("onbutton",OBJPROP_BGCOLOR,clrLime); //ボタンの色を元に戻す。 
                   ObjectSetString(0,"onbutton",OBJPROP_TEXT,"RSI ON");         
                   ba = 0; //クリックカウントを０に戻します。
                      
                              	  
                    }                              
               } 

    
    if(sparam == "onbutton1"){
               ba1++;
               if(ba1 == 1){
               
               areat = true; //クリックカウントが１の時
               stosign = false;            
               ObjectSet("onbutton1",OBJPROP_BGCOLOR,clrYellow); //
               ObjectSetString(0,"onbutton1",OBJPROP_TEXT,"ストキャス OFF");     	               	  
                    }                         
               
               
               if(ba1 == 2){
               
               areat = true ;  //クリックカウントが２の時
               stosign = true;
               ObjectSet("onbutton1",OBJPROP_BGCOLOR,clrLime); //ボタンの色を元に戻す。 
               ObjectSetString(0,"onbutton1",OBJPROP_TEXT,"ストキャス ON");         
               ba1 = 0; //クリックカウントを０に戻します。
                      
                              	  
                    }                              
                                                    
           }
           }
           }



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
  
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+


void OnTimer()
{ 
//---
   
    if(ChartPeriod(0) == 1){Timeframe = 2;}
    if(ChartPeriod(0) == 5){Timeframe = 4;}
    if(ChartPeriod(0) == 15){Timeframe = 6;}
    if(ChartPeriod(0) == 30){Timeframe = 8;}
    if(ChartPeriod(0) == 60){Timeframe = 10;}
    if(ChartPeriod(0) == 240){Timeframe = 15;}
    if(ChartPeriod(0) == 1440){Timeframe = 20;}
    
   
   
   limit = Bars - IndicatorCounted()-1;
   
if(areat==true){
      
      
      
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
      
      ArrayInitialize(Buffer_0,EMPTY_VALUE);
      ArrayInitialize(Buffer_1,EMPTY_VALUE);
      ArrayInitialize(Buffer_2,EMPTY_VALUE);
      ArrayInitialize(Buffer_3,EMPTY_VALUE);
      
if(ChartPeriod(0) == 1){
    if(limitdate == oned){
       limit = MathMin(Bars-1,1440);//1440
    }
    if(limitdate == week){
       limit = MathMin(Bars-1,7200);//7200
    }
    if(limitdate == month){
       limit = MathMin(Bars-1,31600);//31600
    }
    if(limitdate == maxbar){
       limit = MathMin(Bars-1, Maxbars);//31600
    }
}
if(ChartPeriod(0) == 5){
    if(limitdate == week){
       limit = MathMin(Bars-1,1440);//7200
    }
    
    if(limitdate == oned){
       limit = MathMin(Bars-1,288);//18800
    }
   
    if(limitdate == month){
       limit = MathMin(Bars-1,6320);//31600
    }
    if(limitdate == maxbar){
       limit = MathMin(Bars-1, Maxbars);
    }
    
    areat=false;
    
}



}

for(int i = limit; i >= 0; i--){  
      
       
       rsi=iRSI(NULL,0,RSIPeriod,0,i);
       rsi1=iRSI(NULL,0,RSIPeriod,0,i+1);
       
       sto = iStochastic(NULL,0,K,D,S,0,0,0,i);
       sto1 = iStochastic(NULL,0,K,D,S,0,0,0,i+1);
       now = iClose(NULL,0,i); 
       //now1 = iClose(NULL,0,i+1);
      
      /* 
       if(i == 0){ //リアルタイムでサインを出したり消したりしたい場合はこちらも使う。if文の中は下の出の記述と同じでOK  

          Buffer_0[i] = EMPTY_VALUE;
          Buffer_1[i] = EMPTY_VALUE;
                                          
          
          if(dncnt == 0){
             if()
               
             {
                 Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                 if(RealBars < Bars){
                     Alert(Symbol()+" M"+Period()+" High Sign");
                     RealBars = Bars;
                     SendMail("High Sign", "High Sign");
                 }
             }
          }
          
          if(upcnt == 0){
              if()
              
               {
                 Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                 if(RealBars < Bars){
                     Alert(Symbol()+" M"+Period()+" Low Sign");
                     RealBars = Bars;
                     SendMail("Low Sign", "Low Sign");    
                 }
             } 
          }                    
       }*/
       
       
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
             if(( rsisign==true && rsi1>=rdn && rsi<=rdn ) || ( stosign==true && sto1>=stosita && sto<=stosita )){
             Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                 upentryflag = true;
                 eprice = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" High Sign");}
                 upcnt = 1;
                 if(p <= 1){p++;}
             }
          }
          
          if(dncnt == 0){
             if((rsisign==true && rsi1<=rup && rsi>=rup )|| ( stosign==true && sto1<=stoue && sto>=stoue )){
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
                    
            /* ObjectCreate("counttotal1",OBJ_LABEL,0,0,0);
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
             ObjectSet("counttotal3",OBJPROP_YDISTANCE,labelhigh+50);    */                    
                   
                   
             uptotalcnt = upwincnt + uplosecnt;      
             dntotalcnt = dnwincnt + dnlosecnt;      
             totalwin = upwincnt+dnwincnt;
             totallose = uplosecnt+dnlosecnt;
                          
             if(upwincnt > 0){uppercent = MathRound((upwincnt / uptotalcnt)*100);} else uppercent = 0;
             if(dnwincnt > 0){dnpercent = MathRound((dnwincnt / dntotalcnt)*100);} else dnpercent = 0;
             if(totalwin > 0){totalpercent = MathRound((totalwin / (totalwin+totallose))*100);} else totalpercent = 0;
             
             /*ObjectSetText("counttotal",Symbol(), labelsize2, "MS ゴシック",labelcolor2);
             ObjectSetText("counttotal1", "UP: 勝"+upwincnt+" 負"+uplosecnt+" 勝率"+uppercent+"%", labelsize, "MS ゴシック",labelcolor);       
             ObjectSetText("counttotal2", "DN: 勝"+dnwincnt+" 負"+dnlosecnt+" 勝率"+dnpercent+"%", labelsize, "MS ゴシック",labelcolor); */    
             ObjectSetText("counttotal", "勝率: 勝"+totalwin+" 負"+totallose+" 勝率"+totalpercent+"%", labelsize2, "MS ゴシック",labelcolor);    
                    
      }//NowBars
      
   }//timeout



   
//--- return value of prev_calculated for next call
   //return(rates_total);
 }
 
 
//+------------------------------------------------------------------+
 int deinit(){
	
   for(int i = ObjectsTotal()-1; 0 <= i; i--) {
	   string ObjName=ObjectName(i);
	   if(StringFind(ObjName, "counttotal") >= 0)
   	      ObjectDelete(ObjName); 
   	      	
   	if(StringFind(ObjName, "onbutton") >= 0)
   	      ObjectDelete(ObjName);                     	  
   }


  Comment("");
  EventKillTimer();	
  
   return(0);
}// end of deinit()




long          UserID1           =0;
long          UserID2           =0;
long          UserID3           =0;
long          UserID4           =0;
long          UserID5           =0;
long          UserID6           =0;
long          UserID7           =0;
long          UserID8           =0;
long          UserID9           =0;
long          UserID10          =0;
long          UserID11           =0;
long          UserID12           =0;
long          UserID13           =0;
long          UserID14           =0;
long          UserID15           =0;
long          UserID16           =0;
long          UserID17           =0;   //   様
long          UserID18           =0;    //   様
long          UserID19           =0;   //  様
long          UserID20           =0;   //    様
long          UserID21           =0;   //  様
long          UserID22           =0;   //  様
long          UserID23           =0;   //  様
long          UserID24           =0;    //  様
long          UserID25           =0;   //  様
long          UserID26           =0;   //   様
long          UserID27           =0;  //  様
long          UserID28           =0;    //  様
long          UserID29           =0;   //  様
long          UserID30           =0;   //   様
long          UserID31           =0;   //  様
long          UserID32           =0;   //   様
long          UserID33           =0;   //  様
long          UserID34           =0;   //  様
long          UserID35           =0;   //  様
long          UserID36           =0;   //  様
long          UserID37           =0;   //  様
long          UserID38           =0;   //  様
long          UserID39           =0;   //  様
long          UserID40           =0;   //  様
long          UserID41           =0;   // 様
long          UserID42           =0;   // 様
long          UserID43           =0;   // 様
long          UserID44           =0;   // 様
long          UserID45           =0;   // 様
long          UserID46           =0;   // 様
long          UserID47           =0;   // 様
long          UserID48           =0;   // 様
long          UserID49           =0;   // 様


long          UserID           =0;  //あなたのMT4番号  


bool UseSystem(long userid){
   
   if((userid == UserID 
      || userid == UserID1 
      || userid == UserID2 
      || userid == UserID3
      || userid == UserID4
      || userid == UserID5
      || userid == UserID6 
      || userid == UserID7
      || userid == UserID8
      || userid == UserID9
      || userid == UserID10
      || userid == UserID11 
      || userid == UserID12 
      || userid == UserID13
      || userid == UserID14
      || userid == UserID15
      || userid == UserID16 
      || userid == UserID17
      || userid == UserID18
      || userid == UserID19
      || userid == UserID20
      || userid == UserID21 
      || userid == UserID22 
      || userid == UserID23
      || userid == UserID24
      || userid == UserID25
      || userid == UserID26 
      || userid == UserID27
      || userid == UserID28
      || userid == UserID29
      || userid == UserID30
      || userid == UserID31 
      || userid == UserID32
      || userid == UserID33
      || userid == UserID34
      || userid == UserID35 
      || userid == UserID36
      || userid == UserID37
      || userid == UserID38
      || userid == UserID39
      || userid == UserID40
      || userid == UserID41
      || userid == UserID42
      || userid == UserID43
      || userid == UserID44
      || userid == UserID45
      || userid == UserID46
      || userid == UserID47
      || userid == UserID48
      || userid == UserID49
      )
     //&& userid == AccountNumber()
     ){
      Comment("");
      return true;
   }

   return false;
}