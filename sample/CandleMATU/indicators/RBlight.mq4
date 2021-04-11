//+------------------------------------------------------------------+
//|                                                      RBlight.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
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
extern int Maxbars = 2000;//対象本数範囲
extern string Note1 = "";//インジケーター設定---------------------
extern int    RSIPeriod     = 14;//RSI期間
extern int    BandPeriod    = 20;//ボリバン期間
extern double BandDeviation = 2.0;//偏差



int NowBars, RealBars,a, b, c, e, f, p, q, minute, minute2 = 0;
bool flag1, flag2, upentryflag, dnentryflag = false;
double eprice, wincnt, losecnt, totalcnt, percent;



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
  
int limit = Bars - IndicatorCounted()-1;
limit = MathMin(limit, Maxbars);

if(limit == Bars-1){ //チャートを更新したときに勝率計算が2倍に増えるエラーを防ぐための処理
 totalcnt = 0;
 wincnt = 0; 
 losecnt = 0;
 totalcnt = 0;
}

for(int i = limit; i >= 0; i--){  
   

  
       double rsi = iCustom(NULL,0,"RSI-Bollinger",RSIPeriod,BandPeriod,BandDeviation,0,i);
       double rsiboliup = iCustom(NULL,0,"RSI-Bollinger",RSIPeriod,BandPeriod,BandDeviation,1,i);
       double rsibolidn = iCustom(NULL,0,"RSI-Bollinger",RSIPeriod,BandPeriod,BandDeviation,2,i);
      
       double rsi1 = iCustom(NULL,0,"RSI-Bollinger",RSIPeriod,BandPeriod,BandDeviation,0,i+1);
       double rsiboliup1 = iCustom(NULL,0,"RSI-Bollinger",RSIPeriod,BandPeriod,BandDeviation,1,i+1);
       double rsibolidn1 = iCustom(NULL,0,"RSI-Bollinger",RSIPeriod,BandPeriod,BandDeviation,2,i+1);
                      

      if(i == 0){
          Buffer_0[i] = EMPTY_VALUE;        
          Buffer_1[i] = EMPTY_VALUE;                                       
     
          if( rsi1>rsibolidn1 &&  rsi<=rsibolidn && a >= kankaku ){//リアルタイムでのサイン表示条件           
                          Buffer_0[i] = iLow(NULL,0,i)-5*pips*Point;
                          if(i==0 && RealBars < Bars){Alert(Symbol()+" M"+Period()+"High Sign"); RealBars = Bars;}                
          }
          
          if( rsi1<rsiboliup1 && rsi>=rsiboliup && b >= kankaku ){//リアルタイムでのサイン表示条件               
                          Buffer_1[i] = iHigh(NULL,0,i)+10*pips*Point;
                          if(i==0 && RealBars < Bars){Alert(Symbol()+" M"+Period()+"Low Sign"); RealBars = Bars;}                     
              }
                
      }
          
      if(i > 1 || (i == 1 && NowBars < Bars)){ 
      
          NowBars = Bars;      
          a++; b++; //aとbのそれぞれを足確定ごとに+1していき、エントリーから次のエントリーまでの間隔を調整
                   
          if( rsi1>rsibolidn1 &&  rsi<=rsibolidn && a >= kankaku ){ //確定足でのサイン表示条件（上向きサイン）          
                            Buffer_0[i] = iLow(NULL,0,i)-5*pips*Point;
                          
                            upentryflag = true; //エントリー時にflagをtrueにし、判定コードを通るようにする
                            eprice = iClose(NULL,0,i);  //エントリー時の価格を判定用に保存
                            a = 0;           
                            p++;                         
          }
          
          if( rsi1<rsiboliup1 && rsi>=rsiboliup && b >= kankaku){ //確定足でのサイン表示条件(下向きサイン)          
                            Buffer_1[i] = iHigh(NULL,0,i)+10*pips*Point;
                          
                            dnentryflag = true;//エントリー時にflagをtrueにし、判定コードを通るようにする
                            eprice = iClose(NULL,0,i); //エントリー時の価格を判定用に保存
                            b = 0;         
                            q++;                            
          }          
                                 
              //勝敗判定-----------------------------------------------------------------------------------------------------------------
              if(upentryflag == true){
                  if(p <= 1){hantei = 0;}//最初の一回目の判定だけバグ調整でここを通るようにする
                  else{hantei = 1;}                      
                  if(minute == hantei+1){        
                      if(eprice < iClose(NULL,0,i)){            
                          Buffer_2[i] = iLow(NULL,0,i)-5*Point;
                          upentryflag = false;
                          wincnt++;                                 
                      }
                      
                      else{
                               Buffer_3[i] = iLow(NULL,0,i)-5*Point;
                               upentryflag = false;       
                               losecnt++;                                    
                       }
                  minute = 0;
                  } 
              minute++;   
              }
                           
              if(dnentryflag == true){ 
                  if(q <= 1){hantei = 0;}//最初の一回目の判定だけバグ調整でここを通るようにする
                  else{hantei = 1;}                       
                  if(minute2 == hantei+1){        
                      if(eprice > iClose(NULL,0,i)){           
                         Buffer_2[i] = iHigh(NULL,0,i)+5*Point;
                         dnentryflag = false;         
                         wincnt++;            
                      }
                      
                      else{
                                Buffer_3[i] = iHigh(NULL,0,i)+5*Point;
                               dnentryflag = false;       
                               losecnt++;           
                       }
                  minute2 = 0;
                  } 
              minute2++;   
              }        
                                                        
               ObjectCreate("counttotal",OBJ_LABEL,0,0,0);
               ObjectSet("counttotal",OBJPROP_CORNER,0);
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

