//+------------------------------------------------------------------+
//|                                                     Swing_ZZ.mq4 |
//+------------------------------------------------------------------+

//---- Alert by FerruFx

#property copyright "onix"
#property link      "http://onix-trade.net/forum/index.php?s=&showtopic=118&view=findpost&p=131476"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Aqua
#property indicator_color2 Blue
#property indicator_color3 Red

//---- indicator parameters
extern int    minBars = 2; 
extern bool   SignalAlert    = false;
extern bool   SendAlertEmail = false;

//---- indicator buffers
double zzL[];
double zzH[];
double zz[];

//---- Alert
int up =0;
int down =0;
string Timeframe="";
double time_frame;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
 //  IndicatorBuffers(3);
//---- drawing settings
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexArrow(2,159);
   SetIndexArrow(1,159);
//---- indicator buffers mapping
   SetIndexBuffer(0,zz);
   SetIndexBuffer(1,zzH);
   SetIndexBuffer(2,zzL);
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
     
//---- indicator short name
   IndicatorShortName("Swing_ZZ("+minBars+")");

//---- initialization done

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
 int cbi;
 double lLast=0,hLast=0; 
 int fs=0; 
 int ai,bi,ai0,aip0,bi0,bip0; 
 datetime tai,tbi,taip,tbip,ti; 
 
 // ���������� ��� ������� �����
 double lLast_m=0, hLast_m=0;
 int countBarExt; // ������� ������� �����
 int countBarl,countBarh;
 int i,n;

   ArrayInitialize(zz,0.0);
   ArrayInitialize(zzL,0.0);
   ArrayInitialize(zzH,0.0);



// lLast, hLast - ������� � �������� ��������� ����
// lLast_m, hLast_m - ������� � �������� "�������������" �����

//   cbi=Bars-IndicatorCounted()-1;
   cbi=Bars-1; 
