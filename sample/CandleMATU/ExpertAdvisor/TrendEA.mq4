//+------------------------------------------------------------------+
//|                           TrendEA.mq4 
//|                           Copyright 2018 ands                          
//+------------------------------------------------------------------+

#property copyright "Copyright 2018 ands"
#property link      ""
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//AdjustSlippageという関数を自分で作ります。関数というのは自分で作ることができるのです。
//関数のメリットとしてはその中の処理を次からいちいち書かなくてよく、この関数名を書くだけで同様の内容を挿入したことになるため、
//コードが簡潔化されます。もちろん、関数化せずに毎回同じ処理を書いてもいいのですが、
//普通は同じ処理を繰り返し出す場合は一番外側に関数として事前に用意しておきます。
//()の中は。その関数の中身をその先でいろいろ変えるために置き換え可能な変数で設定しています。
//iClose(NULL,0,i)も同じですね。最初にiCloseを定義した時に()の中を実際は(string, int, int)で定義しているんです。
//それぞれの型を指定してあげることで、その位置に入る変数を指定します。
//下記の場合だと(string型, int型)という要素が入るということですね。その要素名は後で決めるので今は仮の名前で入れています。

int AdjustSlippage(string Currency,int Slippage_Pips)
  {
   //ここから、この関数での処理を書きます。
   //この処理の中で通貨ペアごとの桁数の違いでのスリッページ値の調整を行います。
   int Calculated_Slippage=0;

   //(int)というのは、強制的に型をその形に変換することです。
   //もちろんそのあとの要素が正しくないといけませんし通常は書かなくて大丈夫です。
   //MarketInfo()で指定した市場情報を取得できます。
   //今回は(通貨ペア名, DIGITS)というのを取得します。
   //Currencyには後から通貨ペア名を入れ、DIGITSというのはその通貨ペアの小数点以下の桁数になります。
   int Symbol_Digits=(int)MarketInfo(Currency,MODE_DIGITS);

   if(Symbol_Digits==2 || Symbol_Digits==4)
     {
      Calculated_Slippage=Slippage_Pips;
     }
    
    //elseというのはifとセットで使われるものでif文が通らなければ、ということになります。
    //if分とelse文は１度にどちらかしか通りません。どちらかを通るともう一方は無視されます。
   else if(Symbol_Digits==3 || Symbol_Digits==5)
     {
      Calculated_Slippage=Slippage_Pips*10;
     }

   return(Calculated_Slippage);
  }
  //上記関数はEA作成の際のスリッページ設定の際のテンプレートになります。
  

int OnInit()
  {
//---
   //最初に、上記で作ったスリッページ関数を使い、今の通貨ペアを指定したスリッページで設定します。
   //上記関数での()の中を下のように変更すると、関数の中の該当箇所が下記の変数に置き換わるようになっています。
   Adjusted_Slippage=AdjustSlippage(Symbol(),Slippage);   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   //もしコード中でコメント表示をしていたら、削除の際にコメントも消しておきます。
   Comment("");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

extern string Note0="";//----------基本設定----------
extern int  magicnum = 5555;//マジックナンバー
extern double Lots=0.01;  // ロット数
extern int Slippage=3;  // 許容スリッページ


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int NowBars=0;
int Ticket,totalpos=0;
int Adjusted_Slippage=0;
bool Closed=false;

double gmma0, gmma1, gmma2, gmma3, gmma4, gmma5, gmma6, gmma7, gmma8, gmma9, gmma10, gmma11;
double gmma0a, gmma1a, gmma2a, gmma3a, gmma4a, gmma5a, gmma6a, gmma7a, gmma8a, gmma9a, gmma10a, gmma11a;
double gmma12, gmma13;

//OnTimerはティックごとではなく秒ごとに通る関数になります。今は使いません。
void OnTimer(){

}

//OnTick関数はstart関数と同じでtickごとに通ります。
//どちらでも構いませんが、ぱっと見、インジケーターもEAもmq4なので、中身を見たときにわかりやすいように使い分けています。
void OnTick()
  {
//---
    //iCustom関数でGMMAというインジケーターを呼び出します。必ず名前が一致していなければいけません。
    //そのインジケーターの0~11番目のバッファーのロウソク足１本前の値をそれぞれの変数に保存しています。
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
    
    //同様に、２本前の値を別の変数に保存します。
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
    
    //こちらは少し条件で使いたいので、0番目と６番目のバッファーを最新の足の値のみ取得しています。
    gmma12 = iCustom(Symbol(),0,"GMMA", 0, 0);    
    gmma13 = iCustom(Symbol(),0,"GMMA", 6, 0);
    

//EAの処理は基本的にはクローズ処理から先に書きます。
//理由としてはドテン形式(決済と新規を同時に行う形式)のEAの場合はクローズしたすぐ後にオープン処理を書かないと
//そのオープンしたばかりのポジションがすぐに決済されてしまう可能性が出てきます。    
if(gmma0 <= gmma6 && gmma12 > gmma13){    
    //OrdersTotal()というのはEA専用の関数で現在保有しているポジション数の総数を取得します。
    //最後に-1しているのはポジションが１つあればOrdersTotal()は１なのですが、ポジション番号的には０番目となるので番目に合わせています。
    //そして、iを最初は総数にセットッしてそこから０になるまで１つずつ減らしてfor文で繰り返していきます。
    //具体的には、例えばポジションが１０個あったら、９番目から０番目までの１０回＝全ポジションに関してチェックしていくということになります。
    //ここではまだポジションのチェックまでしていません。ここでのiをチェックに使っていきます。あくまでポジション数を取得した段階ですね。
    for(int i = OrdersTotal() - 1; i >= 0; i--){
             //EAのプログラムではまず何かさせたいポジションを選択してあげてそのポジションを指定して処理を書かなければいけません。
             //その選択作業を行うのがOrderSelect()関数になります。
             //()の中に指定する要素は２つ、何番目のポジションかと、保有中のポジションなのか、クローズしたポジションなのか、です。
             //iはポジション数分forで回ってきます。なので、全ポジションを順番に選択していく形になります。
             if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
                 //この中で実際に選択したポジションに対してどんな処理を行うかを書いていきます。
                 //ここから先のOrder＊＊というのはOrderSelect()関数で選択されていないと機能しませんので注意してください。
                 //その選択したポジションの情報をそれぞれ読み取っていきます。
                 if(OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum){     
                     if(OrderType() == OP_SELL){
                        //ここのClosedという変数はなくてもいいのですが、厳密にはこのようにフラグを立ててクローズ処理をしてあげる形となります。
                        //OrderClose関数の中身の順番はこのまま固定なので覚えていたほうがいいでしょう。
                         Closed = OrderClose(OrderTicket(),OrderLots(), Ask, Adjusted_Slippage,White);   
                         NowBars = Bars; 
                         //ここでのNowBarsの処理でこの後の内容に影響して、現在の足ではもう新規ポジションは取らないようにしています。（次の足になるまで）
                     }                
                 }
             }
    }
}

if(gmma0 >= gmma6 && gmma12 < gmma13){  
    for(int i = OrdersTotal() - 1; i >= 0; i--){
             if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
                 if(OrderSymbol() == Symbol() && OrderMagicNumber() == magicnum){   
                     if(OrderType() == OP_BUY){  
                         Closed = OrderClose(OrderTicket(),OrderLots(), Bid, Adjusted_Slippage,White);       
                         NowBars = Bars;             
                     }
                 }
             }
    }
}


