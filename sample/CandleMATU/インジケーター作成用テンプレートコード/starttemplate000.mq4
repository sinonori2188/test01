//+------------------------------------------------------------------+
//|                                                .mq4 |
//|                                             Copyright 2018, ands |
//|                                                                  |
//+------------------------------------------------------------------+
string uselimitet = "2018.5.13 00:00";//使用期限設定
//※口座番号制限コードは一番下にあります。

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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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

   /*datetime nowtime;
   nowtime = StrToTime(uselimitet);
   if( iTime(NULL,0,1) > nowtime ){
      Alert("利用期限を過ぎました。");
      return(INIT_FAILED);
   }*/

  /* if(!Certification)
     {
      if(!UseSystem(AccountNumber()))
        {
         Certification = false;
         Comment("Invalid Account");
         return(INIT_FAILED);
        }
      else
        {
         Certification = true;
         Comment("Valid Account");
        }
     }*/

   return(INIT_SUCCEEDED);
  }


extern string Note = "";//勝率計算期間------------------
extern int year = 2022;//開始日時（年）
extern int month = 01;//開始日時（月）
extern int day = 01;//開始日時（日）
extern int hour = 00;//開始日時（時間）
extern int hun = 10;//開始日時（分）
extern bool maxbar = false;//任意本数指定
extern int Maxbars = 2000;//対象本数範囲
extern int labelsize = 10;//勝率ラベル大きさ
extern int labelpos = 1;//勝率ラベル表示位置(0~3)
extern double pips = 0.2;//サイン表示位置調整
extern int mchange = 0;//マーチン回数（0回/1回/2回）
extern int hantei = 1;//判定本数
extern int stopcnt = 5;//サインを停止させる本数
extern bool timeout = true;//指定時間除外適用
extern string Note0 = "";//MT4時間------------------
extern int startt = 21;//〇〇時~
extern int startm = 30;//〇〇分~
extern int endt = 22;//~〇〇時
extern int endm = 30;//~〇〇分

extern string Note1="";//サンプル：<ストキャス>（不要の場合は削除、もしくは別要素に変更）
extern int K = 5;//%K
extern int D = 3;//%D
extern int S = 3;//スローイング
extern int stoup = 80;//上レベル
extern int stodn = 20;//下レベル

int minute=1;
int minute2=1;
int NowBars, NowBars2, NowBars3, RealBars,a, b, c, d, e, f, Timeframe = 0;
int mminute, m2minute = 0;
int dnminute, dnminute2, dnmminute, dnm2minute = 0;
bool flag1, flag2, upentryflag, dnentryflag, martinflag, martinflag2, dnmartinflag, dnmartinflag2 = false;
double martin1price, martin2price, dnmartin1price, dnmartin2price;
double eprice, eprice2, upwincnt, uplosecnt, dnwincnt, dnlosecnt, uptotalcnt, dntotalcnt, uppercent, dnpercent, totalpercent, totalwin, totallose;
bool Certification = false;
//定番のRSI/ボリバン/ストキャスの変数はあらかじめ用意
double rsi, boup, bodn, rsi1, boup1, bodn1, boliup, bolidown, boup2, bodn2, stoa, stob;
int upcnt, dncnt, Hantei = 0;
int p,q= 0;
int ST, ET;
int pastbar, pastbar2;
datetime pasttime, pasttime2;


