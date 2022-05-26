//+------------------------------------------------------------------+
//|                                                 RSI_Cross_EA.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property strict
#property indicator_chart_window             // 指標をメインウインドウに表示する

// 引数
input int RSI_Period_Short = 14;             // 短期RSI計算期間
input int RSI_Period_Long  = 32;             // 長期RSI計算期間
extern int Lots = 0.1;                       // Lots
extern int Slippage = 3;                     // slippage

// マジックナンバー
#define MAGIC 20220522


//+------------------------------------------------------------------+
//| OnInit(初期化)イベント
//+------------------------------------------------------------------+
int OnInit()
{
    if ( IsDemo() == false ) {              // デモ口座以外の場合
        Print("デモ口座でのみ動作します");
        return INIT_FAILED;                 // 処理終了
    }
    return( INIT_SUCCEEDED );               // 戻り値：初期化成功
}

//+------------------------------------------------------------------+
//| OnCalculate(tick受信)イベント
//+------------------------------------------------------------------+
void OnTick()
{

    // 短期RSIテクニカルインジケータ算出
    double  RSI_Short0 = iRSI(NULL,             // 通貨ペア
                            PERIOD_CURRENT,   // 時間軸(現在チャートの時間軸:0)
                            RSI_Period_Short, // 計算期間
                            PRICE_CLOSE,      // 適用価格
                            1            // シフト
                            );
    double  RSI_Short1 = iRSI(NULL,             // 通貨ペア
                            PERIOD_CURRENT,   // 時間軸(現在チャートの時間軸:0)
                            RSI_Period_Short, // 計算期間
                            PRICE_CLOSE,      // 適用価格
                            2          // シフト
                            );
    // 長期RSIテクニカルインジケータ算出
    double  RSI_Long0 = iRSI(NULL,              // 通貨ペア
                           PERIOD_CURRENT,    // 時間軸(現在チャートの時間軸:0)
                           RSI_Period_Long,   // 計算期間
                           PRICE_CLOSE,       // 適用価格
                           1             // シフト
                           );
    double  RSI_Long1 = iRSI(NULL,              // 通貨ペア
                           PERIOD_CURRENT,    // 時間軸(現在チャートの時間軸:0)
                           RSI_Period_Long,   // 計算期間
                           PRICE_CLOSE,       // 適用価格
                           2           // シフト
                           );

    //----- 短期RSIと長期RSIがクロスした時に矢印を出す -----//
    //ゴールデンクロスした時は
    if(RSI_Short1 < RSI_Long1 && RSI_Short0 >= RSI_Long0){
        //決済と建玉
        ClosePositions();
        OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,"",MAGIC,0,Blue);
    }
    //デッドクロスした時は
    if(RSI_Short1 > RSI_Long1 && RSI_Short0 <= RSI_Long0){
        //決済と建玉
        ClosePositions();
        OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,"",MAGIC,0,Red);
    }
}

//+------------------------------------------------------------------+
//| ポジションを決済する                                                |
//+------------------------------------------------------------------+
void ClosePositions()
{
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) break;
      //オーダータイプのチェック
      if(OrderType()==OP_BUY)
      {
         OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,White);
         break;
      }
      if(OrderType()==OP_SELL)
      {
         OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,White);
         break;
      }
   }
}