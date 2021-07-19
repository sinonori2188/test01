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

// �X�^�[�g�֐�
int start()
{
   // �E�B���h�E�ԍ��̎擾
   int win_idx = WindowFind("ShowMTF");
   if(win_idx < 0) return(-1);

   // ���x���p�I�u�W�F�N�g�̐���
   ObjectCreate("Label0", OBJ_LABEL, win_idx, 0, 0);
   ObjectSet("Label0", OBJPROP_CORNER, 3);
   ObjectSet("Label0", OBJPROP_XDISTANCE, 1);
   ObjectSet("Label0", OBJPROP_YDISTANCE, 18);
   ObjectSetText("Label0", "MACD M15 H1 D1", 8, "Arial", Black);

   // �����`���[�g�p�I�u�W�F�N�g�̐���
   ObjectCreate("Label1", OBJ_LABEL, win_idx, 0, 0);
   ObjectSet("Label1", OBJPROP_CORNER, 3);
   ObjectSet("Label1", OBJPROP_XDISTANCE, 1);
   ObjectSet("Label1", OBJPROP_YDISTANCE, 1);

   // �P���ԑ��`���[�g�p�I�u�W�F�N�g�̐���
   ObjectCreate("Label2",OBJ_LABEL, win_idx, 0, 0);
   ObjectSet("Label2", OBJPROP_CORNER, 3);
   ObjectSet("Label2", OBJPROP_XDISTANCE, 17);
   ObjectSet("Label2", OBJPROP_YDISTANCE, 1);

   // �P�T�����`���[�g�p�I�u�W�F�N�g�̐���
   ObjectCreate("Label3", OBJ_LABEL, win_idx, 0, 0);
   ObjectSet("Label3", OBJPROP_CORNER, 3);
   ObjectSet("Label3", OBJPROP_XDISTANCE, 33);
   ObjectSet("Label3", OBJPROP_YDISTANCE, 1);

   // �����`���[�gMACD
   double macd_d1 = iMACD(NULL, PERIOD_D1, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 0);
   if(macd_d1 > 0) ObjectSetText("Label1", CharToStr(221), 16, "Wingdings", Blue);
   else ObjectSetText("Label1", CharToStr(222), 16, "Wingdings", Red);

   // �P���ԑ��`���[�gMACD
   double macd_h1 = iMACD(NULL, PERIOD_H1, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 0);
   if(macd_h1 > 0) ObjectSetText("Label2", CharToStr(221), 16, "Wingdings", Blue);
   else ObjectSetText("Label2", CharToStr(222), 16, "Wingdings", Red);

   // �P�T�����`���[�gMACD
   double macd_m15 = iMACD(NULL, PERIOD_M15, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 0);
   if(macd_m15 > 0) ObjectSetText("Label3", CharToStr(221), 16, "Wingdings", Blue);
   else ObjectSetText("Label3", CharToStr(222), 16, "Wingdings", Red);

   return(0);
}