//---------------------------------
   for (i=cbi; i>=0; i--) 
     {
//-------------------------------------------------
      // ������������� ��������� �������� �������� � ��������� ����
      if (lLast==0) {lLast=Low[i]; hLast=High[i]; ai=i; bi=i;}
      if (ti!=Time[i])
        {
         ti=Time[i];
         if (lLast_m==0 && hLast_m==0)
           {
            if (lLast>Low[i] && hLast<High[i]) // ������� ���
              {
               lLast=Low[i];hLast=High[i];lLast_m=Low[i];hLast_m=High[i];countBarExt++;
               if (fs==1) {countBarl=countBarExt; ai=i; tai=Time[i];}
               else if (fs==2) {countBarh=countBarExt; bi=i; tbi=Time[i];}
               else {countBarl++;countBarh++;}
              }
            else if (lLast<=Low[i] && hLast<High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=0;hLast_m=High[i];countBarl=0;countBarExt=0;
               if (fs!=1) countBarh++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; ai=i; tai=Time[i];}
              }
            else if (lLast>Low[i] && hLast>=High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=Low[i];hLast_m=0;countBarh=0;countBarExt=0;
               if (fs!=2) countBarl++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; bi=i; tbi=Time[i];}
              }
           }
         else  if (lLast_m>0 && hLast_m>0) // ������� ��� (����������)
           {
            if (lLast_m>Low[i] && hLast_m<High[i]) // ������� ���
              {
               lLast=Low[i];hLast=High[i];lLast_m=Low[i];hLast_m=High[i];countBarExt++;
               if (fs==1) {countBarl=countBarExt; ai=i; tai=Time[i];}
               else if (fs==2) {countBarh=countBarExt; bi=i; tbi=Time[i];}
               else {countBarl++;countBarh++;}
              }
            else if (lLast_m<=Low[i] && hLast_m<High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=0;hLast_m=High[i];countBarl=0;countBarExt=0;
               if (fs!=1) countBarh++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; ai=i; tai=Time[i];}
              }
            else if (lLast_m>Low[i] && hLast_m>=High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=Low[i];hLast_m=0;countBarh=0;countBarExt=0;
               if (fs!=2) countBarl++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; bi=i; tbi=Time[i];}
              }
           }
         else  if (lLast_m>0)
           {
            if (lLast_m>Low[i] && hLast<High[i]) // ������� ���
              {
               lLast=Low[i];hLast=High[i];lLast_m=Low[i];hLast_m=High[i];countBarExt++;
               if (fs==1) {countBarl=countBarExt; ai=i; tai=Time[i];}
               else if (fs==2) {countBarh=countBarExt; bi=i; tbi=Time[i];}
               else {countBarl++;countBarh++;}
              }
            else if (lLast_m<=Low[i] && hLast<High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=0;hLast_m=High[i];countBarl=0;countBarExt=0;
               if (fs!=1) countBarh++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; ai=i; tai=Time[i];}
              }
            else if (lLast_m>Low[i] && hLast>=High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=Low[i];hLast_m=0;countBarh=0;countBarExt=0;
               if (fs!=2) countBarl++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; bi=i; tbi=Time[i];}
              }
           }
         else  if (hLast_m>0)
           {
            if (lLast>Low[i] && hLast_m<High[i]) // ������� ���
              {
               lLast=Low[i];hLast=High[i];lLast_m=Low[i];hLast_m=High[i];countBarExt++;
               if (fs==1) {countBarl=countBarExt; ai=i; tai=Time[i];}
               else if (fs==2) {countBarh=countBarExt; bi=i; tbi=Time[i];}
               else {countBarl++;countBarh++;}
              }
            else if (lLast<=Low[i] && hLast_m<High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=0;hLast_m=High[i];countBarl=0;countBarExt=0;
               if (fs!=1) countBarh++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; ai=i; tai=Time[i];}
              }
            else if (lLast>Low[i] && hLast_m>=High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=Low[i];hLast_m=0;countBarh=0;countBarExt=0;
               if (fs!=2) countBarl++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; bi=i; tbi=Time[i];}
              }
           }

         // ���������� ����������� ������. 
         if (fs==0)
           {
            if (lLast<lLast_m && hLast>hLast_m) // ���������� ���
              {
               lLast=Low[i]; hLast=High[i]; ai=i; bi=i; countBarl=0;countBarh=0;countBarExt=0;
              }
              
            if (countBarh>countBarl && countBarh>countBarExt && countBarh>minBars)
              {
               lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0;
               fs=1;countBarh=0;countBarl=0;countBarExt=0;
               zz[bi]=Low[bi];
               zzL[bi]=Low[bi];
               zzH[bi]=0;
               ai=i;
               tai=Time[i];
              }
            else if (countBarl>countBarh && countBarl>countBarExt && countBarl>minBars)
              {
               lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0;
               fs=2;countBarl=0;countBarh=0;countBarExt=0;
               zz[ai]=High[ai];
               zzH[ai]=High[ai];
               zzL[ai]=0;
               bi=i;
               tbi=Time[i];
              }
           }
         else
           {
            if (lLast_m==0 && hLast_m==0)
              {
               countBarl=0;countBarh=0;countBarExt=0;
              }

            // ��������� ����������
            if (fs==1)
              {
                  if (countBarl>countBarh && countBarl>countBarExt && countBarl>minBars) // ���������� ����� ����� ���������.
                    {
                     // ���������� �������� ����������� ������ fs �� ���������� ����
                     ai0=iBarShift(Symbol(),0,tai); 
                     bi0=iBarShift(Symbol(),0,tbi);
                     fs=2;
                     countBarl=0;

                     zz[ai]=High[ai];
                     zzH[ai]=High[ai];
                     zzL[ai]=0;
                     bi=i;
                     tbi=Time[i];

                     lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0;

                     for (n=0;countBarExt<minBars;n++) 
                       {
                        if (lLast<Low[i+n+1] && hLast>High[i+n+1]) {countBarExt++; countBarh++; lLast=Low[i+n+1]; hLast=High[i+n+1]; hLast_m=High[i];}
                        else break;
                       }

                     lLast=Low[i]; hLast=High[i];

                    }
              }

            // ��������� ����������
            if (fs==2)
              {
                  if (countBarh>countBarl && countBarh>countBarExt && countBarh>minBars) // ���������� ����� ����� ���������.
                    {
                     // ���������� �������� ����������� ������ fs �� ���������� ����
                     ai0=iBarShift(Symbol(),0,tai); 
                     bi0=iBarShift(Symbol(),0,tbi);
                     fs=1;
                     countBarh=0;

                     zz[bi]=Low[bi];
                     zzL[bi]=Low[bi];
                     zzH[bi]=0;
                     ai=i;
                     tai=Time[i];

                     lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0;

                     for (n=0;countBarExt<minBars;n++) 
                       {
                        if (lLast<Low[i+n+1] && hLast>High[i+n+1]) {countBarExt++; countBarl++; lLast=Low[i+n+1]; hLast=High[i+n+1]; lLast_m=Low[i];}
                        else break;
                       }

                     lLast=Low[i]; hLast=High[i];

                    }
              }
           } 
        } 
       if (i==0)
         {
          if (hLast<High[i] && fs==1) // ��������� �� ������� ���� ����������
            {
             ai=i; tai=Time[i]; zz[ai]=High[ai]; zzH[ai]=High[ai]; zzL[ai]=0;
            }
          else if (lLast>Low[i] && fs==2) // ��������� �� ������� ���� ����������
            {
             bi=i; tbi=Time[i]; zz[bi]=Low[bi]; zzL[bi]=Low[bi]; zzH[bi]=0;
            }
//===================================================================================================
      // ������� ���. ������ ������� ���� ZigZag-a

          ai0=iBarShift(Symbol(),0,tai); 
          bi0=iBarShift(Symbol(),0,tbi);

          if (bi0>1) if (fs==1) {for (n=bi0-1; n>=0; n--) {zzH[n]=0.0; zz[n]=0.0;} zz[ai0]=High[ai0]; zzH[ai0]=High[ai0]; zzL[ai0]=0.0;}         
          if (ai0>1) if (fs==2) {for (n=ai0-1; n>=0; n--) {zzL[n]=0.0; zz[n]=0.0;} zz[bi0]=Low[bi0]; zzL[bi0]=Low[bi0]; zzH[bi0]=0.0;}

          if (ti<Time[1]) i=2;

         }
