#property copyright "Ands"
#property strict
#property indicator_chart_window

input int max = 10;//検知日数
input int days =0;//何日前から(0の場合昨日から)
input color linecolor1 = clrWhite;  //当日ラインの色
input color linecolor2 = clrMagenta;  //1日前ラインの色
input color linecolor3 = clrGreen;  //2日前ラインの色
input color linecolor4 = clrYellow;  //3日前ラインの色
extern string space2 = "---";//---
extern bool ShowLines=true;//ライン全体表示ON/OFF
input bool line1 = false;  //当日ライン表示
input bool line2 = true;  //1日前ライン表示
input bool line3 = true;  //2日前ライン表示
input bool line4 = true;  //3日前ライン表示

int NowBars;
double yesterday_high, 
       yesterday_low,
       twodays_high,
       twodays_low,
       threedays_high,
       threedays_low,
       fourdays_high,
       fourdays_low,
       fivedays_high,
       fivedays_low,
       today_high,
       today_low;       

int start() {
  
int i;    
int limit = Bars - IndicatorCounted()-1;

limit = MathMin(limit,max);
for(i = limit; i > 0; i--){
  
   if(i > 1 || (i == 1 && NowBars <= Bars)){ 
       NowBars = Bars; 
       
       int DAYS = days-1;    
//today_high=iHigh(NULL, PERIOD_D1,i+DAYS);//当日最高値
//today_low=iLow(NULL, PERIOD_D1,i+DAYS);//当日最安値

yesterday_high=iHigh(NULL, PERIOD_D1,i+DAYS+1);//1日前最高値
yesterday_low=iLow(NULL, PERIOD_D1,i+DAYS+1);
twodays_high=iHigh(NULL, PERIOD_D1,i+DAYS+2);//2日前最高値
twodays_low=iLow(NULL, PERIOD_D1,i+DAYS+2);
threedays_high=iHigh(NULL, PERIOD_D1,i+DAYS+3);//3日前最高値
threedays_low=iLow(NULL, PERIOD_D1,i+DAYS+3);
fourdays_high=iHigh(NULL, PERIOD_D1,i+DAYS+4);//4日前最高値
fourdays_low=iLow(NULL, PERIOD_D1,i+DAYS+4);

if(ShowLines==true && Period() < PERIOD_W1) {  

datetime time0 = iTime(NULL,PERIOD_D1,i+DAYS);
datetime time1 = iTime(NULL,PERIOD_D1,i+DAYS+1);
if(line1 == true){
ObjectCreate("1 days ago Low line"+i, OBJ_TREND, 0, time1, yesterday_low, time0, yesterday_low);
ObjectSet("1 days ago Low line"+i, OBJPROP_STYLE, STYLE_DASH);
ObjectSet("1 days ago Low line"+i, OBJPROP_COLOR, linecolor1);
ObjectSetInteger(0,"1 days ago Low line"+i,OBJPROP_RAY_RIGHT,false);//当日ラインの延長線(右)

ObjectCreate("1 days ago High line"+i, OBJ_TREND, 0, time1, yesterday_high, time0, yesterday_high);
ObjectSet("1 days ago High line"+i, OBJPROP_STYLE, STYLE_SOLID);
ObjectSet("1 days ago High line"+i, OBJPROP_COLOR, linecolor1);   
ObjectSetInteger(0,"1 days ago High line"+i,OBJPROP_RAY_RIGHT,false);//当日ラインの延長線(右)
}

datetime time2 = iTime(NULL,PERIOD_D1,i+DAYS+2);
if(line2 == true){

ObjectCreate("2 days ago Low line"+i, OBJ_TREND, 0, time1, twodays_low, time0, twodays_low);
ObjectSet("2 days ago Low line"+i, OBJPROP_STYLE, STYLE_DASH);
ObjectSet("2 days ago Low line"+i, OBJPROP_COLOR, linecolor2);
ObjectSetInteger(0,"2 days ago Low line"+i,OBJPROP_RAY_RIGHT,false);//1日前～1日前ラインの延長線終了位置(右側)

ObjectCreate("2 days ago High line"+i, OBJ_TREND, 0, time1, twodays_high, time0, twodays_high);
ObjectSet("2 days ago High line"+i, OBJPROP_STYLE, STYLE_SOLID);
ObjectSet("2 days ago High line"+i, OBJPROP_COLOR, linecolor2);         
ObjectSetInteger(0,"2 days ago High line"+i,OBJPROP_RAY_RIGHT,false);//1日前～1日前ラインの延長線終了位置(右)
}

datetime time3 = iTime(NULL,PERIOD_D1,i+DAYS+3);
if(line3 == true){

ObjectCreate("3 days ago Low line"+i, OBJ_TREND, 0, time1, threedays_low,time0, threedays_low);
ObjectSet("3 days ago Low line"+i, OBJPROP_STYLE, STYLE_DASH);
ObjectSet("3 days ago Low line"+i, OBJPROP_COLOR, linecolor3);
ObjectSetInteger(0,"3 days ago Low line"+i,OBJPROP_RAY_RIGHT,false);//1日前～2日前ラインの延長線終了位置(右)

ObjectCreate("3 days ago High line"+i, OBJ_TREND, 0, time1, threedays_high, time0, threedays_high);
ObjectSet("3 days ago High line"+i, OBJPROP_STYLE, STYLE_SOLID);
ObjectSet("3 days ago High line"+i, OBJPROP_COLOR, linecolor3);
ObjectSetInteger(0,"3 days ago High line"+i,OBJPROP_RAY_RIGHT,false);//1日前～2日前ラインの延長線終了位置(右)
}

datetime time4 = iTime(NULL,PERIOD_D1,i+DAYS+4);
if(line4 == true){

ObjectCreate("4 days ago Low line"+i, OBJ_TREND, 0, time1, fourdays_low,time0, fourdays_low);
ObjectSet("4 days ago Low line"+i, OBJPROP_STYLE, STYLE_DASH);
ObjectSet("4 days ago Low line"+i, OBJPROP_COLOR, linecolor4);
ObjectSetInteger(0,"4 days ago Low line"+i,OBJPROP_RAY_RIGHT,false);//1日前～3日前ラインの延長線終了位置(右)

ObjectCreate("4 days ago High line"+i, OBJ_TREND, 0, time1, fourdays_high, time0, fourdays_high);
ObjectSet("4 days ago High line"+i, OBJPROP_STYLE, STYLE_SOLID);
ObjectSet("4 days ago High line"+i, OBJPROP_COLOR, linecolor4);
ObjectSetInteger(0,"4 days ago High line"+i,OBJPROP_RAY_RIGHT,false);//1日前～3日前ラインの延長線終了位置(右)
}

} 
              
 }
} 
   return(0);
  }
 
 int deinit(){
for (int i=0; i<10000; i++)
{
ObjectDelete("4 days ago High line"+i);
ObjectDelete("3 days ago High line"+i);
ObjectDelete("2 days ago High line"+i);
ObjectDelete("1 days ago High line"+i);
ObjectDelete("4 days ago Low line"+i);
ObjectDelete("3 days ago Low line"+i);
ObjectDelete("2 days ago Low line"+i);
ObjectDelete("1 days ago Low line"+i);
}	
   return(0);
}// end of deinit()