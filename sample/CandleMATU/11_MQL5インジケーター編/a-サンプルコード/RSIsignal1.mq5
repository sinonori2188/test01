//+------------------------------------------------------------------+ 
//|                                                                  | 
//|                                                                  | 
//|                                                        RSIsignal | 
//+------------------------------------------------------------------+ 

//---proparty関数はMQL4と基本的に同じです
//---


#property copyright ""
#property link ""
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 2 

//----チャートに描画するものをplotと表現します 
#property indicator_plots   2

//---- サインの色や名前の設定
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrDodgerBlue
#property indicator_label1  "Buy"
#property indicator_width1  3

#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_label2  "Sell"
#property indicator_width2  3

//
//変数

//---MQL5ではパラメーター設定したいものはinput~にします。extern~は使いません。

input int maxbar =2000;//判定期間
input int RSI_Period=9;                        // RSI期間
input ENUM_APPLIED_PRICE RSI_Price=PRICE_CLOSE; // RSI適応価格 
input int RSIue = 70;//RSI上ライン
input int RSIsita = 30;//RSI下ライン

input int K =5;//K
input int D =3;//D
input int S =3;//S
input int STOue = 80;//ストキャス上ライン
input int STOsita = 20;//ストキャス下ライン
//+-----------------------------------+


//---MQL5ではRSIなどのインジケーターを呼び出すときにハンドルというのを使います。
//詳しくは下で説明しますがRSI_Handleと変数の宣言をしておきます。
//ハンドルはint型です。
//バッファ―名も宣言しておきます。


int RSI_Handle;
int STO_Handle;
double BufBuy[];
double BufSell[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+


int OnInit()
  {

//---- MQL4ではiRSI(NULL,0,RSIPeriod,PRICE_CLOSE,i)と書けばRSIのバッファー値を呼び出すことができましたがMQL5では違います。
//iRSIではハンドルというのを返すため、ハンドルを手に入れてから後でCopyBufferという関数を使って呼び出します。

   RSI_Handle=iRSI(NULL,0,RSI_Period,RSI_Price);
   if(RSI_Handle==INVALID_HANDLE) Print(" Failed to get handle of the RSI indicator");//ハンドルが読み込めなかった場合エラーメッセージが出るようにしておきます

   STO_Handle=iStochastic(NULL,0,K,D,S,MODE_SMA,STO_LOWHIGH);
   if(STO_Handle==INVALID_HANDLE) Print(" Failed to get handle of the Stochastic indicator");
   
   
   Comment("");
   
   SetIndexBuffer(0,BufBuy);
   SetIndexBuffer(1,BufSell);
   
   
//SetIndexStyleはMQL5ではPlotIndexSetIntegerに変わりました。
//基本的に考え方は一緒ですが、描画させるものはPlot~となります。
   
   PlotIndexSetInteger(0,PLOT_ARROW,233);
   PlotIndexSetInteger(1,PLOT_ARROW,234);   
   
   
   return(INIT_SUCCEEDED);
  }
  
void OnDeinit(const int reason)
  {
	
  Comment("");
  
  }//deinit関数終了  
//+------------------------------------------------------------------+  
//| Custom indicator iteration function                              | 
//+------------------------------------------------------------------+  
int OnCalculate(const int rates_total,    // number of bars in history at the current tick
                const int prev_calculated,// number of bars calculated at previous call
                const datetime &Time[],
                const double &Open[],
                const double &High[],
                const double &Low[],
                const double &Close[],
                const long &Tick_Volume[],
                const long &Volume[],
                const int &Spread[])
  {

//MQL5ではBars→rates_total、 IndicatorCounted()→prev_calculatedとしてください
//---- BarsCalculatedはハンドルの計算された数です。もしハンドルの方が大きければreturn処理で終了とします（定型文として覚えておいてください。）

   if(BarsCalculated(RSI_Handle)<rates_total ||
      BarsCalculated(STO_Handle)<rates_total )
      return(0);


   int to_copy,limit,i;
   double RSI[],stomain[],stosignal[];



   
   limit=rates_total-prev_calculated; // starting index for calculation of new bar
   limit = MathMin(limit,rates_total-2);
   limit = MathMin(limit,maxbar);
   to_copy=limit+2;



//iRSIで読み込んだハンドルをCopyBufferという関数を使いRSI[]に入れていきます。
//CopyBuffer(取得したハンドル名,バッファー番号,取得開始位置,取得終了位置,配列変数)になります0以下ならreturn処理をするのも定型文みたいなので覚えておいてください。


   if(CopyBuffer(RSI_Handle,0,0,to_copy,RSI)<=0) return(0);
   if(CopyBuffer(STO_Handle,MAIN_LINE,0,to_copy,stomain)<=0) return(0);
   if(CopyBuffer(STO_Handle,SIGNAL_LINE,0,to_copy,stosignal)<=0) return(0);
   
   
//MQL5では配列の初期設定が逆ですMQL4では0が最新、Bars-1が一番過去の足でしたがMQL5では逆で0が一番過去の足、rates_totalが最新足です。
//ArraySetAsSeriesは配列の順番を逆にする関数なのでMQLに合わせるように配列をすべて反対にしていきます。  
   ArraySetAsSeries(RSI,true);
   ArraySetAsSeries(High,true);
   ArraySetAsSeries(Low,true);
   ArraySetAsSeries(BufBuy,true);
   ArraySetAsSeries(BufSell,true);
   ArraySetAsSeries(stomain,true);
   ArraySetAsSeries(stosignal,true);
   
   
//for文処理、基本的には一緒です。IsStoppedは強制シャットダウン機能が働いたとき!IsStopped()とすることでfalseの時（強制シャットダウンしないとき）としています。
   for(i=limit; i>=0 && !IsStopped(); i--)
     {
     
     BufBuy[i]=EMPTY_VALUE;
     BufSell[i]=EMPTY_VALUE;
     

      if(RSI[i+1]<RSIue && RSI[i]>=RSIue && stomain[i]>=STOue)
        {
         BufSell[i]=High[i]+5*_Point;//Point→_Pointに変わったため注意！
        }

      if(RSI[i+1]>RSIsita && RSI[i]<=RSIsita && stomain[i]<=STOsita)
        {
         BufBuy[i]=Low[i]-5*_Point;
        }
     }
//----    
   return(rates_total);
  }
//+------------------------------------------------------------------+
