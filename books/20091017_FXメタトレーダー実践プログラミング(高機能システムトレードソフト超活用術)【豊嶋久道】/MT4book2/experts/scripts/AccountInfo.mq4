//+------------------------------------------------------------------+
//|                                                  AccountInfo.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// スタート関数
int start()
{
   int level=AccountStopoutLevel();
   if(AccountStopoutMode()==0) Print("StopOutLevel = ", level, "%");
   else Print("StopOutLevel = ", level, " ", AccountCurrency());
   Print("AccountBalance = ", AccountBalance( ));
   Print("AccountEquity = ", AccountEquity( ));
   Print("AccountFreeMargin = ", AccountFreeMargin( ));
   Print("AccountMargin = ", AccountMargin( ));
   Print("AccountProfit = ", AccountProfit( ));
   Print("AccountCredit = ", AccountCredit( ));
   Print("AccountLeverage = ", AccountLeverage( ));
   Print("AccountName = ", AccountName( ));
   Print("AccountNumber = ", AccountNumber( ));
   Print("AccountCurency = ", AccountCurrency( ));
   Print("AccountServer = ", AccountServer( ));
   Print("AccountCompany = ", AccountCompany( ));

   return(0);
}

