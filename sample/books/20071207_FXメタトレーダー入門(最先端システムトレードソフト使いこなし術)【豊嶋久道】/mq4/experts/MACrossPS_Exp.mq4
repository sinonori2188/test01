//+------------------------------------------------------------------+
//|                                                 MACrossPS_Exp.mq4|
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

//マジックナンバー
#define MAGIC  20070828

//パラメーター
extern int FastMA_Period = 10;
extern int SlowMA_Period = 40;
extern int Slippage = 3;
extern double Leverage = 1.0; //レバレッジ

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

//+------------------------------------------------------------------+
//| スタート関数                                                     |
//+------------------------------------------------------------------+
int start()
{
	//バーの始値でトレード可能かチェック
   if(Volume[0]>1 || IsTradeAllowed()==false) return(0);

	//移動平均の計算
   double FastMA1 = iMA(NULL,0,FastMA_Period,0,MODE_SMA,PRICE_CLOSE,1);
   double SlowMA1 = iMA(NULL,0,SlowMA_Period,0,MODE_SMA,PRICE_CLOSE,1);
   double FastMA2 = iMA(NULL,0,FastMA_Period,0,MODE_SMA,PRICE_CLOSE,2);
   double SlowMA2 = iMA(NULL,0,SlowMA_Period,0,MODE_SMA,PRICE_CLOSE,2);

   //ロット数の計算
   double minlot = 0.1;
   double Lots = NormalizeDouble(AccountFreeMargin()*Leverage/100000,1);
   if(Lots < minlot) Lots = minlot;

   //買いシグナル
   if(FastMA2 <= SlowMA2 && FastMA1 > SlowMA1)
   {
      ClosePositions();
      OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,"",MAGIC,0,Blue);
      return(0);
   }

   //売りシグナル
   if(FastMA2 >= SlowMA2 && FastMA1 < SlowMA1)
   {
      ClosePositions();
      OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,"",MAGIC,0,Red);
      return(0);
   }
   return(0);
}
//+------------------------------------------------------------------+