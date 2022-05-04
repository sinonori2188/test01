//+------------------------------------------------------------------+
//|                                                        Bline.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//|OnCalculateは今回使いませんので空にしておきます。                            |
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
   return(rates_total);
}


//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   // 変数定義
   int KEY = 84; // キーコードT
   int KEY1 = 82; // キーコードR
   
   //キーコードはhttp://faq.creasus.net/04/0131/CharCode.htmlより調べることが
   
   string objname = "Hline";  //水平線名称
   static int objnumber = 1; // 番号
   
   static int step = 0; //キーボード押下時のフラグ
   static int step1 = 0; // クリック時のフラグ


   // キーボード入力時
   if(id == CHARTEVENT_KEYDOWN){//イベント発生時lparam→キーコード、dparam→繰り返し押された回数、sparam→文字列を返します、今回はキーコードを取得します。
      if(lparam == KEY){//Tが押されたとき
         if(step == 0){
            step = 1;
         }
      }
      if(lparam == KEY1){//Rが押されたとき
         if(step1 == 0){
            step1 = 1;
         }
      }
   }

   // マウスクリック時
   if(id == CHARTEVENT_CLICK){//イベント発生時lparam→x座標、dparam→y座標、、を返します、今回はxy座標を取得し、その後ChartXYToTimePriceを使い座標から価格と時間を取得し平行線を引きます。
         
         // クリック時のXY座標を取得
         int x = (int)lparam;
         int y = (int)dparam;

         // 座標を時間と価格に変換
         datetime time = 0;
         double price = 0;
         int window = 0;
         ChartXYToTimePrice(0, x, y, window, time, price);

         if(step == 1){
            //　クリック座標を始点として平行線を生成
            objname = objname + (string)objnumber;
            ObjectCreate(0, objname, OBJ_HLINE, 0, time, price);
            objnumber++;
            step = 0;
         }
         
      
      }
      
   if(id == CHARTEVENT_OBJECT_CLICK){//イベント発生時lparam→オブジェクトのx座標、dparam→オブジェクトのy座標sparam→オブジェクト名を返します、今回はオブジェクト名を取得し、削除する式を入れます。
         string obj = sparam; 
     
         if(step1 == 1){
         ObjectDelete(obj);
         step1 = 0;
         }
    
       
      }

}
