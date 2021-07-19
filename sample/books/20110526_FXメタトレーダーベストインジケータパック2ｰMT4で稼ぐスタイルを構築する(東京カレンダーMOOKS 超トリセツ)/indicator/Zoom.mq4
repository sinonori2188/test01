//+------------------------------------------------------------------+
//|                                                                  |
//|                                                      Denis Orlov |
//|                                    http://denis-or-love.narod.ru |
/*
���������� ��������� "���������" ������������ ����� ������� � ����������� �� � ��������� ����������.
http://codebase.mql4.com/ru/7161

The tool allows to "increase" any part of the schedule for considering it in chosen timeframes.
http://codebase.mql4.com/7162
*/
//+------------------------------------------------------------------+
#property copyright "Denis Orlov,http://denis-or-love.narod.ru"
#property link      "http://denis-or-love.narod.ru"

//#define Pref "Denis Orlov: "

#property indicator_chart_window

#property indicator_buffers 4

#property indicator_color1 DarkTurquoise
#property indicator_color2 DarkBlue
#property indicator_color3 DarkTurquoise
#property indicator_color4 DarkBlue


double LineBma[], Line1[], Line2[], Line3[], Line4[];
//#property indicator_maximum 100



string TimeFrsArray[];
int BarsEn[];//array of end bar
int BarsSt[];//array of start bar
int BarsTx[];//array of bar for price label

                         
extern string TimeFrames=
"15 30";
//"240";


//"USDJPY EURJPY GBPJPY";

//extern 
int Bars_ =0;
datetime RectT1,RectT2;
double RectP1,RectP2;

extern string RectName="Zoom_Rectangle";
extern color RectColor=Blue;  
extern int ChartsGap =1;
extern bool GoldColor=False;
//extern string note1="Vertical lines:";                  
//extern color VertLineColor=Blue;
//extern int VertLineWidth=1;
//extern int VertLineStyle=2;
extern string note2="Text:"; 
//extern int TextY=80;
//extern int TextYStep=20;
extern int FontSize=10;
extern color TextColor=Blue;
//extern color UpColor=Green;
//extern color DnColor=Red;


double CountLevel;
//extern int History=0; 

/*extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalSMA=9;

#define MacdArrSize 5
double MACD[MacdArrSize];
double MACD_S[MacdArrSize];*/

int perB;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----   
     
    //Comment("*MultiChart* "+ArraySize(TimeFrsArray)+" symbols *http://denis-or-love.narod.ru*");
    
   SetIndexStyle(0,DRAW_HISTOGRAM,0,3);
   SetIndexBuffer(0,Line1);
   
   SetIndexStyle(1,DRAW_HISTOGRAM,0,3);
   SetIndexBuffer(1,Line2);

   SetIndexStyle(2,DRAW_HISTOGRAM,0,1);
   SetIndexBuffer(2,Line3);
   
   SetIndexStyle(3,DRAW_HISTOGRAM,0,1);
   SetIndexBuffer(3,Line4);
   
      if(GoldColor)
      {
         SetIndexStyle(0,DRAW_HISTOGRAM,0,3,Yellow);
         SetIndexStyle(1,DRAW_HISTOGRAM,0,3,Orange);
         SetIndexStyle(2,DRAW_HISTOGRAM,0,1,Yellow);
         SetIndexStyle(3,DRAW_HISTOGRAM,0,1,Orange);
      }
      
 // DrawLabels(Pref+"Warning!", 0, 250, 1, 
 // "Remember NOT to trade here! �������, �� ��������� �����!", 0, DnColor, 0,  FontSize);

 int lastBar=WindowFirstVisibleBar()-WindowBarsPerChart()-1;
 while(lastBar<0)lastBar++;
  
 double Highval=High[iHighest(NULL,0,MODE_HIGH,9,lastBar+1)];
 double Lowval=Low[iLowest(NULL,0,MODE_LOW,9,lastBar+1)]; 
 
  DrawRect("Main"+RectName, Time[lastBar+10], Highval, Time[lastBar], Lowval, RectColor,0,TimeFrames); 
  
  CountLevel=Lowval;
  DrawText("Main"+RectName+"CountLevel", Time[lastBar], Lowval-10*Point, "", 69, TextColor, FontSize+2,0) ;  
  
  FillTimeFrsArray();
    if(ArraySize(TimeFrsArray)<1) return;
     ArrayResize( BarsEn,ArraySize(TimeFrsArray));
     ArrayResize( BarsSt,ArraySize(TimeFrsArray));
     ArrayResize( BarsTx,ArraySize(TimeFrsArray));  
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+