//====================================================================================================
      //---- Alert
      time_frame=Period();
      if(time_frame==1) { Timeframe = "M1"; }
      if(time_frame==5) { Timeframe = "M5"; }
      if(time_frame==15) { Timeframe = "M15"; }
      if(time_frame==30) { Timeframe = "M30"; }
      if(time_frame==60) { Timeframe = "H1"; }
      if(time_frame==240) { Timeframe = "H4"; }
      if(time_frame==1440) { Timeframe = "D1"; }
      if(time_frame==10080) { Timeframe = "W1"; }
      if(time_frame==43200) { Timeframe = "MN"; }
      
      if(zzL[i] != 0 && down ==0)
      {
       if (SignalAlert) Alert("Swing ZZ Down - ",Symbol()," ",Timeframe," at ",TimeToStr(TimeCurrent(),TIME_SECONDS));
       if(SendAlertEmail) SendMail("Swing ZZ","Swing ZZ Down - "+Symbol()+" "+Timeframe+" at "+TimeToStr(TimeCurrent(),TIME_SECONDS)+" (server time)");
       up = 0;
       down = 1;
      }
      if(zzH[i] != 0 && up ==0)
      {
       if (SignalAlert) Alert("Swing ZZ Up - ",Symbol()," ",Timeframe," at ",TimeToStr(TimeCurrent(),TIME_SECONDS));
       if(SendAlertEmail) SendMail("Swing ZZ","Swing ZZ Up - "+Symbol()+" "+Timeframe+" at "+TimeToStr(TimeCurrent(),TIME_SECONDS)+" (server time)");
       up = 1;
       down = 0;
      }
      
      
      
      
      
      
     }
//--------------------------------------------
   
return(0);
}
//+------------------------------------------------------------------+