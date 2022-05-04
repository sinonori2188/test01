//+------------------------------------------------------------------+
//|                                                             .mq4 |
//|                                             Copyright 2020, ands |
//|                                                                  |
//+------------------------------------------------------------------+


#property copyright "ands"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2

#property indicator_width1 3
#property indicator_color1 Red
#property indicator_width2 3
#property indicator_color2 Blue

double Buffer_0[]; //上向きサインバッファー用の配列
double Buffer_1[]; //上向きサインバッファー用の配列

int OnInit()
  {
   IndicatorBuffers(2);
   SetIndexBuffer(0,Buffer_0);//Buffer_0を0番目のバッファーに指定（上向きサイン）
   SetIndexStyle(0,DRAW_ARROW); 
   SetIndexArrow(0,241);
     
   SetIndexBuffer(1,Buffer_1); //Buffer_1を1番目のバッファーに指定（下向きサイン）
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,242);
   
   return(INIT_SUCCEEDED);
  }

enum limitdate1{
                    oned,//１日
                    week,//１週間
                    month//１ヶ月
                    };

extern limitdate1 limitdate = oned;//サイン表示期間
extern string Note2 = "";//ボリバン設定----------------
extern int mainbope = 20;//ボリンジャーバンド期間
extern double sigma = 2.0;//条件シグマ

int NowBars, RealBars,a, b, c, d, e, f, Timeframe = 0;
double boup, bodn, boup1, bodn1, boliup, bolidown, boup2, bodn2;
int hantei, Hantei, p, q = 0;
bool UPflag,DNflag;

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

//-------時間足によってサインの表示距離を調整--------- 
   
    if(ChartPeriod(0) == 1){Timeframe = 2;}
    if(ChartPeriod(0) == 5){Timeframe = 4;}
    if(ChartPeriod(0) == 15){Timeframe = 6;}
    if(ChartPeriod(0) == 30){Timeframe = 8;}
    if(ChartPeriod(0) == 60){Timeframe = 10;}
    if(ChartPeriod(0) == 240){Timeframe = 15;}
    if(ChartPeriod(0) == 1440){Timeframe = 20;}
    
int limit = Bars - IndicatorCounted()-1;

//-------検知本数調整（最新足から何本検知させるか）--------- 
if(ChartPeriod(0) == 1){
    if(limitdate == oned){
       limit = MathMin(limit,1440);//1日で1分足の本数は1440本
    }
    if(limitdate == week){
       limit = MathMin(limit,7200);//1週間で1分足の本数は約7200本
    }
    if(limitdate == month){
       limit = MathMin(limit,31600);//1か月で1分足の本数は約31600本
    }
}
if(ChartPeriod(0) == 5){
    if(limitdate == oned){
       limit = MathMin(limit,288);//1日で5分足の本数は288本
    }
    if(limitdate == week){
       limit = MathMin(limit,1440);//1週間で5分足の本数は1440本
    }
    if(limitdate == month){
       limit = MathMin(limit,6320);//1か月で5分足の本数は6320本
    }
}

for(int i = limit; i >= 0; i--){  

       boup = iBands(NULL,0,mainbope,sigma,0,0,1,i);//ボリンジャーバン後の上バンドの値を保存
       bodn = iBands(NULL,0,mainbope,sigma,0,0,2,i);//ボリンジャーバン後の下バンドの値を保存      
    
       if(i == 0){  //最新足の時にしか通らない処理
       

          Buffer_0[i] = EMPTY_VALUE;//毎ティックサインを消す処理を行っている。これにより下の条件文を通らなかった時にはサインが出なくなるため、最新足でサインが出たり消えたりする状態にできる。
          Buffer_1[i] = EMPTY_VALUE;


             if(iClose(NULL,0,i) <= bodn){
                 Buffer_0[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                 if(i==0 && RealBars < Bars){Alert(Symbol()+" M"+Period()+" High Sign"); RealBars = Bars;}//何度も連続でアラートがならないようにRealBarsという変数に現在のBars（チャート上の全ローソク足本数）を入れて「RealBars < Bars」の条件を次の足まで通らないようにする
             }
                  
             if(iClose(NULL,0,i) >= boup){
                 Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*10*Point;
                 if(i==0 && RealBars < Bars){Alert(Symbol()+" M"+Period()+" Low Sign"); RealBars = Bars;}
             }                                        
       }


      if(i > 1 || (i == 1 && NowBars < Bars)){ //確定足条件
          NowBars = Bars;
                       
//-------確定足サイン---------                               

                if(iClose(NULL,0,i) <= bodn && UPflag == false){//サイン表示が連続で行われないようにUPflagで制御
                    Buffer_0[i] = iLow(NULL,0,i)-Timeframe*5*Point;
                    UPflag = true;
                }
                if(iClose(NULL,0,i) > bodn && UPflag == true){UPflag = false;}//下バンドよりも価格が上に戻ったらUPflagを戻しサイン表示を行えるように戻す



                if(iClose(NULL,0,i) >= boup && DNflag == false){//サイン表示が連続で行われないようにDNflagで制御
                    Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*10*Point;
                    DNflag = true;
                }  
                if(iClose(NULL,0,i) < boup && DNflag == true){DNflag = false;}//上バンドよりも価格が下に戻ったらDNflagを戻しサイン表示を行えるように戻す               
                                             
      }
}
   
   return(rates_total);
  }
//+------------------------------------------------------------------+
 int deinit(){              	  
   
   return(0);
}// end of deinit()