//------------------
int deinit()
  {
//----
   //Delete_My_Obj( Pref);
   Delete_My_Obj( RectName);
   Delete_My_Obj("Main"+RectName);
   //Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
   if(ObjectDescription("Main"+RectName)!=TimeFrames)
   { 
     Delete_My_Obj(RectName);
     FillTimeFrsArray();
    if(ArraySize(TimeFrsArray)<1) return;
     ArrayResize( BarsEn,ArraySize(TimeFrsArray));
     ArrayResize( BarsSt,ArraySize(TimeFrsArray));
     ArrayResize( BarsTx,ArraySize(TimeFrsArray)); 
     TimeFrames=ObjectDescription("Main"+RectName);
   }
   
   if(ArraySize(TimeFrsArray)<1) return;
   
   if (perB!= Time[0])  // ���� ��� � ���
         {
           perB = Time[0];
           
         }
         
     
    ObjectSet("Main"+RectName+"CountLevel",OBJPROP_TIME1,ObjectGet("Main"+RectName,OBJPROP_TIME2)) ; 
    MainDraw();  
  //  if(CountLevel!=ObjectGet("Main"+RectName+"CountLevel",OBJPROP_PRICE1)+10*Point) MainDraw();  //������ ���������   
   
   //�� ������ ���� ������ ������� ���� ���������, Bars0
    /* for( int i=0; i<ArraySize(TimeFrsArray);i++)//�� ������� �������
         {
             if(StringLen(TimeFrsArray[i])>6) 
         int per=StrToPeriod(StringSubstr(TimeFrsArray[i],6, 0));
            else per=Period();
             
            int B=Bars0[i];
            
            string perStr=PeriodToStr(per);     // our Period, ��� ���������
         string Symb=StringSubstr(TimeFrsArray[i],0, 6);// our symbol, ��� ����������
         double po=MarketInfo(TimeFrsArray[i], MODE_POINT);
         
         double razn=CountLevel-iClose(Symb,per ,Bars_-1);//������� ��� 
             
             double 
                  H=iHigh(Symb, per, 0),
                  L=iLow(Symb, per, 0),
                  O=iOpen(Symb, per, 0),
                  C=iClose(Symb, per, 0); 
                  
                  if(StringSubstr(Symb,3, 0)=="JPY")//���������� ���� ��� ������
                    {
                      H=H/100; L=L/100; O=O/100; C=C/100;
                      razn=CountLevel-iClose(Symb,per ,Bars_-1)/100;
                    }
                     
                  
                 // Comment("*"+iClose(Symb, per, j)+"*");
                  
            if(C>O)
            {
               Line1[B]=C+razn; Line2[B]=O+razn;
               Line3[B]=H+razn; Line4[B]=L+razn; 
            }
            else
            if(C<O)
            {
               Line1[B]=C+razn; Line2[B]=O+razn;
               Line3[B]=L+razn; Line4[B]=H+razn; 
            }
            else
            if(C==O)
            {
               Line1[B]=O+razn; Line2[B]=C+0.01*po+razn;
               Line3[B]=L+razn; Line4[B]=H+razn; 
            }
            
         string LName=Pref+"Tx "+Symb+" "+perStr;
        double c=iClose(Symb, per, 0), o=iOpen(Symb, per, 0);
        if(c>o) color pColor=UpColor; else pColor=DnColor;//���� ������� �����
           
     /// LABEL
     string Text=DoubleToStr(c, Digits);
     DrawText( LName+"_3", Time[BarsTx[i]], WindowPriceMin()+(TextY-2*TextYStep)*Point, Text, 0, pColor, FontSize,0) ; 
         }*/
   
   
   
}
int MainDraw()
  {
//---
   
    if(ArraySize(TimeFrsArray)<1) return;

      Bars_=CountBars()+ArraySize(TimeFrsArray)*ChartsGap+1; //Alert(Bars_);
      
      int B=iBarShift(NULL,0, ObjectGet("Main"+RectName,OBJPROP_TIME2))+Bars_;//ArraySize(TimeFrsArray)*(Bars_+1+ChartsGap)-1;
       
      CountLevel=ObjectGet("Main"+RectName+"CountLevel",OBJPROP_PRICE1)+10*Point;
      
   ArrayInitialize( Line1, EMPTY_VALUE);// ������� ������
   ArrayInitialize( Line2, EMPTY_VALUE);
   ArrayInitialize( Line3, EMPTY_VALUE);
   ArrayInitialize( Line4, EMPTY_VALUE);

      for( int i=0; i<ArraySize(TimeFrsArray);i++)//�� ������� tf
         {
         // ������ ��������� ���������� � ������ �� �������
         //if(StringLen(TimeFrsArray[i])>6) 
         int per=StrToPeriod(TimeFrsArray[i]);
           // else per=Period(); 
            
            string perStr=PeriodToStr(per);     // our Period, ��� ���������
         string Symb=Symbol();//StringSubstr(TimeFrsArray[i],0, 6);// our symbol, ��� ����������
         double po=MarketInfo(TimeFrsArray[i], MODE_POINT);
           
                 //if(Symb!=Symbol())
                 
                 int BarRect1=iBarShift(NULL,0, ObjectGet("Main"+RectName,OBJPROP_TIME1));
                 int BarRect2=iBarShift(NULL,0, ObjectGet("Main"+RectName,OBJPROP_TIME2));
                 int ourBars=BarRect1-BarRect2-1;
                 
                 int startBar=iBarShift(NULL,per, Time[BarRect1-1]); 
                 double p=Period();double p_=per;    
                  double d=p/p_;
                 int endBar=startBar-MathRound(d*ourBars)+1; 
                 if(endBar<0)endBar=0;
                 double Highval=High[iHighest(NULL,0,MODE_HIGH,ourBars,BarRect2+1)];
                 double Lowval=Low[iLowest(NULL,0,MODE_LOW,ourBars,BarRect2+1)]; 
                 
                 double razn=CountLevel-Lowval;
                 
                  
                 /* string LName=RectName+"VL "+Symb+" "+perStr; //������� ���� ����������� �������
                  if(ObjectFind(LName)<0) ObjectCreate( LName,OBJ_VLINE,0,Time[B],0);
                  ObjectSet( LName, OBJPROP_TIME1 , Time[B]);            
                  ObjectSet( LName, OBJPROP_COLOR , VertLineColor);
                  ObjectSet( LName, OBJPROP_WIDTH , VertLineWidth);
                  ObjectSet( LName, OBJPROP_BACK, True);
                  if(VertLineWidth<2)
                  ObjectSet( LName, OBJPROP_STYLE , VertLineStyle);*/
                 // ObjectSetText( LName, DoubleToStr(TM,0));
                 
           //�������, ����������� �����
          string LName=RectName+i+"Tx "+Symb+" "+perStr;
       // double c=iClose(Symb, per, 0), o=iOpen(Symb, per, 0);
        //if(c>o) color pColor=UpColor; else pColor=DnColor;//���� ������� �����
           
     /// LABELS
     //string Text=DoubleToStr(c, Digits);
    // DrawText( LName+"_1", Time[B-6], WindowPriceMin()+TextY*Point, Symb, 0, TextColor, FontSize,0) ; 
     DrawText( LName+"_2", Time[B-4], Lowval+razn, perStr, 0, TextColor, FontSize,0) ;
    // DrawText( LName+"_3", Time[B-5], WindowPriceMin()+(TextY-2*TextYStep)*Point, Text, 0, pColor, FontSize,0) ;            
    // DrawText( LName+"_4", Time[B-5], WindowPriceMin()+(TextY-3*TextYStep)*Point, "�����= "+DoubleToStr(MarketInfo(Symb, MODE_SPREAD),0), 0, TextColor, FontSize,0) ;
     
     //DrawText( LName+"_5", Time[B-5], WindowPriceMin()+(TextY-4*TextYStep)*Point, NewText, 0, pColor, FontSize,0) ;
             BarsTx[i]=B-5; 
                            
                             B--; // ��������� ����� ����� ���...
                 
                 //������� ��� ��� ������������ � ����
                 // else razn=0;
                 
                // Alert(per+":"+startBar+";"+endBar+";"+ourBars+";");      
         
         for(int j=startBar; j>=endBar;j--)//�� ������� ����
             {                
                  if(j==startBar)//BarsSt[i]=B;//��������� "������ ���" ��� ����� ��      
                     DrawRect(RectName+i+perStr, Time[B]-Period()*60, Highval+razn, Time[B], Lowval+razn, RectColor);   
                  if(j==endBar)//BarsEn[i]=B;//��������� "��������� ���" ��� ����� ��
                     ObjectSet(RectName+i+perStr,OBJPROP_TIME2, Time[B]+Period()*60);
                  
                  double // �������� ������
                  H=iHigh(Symb, per, j),
                  L=iLow(Symb, per, j),
                  O=iOpen(Symb, per, j),
                  C=iClose(Symb, per, j); 
                  
                 /* if(StringSubstr(Symb,3, 0)=="JPY")//���� ����, ���������� ���� ��� ������
                    {
                      H=H/100; L=L/100; O=O/100; C=C/100;
                      razn=CountLevel-iClose(Symb,per ,Bars_-1)/100;
                    }*/
                     
                  
               /// ������!������ ������...
                  
            if(C>O)
            {
               Line1[B]=C+razn; Line2[B]=O+razn;
               Line3[B]=H+razn; Line4[B]=L+razn; 
            }
            else
            if(C<O)
            {
               Line1[B]=C+razn; Line2[B]=O+razn;
               Line3[B]=L+razn; Line4[B]=H+razn; 
            }
            else
            if(C==O)
            {
               Line1[B]=O+razn; Line2[B]=C+0.01*po+razn;
               Line3[B]=L+razn; Line4[B]=H+razn; 
            }
            
                        
                        
             B--;  ///   ��������� ���...     
           }//�� ������� ����
           
           B=B-ChartsGap; //������ ����� �������

      }//�� ������� �������

//----
   return(0);
  }
