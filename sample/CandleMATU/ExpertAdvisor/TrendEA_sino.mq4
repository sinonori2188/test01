//+------------------------------------------------------------------+
//|                                                       TrendEA.mq4
//|                                               Copyright 2018 ands
//+------------------------------------------------------------------+
#property copyright "Copyright 2020 ands"
#property link      ""
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| ライブラリ                                                       |
//+------------------------------------------------------------------+
#include <stderror.mqh>
#include <stdlib.mqh>
#include <WinUser32.mqh>
#include <MeFunc/ComLog.mqh>

//+------------------------------------------------------------------+
//| 関数名：AdjustSlippage
//| 機　能：調整後スリッページの取得
//| 詳　細：通貨ペアごとの桁数の違いで発生するスリッページ値を調整
//| 引　数：① string Currency     ：通貨ペア名
//|　　　　 ② int    SlippagePips ：その通貨ペアの小数点以下の桁数
//| 戻り値：調整後スリッページ値
//+------------------------------------------------------------------+
int AdjustSlippage(string Currency,int SlippagePips)
{
    //初期値
    int Calculated_SlippagePips=0;
    
    //市場情報の取得(通貨ペアの小数点以下情報)
    int Symbol_Digits=(int)MarketInfo(Currency,     //通貨ペア
                                      MODE_DIGITS   //その通貨ペアの小数点以下の桁数
                                      );

    if(Symbol_Digits == 2 || Symbol_Digits == 4 ){
        Calculated_SlippagePips = Slippage_Pips;
    }
    else if(Symbol_Digits == 3 || Symbol_Digits==5){
        Calculated_SlippagePips = Slippage_Pips * 10;
    }

    return(Calculated_SlippagePips);

}

  
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //通貨ペアを指定して調整後のスリッページを取得
   Adjusted_Slippage = AdjustSlippage(Symbol(),
                                      extPermitSlippage
                                      );

   return(INIT_SUCCEEDED);

}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //終了時にコメントを消す。
   Comment("");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

extern string   extNote0 = "";          // ----------基本設定----------
extern int      extMagicNum = 5555;     // マジックナンバー
extern double   extLots = 0.01;         // ロット数
extern int      extPermitSlippage = 3;  // 許容スリッページ


int  NowBars = 0;
int  Ticket,totalpos = 0;
int  Adjusted_Slippage = 0;
bool Closed = false;

double gmma0, gmma1, gmma2, gmma3, gmma4, gmma5, gmma6, gmma7, gmma8, gmma9, gmma10, gmma11;
double gmma0a, gmma1a, gmma2a, gmma3a, gmma4a, gmma5a, gmma6a, gmma7a, gmma8a, gmma9a, gmma10a, gmma11a;
double gmma12, gmma13;

//+------------------------------------------------------------------+
//| Timer関数(ティックごとではなく秒ごとに通る関数)                    |
//+------------------------------------------------------------------+
void OnTimer()
{
}

