//+------------------------------------------------------------------+
//|                                                  Stochastic3.mq4 |
//|                               Copyright � 2009, Vladimir Hlystov |
//|            Stochastic ���������� ������� 3 �������� � ����� ���� |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2009, Vladimir Hlystov"
#property link      "cmillion@narod.ru"

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_level1	20
#property indicator_level3	50
#property indicator_level2	80
#property indicator_levelcolor	Silver//	���� �������������� ������� ����������
#property indicator_levelwidth	0//	������� �������������� ������� ����������
#property indicator_levelstyle	2//	����� �������������� ������� ����������
#property indicator_buffers 4
#property indicator_color1 Maroon
#property indicator_style1 2
#property indicator_color2 DarkGreen
#property indicator_style2 2
#property indicator_color3 Navy
#property indicator_style3 2
#property indicator_color4 Yellow
#property indicator_width4 2
//---- buffers
double SignalBuffer[];
double BUFFER_1[];
double BUFFER_2[];
double BUFFER_3[];
   int per1;
   int per2;
   int per3;
   int n=3;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(4);
   IndicatorDigits(0);
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0, BUFFER_1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1, BUFFER_2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2, BUFFER_3);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3, SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   per1=Period();
   per2 = next_period(per1+1);
   if (per2==0) n=1;
   per3 = next_period(per2+1);
   if (per3==0&&per2!=0) n=2;
   SetIndexLabel(0, string_���(per1));
   SetIndexLabel(1, string_���(per2));
   SetIndexLabel(2, string_���(per3));
   SetIndexLabel(3, "�������");
   IndicatorShortName("Stochastic ("+string_���(per1)+""+string_���(per2)+""+string_���(per3)+")");
   return(0);
  }
//+------------------------------------------------------------------+
//| Stochastic oscillator                                            |
//+------------------------------------------------------------------+
int start()
{
   int    counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   for(int i=0; i<limit; i++)
   {
      BUFFER_1[i]  = iStochastic(NULL,per1    ,5,3,3,MODE_SMA,0,MODE_MAIN,iBarShift(NULL,per1    ,Time[i],false));
      if (n>1) BUFFER_2[i]  = iStochastic(NULL,per2    ,5,3,3,MODE_SMA,0,MODE_MAIN,iBarShift(NULL,per2    ,Time[i],false));
      if (n>2) BUFFER_3[i] = iStochastic(NULL,per3   ,5,3,3,MODE_SMA,0,MODE_MAIN,iBarShift(NULL,per3   ,Time[i],false));
      if (n==3) SignalBuffer[i]  = (BUFFER_1[i]+BUFFER_2[i]+BUFFER_3[i])/n;
      if (n==2) SignalBuffer[i]  = (BUFFER_1[i]+BUFFER_2[i])/n;
      if (n==1) SignalBuffer[i]  = BUFFER_1[i];
   }
   return(0);
}
//+------------------------------------------------------------------+
int next_period(int per)
{
   if (per > 43200)  return(0); 
   if (per > 10080)  return(43200); 
   if (per > 1440)   return(10080); 
   if (per > 240)    return(1440); 
   if (per > 60)     return(240); 
   if (per > 30)     return(60);
   if (per > 15)     return(30); 
   if (per > 5)      return(15); 
   if (per > 1)      return(5);   
}
//+------------------------------------------------------------------+
string string_���(int per)
{
   if (per == 1)     return(" M1  ");   //1 ������
   if (per == 5)     return(" M5  ");   //5 ����� 
   if (per == 15)    return(" M15 ");  //15 �����
   if (per == 30)    return(" M30 ");  //30 �����
   if (per == 60)    return(" H1  ");   //1 ���
   if (per == 240)   return(" H4  ");   //4 ����
   if (per == 1440)  return(" D1  ");   //1 ����
   if (per == 10080) return(" W1  ");   //1 ������
   if (per == 43200) return(" MN1 ");  //1 �����
return("������ �������");
}
//+------------------------------------------------------------------+