//+------------------------------------------------------------------+

//��������� ������ ������������
int FillTimeFrsArray()
{
   string str=ObjectDescription("Main"+RectName), delim=" ";
   
   str=StringTrimRight( str) ;
       str=StringTrimLeft( str) ;
       
   while( StringFind( str, "  ")>-1 && StringLen(str)>0)
        str=StringReplace(str, "  ", " ");
       while( StringFind( str, "\t")>-1 && StringLen(str)>0)
        str=StringReplace(str, "\t", " ");
       
       str=str+" ";
       ArrayResize( TimeFrsArray, 0) ;
        
     while( StringLen(str)>0)
      {
         int pos=StringFind(str, delim);
         string sy=StringSubstr(str, 0, pos);
         str=StringSubstr(str, pos+1);/// ������� 
         
            if(StringSubstr(sy, 0,1)=="-") continue;
            
         int Size=ArraySize(TimeFrsArray);
         ArrayResize( TimeFrsArray, Size+1) ;
         TimeFrsArray[Size]=sy;
      } 
      
      return(ArraySize(TimeFrsArray));  
}
//-------
string StringReplace(string text, string oldstr, string newstr)
{
  int pos=StringFind(text, oldstr);
  if(pos>-1)
   { 
      string str=StringSubstr(text, 0, pos)+newstr+StringSubstr(text, pos+StringLen(oldstr));
      return(str);
   }
   return(text);
}
//----------------
int StrToPeriod(string str)
{
     if(str=="M1" || str=="1" )return(1);
     if(str=="M5" || str=="5")return(5);
     if(str=="M15" || str=="15")return(15);
     if(str=="M30" || str=="30")return(30);
     if(str=="H1" || str=="60")return(60);
     if(str=="H4" || str=="240")return(240);
     if(str=="D1" || str=="1440")return(1440);
     if(str=="W1" || str=="10080")return(10080);
     if(str=="�N" || str=="43200")return(43200);
     
        return(Period());
}
string PeriodToStr(int Per)
   {
      switch(Per)                 // ������ ������������� ���..     
      {                              // .. ��������� ��      
      case     1: return("M1");  // ��������� �1      
      case     5: return("M5");  // ��������� �5      
      case    15: return("M15");  // ��������� �15      
      case    30: return("M30");  // ��������� �30      
      case    60: return("H1");  // ��������� H1      
      case   240: return("H4");  // ��������� H4      
      case  1440: return("D1");  // ��������� D1      
      case 10080: return("W1");  // ��������� W1      
      case 43200: return("�N");  // ��������� �N     
      }
   }
