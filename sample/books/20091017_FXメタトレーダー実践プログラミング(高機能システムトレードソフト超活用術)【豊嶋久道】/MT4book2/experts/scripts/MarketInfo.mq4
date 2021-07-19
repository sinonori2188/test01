//+------------------------------------------------------------------+
//|                                                   MarketInfo.mq4 |
//|                                   Copyright (c) 2009, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009, Toyolab FX"
#property link      "http://forex.toyolab.com"

// スタート関数
int start()
{
   Print("MODE_MAXLOT : 最大ロット数 = "+MarketInfo(Symbol(), MODE_MAXLOT));
   Print("MODE_LOTSTEP : ロットの最小変化幅 = "+MarketInfo(Symbol(), MODE_LOTSTEP));
   Print("MODE_MINLOT : 最小ロット数 = "+MarketInfo(Symbol(), MODE_MINLOT));
   Print("MODE_SWAPSHORT : 1ロットあたりの売りポジションのスワップ値(口座通貨) = "+MarketInfo(Symbol(), MODE_SWAPSHORT));
   Print("MODE_SWAPLONG : 1ロットあたりの買いポジションのスワップ値(口座通貨) = "+MarketInfo(Symbol(), MODE_SWAPLONG));
   Print("MODE_TICKVALUE : 1ロットあたりの1pipの価格(口座通貨) = "+MarketInfo(Symbol(), MODE_TICKVALUE));
   Print("MODE_LOTSIZE : 1ロットのサイズ(通貨単位) = "+MarketInfo(Symbol(), MODE_LOTSIZE));
   Print("MODE_STOPLEVEL : 指値・逆指値の値幅(pips) = "+MarketInfo(Symbol(), MODE_STOPLEVEL));
   Print("MODE_SPREAD : スプレッド(pips) = "+MarketInfo(Symbol(), MODE_SPREAD));
   Print("MODE_TIME : 最新のtick時刻 = "+TimeToStr(MarketInfo(Symbol(), MODE_TIME), TIME_DATE|TIME_SECONDS));
   Print("MODE_HIGH : 当日の高値 = "+MarketInfo(Symbol(), MODE_HIGH));
   Print("MODE_LOW : 当日の安値 = "+MarketInfo(Symbol(), MODE_LOW));

   return(0);
}

