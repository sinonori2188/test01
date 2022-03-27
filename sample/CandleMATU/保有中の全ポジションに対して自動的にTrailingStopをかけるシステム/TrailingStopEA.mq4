//+------------------------------------------------------------------+
//|                                                  Trailing_EA.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "ands"
#property link ""

extern double TrailingPips = 50;
int mode = 2;//Trailモード(1:利確 2:損切り)

bool error, Modify;
int NowBars = 0;

int init()
{
   //OnTimer関数を使う時にはinit関数の中でSetTimer関数を設定する必要があります。
   //ここでは500ミリ秒＝0.5秒に１回OnTimer関数を読み込ませるという形になります。（1000ミリ秒＝1秒）
   EventSetMillisecondTimer(500);
   Comment("");
   return(0);
}

void OnDeinit(const int reason)
  {
//---
   //そして、ルールとして、SetTimerをdeinitで消してあげる必要があります。それがKillTimer関数です。
   Comment("");
   EventKillTimer();
  }

   double now_stop;
   double tr_stop;

//ここからが、0.5秒に１回読み込まれる処理になります。（ティックごとではないので価格が動かなくてもOK）
void OnTimer()
{   
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true){
            int digit;
            double trailing = TrailingPips;
            double spread;
            double price;   
            
            //選択したポジションの価格、現在入っているSL、桁数を取得。
            price = iClose(OrderSymbol(),0,0);
            now_stop = OrderStopLoss();                               
            digit = MarketInfo(OrderSymbol(),MODE_DIGITS);      
                            
            //桁数によって指定数値がどう表記されるかを確認する。
            //例えば小数点以下が３桁の場合は112.250であればTrailingPips50でSLは112.200に入って欲しい。
            //ただ、今のままだと112.250-50で62.250になってしまう。
            //そこで0.05減らしたいわけなので、50*0.001と調整している。
            if(digit == 3){
                trailing = TrailingPips*0.001;
                spread = MarketInfo(OrderSymbol(),MODE_SPREAD)*0.001;
            }     
            //５桁の場合はPointというのをかけると最小小数点を出してくれるが、0.00001でも同様の結果になります。
            else if(digit == 5){
                         trailing = TrailingPips*Point;
                         spread = MarketInfo(OrderSymbol(),MODE_SPREAD)*Point;
            }

               //Commnet()関数は値が希望通りの数字で入っているかの確認で多用します。検証したい要素を入れてみましょう。
               //豆知識：要素の間にスペースを入れたい場合は+" "+を入れ、要素を開業したい場合は+"\n"+を入れます。スラッシュではなくバックスラッシュです。
               Comment(price+" "+
               (/*OrderOpenPrice()-*/spread+" "+trailing)
               +" DIGITS:"+digit+" Trail:"+TrailingPips+" Symbol:"+OrderSymbol()+" Time:"+TimeSeconds(TimeCurrent()));
       
            if(NowBars < Bars){
                  NowBars = Bars;
                  
                  //通貨ペアによってストップレベル（最低注文価格）が決まっています。
                  //その最低値よりも低いTrailは設定できないので、その場合その通貨ペア名とストップレベルをアラートで通知させます。
                  if(TrailingPips < MarketInfo(OrderSymbol(), MODE_STOPLEVEL))
                  {
                     Alert(OrderSymbol()+" >> Minimum Trailing is "+MarketInfo(OrderSymbol(), MODE_STOPLEVEL));
                     //continueというのはforの繰り返しをそこで止め、次の循環に回すコードです。この周回に関してはこれより先は見ないということになります。
                     continue;
                  }
            }
               
            if(mode == 1){
                  if(OrderType()==OP_BUY)
                  {
                     //Trailing幅よりも利益が出た時              
                     if(iClose(OrderSymbol(),0,0) > (OrderOpenPrice()+trailing)){
                           //新規のSLとして現在価格からTrail幅下の価格を設定
                           tr_stop = iClose(OrderSymbol(),0,0)-trailing;
                           //NormalizeDouble()関数というのは()の１番目のdouble型の要素を２番目の数字の小数点で四捨五入する関数です。
                           //下記では現在と新規それぞれのSL値をその通貨ペアの桁数で揃えて比較しています。
                           if(NormalizeDouble(now_stop, digit) < NormalizeDouble(tr_stop, digit))
                           {
                              //すでに保有しているポジションに対して修正を行う場合は
                              Modify = OrderModify(OrderTicket(),OrderOpenPrice(),tr_stop,OrderTakeProfit(),0,Red);
                           }
                     }
                  }
                  
                  else if(OrderType()==OP_SELL)
                  {  
                     if(iClose(OrderSymbol(),0,0) <
                        (OrderOpenPrice()-spread-trailing)){
                           tr_stop = iClose(OrderSymbol(),0,0)+spread+trailing;              
                           //ショートの場合は注意が必要です。現在SLが入っていない時も条件を満たすように[ || ]で追加します。
                           if(NormalizeDouble(now_stop, digit) > NormalizeDouble(tr_stop, digit) || now_stop==0)
                           {
                              Modify = OrderModify(OrderTicket(),OrderOpenPrice(),tr_stop,OrderTakeProfit(),0,Red);
                           }
                     }
                  }
            }
            
            //利益が出ていなくてもとりあえずすぐにTrail幅分のSLを設定する。
            if(mode == 2){
                  if(OrderType()==OP_BUY)
                  {
                     tr_stop = iClose(OrderSymbol(),0,0)-trailing;
                     if(NormalizeDouble(now_stop, digit) < NormalizeDouble(tr_stop, digit))
                     {
                        Modify = OrderModify(OrderTicket(),OrderOpenPrice(),tr_stop,OrderTakeProfit(),0,Red);
                     }
                  }
                  
                  else if(OrderType()==OP_SELL)
                  {  
                     tr_stop = iClose(OrderSymbol(),0,0)+spread+trailing;              
                     if(NormalizeDouble(now_stop, digit) > NormalizeDouble(tr_stop, digit) || now_stop==0)
                     {         
                        Modify = OrderModify(OrderTicket(),OrderOpenPrice(),tr_stop,OrderTakeProfit(),0,Red);
                     }
                  }
            }
      }
   }
}