//+------------------------------------------------------------------+
//|                                                                  |
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

   if(ChartPeriod(0) == 1)
     {
      Timeframe = 2;
     }
   if(ChartPeriod(0) == 5)
     {
      Timeframe = 4;
     }
   if(ChartPeriod(0) == 15)
     {
      Timeframe = 6;
     }
   if(ChartPeriod(0) == 30)
     {
      Timeframe = 8;
     }
   if(ChartPeriod(0) == 60)
     {
      Timeframe = 10;
     }
   if(ChartPeriod(0) == 240)
     {
      Timeframe = 15;
     }
   if(ChartPeriod(0) == 1440)
     {
      Timeframe = 20;
     }

   int limit = Bars - IndicatorCounted()-1;
   if(maxbar == true)
     {
      limit = MathMin(limit, Maxbars);
     }
   for(int i = limit; i >= 0; i--)
     {

      if(TimeYear(iTime(NULL,0,i))==year &&
         TimeMonth(iTime(NULL,0,i))==month &&
         TimeDay(iTime(NULL,0,i))==day &&
         TimeHour(iTime(NULL,0,i))==hour &&
         TimeMinute(iTime(NULL,0,i))==hun)
        {

         pasttime = iTime(NULL,0,i);
         pastbar = iBarShift(NULL,0,pasttime);
         Print("OK1 "+pasttime);
        }
      //pastbar = limit;

      if(i <= pastbar)
        {

         if(timeout == true)
           {
            int hour2, hour3, hour4;
            hour2 = TimeHour(iTime(NULL,0,i)) + 0;
            if(24 <= hour2)
              {
               hour2 = hour2 - 24;
              }

            int ST = startt;
            int ET = endt;


            if(ST+1 == 24)
              {
               hour3 = 0;
              }
            else
              {
               hour3 = ST+1;
              }

            if(ET+1 == 24)
              {
               hour4 = 0;
              }
            else
              {
               hour4 = ET+1;
              }

            if(startt < endt)
              {
               if(flag1 == false && ((hour2 == ST && TimeMinute(iTime(NULL,0,i)) >= startm) || hour2 >= hour3))
                 {
                  flag1 = true;
                 }

               if(flag1 == true &&
                  ((hour2 == ET && TimeMinute(iTime(NULL,0,i)) >= endm) || (hour2 >= hour4)/* || sflag == true*/)
                 )
                 {
                  flag1 = false;
                 }
              }
            if(startt > endt)
              {
               if(flag1 == false && ((hour2 == ST && TimeMinute(iTime(NULL,0,i)) >= startm) || hour2 >= hour3))
                 {
                  flag1 = true;
                 }

               if(flag1 == true && hour2 < ST &&
                  ((hour2 == ET && TimeMinute(iTime(NULL,0,i)) >= endm) || (hour2 >= hour4)/* || sflag == true*/)
                 )
                 {
                  flag1 = false;
                 }
              }
           }
         else
           {
            flag1 = false;
           }

         if(flag1 == false)
           {
            //rsi = iRSI(NULL,0,14,0,i); //それぞれの関数を使用可能
            //boup = iBands(NULL,0,mainbope,sigma,0,0,1,i);
            //bodn = iBands(NULL,0,mainbope,sigma,0,0,2,i);
            //stoa = iStochastic(NULL,0,K,D,S,0,0,0,i);
            //stob = iStochastic(NULL,0,K,D,S,0,0,1,i);

            if(i == 0)  //リアルタイムでサインを出したり消したりしたい場合はこちらも使う。if文の中は下の出の記述と同じでOK
              {

               /*Buffer_0[i] = EMPTY_VALUE;
               Buffer_0[i] = 0;
               Buffer_1[i] = EMPTY_VALUE;
               Buffer_1[i] = 0;

               if(dncnt == 0){
                  if(){
                      Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                      if(RealBars < Bars){
                          Alert(Symbol()+" M"+Period()+" High Sign");
                          RealBars = Bars;
                          SendMail("High Sign", "High Sign");
                      }
                  }
               }

               if(upcnt == 0){
                  if(){
                      Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                      if(RealBars < Bars){
                          Alert(Symbol()+" M"+Period()+" Low Sign");
                          RealBars = Bars;
                          SendMail("Low Sign", "Low Sign");
                      }
                  }
               }*/
              }


            if(i > 1 || (i == 1 && NowBars < Bars))
              {
               NowBars = Bars;


               //勝敗判定-----------------------------------------------------------------------------------------------------------------
               //上矢印判定--------------------
               if(upentryflag == true)
                 {
                  if(minute == hantei)
                    {
                     if(eprice < iClose(NULL,0,i))
                       {
                        Buffer_2[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                        upentryflag = false;
                        upwincnt++;
                       }
                     else
                       {
                        Buffer_3[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                        upentryflag = false;
                        if(mchange == 1 || mchange == 2)
                          {
                           martinflag = true;
                           martin1price = iClose(NULL,0,i);
                           if(i == 1)
                             {
                              Alert(Symbol()," M"+Period(),"  FirstMartin HIGH  ");
                             }
                          }
                        if(mchange == 0)
                          {
                           uplosecnt++;
                          }
                       }
                     minute = 0;
                    }
                  minute++;
                  mminute = 0;
                  m2minute = 0;
                 }

               //マーチン1回目--------------------
               if(martinflag == true)
                 {
                  if(mminute == hantei)
                    {
                     if(martin1price < iClose(NULL,0,i))
                       {
                        Buffer_2[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                        upwincnt++;
                        martinflag = false;
                       }
                     else
                       {
                        Buffer_3[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                        martinflag = false;
                        if(mchange == 2)
                          {
                           martin2price = iClose(NULL,0,i);
                           martinflag2 = true;
                           if(i == 1)
                             {
                              Alert(Symbol()," M"+Period(),"  SecondMartin HIGH  ");
                             }
                          }
                        if(mchange == 1)
                          {
                           uplosecnt++;
                          }
                       }
                     mminute = 0;
                    }
                  mminute++;
                 }

               //マーチン2回目--------------------
               if(martinflag2 == true)
                 {
                  if(m2minute == hantei)
                    {
                     if(martin2price < iClose(NULL,0,i))
                       {
                        Buffer_2[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                        upwincnt++;
                        martinflag2 = false;
                       }
                     else
                       {
                        Buffer_3[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                        martinflag2 = false;
                        uplosecnt++;
                       }
                     m2minute = 0;
                    }
                  m2minute++;
                 }


               //下矢印判定--------------------
               if(dnentryflag == true)
                 {
                  if(minute2 == hantei)
                    {
                     if(eprice2 > iClose(NULL,0,i))
                       {
                        Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                        dnentryflag = false;
                        dnwincnt++;
                       }

                     else
                       {
                        Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*pips*15*Point;
                        dnentryflag = false;
                        if(mchange == 1 || mchange == 2)
                          {
                           dnmartinflag = true;
                           dnmartin1price = iClose(NULL,0,i);
                           if(i == 1)
                             {
                              Alert(Symbol()," M"+Period(),"  FirstMartin LOW  ");
                             }
                          }
                        if(mchange == 0)
                          {
                           dnlosecnt++;
                          }
                       }
                     minute2 = 0;
                    }
                  minute2++;
                  dnmminute = 0;
                  dnm2minute = 0;
                 }

               //マーチン1回目--------------------
               if(dnmartinflag == true)
                 {
                  if(dnmminute == hantei)
                    {
                     if(dnmartin1price > iClose(NULL,0,i))
                       {
                        Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*pips*15*Point;
                        dnwincnt++;
                        dnmartinflag = false;
                       }
                     else
                       {
                        Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*pips*15*Point;
                        dnmartinflag = false;
                        if(mchange == 2)
                          {
                           dnmartin2price = iClose(NULL,0,i);
                           dnmartinflag2 = true;
                           if(i == 1)
                             {
                              Alert(Symbol()," M"+Period(),"  SecondMartin LOW  ");
                             }
                          }
                        if(mchange == 1)
                          {
                           dnlosecnt++;
                          }
                       }
                     dnmminute = 0;
                    }
                  dnmminute++;
                 }

               //マーチン2回目--------------------
               if(dnmartinflag2 == true)
                 {
                  if(dnm2minute == hantei)
                    {
                     if(dnmartin2price > iClose(NULL,0,i))
                       {
                        Buffer_2[i] = iHigh(NULL,0,i)+Timeframe*pips*15*Point;
                        dnwincnt++;
                        dnmartinflag2 = false;
                       }
                     else
                       {
                        Buffer_3[i] = iHigh(NULL,0,i)+Timeframe*pips*15*Point;
                        dnmartinflag2 = false;
                        dnlosecnt++;
                       }
                     dnm2minute = 0;
                    }
                  dnm2minute++;
                 }


               if(dncnt >= 1)
                 {
                  dncnt++;
                 }
               if(upcnt >= 1)
                 {
                  upcnt++;
                 }

               if(dncnt > stopcnt)
                 {
                  dncnt = 0;
                 }
               if(upcnt > stopcnt)
                 {
                  upcnt = 0;
                 }
/*
               if(upcnt == 0){//プログラムの際はこちらのコメントアウトを解除してif文の中を書きましょう。
                  if(){
                      Buffer_0[i] = iLow(NULL,0,i)-Timeframe*pips*5*Point;
                      upentryflag = true;
                      eprice = iClose(NULL,0,i);
                      //if(i==1){Alert(Symbol()+" M"+Period()+" High Sign");}
                      upcnt = 1;
                  }
               }

               if(dncnt == 0){
                  if(){
                      Buffer_1[i] = iHigh(NULL,0,i)+Timeframe*pips*10*Point;
                      dnentryflag = true;
                      eprice2 = iClose(NULL,0,i);
                      //if(i==1){Alert(Symbol()+" M"+Period()+" Low Sign");}
                      dncnt = 1;
                  }
               }*/

               if(i==1)
                 {
                  ObjectCreate("counttotal1",OBJ_LABEL,0,0,0);
                  ObjectSet("counttotal1",OBJPROP_CORNER,labelpos);
                  ObjectSet("counttotal1",OBJPROP_XDISTANCE,5);
                  ObjectSet("counttotal1",OBJPROP_YDISTANCE,30);

                  ObjectCreate("counttotal2",OBJ_LABEL,0,0,0);
                  ObjectSet("counttotal2",OBJPROP_CORNER,labelpos);
                  ObjectSet("counttotal2",OBJPROP_XDISTANCE,5);
                  ObjectSet("counttotal2",OBJPROP_YDISTANCE,45);

                  ObjectCreate("counttotal3",OBJ_LABEL,0,0,0);
                  ObjectSet("counttotal3",OBJPROP_CORNER,labelpos);
                  ObjectSet("counttotal3",OBJPROP_XDISTANCE,5);
                  ObjectSet("counttotal3",OBJPROP_YDISTANCE,60);


                  uptotalcnt = upwincnt + uplosecnt;
                  dntotalcnt = dnwincnt + dnlosecnt;
                  totalwin = upwincnt+dnwincnt;
                  totallose = uplosecnt+dnlosecnt;

                  if(upwincnt > 0)
                    {
                     uppercent = MathRound((upwincnt / uptotalcnt)*100);
                    }
                  else
                     uppercent = 0;
                  if(dnwincnt > 0)
                    {
                     dnpercent = MathRound((dnwincnt / dntotalcnt)*100);
                    }
                  else
                     dnpercent = 0;
                  if(totalwin > 0)
                    {
                     totalpercent = MathRound((totalwin / (totalwin+totallose))*100);
                    }
                  else
                     totalpercent = 0;

                  ObjectSetText("counttotal1", "UP: 勝"+upwincnt+" 負"+uplosecnt+" 勝率"+uppercent+"%", labelsize, "MS ゴシック",Yellow);
                  ObjectSetText("counttotal2", "DN: 勝"+dnwincnt+" 負"+dnlosecnt+" 勝率"+dnpercent+"%", labelsize, "MS ゴシック",Yellow);
                  ObjectSetText("counttotal3", "TTL: 勝"+totalwin+" 負"+totallose+" 勝率"+totalpercent+"%", labelsize, "MS ゴシック",Yellow);
                 }

              }//NowBars

           }//timeout

        }//pastbar


     }//for

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
int deinit()
  {

   for(int i = ObjectsTotal()-1; 0 <= i; i--)
     {
      string ObjName=ObjectName(i);
      if(StringFind(ObjName, "counttotal") >= 0)
         ObjectDelete(ObjName);
     }


   Comment("");

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


long          UserID           =23057318;  //あなたのMT4番号


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool UseSystem(long userid)
  {

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
     )
     {
      Comment("");
      return true;
     }

   return false;
  }
//+------------------------------------------------------------------+
