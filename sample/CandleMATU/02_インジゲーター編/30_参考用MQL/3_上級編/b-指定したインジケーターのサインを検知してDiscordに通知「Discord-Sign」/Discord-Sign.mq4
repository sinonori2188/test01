//+------------------------------------------------------------------+
//|                                                 Discord-Sign.mq4 |
//|                                              Copyright 2020 ands |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "Copyright 2020 ands"
#property link      ""
#property version   "1.00"
#property strict


input string DMessage = "Long Sign"; // メッセージ本文(必須)現在足上サイン
input string DMessage2 = "Short Sign"; // メッセージ本文(必須)現在足下サイン
input string DMessage3 = "Long Sign OK"; // メッセージ本文(必須)1本前足上サイン
input string DMessage4 = "Short Sign OK"; // メッセージ本文(必須)1本前足下サイン

extern string indiname = "ここを変更してください";//インジケーター名(入力必須)
extern bool nowbar = true;//現在足検知
extern int buf1 = 0;//サイン番号1[上向き]
extern int buf2 = 1;//サイン番号2[下向き]
extern bool lastbar = false;//1本前足検知
extern int buf3 = 0;//サイン番号3[上向き]
extern int buf4 = 1;//サイン番号4[下向き]
extern string WebhookURL = "";//ウェブフックURL
string headers;
char post[],result[];

int a;


int OnInit()
  {
a++;
flag1 = false;
AlertDiscord(WebhookURL, "起動");//起動時Discordへ起動通知

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

bool AlertDiscord(const string  url, const string text)//56から75行目までコピペでOK（ここによりAlertDiscordが使用可能となる）
{
    int status_code;
    string headers;
    char data[];
    char result[];

    if (IsTesting()) {
        return(false);
    }

    StringToCharArray("content=" + text, data, 0, WHOLE_ARRAY, CP_UTF8);
    status_code = WebRequest("POST", url, NULL, NULL, 5000, data, 0, result, headers);

    if (status_code == -1) {
        Print(GetLastError());
        return(false);
    }
    return(true);
}

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
     
Comment(a);   
if(nowbar == true && signup != EMPTY_VALUE && signup != 0){//リアルタイム上サインを検知したとき
if(flag1 == false){AlertDiscord(WebhookURL,Symbol()+" "+DMessage);flag1 = true;}//Discordへ通知（通知したいタイミングへコピペでOK）
}
if(nowbar == true && signdn != EMPTY_VALUE && signdn != 0){//リアルタイム下サインしたとき
if(flag1 == false){AlertDiscord(WebhookURL,Symbol()+" "+DMessage2);flag1 = true;}//Discordへ通知
}


//---
int limit = Bars - IndicatorCounted()-1;

for(int i = limit; i >= 0; i--){
if(i == 1 && NowBars < Bars){
  NowBars = Bars;      
  flag1 = false;

if(lastbar == true  && signup2 != EMPTY_VALUE && signup2 != 0){//確定足上サインしたとき
if(flag1 == false){AlertDiscord(WebhookURL,Symbol()+" "+DMessage3);flag1 = true;}//Discordへ通知   
   
}
if(lastbar == true  && signdn2 != EMPTY_VALUE && signup2 != 0){//確定足下サインしたとき
if(flag1 == false){AlertDiscord(WebhookURL,Symbol()+" "+DMessage4);flag1 = true;}//Discordへ通知  
}
}
}

}//---OnTick