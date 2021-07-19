//+------------------------------------------------------------------+
//|                                                      ShowMTF.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 1

// スタート関数
int start()
{
   // ウィンドウ番号の取得
   int win_idx = WindowFind("ShowMTF");
   if(win_idx < 0) return(-1);

   // ラベル用オブジェクトの生成
   ObjectCreate("Label0", OBJ_LABEL, win_idx, 0, 0);
   ObjectSet("Label0", OBJPROP_CORNER, 3);
   ObjectSet("Label0", OBJPROP_XDISTANCE, 1);
   ObjectSet("Label0", OBJPROP_YDISTANCE, 18);
   ObjectSetText("Label0", "MACD M15 H1 D1", 8, "Arial", Black);

   // 日足チャート用オブジェクトの生成
   ObjectCreate("Label1", OBJ_LABEL, win_idx, 0, 0);
   ObjectSet("Label1", OBJPROP_CORNER, 3);
   ObjectSet("Label1", OBJPROP_XDISTANCE, 1);
   ObjectSet("Label1", OBJPROP_YDISTANCE, 1);

   // １時間足チャート用オブジェクトの生成
   ObjectCreate("Label2",OBJ_LABEL, win_idx, 0, 0);
   ObjectSet("Label2", OBJPROP_CORNER, 3);
   ObjectSet("Label2", OBJPROP_XDISTANCE, 17);
   ObjectSet("Label2", OBJPROP_YDISTANCE, 1);

   // １５分足チャート用オブジェクトの生成
   ObjectCreate("Label3", OBJ_LABEL, win_idx, 0, 0);
   ObjectSet("Label3", OBJPROP_CORNER, 3);
   ObjectSet("Label3", OBJPROP_XDISTANCE, 33);
   ObjectSet("Label3", OBJPROP_YDISTANCE, 1);

   // 日足チャートMACD
   double macd_d1 = iMACD(NULL, PERIOD_D1, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 0);
   if(macd_d1 > 0) ObjectSetText("Label1", CharToStr(221), 16, "Wingdings", Blue);
   else ObjectSetText("Label1", CharToStr(222), 16, "Wingdings", Red);

   // １時間足チャートMACD
   double macd_h1 = iMACD(NULL, PERIOD_H1, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 0);
   if(macd_h1 > 0) ObjectSetText("Label2", CharToStr(221), 16, "Wingdings", Blue);
   else ObjectSetText("Label2", CharToStr(222), 16, "Wingdings", Red);

   // １５分足チャートMACD
   double macd_m15 = iMACD(NULL, PERIOD_M15, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 0);
   if(macd_m15 > 0) ObjectSetText("Label3", CharToStr(221), 16, "Wingdings", Blue);
   else ObjectSetText("Label3", CharToStr(222), 16, "Wingdings", Red);

   return(0);
}

