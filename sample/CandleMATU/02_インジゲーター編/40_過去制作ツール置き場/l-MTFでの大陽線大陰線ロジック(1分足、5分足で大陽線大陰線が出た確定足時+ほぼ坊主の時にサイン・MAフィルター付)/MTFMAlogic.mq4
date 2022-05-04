//+------------------------------------------------------------------+
//|                                                   MTFMAlogic.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, "
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 6

#property indicator_width1 3
#property indicator_color1 Red
#property indicator_width2 3
#property indicator_color2 Aqua
#property indicator_width3 3
#property indicator_color3 White
#property indicator_width4 3
#property indicator_color4 White
#property indicator_width5 3
#property indicator_color5 Yellow
#property indicator_width6 3
#property indicator_color6 Aqua

double Buffer_0[];
double Buffer_1[];
double Buffer_2[];
double Buffer_3[];
double Buffer_4[];
double Buffer_5[];

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
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,2);
   
   SetIndexBuffer(5,Buffer_5);
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,2);

   
   return(INIT_SUCCEEDED);
  }



enum limitdate1{
                    oned,//１日
                    week,//１週間
                    month,//１ヶ月
                    maxbar
                    };




extern limitdate1 limitdate = maxbar;//勝率表示期間

extern int Maxbars = 20000;//対象本数範囲
extern int hantei = 1;//判定本数

extern int labelpos2 = 1;//通貨名ラベル位置
extern int labelhigh2 = 15;//通貨名ラベル高さ
extern int labelsize2 = 10;//通貨名ラベル大きさ
extern double pips = 0.3;//サイン表示位置調整
extern color labelcolor2 = Yellow;//通貨名ラベルカラー
extern int labelpos = 1;//勝率ラベル位置
extern int labelhigh = 30;//勝率ラベル高さ
extern int labelsize = 10;//勝率ラベル大きさ
extern color labelcolor = Yellow;//勝率ラベルカラー
//extern int stopcnt = 0;//停止ロウソク足本数

extern string Note1="";//設定
extern int o = 10;//何本分のローソク足の平均を出すか
extern double bb = 2.0;//過去足の平均の何倍以上の時サイン
extern int hiritu = 90;//坊主率(100が坊主)
extern int period = 8;//ma期間



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

double all,all5,all0,all50,w,w5;
double yuhige,ishige;

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
    
         int j = iBarShift(NULL,PERIOD_M5,iTime(NULL,PERIOD_M1,i));
         
         double now1 = iClose(NULL,PERIOD_M1,i);
         double op1 = iOpen(NULL,PERIOD_M1,i);
         
         double now5 = iClose(NULL,PERIOD_M5,j) ;
         double op5 = iOpen(NULL,PERIOD_M5,j);
         
         double ma1 = iMA(NULL,PERIOD_M1,period,0,MODE_SMA,PRICE_CLOSE,i);
         double ma5 = iMA(NULL,PERIOD_M5,period,0,MODE_SMA,PRICE_CLOSE,j);
         
         double rosoku = (iOpen(NULL,0,i)-iClose(NULL,0,i));
         
         double zittai = MathAbs(iOpen(NULL,PERIOD_M1,i)-iClose(NULL,PERIOD_M1,i));
         double ozittai = MathAbs(iOpen(NULL,PERIOD_M1,i+o)-iClose(NULL,PERIOD_M1,i+o));//後で引く用
         
         double zittai5 = MathAbs(iOpen(NULL,PERIOD_M5,j)-iClose(NULL,PERIOD_M5,j));//5分足実体
         double ozittai5 = MathAbs(iOpen(NULL,PERIOD_M1,j+o)-iClose(NULL,PERIOD_M1,j+o));//後で引く用
         
         yuhige = EMPTY_VALUE;
         ishige = EMPTY_VALUE;
         
         //陽線ヒゲ  
         if(rosoku < 0){
         yuhige=(iHigh(NULL,0,i)-iOpen(NULL,0,i));//陽線上ヒゲ込み実体
         }
    
         //陰線ヒゲ   
         if(rosoku > 0){
         ishige=(iOpen(NULL,0,i)-iLow(NULL,0,i));//陰線下ヒゲ込み実体
         }
         
         
         Buffer_4[i] = ma1;
         Buffer_5[i] = ma5;
         
         
      /* if(i == 0){
          
          Buffer_0[i] = EMPTY_VALUE;
          Buffer_0[i] = 0;
          Buffer_1[i] = EMPTY_VALUE;
          Buffer_1[i] = 0;                                 
          
          
          if(upcnt == 0){
              if()
                {
                 Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                 
                 if(RealBars < Bars ){
                     Alert(Symbol()+" M"+Period()+" High Sign");
                     RealBars = Bars;
                     SendMail("High Sign", "High Sign");
                 }
             }
          }
          
          if(dncnt == 0){
             if()
                {
                 Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                 
                 if(RealBars < Bars ){
                     Alert(Symbol()+" M"+Period()+" Low Sign");
                     RealBars = Bars;
                     SendMail("Low Sign", "Low Sign");    
                 }
             } 
          }                      
       }   */  
              
                
      if(i > 1 || (i == 1 && NowBars < Bars)){ 
          NowBars = Bars;
      
     
        
         
        
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
                     Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                     dnentryflag = false;         
                     dnwincnt++;            
                  }
                  
                  else{
                           Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*pips*15*Point;
                           dnentryflag = false;
                           dnlosecnt++; 
                                      
                   }
              minute2 = 0;
              } 
          minute2++;   
         }
 
       
         /* if(dncnt >= 1){dncnt++;}
          if(upcnt >= 1){upcnt++;}
          
          if(dncnt > stopcnt){dncnt = 0;}
          if(upcnt > stopcnt){upcnt = 0;} */
          
          
     
              
        //1分足の平均を出す------------------------------------------ 
        //double all = all+zittai;
        //w++;
        
        if( w>=o ){all = all-ozittai;
                   all0 = (all / o);
        }
        
        //Comment(all0);
                
        if(MathMod(TimeMinute(iTime(NULL,0,i)), 5) == 4){ //5分確定時のみ
        
        
        
       //5分足の平均を出す------------------------------------------  
         //double all5 = all5+zittai;
         //w5++;
        
        if( w5>=o ){all5 = all5-ozittai5;
                    all50 = (all5 / o);
        }
     
        
     
     //サイン条件-----------------------------------------
        if( i <= limit-(o*5) ){ 
       
        //if(upcnt == 0){  
              if( op1>now1 && op5>now5 && now1<=ma1 && now5<=ma5 && (all0*bb)<zittai && (all50*bb)<zittai5 && ((zittai/ishige)*100) >= hiritu)
                {
                 Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                 
                 upentryflag = true;
                 eprice = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" High Sign");}
                 //upcnt = 1;
                 if(p <= 1){p++;}
             }
          //}
          
          //if(dncnt == 0){
             if( op1<now1 && op5<now5 && now1>=ma1 && now5>=ma5 && (all0*bb)<zittai && (all50*bb)<zittai5 && ((zittai/yuhige)*100) >= hiritu )
                {
                 Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                 
                 dnentryflag = true;
                 eprice2 = iClose(NULL,0,i);
                 //if(i==1){Alert(Symbol()+" M"+Period()+" Low Sign");}
                 dncnt = 1;
                 if(q <= 1){q++;}
             } 
          //}
          
          
          
          }
          
          all5 = all5+zittai;
          w5++;
          
          }//mathmod                    
          
          all = all+zittai;
          w++;
                    
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
   }

 
		
   return(0);
}// end of deinit()