//+------------------------------------------------------------------+
//| エキスパートティック関数                                          |
//| OnTick関数はstart関数と同じでtickごとに通る。                     |
//+------------------------------------------------------------------+
void OnTick()
{
    //iCustom関数でGMMA(インジケーター)を呼び出す。※必ず名前が一致していること。
    //インジケーターの0～11番目のバッファーのロウソク足１本前の値をそれぞれの変数に保存。
    gmma0 = iCustom(Symbol(),0,"GMMA", 0, 1);
    gmma1 = iCustom(Symbol(),0,"GMMA", 1, 1);
    gmma2 = iCustom(Symbol(),0,"GMMA", 2, 1);
    gmma3 = iCustom(Symbol(),0,"GMMA", 3, 1);
    gmma4 = iCustom(Symbol(),0,"GMMA", 4, 1);
    gmma5 = iCustom(Symbol(),0,"GMMA", 5, 1);
    gmma6 = iCustom(Symbol(),0,"GMMA", 6, 1);
    gmma7 = iCustom(Symbol(),0,"GMMA", 7, 1);
    gmma8 = iCustom(Symbol(),0,"GMMA", 8, 1);
    gmma9 = iCustom(Symbol(),0,"GMMA", 9, 1);
    gmma10 = iCustom(Symbol(),0,"GMMA", 10, 1);
    gmma11 = iCustom(Symbol(),0,"GMMA", 11, 1);
    
    LogWrite("gmma0：" + (string)gmma0 + "\t" + "gmma1：" + (string)gmma1);
        
    //インジケーターの0～11番目のバッファーのロウソク足2本前の値をそれぞれの変数に保存
    gmma0a = iCustom(Symbol(),0,"GMMA", 0, 2);
    gmma1a = iCustom(Symbol(),0,"GMMA", 1, 2);
    gmma2a = iCustom(Symbol(),0,"GMMA", 2, 2);
    gmma3a = iCustom(Symbol(),0,"GMMA", 3, 2);
    gmma4a = iCustom(Symbol(),0,"GMMA", 4, 2);
    gmma5a = iCustom(Symbol(),0,"GMMA", 5, 2);
    gmma6a = iCustom(Symbol(),0,"GMMA", 6, 2);
    gmma7a = iCustom(Symbol(),0,"GMMA", 7, 2);
    gmma8a = iCustom(Symbol(),0,"GMMA", 8, 2);
    gmma9a = iCustom(Symbol(),0,"GMMA", 9, 2);
    gmma10a = iCustom(Symbol(),0,"GMMA", 10, 2);
    gmma11a = iCustom(Symbol(),0,"GMMA", 11, 2);    
    
    //別の条件で使いたいので、0番目と６番目のバッファーを最新の足の値のみ取得し。
    gmma12 = iCustom(Symbol(),0,"GMMA", 0, 0);    
    gmma13 = iCustom(Symbol(),0,"GMMA", 6, 0);

    //*----- EAはクローズ処理からコーディング -----*
    // ドテン形式(決済と新規を同時に行う形式)のEAの場合、
    // オープンしたばかりのポジションをすぐに決済しまうことを防ぐため。
    if(gmma0 <= gmma6 && gmma12 > gmma13){    
 
        //OrdersTotal()：ポジション総数の取得
        //最後に-1しているのはポジションが１つあればOrdersTotal()は１だが、要素は０番目となるため。
        for(int i = OrdersTotal() - 1; i >= 0; i--){
    
            //OrderSelect()で、ポジションを選択してから処理を行う。
            //iはポジション数分for文で回るため、全ポジションを順番に選択。
            if(OrderSelect(i,               // 注文チケットインデックス 
                           SELECT_BY_POS,   // 選択タイプ(SELECT_BY_POS : 注文プールのインデックスをindexに指定)
                           MODE_TRADES      // 注文プール選択(MODE_TRADE：エントリー中・保留中の注文)
                           ) == true
                           ){
    
                //実際に選択したポジションに対する処理。
                //ここから先のOrder＊＊というのはOrderSelect()関数で選択されていないと機能しないため注意。
                if(OrderSymbol() == Symbol() && OrderMagicNumber() == extMagicNum){
                    // 現在選択中の注文の注文タイプ
                    if(OrderType() == OP_SELL){
                        //ここのClosedという変数はなくても良いが、厳密にはこのようにフラグを立ててクローズ処理をするのが良い。
                        Closed = OrderClose(OrderTicket(),          // 決済するチケット番号
                                            OrderLots(),            // 決済するロット量
                                            Ask,                    // 決済価格                
                                            Adjusted_Slippage,      // スリップページの上限[分解能：0.1pips]
                                            White                   // チャート上の決済矢印の色
                                            );   
                        //ここでのNowBarsの処理でこの後の内容に影響して、現在の足ではもう新規ポジションは取らないようにしています。（次の足になるまで）
                        NowBars = Bars;
                    }
                }
            }
        }
    }
    
    if(gmma0 >= gmma6 && gmma12 < gmma13){  
        for(int i = OrdersTotal() - 1; i >= 0; i--){
            if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
                if(OrderSymbol() == Symbol() && OrderMagicNumber() == extMagicNum){   
                    if(OrderType() == OP_BUY){  
                        Closed = OrderClose(OrderTicket(),
                                            OrderLots(), 
                                            Bid, 
                                            Adjusted_Slippage,
                                            White);       
                        NowBars = Bars;             
                    }
                }
            }
        }
    }


    //ここからがオープン処理になります。
    if(NowBars < Bars){
    //NowBars = Bars;   

    //エントリー中の注文数と保留中注文数の合計を取得
    totalpos=OrdersTotal();

//+------------------------------------------------------------------+   
      if(totalpos == 0){
      //売り注文(全部の線が下向き)
         if(gmma6 > gmma0 && gmma6 > gmma1 && gmma6 > gmma2 && gmma6 > gmma3 && gmma6 > gmma4 && gmma6 > gmma5 &&
            gmma7 > gmma0 && gmma7 > gmma1 && gmma7 > gmma2 && gmma7 > gmma3 && gmma7 > gmma4 && gmma7 > gmma5 &&
            gmma8 > gmma0 && gmma8 > gmma1 && gmma8 > gmma2 && gmma8 > gmma3 && gmma8 > gmma4 && gmma8 > gmma5 &&
            gmma9 > gmma0 && gmma9 > gmma1 && gmma9 > gmma2 && gmma9 > gmma3 && gmma9 > gmma4 && gmma9 > gmma5 &&
            gmma10 > gmma0 && gmma10 > gmma1 && gmma10 > gmma2 && gmma10 > gmma3 && gmma10 > gmma4 && gmma10 > gmma5 &&
            gmma11 > gmma0 && gmma11 > gmma1 && gmma11 > gmma2 && gmma11 > gmma3 && gmma11 > gmma4 && gmma11 > gmma5 &&
             
            gmma0 < gmma0a && gmma1 < gmma1a && gmma2 < gmma2a && gmma3 < gmma3a && gmma4 < gmma4a && gmma5 < gmma5a && 
            gmma6 < gmma6a && gmma7 < gmma7a && gmma8 < gmma8a && gmma9 < gmma9a && gmma10 < gmma10a && gmma11 < gmma11a           
           ){
            //新規Shortポジションを取得
            Ticket=OrderSend(NULL,              // 通貨ペア名
                             OP_SELL,           // 注文タイプ
                             extLots,           // ロット数
                             Bid,               // 注文価格
                             Adjusted_Slippage, // 許容するスリップページ
                             0,                 // ストップロス価格
                             0,                 // リミット価格
                             NULL,              // 注文コメント
                             extMagicNum,       // マジックナンバー(識別用)
                             0,                 // 注文の有効期限(指値注文のみ)
                             Aqua               // チャート上の注文矢印の色
                             );

            
            
           }

        //買い注文(全部の線が上向き)
        if(gmma6 < gmma0 && gmma6 < gmma1 && gmma6 < gmma2 && gmma6 < gmma3 && gmma6 < gmma4 && gmma6 < gmma5 &&
           gmma7 < gmma0 && gmma7 < gmma1 && gmma7 < gmma2 && gmma7 < gmma3 && gmma7 < gmma4 && gmma7 < gmma5 &&
           gmma8 < gmma0 && gmma8 < gmma1 && gmma8 < gmma2 && gmma8 < gmma3 && gmma8 < gmma4 && gmma8 < gmma5 &&
           gmma9 < gmma0 && gmma9 < gmma1 && gmma9 < gmma2 && gmma9 < gmma3 && gmma9 < gmma4 && gmma9 < gmma5 &&
          
           gmma10 < gmma0 && gmma10 < gmma1 && gmma10 < gmma2 && gmma10 < gmma3 && gmma10 < gmma4 && gmma10 < gmma5 &&
           gmma11 < gmma0 && gmma11 < gmma1 && gmma11 < gmma2 && gmma11 < gmma3 && gmma11 < gmma4 && gmma11 < gmma5 &&
             
           gmma0 > gmma0a && gmma1 > gmma1a && gmma2 > gmma2a && gmma3 > gmma3a && gmma4 > gmma4a && gmma5 > gmma5a && 
           gmma6 > gmma6a && gmma7 > gmma7a && gmma8 > gmma8a && gmma9 > gmma9a && gmma10 > gmma10a && gmma11 > gmma11a       
          ){
            //新規Longポジションを持つ処理
            Ticket=OrderSend(NULL,              // 通貨ペア名
                             OP_BUY,            // 注文タイプ
                             extLots,           // ロット数
                             Ask,               // 注文価格
                             Adjusted_Slippage, // 許容するスリップページ
                             0,                 // ストップロス価格
                             0,                 // リミット価格
                             NULL,              // 注文コメント
                             extMagicNum,       // マジックナンバー(識別用)
                             0,                 // 注文の有効期限(指値注文のみ)
                             White              // チャート上の注文矢印の色
                             );
            }
        }

    }//---NowBars

}//---OnTick
//+------------------------------------------------------------------+

