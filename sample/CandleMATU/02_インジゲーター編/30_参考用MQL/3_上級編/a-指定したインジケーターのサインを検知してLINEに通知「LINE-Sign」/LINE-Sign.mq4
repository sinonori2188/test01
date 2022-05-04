//+------------------------------------------------------------------+
//|                                                    LINE-Sign.mq4 |
//|                                              Copyright 2019 ands |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "Copyright 2019 ands"
#property link      ""
#property version   "1.00"
#property strict

input string message = "Long Sign"; // メッセージ本文(必須)現在足上サイン
input string message2 = "Short Sign"; // メッセージ本文(必須)現在足下サイン
input string message3 = "Long Sign OK"; // メッセージ本文(必須)1本前足上サイン
input string message4 = "Short Sign OK"; // メッセージ本文(必須)1本前足下サイン
input string token=""; // LINEトークン
string api_url="https://notify-api.line.me/api/notify"; // apiのurl

extern string indiname = "ここを変更してください";//インジケーター名(入力必須)
extern bool nowbar = true;//現在足検知
extern int buf1 = 0;//サイン番号1[上向き]
extern int buf2 = 1;//サイン番号2[下向き]
extern bool lastbar = false;//1本前足検知
extern int buf3 = 0;//サイン番号3[上向き]
extern int buf4 = 1;//サイン番号4[下向き]

string headers;
char post[],result[];

int OnInit()
  {
flag1 = false;
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
//---

  }

int NowBars, NowBars2=0;
int Adjusted_Slippage=0;
datetime Bar_Time=0;
bool Closed,flag1,flag2,flag3,flag4=false;
bool test = false;
datetime time0, time1;
bool Certification = false;
double signup, signdn,signup2, signdn2;


int AdjustSlippage(string Currency,int Slippage_Pips)
  {
   int Calculated_Slippage=0;

   int Symbol_Digits=(int)MarketInfo(Currency,MODE_DIGITS);

   if(Symbol_Digits==2 || Symbol_Digits==4)
     {
      Calculated_Slippage=Slippage_Pips;
     }
   else if(Symbol_Digits==3 || Symbol_Digits==5)
     {
      Calculated_Slippage=Slippage_Pips*10;
     }

   return(Calculated_Slippage);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   signup = iCustom(Symbol(),0,indiname, buf1, 0);//上サイン（今足）
   signdn = iCustom(Symbol(),0,indiname, buf2, 0);//下サイン（今足）
   signup2 = iCustom(Symbol(),0,indiname, buf3, 1);//上サイン(1本前)
   signdn2 = iCustom(Symbol(),0,indiname, buf4, 1);//下サイン(1本前)  
     
    
if(nowbar == true && signup != EMPTY_VALUE && flag1 == false){//リアルタイム上サインを検知したとき

   headers="Authorization: Bearer "+token+"\r\n";
   headers+="Content-Type: application/x-www-form-urlencoded\r\n";
   ArrayResize(post,StringToCharArray("message="+Symbol()+" M"+Period()+message,post,0,WHOLE_ARRAY,CP_UTF8)-1);
   int rest=WebRequest("POST",api_url,headers,5000,post,result,headers); //WebRequestでLINE Nitifyサービスへ(転用する際にはここのブロックをそのままコピペすればOK)
   flag1 = true;  
}
if(nowbar == true && signdn != EMPTY_VALUE && flag1 == false){//リアルタイム下サインしたとき

   headers="Authorization: Bearer "+token+"\r\n";
   headers+="Content-Type: application/x-www-form-urlencoded\r\n";
   ArrayResize(post,StringToCharArray("message="+Symbol()+" M"+Period()+message2,post,0,WHOLE_ARRAY,CP_UTF8)-1);
   int rest=WebRequest("POST",api_url,headers,5000,post,result,headers); 
   flag1 = true;  
   
}


//---
int limit = Bars - IndicatorCounted()-1;
for(int i = limit; i >= 0; i--){
if(i == 1 && NowBars < Bars){
  NowBars = Bars;      
  flag1 = false;
if(lastbar == true  && signup2 != EMPTY_VALUE && signup2 != 0 && flag1 == false){//確定足上サインしたとき

   headers="Authorization: Bearer "+token+"\r\n";
   headers+="Content-Type: application/x-www-form-urlencoded\r\n";
   ArrayResize(post,StringToCharArray("message="+Symbol()+" M"+Period()+message3,post,0,WHOLE_ARRAY,CP_UTF8)-1);
   int rest=WebRequest("POST",api_url,headers,5000,post,result,headers); 
   flag1 = true;  
   
}
if(lastbar == true  && signdn2 != EMPTY_VALUE && signup2 != 0 && flag1 == false){//確定足下サインしたとき

   headers="Authorization: Bearer "+token+"\r\n";
   headers+="Content-Type: application/x-www-form-urlencoded\r\n";
   ArrayResize(post,StringToCharArray("message="+Symbol()+" M"+Period()+message4,post,0,WHOLE_ARRAY,CP_UTF8)-1);
   int rest=WebRequest("POST",api_url,headers,5000,post,result,headers);
   flag1 = true;   
   
}
}
}

}//---OnTick