///=======================
void Delete_My_Obj(string Prefix)
   {
   for(int k=ObjectsTotal()-1; k>=0; k--)  // �� ���������� ���� �������� 
     {
      string Obj_Name=ObjectName(k);   // ����������� ��� �������
      string Head=StringSubstr(Obj_Name,0,StringLen(Prefix));// ��������� ������ ���

      if (Head==Prefix)// ������ ������, ..
         {
         ObjectDelete(Obj_Name);
         }                
        
     }
   }
//----------------------------------
int DrawText( string name, datetime T, double P, string Text, int code=0, color Clr=Green,  int Fsize=10, int Win=0)
   { 
      if (name=="") name="Text_"+T;
      
      int Error=ObjectFind(name);// ������ 
   if (Error!=Win)// ���� ������� � ��. ���� ��� :(
    { 
      ObjectCreate(name, OBJ_TEXT, Win, T, P);
      }
      
      ObjectSet(name, OBJPROP_TIME1, T);
      ObjectSet(name, OBJPROP_PRICE1, P);
      if(code==0)
      ObjectSetText(name, Text ,Fsize,"Arial",Clr);
      else
      ObjectSetText(name, CharToStr(code), Fsize,"Wingdings",Clr);
   }
///================================
int DrawLabels(string name, int corn, int X, int Y, string Text, int code=0, color Clr=Green, int Win=0, int FSize=10)
   {
     int Error=ObjectFind(name);// ������ 
   if (Error!=Win)// ���� ������� � ��. ���� ��� :(
    {  
      ObjectCreate(name,OBJ_LABEL,Win, 0,0); // �������� �������
    }
     
     ObjectSet(name, OBJPROP_CORNER, corn);     // �������� � ����   
     ObjectSet(name, OBJPROP_XDISTANCE, X);  // ���������� �   
     ObjectSet(name,OBJPROP_YDISTANCE,Y);// ���������� Y   
     ObjectSetText(name,Text,FSize,"Arial",Clr);
          if(code==0)
      ObjectSetText(name, Text ,FSize,"Arial",Clr);
      else
      ObjectSetText(name, CharToStr(code), FSize,"Wingdings",Clr);
   }
