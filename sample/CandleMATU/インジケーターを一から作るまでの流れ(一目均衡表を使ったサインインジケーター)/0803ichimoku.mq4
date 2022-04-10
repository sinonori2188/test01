//+------------------------------------------------------------------+
//|                                                         0803.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+


#property copyright "Copyright 2020, ands"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4

#property indicator_width1 3
#property indicator_color1 Orange
#property indicator_width2 3
#property indicator_color2 Magenta
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
   
   
   return(INIT_SUCCEEDED);
  }

extern int labelsize = 10;//勝率ラベル大きさ
extern int hantei = 1;//判定本数
extern int kankaku = 5;//間隔本数
extern double pips = 2;//サイン表示位置調整

extern string Note1 = "";//インジケーター設定---------------------
extern int MAPeriod = 50;//MA期間
extern int BBPeriod = 21;//ボリンジャーバンド期間
extern double hensa = 2.0;//偏差
extern int  tenkansen = 9;     // 転換線期間
extern int  kijunsen = 26;     // 基準線期間
extern int  senkousupan = 52;     // 先行スパン期間




int NowBars, RealBars,a, b, c, e, f, p, q, minute, minute2, Timeframe,HANTEI = 0;
bool flag1, flag2, upentryflag, dnentryflag = false;
double eprice,eprice1, wincnt, losecnt, totalcnt, percent;
bool Certification = false;

double RSI1, RSI2, Sto1, Sto2, CCI1;
double boup1, boup2, boup3, bodn1, bodn2, bodn3, boup11, bodn11;
bool boupflag, bodnflag, boupflag2, bodnflag2 = false;

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
 totalcnt = 0;
 wincnt = 0; 
 losecnt = 0;
 totalcnt = 0;
}

for(int i = limit; i >= 0; i--){  

     double ma = iMA(NULL,0,MAPeriod,0,0,0,i);
     
     double boup = iBands(NULL,0,BBPeriod,hensa,0,0,1,i+kijunsen);
     double boup1 = iBands(NULL,0,BBPeriod,hensa,0,0,1,i+kijunsen+1);
     double bodn = iBands(NULL,0,BBPeriod,hensa,0,0,2,i+kijunsen);
     double bodn1 = iBands(NULL,0,BBPeriod,hensa,0,0,2,i+kijunsen+1);                
     
     double tikou = iIchimoku(NULL,0,tenkansen,kijunsen,senkousupan,5,i+kijunsen);
     double tikou1 = iIchimoku(NULL,0,tenkansen,kijunsen,senkousupan,5,i+kijunsen+1);
     
     double now = iClose(NULL,0,i);
     
      if(i == 0){
          Buffer_0[i] = EMPTY_VALUE;        
          Buffer_1[i] = EMPTY_VALUE;                                       
      }

                
      if(i == 0){ 
          if(ma<=now && boup1>tikou1 && boup<=tikou && a >= kankaku){//リアルタイムでのサイン表示条件           
                          Buffer_0[i] = iLow(NULL,0,i)-5*pips*Point;
                          if(i==0 && RealBars < Bars){Alert(Symbol()+" M"+Period()+"High Sign"); RealBars = Bars;}                
          }
          
          if(ma>=now && bodn1<tikou1 && bodn>=tikou && b >= kankaku){//リアルタイムでのサイン表示条件               
                          Buffer_1[i] = iHigh(NULL,0,i)+10*pips*Point;
                          if(i==0 && RealBars < Bars){Alert(Symbol()+" M"+Period()+"Low Sign"); RealBars = Bars;}                     
              }
                
      }
          
      if(i > 1 || (i == 1 && NowBars < Bars)){ 
          NowBars = Bars;      
          a++; b++; //aとbのそれぞれを足確定ごとに+1していき、エントリーから次のエントリーまでの間隔を調整
                   
          if(ma<=now && boup1>tikou1 && boup<=tikou && a >= kankaku){ //確定足でのサイン表示条件（上向きサイン）          
                            Buffer_0[i] = iLow(NULL,0,i)-5*pips*Point;
                            if(i==1)Alert(Symbol()+" M"+Period()+" High Sigh");
                            upentryflag = true; //エントリー時にflagをtrueにし、判定コードを通るようにする
                            eprice = iClose(NULL,0,i);  //エントリー時の価格を判定用に保存
                            a = 0;           
                            p++;                         
          }
          
          if(ma>=now && bodn1<tikou1 && bodn>=tikou && b >= kankaku){ //確定足でのサイン表示条件(下向きサイン)          
                            Buffer_1[i] = iHigh(NULL,0,i)+10*pips*Point;
                            if(i==1)Alert(Symbol()+" M"+Period()+" Low Sigh");
                            dnentryflag = true;//エントリー時にflagをtrueにし、判定コードを通るようにする
                            eprice1 = iClose(NULL,0,i); //エントリー時の価格を判定用に保存
                            b = 0;         
                            q++;                            
          }          
                                 
          //勝敗判定-----------------------------------------------------------------------------------------------------------------
              if(upentryflag == true){
                  if(p <= 1){HANTEI = hantei;}//最初の一回目の判定だけバグ調整でここを通るようにする
                  else{HANTEI = hantei+1;}                      
                  if(minute == HANTEI){        
                      if(eprice < iClose(NULL,0,i)){            
                          Buffer_2[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                          upentryflag = false;
                          wincnt++;                                 
                      }
                      
                      else{
                               Buffer_3[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                               upentryflag = false;       
                               losecnt++;                                    
                       }
                  minute = 0;
                  } 
              minute++;   
              }
                           
              if(dnentryflag == true){ 
                  if(q <= 1){HANTEI = hantei;}//最初の一回目の判定だけバグ調整でここを通るようにする
                  else{HANTEI = hantei+1;}                      
                  if(minute2 == HANTEI){        
                      if(eprice1 > iClose(NULL,0,i)){           
                         Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*10*Point;
                         dnentryflag = false;         
                         wincnt++;            
                      }
                      
                      else{
                                Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*10*Point;
                               dnentryflag = false;       
                               losecnt++;           
                       }
                  minute2 = 0;
                  } 
              minute2++;   
              }        
                                                        
               ObjectCreate("counttotal",OBJ_LABEL,0,0,0);
               ObjectSet("counttotal",OBJPROP_CORNER,1);
               ObjectSet("counttotal",OBJPROP_XDISTANCE,5);
               ObjectSet("counttotal",OBJPROP_YDISTANCE,15);
                     
               totalcnt = wincnt + losecnt;      
               if(wincnt > 0){percent = MathRound((wincnt / totalcnt)*100);} else percent = 0;
               
               ObjectSetText("counttotal", "Win"+wincnt+"回"+" Lose: "+losecnt+"回"+" 勝率: "+percent+"%", labelsize, "MS ゴシック",White);  
               
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
   }


  Comment("");
		
   return(0);
}// end of deinit()

