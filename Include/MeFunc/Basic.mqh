//+------------------------------------------------------------------+
//|                                                        Basic.mqh |
//|                                     Copyright (c) 2015, りゅーき |
//|                                            https://autofx100.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2015, りゅーき"
#property link      "https://autofx100.com/"
#property version   "1.00"

//+------------------------------------------------------------------+
//|【関数】1pips当たりの価格単位を計算する                           |
//|                                                                  |
//|【引数】 IN OUT  引数名             説明                          |
//|        --------------------------------------------------------- |
//|         ○      aSymbol            通貨ペア                      |
//|                                                                  |
//|【戻値】1pips当たりの価格単位                                     |
//|                                                                  |
//|【備考】なし                                                      |
//+------------------------------------------------------------------+
double currencyUnitPerPips(string aSymbol)
{
  // 通貨ペアに対応する小数点数を取得
  double digits = MarketInfo(aSymbol, MODE_DIGITS);

  // 通貨ペアに対応するポイント（最小価格単位）を取得
  // 3桁/5桁のFX業者の場合、0.001/0.00001
  // 2桁/4桁のFX業者の場合、0.01/0.0001
  double point = MarketInfo(aSymbol, MODE_POINT);

  // 価格単位の初期化
  double currencyUnit = 0.0;

  // 3桁/5桁のFX業者の場合
  if(digits == 3.0 || digits == 5.0){
    currencyUnit = point * 10.0;
  // 2桁/4桁のFX業者の場合
  }else{
    currencyUnit = point;
  }

  return(currencyUnit);
}

//+------------------------------------------------------------------+
//|【関数】ポイント換算した許容スリッページを計算する                |
//|                                                                  |
//|【引数】 IN OUT  引数名             説明                          |
//|        --------------------------------------------------------- |
//|         ○      aSymbol            通貨ペア                      |
//|         ○      aSlippagePips      許容スリッページ（pips）      |
//|                                                                  |
//|【戻値】許容スリッページ（ポイント）                              |
//|                                                                  |
//|【備考】なし                                                      |
//+------------------------------------------------------------------+
int getSlippage(string aSymbol, int aSlippagePips)
{
  double digits = MarketInfo(aSymbol, MODE_DIGITS);
  int slippage = 0;

  // 3桁/5桁業者の場合
  if(digits == 3.0 || digits == 5.0){
    slippage = aSlippagePips * 10;
  // 2桁/4桁業者の場合
  }else{
    slippage = aSlippagePips;
  }

  return(slippage);
}