//ここからがオープン処理になります。
if(NowBars < Bars){
   //NowBars = Bars;   
           
   totalpos=OrdersTotal();
        
//+------------------------------------------------------------------+   
      if(totalpos == 0){
         if(gmma6 > gmma0 && gmma6 > gmma1 && gmma6 > gmma2 && gmma6 > gmma3 && gmma6 > gmma4 && gmma6 > gmma5 &&
            gmma7 > gmma0 && gmma7 > gmma1 && gmma7 > gmma2 && gmma7 > gmma3 && gmma7 > gmma4 && gmma7 > gmma5 &&
            gmma8 > gmma0 && gmma8 > gmma1 && gmma8 > gmma2 && gmma8 > gmma3 && gmma8 > gmma4 && gmma8 > gmma5 &&
            gmma9 > gmma0 && gmma9 > gmma1 && gmma9 > gmma2 && gmma9 > gmma3 && gmma9 > gmma4 && gmma9 > gmma5 &&
            gmma10 > gmma0 && gmma10 > gmma1 && gmma10 > gmma2 && gmma10 > gmma3 && gmma10 > gmma4 && gmma10 > gmma5 &&
            gmma11 > gmma0 && gmma11 > gmma1 && gmma11 > gmma2 && gmma11 > gmma3 && gmma11 > gmma4 && gmma11 > gmma5 &&
             
            gmma0 < gmma0a && gmma1 < gmma1a && gmma2 < gmma2a && gmma3 < gmma3a && gmma4 < gmma4a && gmma5 < gmma5a && 
            gmma6 < gmma6a && gmma7 < gmma7a && gmma8 < gmma8a && gmma9 < gmma9a && gmma10 < gmma10a && gmma11 < gmma11a           
           ){
           //こちらで新規ポジションを持つ処理を書いています。これも必ず使用する処理なので順番等を覚えていたほうが楽でしょう。
            Ticket=OrderSend(NULL,OP_SELL,Lots,Bid,Adjusted_Slippage,0,0,NULL,magicnum,0,Aqua);
           }

         if(gmma6 < gmma0 && gmma6 < gmma1 && gmma6 < gmma2 && gmma6 < gmma3 && gmma6 < gmma4 && gmma6 < gmma5 &&
            gmma7 < gmma0 && gmma7 < gmma1 && gmma7 < gmma2 && gmma7 < gmma3 && gmma7 < gmma4 && gmma7 < gmma5 &&
            gmma8 < gmma0 && gmma8 < gmma1 && gmma8 < gmma2 && gmma8 < gmma3 && gmma8 < gmma4 && gmma8 < gmma5 &&
            gmma9 < gmma0 && gmma9 < gmma1 && gmma9 < gmma2 && gmma9 < gmma3 && gmma9 < gmma4 && gmma9 < gmma5 &&
            gmma10 < gmma0 && gmma10 < gmma1 && gmma10 < gmma2 && gmma10 < gmma3 && gmma10 < gmma4 && gmma10 < gmma5 &&
            gmma11 < gmma0 && gmma11 < gmma1 && gmma11 < gmma2 && gmma11 < gmma3 && gmma11 < gmma4 && gmma11 < gmma5 &&
             
            gmma0 > gmma0a && gmma1 > gmma1a && gmma2 > gmma2a && gmma3 > gmma3a && gmma4 > gmma4a && gmma5 > gmma5a && 
            gmma6 > gmma6a && gmma7 > gmma7a && gmma8 > gmma8a && gmma9 > gmma9a && gmma10 > gmma10a && gmma11 > gmma11a       
         ){
            Ticket=OrderSend(NULL,OP_BUY,Lots,Ask,Adjusted_Slippage,0,0,NULL,magicnum,0,White);
         }   
      }

   }//---NowBars

}//---OnTick
//+------------------------------------------------------------------+

