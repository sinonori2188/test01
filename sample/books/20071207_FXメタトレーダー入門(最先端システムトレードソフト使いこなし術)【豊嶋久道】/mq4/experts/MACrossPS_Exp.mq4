//+------------------------------------------------------------------+
//|                                                 MACrossPS_Exp.mq4|
//|                                   Copyright (c) 2007, Toyolab FX |
//|                                         http://forex.toyolab.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2007, Toyolab FX"
#property link      "http://forex.toyolab.com"

//�}�W�b�N�i���o�[
#define MAGIC  20070828

//�p�����[�^�[
extern int FastMA_Period = 10;
extern int SlowMA_Period = 40;
extern int Slippage = 3;
extern double Leverage = 1.0; //���o���b�W

//+------------------------------------------------------------------+
//| �|�W�V���������ς���                                             |
//+------------------------------------------------------------------+
void ClosePositions()
{
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) break;
      if(OrderMagicNumber() != MAGIC || OrderSymbol() != Symbol()) continue;
      //�I�[�_�[�^�C�v�̃`�F�b�N
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
//| �X�^�[�g�֐�                                                     |
//+------------------------------------------------------------------+
int start()
{
	//�o�[�̎n�l�Ńg���[�h�\���`�F�b�N
   if(Volume[0]>1 || IsTradeAllowed()==false) return(0);

	//�ړ����ς̌v�Z
   double FastMA1 = iMA(NULL,0,FastMA_Period,0,MODE_SMA,PRICE_CLOSE,1);
   double SlowMA1 = iMA(NULL,0,SlowMA_Period,0,MODE_SMA,PRICE_CLOSE,1);
   double FastMA2 = iMA(NULL,0,FastMA_Period,0,MODE_SMA,PRICE_CLOSE,2);
   double SlowMA2 = iMA(NULL,0,SlowMA_Period,0,MODE_SMA,PRICE_CLOSE,2);

   //���b�g���̌v�Z
   double minlot = 0.1;
   double Lots = NormalizeDouble(AccountFreeMargin()*Leverage/100000,1);
   if(Lots < minlot) Lots = minlot;

   //�����V�O�i��
   if(FastMA2 <= SlowMA2 && FastMA1 > SlowMA1)
   {
      ClosePositions();
      OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,"",MAGIC,0,Blue);
      return(0);
   }

   //����V�O�i��
   if(FastMA2 >= SlowMA2 && FastMA1 < SlowMA1)
   {
      ClosePositions();
      OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,"",MAGIC,0,Red);
      return(0);
   }
   return(0);
}
//+------------------------------------------------------------------+