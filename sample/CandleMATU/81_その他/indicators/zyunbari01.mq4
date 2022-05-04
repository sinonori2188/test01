//+------------------------------------------------------------------+
//|                                                   zyunbari01.mq4 |
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
   
   
   return(INIT_SUCCEEDED);
  }

extern int labelsize = 10;//勝率ラベル大きさ
extern int hantei = 1;//判定本数
extern double pips = 2;//サイン表示位置調整
extern int Maxbars = 500000;//対象本数範囲

extern string Note1="";//インジケーター設定
extern int mainbope = 20;//ボリバン期間
extern double sigma = 2.0;//σ
extern int ue = 60;//上ライン
extern int ue1 = 70;//ハイエントリー終了ライン
extern int sita = 40;//下ライン
extern int sita1 = 30;//ローエントリー終了ライン
extern int    RSIPeriod     = 9;//RSI期間


int NowBars, RealBars,a, b, c, e, f, p, q, minute, minute2,Hantei = 0;
bool hflag,hflag1, lflag,lflag1, upentryflag, dnentryflag = false;
double eprice,eprice1, wincnt, losecnt, totalcnt, percent;



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
 
}

for(int i = limit; i >= 0; i--){  
       
       
       
       double rsi=iRSI(NULL,0,RSIPeriod,0,i);
       double rsi1=iRSI(NULL,0,RSIPeriod,0,i+1);
      
       double now = iClose(NULL,0,i); 
       double now1 = iClose(NULL,0,i+1);
       double hi = iHigh(NULL,0,i);
       double lo = iLow(NULL,0,i);
       
       double boup = iBands(NULL,0,mainbope,sigma,0,0,1,i);
       double bodn = iBands(NULL,0,mainbope,sigma,0,0,2,i);
       
       
          
      if(i > 1 || (i == 1 && NowBars < Bars)){ 
      
          NowBars = Bars;      
          
          //勝敗判定-----------------------------------------------------------------------------------------------------------------
              if(upentryflag == true){
              if(p <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(minute == Hantei){       
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
              if(q <= 1){Hantei = hantei-1;}
              else{Hantei = hantei;}              
              if(minute2 == Hantei){        
                      if(eprice1 > iClose(NULL,0,i)){           
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
          
          
          if(rsi<ue)hflag=false;//RSI60以下の時falseに
          if(boup<=hi && rsi>=ue) hflag=true;//ボリバン上タッチRSI60以上でtrueに
          
          
          if(rsi1>ue1 && rsi<=ue1) hflag=false;//RSIが70以上から70以下になったらなったらfalseに
          
          
                
          if(rsi>sita)lflag=false;//RSI40以上の時falseに
          if(bodn>=lo && rsi<=sita) lflag=true;//ボリバン下タッチRSI40以下でtrueに
          
          if(rsi1<sita1 && rsi>=sita1) lflag=false;//RSIが30以下から30以上なったらfalseに
         
                   
          if(hflag==true )//ハイのflagがtrueの時
          {          
                            Buffer_0[i] = iLow(NULL,0,i)-5*pips*Point;//上矢印を安値の下に出す
                          
                            upentryflag = true; //エントリー時にflagをtrueにし、判定コードを通るようにする
                            eprice = iClose(NULL,0,i);  //エントリー時の価格を判定用に保存
                                   
                            p++;//サインが出た数をカウント                         
          }
          
          if(lflag==true )
          {          
                            Buffer_1[i] = iHigh(NULL,0,i)+10*pips*Point;//下矢印を高値の上に出す
                          
                            dnentryflag = true;//エントリー時にflagをtrueにし、判定コードを通るようにする
                            eprice1 = iClose(NULL,0,i); //エントリー時の価格を判定用に保存
                                     
                            q++;//サインが出た数をカウント                              
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

   
  
//+------------------------------------------------------------------+