///================================
int DrawRect(string name, datetime T1, double P1, datetime T2, double P2, color Clr, int W=1, string Text="", bool BACK=false, int Win=0)
   {
     int Error=ObjectFind(name);// ������ 
   if (Error!=Win)// ���� ������� � ��. ���� ��� :(
    {  
      ObjectCreate(name, OBJ_RECTANGLE, Win,T1,P1,T2,P2);//�������� ��������� �����
    }
     
    ObjectSet(name, OBJPROP_TIME1 ,T1);
    ObjectSet(name, OBJPROP_PRICE1,P1);
    ObjectSet(name, OBJPROP_TIME2 ,T2);
    ObjectSet(name, OBJPROP_PRICE2,P2);
    ObjectSet(name,OBJPROP_BACK, BACK);
    ObjectSet(name,OBJPROP_STYLE,0);
    ObjectSet(name, OBJPROP_COLOR , Clr);
    ObjectSet(name, OBJPROP_WIDTH , W);
    ObjectSetText(name,Text);
   }  
//-------------------
///================================
int CountBars()
{
    double res=0;
    for( int i=0; i<ArraySize(TimeFrsArray);i++)//�� ������� tf
    {
      
      int BarRect1=iBarShift(NULL,0, ObjectGet("Main"+RectName,OBJPROP_TIME1));
      int BarRect2=iBarShift(NULL,0, ObjectGet("Main"+RectName,OBJPROP_TIME2));
      int ourBars=BarRect1-BarRect2-1;
      int zoomPer=StrToPeriod(TimeFrsArray[i]);
     
      double p=Period();double p_=zoomPer;    
      double d=p/p_;
      res=res+MathRound(d*ourBars); //Alert(Period()+"/"+d+"="+res);
      
    }
  return(res);  
}