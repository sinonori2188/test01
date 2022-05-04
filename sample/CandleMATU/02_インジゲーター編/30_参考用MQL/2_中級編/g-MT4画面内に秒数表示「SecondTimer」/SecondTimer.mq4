#property copyright "Copyright 2018, ands"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
enum limitdate1{
                    one = 0,//左上
                    two = 1,//右上
                    three = 2,//左下
                    four = 3,//右下
                    };
extern limitdate1 secondplace = four;//カウンター表示位置

int init()
  {
//---- indicators
   EventSetTimer(1);//1秒ずつOnTimerを稼働させる
//---- indicators

   

//----
   return(0);
  }

 int deinit(){
	
  EventKillTimer();
  ObjectDelete("sectimer");
		
   return(0);
}// end of deinit()

void OnTimer(){
         ObjectCreate("sectimer",OBJ_LABEL,0,0,0);//秒数表示のオブジェクトを作成
         ObjectSet("sectimer",OBJPROP_CORNER,secondplace);//パラメーターにて位置の指定を可能にしている
         ObjectSet("sectimer",OBJPROP_XDISTANCE,5);
         ObjectSet("sectimer",OBJPROP_YDISTANCE,0);
         ObjectSetText("sectimer", IntegerToString(TimeSeconds(TimeLocal())+1), 20, NULL, clrYellow);//[TimeSeconds(TimeLocal())+1]とすることで1～60までの秒数を表示させることができる。+1をつけない場合0～59
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {

   return(0);
  }
//+------------------------------------------------------------------