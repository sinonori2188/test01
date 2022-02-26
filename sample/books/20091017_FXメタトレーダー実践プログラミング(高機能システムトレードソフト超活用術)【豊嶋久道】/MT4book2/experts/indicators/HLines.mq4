//+------------------------------------------------------------------+
//|                                                       HLines.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

#property indicator_chart_window

// �O���p�����[�^
extern int PipsWidth = 25;

// �������֐�
int init()
{
   ObjectCreate("Line1", OBJ_HLINE, 0, 0, 0);
   ObjectCreate("Line2", OBJ_HLINE, 0, 0, 0);
   ObjectCreate("Line3", OBJ_HLINE, 0, 0, 0);
   ObjectCreate("Line4", OBJ_HLINE, 0, 0, 0);

   return(0);
}

// �I���֐�
int deinit()
{
   ObjectDelete("Line1");
   ObjectDelete("Line2");
   ObjectDelete("Line3");
   ObjectDelete("Line4");

   return(0);
}

// �X�^�[�g�֐�
int start()
{
   double diff = PipsWidth*Point;
   int upper = MathCeil(Close[0]/diff);
   int lower = MathFloor(Close[0]/diff);
   
   ObjectSet("Line1", OBJPROP_PRICE1, upper*diff);
   ObjectSet("Line2", OBJPROP_PRICE1, lower*diff);
   ObjectSet("Line3", OBJPROP_PRICE1, (upper+1)*diff);
   ObjectSet("Line4", OBJPROP_PRICE1, (lower-1)*diff);

   return(0);
}

