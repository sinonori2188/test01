//+------------------------------------------------------------------+
//|                                                  Breakout_Exp.mq4|
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

//マジックナンバー
#define MAGIC  20070831

//パラメーター
extern int Fast_Period = 20;
extern int Slow_Period = 40;
extern double Lots = 0.1;
extern int Slippage = 3;

//+------------------------------------------------------------------+
//| オープンポジションの計算                                         |
//+------------------------------------------------------------------+
int CalculateCurrentOrders()
{
   //オープンポジション数（+:買い -:売り）
   int pos=0;

   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) break;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MAGIC)
      {
         if(OrderType() == OP_BUY)  pos++;
         if(OrderType() == OP_SELL) pos--;
      }
   }
   return(pos);
}

//+------------------------------------------------------------------+
//| ポジションを決済する                                             |
//+------------------------------------------------------------------+
void ClosePositions()
{
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) break;
      if(OrderMagicNumber() != MAGIC || OrderSymbol() != Symbol()) continue;
      //オーダータイプのチェック 
      if(OrderType() == OP_BUY)
      {
         OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,White);
         break;
      }
      if(OrderType() == OP_SELL)
      {
         OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,White);
         break;
      }
   }
}

//+------------------------------------------------------------------+
//| スタート関数                                                     |
//+------------------------------------------------------------------+
int start()
{
   //バーの始値でトレード可能かチェック
   if(Volume[0] > 1 || IsTradeAllowed() == false) return(0);

   //指標の計算
   double SlowHH = Close[iHighest(NULL,0,MODE_CLOSE,Slow_Period,2)];
   double SlowLL = Close[iLowest(NULL,0,MODE_CLOSE,Slow_Period,2)];
   double FastHH = Close[iHighest(NULL,0,MODE_CLOSE,Fast_Period,2)];
   double FastLL = Close[iLowest(NULL,0,MODE_CLOSE,Fast_Period,2)];

   //オープンポジションの計算
   int pos = CalculateCurrentOrders();

   //買いシグナル
   if(pos <= 0 && Close[2] <= SlowHH && Close[1] > SlowHH)
   {
      ClosePositions();
      OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,"",MAGIC,0,Blue);
      return(0);
   }
   //売りシグナル
   if(pos >= 0 && Close[2] >= SlowLL && Close[1] < SlowLL)
   {
      ClosePositions();
      OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,"",MAGIC,0,Red);
      return(0);
   }
   //買いポジションを決済する
   if(pos > 0 && Close[2] >= FastLL && Close[1] < FastLL)
   {
      ClosePositions();
      return(0);
   }
   //売りポジションを決済する
   if(pos < 0 && Close[2] <= FastHH && Close[1] > FastHH)
   {
      ClosePositions();
      return(0);
   }
}
//+------------------------------------------------------------------+