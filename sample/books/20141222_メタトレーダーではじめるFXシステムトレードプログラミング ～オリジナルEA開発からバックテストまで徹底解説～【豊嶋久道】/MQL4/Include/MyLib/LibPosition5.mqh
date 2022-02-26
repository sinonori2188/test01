// LibPosition5.mqh

// order type extension
#define ORDER_TYPE_NONE -1
#define OP_NONE ORDER_TYPE_NONE
#define OP_BUY ORDER_TYPE_BUY
#define OP_SELL ORDER_TYPE_SELL
#define OP_BUYLIMIT ORDER_TYPE_BUY_LIMIT
#define OP_SELLLIMIT ORDER_TYPE_SELL_LIMIT
#define OP_BUYSTOP ORDER_TYPE_BUY_STOP
#define OP_SELLSTOP ORDER_TYPE_SELL_STOP

// MQL4 compatible functions
#include <MyLib\LibMQL4.mqh>

// MQL4 compatible predefined variables
double Bid, Ask, Open[], Low[], High[], Close[];
datetime Time[];
long Volume[];

// structure for MyPosition
struct MyPosition
{
   ulong ticket;        // deal ticket
   ulong order_stop;    // stop order ticket
   ulong order_limit;   // limit order ticket
   double lots;         // open lots
   double price;        // open price
   datetime time;       // open time
} MyPos[POSITIONS];

// magic numbers
long MAGIC_B[POSITIONS]={0}, MAGIC_S[POSITIONS]={0};

// pips adjustment
double PipPoint = _Point;

// slippage
input double SlippagePips = 1;
ulong Slippage = 1;

// start date of history
input datetime StartHistory = 0;

// retrieve position from history pool
input bool RetrieveHistory = true;

// refresh Bid/Ask
bool RefreshPrice(double &bid, double &ask)
{
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol, tick)) return(false);
   if(tick.bid <= 0 || tick.ask <= 0) return(false);
   bid = tick.bid;
   ask = tick.ask;
   return(true);
}

// init MyPosition to be called in OnInit()
void InitPosition()
{
   // pips adjustment
   if(_Digits == 3 || _Digits == 5)
   {
      Slippage = (ulong)(SlippagePips * 10);
      PipPoint = _Point * 10;
   }
   else
   {
      Slippage = (ulong)SlippagePips;
      PipPoint = _Point;
   }
   // position settings
   for(int i=0; i<POSITIONS; i++)
   {
      // magic number setting
      MAGIC_B[i] = MAGIC*10+2*i;
      MAGIC_S[i] = MAGIC_B[i]+1;
      // reset position
      ZeroMemory(MyPos[i]);
      // retrieve position and order
      if(!RetrieveHistory) continue;
      RetrieveOpenPosition(i);
      RetrieveOrder(i);
   }
   InitRates();
}

// retrieve open position from deal history pool
bool RetrieveOpenPosition(int i)
{
   HistorySelect(StartHistory, TimeCurrent()+60);
   for(int k=HistoryDealsTotal()-1; k>=0; k--)
   {
      ulong ticket = HistoryDealGetTicket(k);
      if(HistoryDealGetString(ticket, DEAL_SYMBOL) != _Symbol) continue;
      long dmagic = HistoryDealGetInteger(ticket, DEAL_MAGIC);
      ENUM_DEAL_TYPE dtype
         = (ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket, DEAL_TYPE);
      // position is closed
      if((dtype == DEAL_TYPE_SELL && dmagic == MAGIC_B[i]) || 
         (dtype == DEAL_TYPE_BUY && dmagic == MAGIC_S[i])) break;
      // position is open
      if((dtype == DEAL_TYPE_BUY && dmagic == MAGIC_B[i]) || 
         (dtype == DEAL_TYPE_SELL && dmagic == MAGIC_S[i]))
      {
         MyPos[i].ticket = ticket;
         MyPos[i].lots = HistoryDealGetDouble(ticket, DEAL_VOLUME);
         if(dtype == DEAL_TYPE_SELL) MyPos[i].lots = -MyPos[i].lots;
         MyPos[i].price = HistoryDealGetDouble(ticket, DEAL_PRICE);
         MyPos[i].time
            = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);
         return true;
      }
   }
   return false;
}

// retrieve closed position from deal history pool
bool RetrieveLastPosition(int i, MyPosition &openpos,
                          MyPosition &closepos)
{
   bool last_pos = false; // set true when last closed position is found
   HistorySelect(StartHistory, TimeCurrent()+60);
   for(int k=HistoryDealsTotal()-1; k>=0; k--)
   {
      ulong ticket = HistoryDealGetTicket(k);
      if(HistoryDealGetString(ticket, DEAL_SYMBOL) != _Symbol) continue;
      long dmagic = HistoryDealGetInteger(ticket, DEAL_MAGIC);
      ENUM_DEAL_TYPE dtype
         = (ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket, DEAL_TYPE);
      // open position is found
      if((dtype == DEAL_TYPE_BUY && dmagic == MAGIC_B[i]) || 
         (dtype == DEAL_TYPE_SELL && dmagic == MAGIC_S[i]))
      {
         if(!last_pos) continue;
         openpos.lots = HistoryDealGetDouble(ticket, DEAL_VOLUME);
         if(dtype == DEAL_TYPE_SELL) openpos.lots = -openpos.lots;
         openpos.price = HistoryDealGetDouble(ticket, DEAL_PRICE);
         openpos.time
            = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);
         return true;
      }
      // close position is found
      if((dtype == DEAL_TYPE_SELL && dmagic == MAGIC_B[i]) || 
         (dtype == DEAL_TYPE_BUY && dmagic == MAGIC_S[i]))
      {
         closepos.price = HistoryDealGetDouble(ticket, DEAL_PRICE);
         closepos.time
            = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);
         last_pos = true;
      }
   }
   return false;
}

// retrieve orders from current order pool
bool RetrieveOrder(int i)
{
   bool stop_flag = false, limit_flag = false;
   for(int k=OrdersTotal()-1; k>=0; k--)
   {
      ulong order = OrderGetTicket(k);
      if(!OrderSelect(order)) continue;
      if(OrderGetString(ORDER_SYMBOL) != _Symbol) continue;
      long omagic = OrderGetInteger(ORDER_MAGIC);
      ENUM_ORDER_TYPE otype
         = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
      if(omagic != MAGIC_B[i] && omagic != MAGIC_S[i]) continue;
      if(otype == ORDER_TYPE_BUY_STOP || otype == ORDER_TYPE_SELL_STOP)
      {
         if(stop_flag) return true;
         else stop_flag = true;
         MyPos[i].order_stop = order;
      }
      if(otype == ORDER_TYPE_BUY_LIMIT || otype == ORDER_TYPE_SELL_LIMIT)
      {
         if(limit_flag) return true;
         else limit_flag = true;
         MyPos[i].order_limit = order;
      }
   }
   return(stop_flag || limit_flag);
}

// check MyPosition to be called in OnTrade()
void UpdatePosition()
{
   if(MAGIC_B[0] == 0) InitPosition(); // 初期化

   HistorySelect(StartHistory, TimeCurrent());
   for(int i=0; i<POSITIONS; i++)
   {
      // stop order is filled
      if(SubCheckPosition(i, MyPos[i].order_stop))
      {
         SubOrderDelete(MyPos[i].order_limit);
         MyPos[i].order_stop = 0;
         MyPos[i].order_limit = 0;
      }
      // limit order is filled
      if(SubCheckPosition(i, MyPos[i].order_limit))
      {
         SubOrderDelete(MyPos[i].order_stop);
         MyPos[i].order_stop = 0;
         MyPos[i].order_limit = 0;
      }
   }
   RefreshRates();
}

// check position sub-function
bool SubCheckPosition(int i, ulong order)
{
   // filled order check from order history pool
   if(!HistoryOrderSelect(order) ||
      HistoryOrderGetInteger(order, ORDER_STATE) != ORDER_STATE_FILLED)
      return false;
   for(int k=HistoryDealsTotal()-1; k>=0; k--)
   {
      ulong ticket = HistoryDealGetTicket(k);
      if(HistoryDealGetString(ticket, DEAL_SYMBOL) != _Symbol) continue;
      long dmagic = HistoryDealGetInteger(ticket, DEAL_MAGIC);
      datetime dtime
         = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);
      double dprice = HistoryDealGetDouble(ticket, DEAL_PRICE);
      double dlots = HistoryDealGetDouble(ticket, DEAL_VOLUME);
      ENUM_DEAL_TYPE dtype
         = (ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket, DEAL_TYPE);
      ENUM_ORDER_TYPE otype = ORDER_TYPE_BUY;
      if(dtype == DEAL_TYPE_SELL) otype = ORDER_TYPE_SELL;
      // position closed
      if((dtype == DEAL_TYPE_SELL && dmagic == MAGIC_B[i]) ||
         (dtype == DEAL_TYPE_BUY && dmagic == MAGIC_S[i]))
      {
         // reset position
         MyPos[i].ticket = 0;
         MyPos[i].lots = 0;
         MyPos[i].price = 0;
         MyPos[i].time = 0;
         break;
      }
      // position opened
      if((dtype == DEAL_TYPE_BUY && dmagic == MAGIC_B[i]) ||
         (dtype == DEAL_TYPE_SELL && dmagic == MAGIC_S[i]))
      {
         MyPos[i].ticket = ticket;
         MyPos[i].lots = dlots;
         if(dtype == DEAL_TYPE_SELL) MyPos[i].lots = -MyPos[i].lots;
         MyPos[i].price = dprice;
         MyPos[i].time = dtime;
         break;
      }
   }
   return true;
}

// get filling mode
ENUM_ORDER_TYPE_FILLING OrderFilling()
{
   long filling_mode = SymbolInfoInteger(_Symbol, SYMBOL_FILLING_MODE);
   if(filling_mode%2 != 0) return ORDER_FILLING_FOK;
   else if(filling_mode%4 != 0) return ORDER_FILLING_IOC;
   return ORDER_FILLING_RETURN;
}

// send order to open position
bool MyOrderSend(ENUM_ORDER_TYPE type, double lots, double price=0,
                 int pos_id=0)
{
   price = NormalizeDouble(price, _Digits);
   bool ret = false;
   switch(type)
   {
      case ORDER_TYPE_BUY:
      case ORDER_TYPE_SELL:
         ret = OrderSendMarket(type, lots, pos_id);
         break;
      case ORDER_TYPE_BUY_STOP:
      case ORDER_TYPE_BUY_LIMIT:
      case ORDER_TYPE_SELL_STOP:
      case ORDER_TYPE_SELL_LIMIT:
         ret = OrderSendPending(type, lots, price, pos_id);
         break;
      default:
         Print("MyOrderSend : Unsupported type");
         break;
   }
   return ret;
}

// send market order to open position
bool OrderSendMarket(ENUM_ORDER_TYPE type, double lots, int i)
{
   if(MyOrderType(i) != ORDER_TYPE_NONE) return true;
   // for no position or order
   MqlTradeRequest request={0};
   MqlTradeResult result={0}; 
   // refresh rate
   double bid, ask;
   RefreshPrice(bid, ask);
   // order request
   if(type == ORDER_TYPE_BUY)
   {
      request.price = ask;
      request.magic = MAGIC_B[i];
   }
   else if(type == ORDER_TYPE_SELL)
   {
      request.price = bid;
      request.magic = MAGIC_S[i];
   }
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = lots;
   request.deviation = Slippage;
   request.type = type;
   request.type_filling = OrderFilling();
   request.comment = IntegerToString(request.magic);
   bool b = OrderSend(request,result);
   // order completed
   if(result.retcode == TRADE_RETCODE_DONE)
   {
      MyPos[i].ticket = result.deal;
      MyPos[i].lots = result.volume;
      MyPos[i].price = result.price;
      MyPos[i].time = TimeCurrent();
      if(type == ORDER_TYPE_SELL) MyPos[i].lots = -MyPos[i].lots;
   }
   // order error
   else
   {
      Print("MyOrderSendMarket : ", result.retcode, " ",
            RetcodeDescription(result.retcode));
      return false;
   }
   return true;
}

// send pending order to open position
bool OrderSendPending(ENUM_ORDER_TYPE type, double lots, double price,
                      int i)
{
   if(MyPos[i].ticket > 0) return true;
   // for no open position
   if(MyPos[i].order_limit > 0 &&
     (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_SELL_LIMIT))
      return true;
   if(MyPos[i].order_stop > 0 &&
     (type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_SELL_STOP))
      return true;
   // for non-existing pending order 
   MqlTradeRequest request={0};
   MqlTradeResult result={0}; 
   // order request
   if(type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP)
      request.magic = MAGIC_B[i];
   else if(type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP)
           request.magic = MAGIC_S[i];
   request.action = TRADE_ACTION_PENDING;
   request.symbol = _Symbol;
   request.volume = lots;
   request.type = type;
   request.price = price;
   request.type_filling = OrderFilling();
   request.type_time = ORDER_TIME_GTC;
   request.comment = IntegerToString(request.magic);
   bool b = OrderSend(request,result);
   // order completed
   if(result.retcode == TRADE_RETCODE_DONE)
   {
      if(type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_SELL_STOP)
         MyPos[i].order_stop = result.order;
      if(type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_SELL_LIMIT)
         MyPos[i].order_limit = result.order;
   }
   // order error
   else
   {
      Print("MyOrderSendPending : ", result.retcode, " ",
            RetcodeDescription(result.retcode));
      return false;
   }
   return true;
}

// send close order
bool MyOrderClose(int pos_id=0)
{
   if(MyPos[pos_id].ticket == 0) return true;
   // for open position
   MqlTradeRequest request={0};
   MqlTradeResult result={0}; 
   MyPosition pos;
   // refresh rate
   double bid, ask;
   RefreshPrice(bid, ask);
   // order request
   double lots = MyPos[pos_id].lots;
   if(lots > 0)
   {
      request.type = ORDER_TYPE_SELL;
      request.magic = MAGIC_B[pos_id];
      request.price = bid;
   }
   else if(lots < 0)
   {
      request.type = ORDER_TYPE_BUY;
      request.magic = MAGIC_S[pos_id];
      request.price = ask;
   }
   else return true;
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.deviation = Slippage;
   request.volume = MathAbs(lots);
   request.comment
      = HistoryDealGetString(MyPos[pos_id].ticket, DEAL_COMMENT);
   if(request.comment == "")
      request.comment = IntegerToString(request.magic);
   request.type_filling = OrderFilling();
   bool b = OrderSend(request,result);
   // order completed
   if(result.retcode == TRADE_RETCODE_DONE)
   {
      pos.ticket = result.deal;
      pos.price = result.price;
      pos.time = TimeCurrent();
   }
   // order error
   else
   {
      Print("MyOrderClose : ", result.retcode, " ",
            RetcodeDescription(result.retcode));
      return false;
   }
   // delete SL and TP orders
   if(MyPos[pos_id].order_stop > 0)
      SubOrderDelete(MyPos[pos_id].order_stop);
   if(MyPos[pos_id].order_limit > 0)
      SubOrderDelete(MyPos[pos_id].order_limit);
   ZeroMemory(MyPos[pos_id]);
   return true;
}

// delete pending order
bool MyOrderDelete(int pos_id=0)
{
   if(MyPos[pos_id].ticket > 0) return true;
   // for pending order
   bool ret = true;
   if(MyPos[pos_id].order_stop > 0 &&
     (ret=SubOrderDelete(MyPos[pos_id].order_stop)))
      MyPos[pos_id].order_stop = 0;
   if(MyPos[pos_id].order_limit > 0 &&
     (ret=SubOrderDelete(MyPos[pos_id].order_limit)))
      MyPos[pos_id].order_limit = 0;
   return ret;
}

// delete pending order sub-function
bool SubOrderDelete(ulong order)
{
   if(order == 0) return true;
   // for pending order
   MqlTradeRequest request={0};
   MqlTradeResult result={0}; 
   // order request
   request.action = TRADE_ACTION_REMOVE;
   request.order = order;
   bool b = OrderSend(request,result);
   // order completed
   if(result.retcode == TRADE_RETCODE_DONE) return true;
   // order error
   else
   {
      Print("MyOrderDelete : ", result.retcode, " ",
            RetcodeDescription(result.retcode));
      return false;
   }
}

// modify order
bool MyOrderModify(double price, double sl, double tp, int pos_id=0)
{
   bool ret = true;
   price = NormalizeDouble(price, _Digits);
   sl = NormalizeDouble(sl, _Digits);
   tp = NormalizeDouble(tp, _Digits);
   // for open position
   if(MyPos[pos_id].ticket > 0)
   {
      if(sl > 0) ret = OrderModifyPending(pos_id, sl, "SL");
      if(tp > 0) ret = OrderModifyPending(pos_id, tp, "TP");
   }
   // for stop order
   else if(MyPos[pos_id].order_stop > 0)
   {
      if(price > 0)
         ret = SubOrderModify(MyPos[pos_id].order_stop, price);
   }
   // for limit order
   else if(MyPos[pos_id].order_limit > 0)
   {
      if(price > 0)
         ret = SubOrderModify(MyPos[pos_id].order_limit, price);
   }
   return ret;
}

// order modify sub-function(new SL/TP)
bool OrderModifyPending(int i, double price, string comment)
{
   if(MyPos[i].ticket == 0 || price == 0) return true;
   // for open position
   MqlTradeRequest request={0};
   MqlTradeResult result={0}; 
   // refresh rate
   double bid, ask;
   RefreshPrice(bid, ask);
   // order request
   double lots = MyPos[i].lots;
   if(lots > 0)
   {
      request.magic = MAGIC_B[i];
      if(comment == "SL") request.type = ORDER_TYPE_SELL_STOP;
      if(comment == "TP") request.type = ORDER_TYPE_SELL_LIMIT;
   }
   else if(lots < 0)
   {
      request.magic = MAGIC_S[i];
      if(comment == "SL") request.type = ORDER_TYPE_BUY_STOP;
      if(comment == "TP") request.type = ORDER_TYPE_BUY_LIMIT;
   }
   else return true;
   // for existing SL order
   if(MyPos[i].order_stop > 0 &&
     (request.type == ORDER_TYPE_BUY_STOP ||
      request.type == ORDER_TYPE_SELL_STOP))
   {
      SubOrderModify(MyPos[i].order_stop, price);
      return true;
   }
   // for existing TP order
   if(MyPos[i].order_limit > 0 &&
     (request.type == ORDER_TYPE_BUY_LIMIT ||
      request.type == ORDER_TYPE_SELL_LIMIT))
   {
      SubOrderModify(MyPos[i].order_limit, price);
      return true;
   }
   request.action = TRADE_ACTION_PENDING;
   request.symbol = _Symbol;
   request.volume = MathAbs(lots);
   request.price = price;
   request.type_filling = OrderFilling();
   request.type_time = ORDER_TIME_GTC;
   request.comment
      = HistoryDealGetString(MyPos[i].ticket, DEAL_COMMENT);
   if(request.comment == "")
      request.comment = IntegerToString(request.magic);
   request.comment = request.comment + comment;
   bool b = OrderSend(request,result);
   // order completed
   if(result.retcode == TRADE_RETCODE_DONE)
   {
      if(request.type == ORDER_TYPE_BUY_STOP ||
         request.type == ORDER_TYPE_SELL_STOP)
         MyPos[i].order_stop = result.order;
      if(request.type == ORDER_TYPE_BUY_LIMIT ||
         request.type == ORDER_TYPE_SELL_LIMIT)
         MyPos[i].order_limit = result.order;
   }
   // order error
   else
   {
      Print("MyOrderModifyPending : ", result.retcode, " ",
            RetcodeDescription(result.retcode));
      return false;
   }
   return true;
}

// modify order sub-function(modify SL/TP)
bool SubOrderModify(ulong order, double price)
{
   if(order == 0 || price == 0) return true;
   if(OrderSelect(order) && OrderGetDouble(ORDER_PRICE_OPEN) == price)
      return true;
   // for pending order with SL/TP
   MqlTradeRequest request={0};
   MqlTradeResult result={0}; 
   // order request
   request.action = TRADE_ACTION_MODIFY;
   request.order = order;
   request.price = price;
   request.type_time = ORDER_TIME_GTC;
   bool b = OrderSend(request,result);
   // order completed
   if(result.retcode == TRADE_RETCODE_DONE) return true;
   // order error
   else
   {
      Print("MyOrderModify : ", result.retcode, " ",
            RetcodeDescription(result.retcode));
      return false;
   }
}

// get order type
ENUM_ORDER_TYPE MyOrderType(int pos_id=0)
{
   ENUM_ORDER_TYPE type = ORDER_TYPE_NONE;
   if(MyPos[pos_id].ticket > 0)
   {
      if(MyPos[pos_id].lots > 0) type = ORDER_TYPE_BUY;
      if(MyPos[pos_id].lots < 0) type = ORDER_TYPE_SELL;
   }
   else if(OrderSelect(MyPos[pos_id].order_stop))
           type = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
   else if(OrderSelect(MyPos[pos_id].order_limit))
           type = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
   return type;
}

// get order lots
double MyOrderLots(int pos_id=0)
{
   double lots = 0;
   if(MyPos[pos_id].ticket > 0) lots = MathAbs(MyPos[pos_id].lots);
   else if(OrderSelect(MyPos[pos_id].order_stop))
           lots = OrderGetDouble(ORDER_VOLUME_CURRENT);
   else if(OrderSelect(MyPos[pos_id].order_limit))
           lots = OrderGetDouble(ORDER_VOLUME_CURRENT);
   return lots;
}

// get signed lots of open position
double MyOrderOpenLots(int pos_id=0)
{
   double lots = 0;
   if(MyPos[pos_id].ticket > 0) lots = MyPos[pos_id].lots;
   return lots;   
}

// get order open price
double MyOrderOpenPrice(int pos_id=0)
{
   double price = 0;
   if(MyPos[pos_id].ticket > 0) price = MyPos[pos_id].price;
   else if(OrderSelect(MyPos[pos_id].order_stop))
           price = OrderGetDouble(ORDER_PRICE_OPEN);
   else if(OrderSelect(MyPos[pos_id].order_limit))
           price = OrderGetDouble(ORDER_PRICE_OPEN);
   return price;
}

// get order open time
datetime MyOrderOpenTime(int pos_id=0)
{
   datetime opentime = 0;
   if(MyPos[pos_id].ticket > 0) opentime = MyPos[pos_id].time;
   else if(OrderSelect(MyPos[pos_id].order_stop))
           opentime = (datetime)OrderGetInteger(ORDER_TIME_SETUP);
   else if(OrderSelect(MyPos[pos_id].order_limit))
           opentime = (datetime)OrderGetInteger(ORDER_TIME_SETUP);
   return opentime;
}

// get order stop loss
double MyOrderStopLoss(int pos_id=0)
{
   double sl = 0;
   if(MyPos[pos_id].ticket > 0)
   {
      if(OrderSelect(MyPos[pos_id].order_stop))
         sl = OrderGetDouble(ORDER_PRICE_OPEN);
   }
   return sl;
}

// get order take profit
double MyOrderTakeProfit(int pos_id=0)
{
   double tp = 0;
   if(MyPos[pos_id].ticket > 0)
   {
      if(OrderSelect(MyPos[pos_id].order_limit))
         tp = OrderGetDouble(ORDER_PRICE_OPEN);
   }
   return tp;
}

// get close price of open position
double MyOrderClosePrice(int pos_id=0)
{
   double bid, ask;
   RefreshPrice(bid, ask);
   double price = 0;
   if(MyPos[pos_id].lots > 0) price = bid;
   if(MyPos[pos_id].lots < 0) price = ask;
   return price;
}

// get profit of open position
double MyOrderProfit(int pos_id=0)
{
   return MyOrderProfitPips(pos_id)
      *SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE)
      *SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE)
      *MyOrderLots(pos_id)*0.0001;
}

// get profit of open position in pips
double MyOrderProfitPips(int pos_id=0)
{
   double profit = 0;
   if(MyPos[pos_id].lots > 0) profit = MyOrderClosePrice(pos_id)
                                     - MyPos[pos_id].price;
   if(MyPos[pos_id].lots < 0) profit = MyPos[pos_id].price
                                     - MyOrderClosePrice(pos_id);
   return profit/PipPoint;
}

// get order type of last position
int MyOrderLastType(int pos_id=0)
{
   MyPosition openpos, closepos;
   ENUM_ORDER_TYPE type = ORDER_TYPE_NONE;
   if(RetrieveLastPosition(pos_id, openpos, closepos))
   {
      if(openpos.lots > 0) type = ORDER_TYPE_BUY;
      if(openpos.lots < 0) type = ORDER_TYPE_SELL;
   }
   return type;
}

// get order lots of last position
double MyOrderLastLots(int pos_id=0)
{
   MyPosition openpos, closepos;
   double lots = 0;
   if(RetrieveLastPosition(pos_id, openpos, closepos))
      lots = MathAbs(openpos.lots);
   return lots;
}

// get openprice of last position
double MyOrderLastOpenPrice(int pos_id=0)
{
   MyPosition openpos, closepos;
   double price = 0;
   if(RetrieveLastPosition(pos_id, openpos, closepos))
      price = openpos.price;
   return price;
}

// get closeprice of last position
double MyOrderLastClosePrice(int pos_id=0)
{
   MyPosition openpos, closepos;
   double price = 0;
   if(RetrieveLastPosition(pos_id, openpos, closepos))
      price = closepos.price;
   return price;
}

// get order open time of last position
datetime MyOrderLastOpenTime(int pos_id=0)
{
   MyPosition openpos, closepos;
   datetime opentime = 0;
   if(RetrieveLastPosition(pos_id, openpos, closepos))
      opentime = openpos.time;
   return opentime;   
}

// get order close time of last position
datetime MyOrderLastCloseTime(int pos_id=0)
{
   MyPosition openpos, closepos;
   datetime closetime = 0;
   if(RetrieveLastPosition(pos_id, openpos, closepos))
      closetime = closepos.time;
   return closetime;   
}

// get profit of last position in pips
double MyOrderLastProfitPips(int pos_id=0)
{
   MyPosition openpos, closepos;
   double profit = 0;
   if(RetrieveLastPosition(pos_id, openpos, closepos))
   {
      if(openpos.lots > 0) profit = closepos.price - openpos.price;
      if(openpos.lots < 0) profit = openpos.price - closepos.price;
   }
   return profit/PipPoint;
}

// get profit of last position
double MyOrderLastProfit(int pos_id=0)
{
   return MyOrderLastProfitPips(pos_id)
      *SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE)
      *SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE)
      *MyOrderLastLots(pos_id)*0.0001;
}

// print order information
void MyOrderPrint(int pos_id=0)
{
   double minlots = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   int lots_digits = (int)(MathLog10(1.0/minlots));
   string stype[] = {"buy", "sell", "buy limit", "sell limit",
                     "buy stop", "sell stop"};
   string s = "MyPos[" + IntegerToString(pos_id) + "] ";
   if(MyOrderType(pos_id) == OP_NONE) s = s + "No position";
   else
   {
      s = s + "#";
      if(MyPos[pos_id].ticket > 0)
         s = s + IntegerToString(MyPos[pos_id].ticket);
      else if(MyPos[pos_id].order_limit > 0)
              s = s + IntegerToString(MyPos[pos_id].order_limit);
      else if(MyPos[pos_id].order_stop > 0)
              s = s + IntegerToString(MyPos[pos_id].order_stop);
      s = s + " ["
            + TimeToString(MyOrderOpenTime(pos_id))
            + "] "
            + stype[MyOrderType(pos_id)]
            + " "
            + DoubleToString(MyOrderLots(pos_id), lots_digits)
            + " "
            + Symbol()
            + " at " 
            + DoubleToString(MyOrderOpenPrice(pos_id), _Digits);
      if(MyOrderStopLoss(pos_id) != 0) s = s + " sl "
         + DoubleToString(MyOrderStopLoss(pos_id), _Digits);
      if(MyOrderTakeProfit(pos_id) != 0) s = s + " tp "
         + DoubleToString(MyOrderTakeProfit(pos_id), _Digits);
      s = s + " magic ";
      if(MyOrderType(pos_id) % 2 == 0)
         s = s + IntegerToString( MAGIC_B[pos_id]);
      else s = s + IntegerToString(MAGIC_S[pos_id]);
   }
   Print(s);
}

// OrderSend retcode description
string RetcodeDescription(int retcode)
{
   switch(retcode)
   {
      case TRADE_RETCODE_REQUOTE:
           return("Requote");
      case TRADE_RETCODE_REJECT:
           return("Request rejected");
      case TRADE_RETCODE_CANCEL:
           return("Request canceled by trader");
      case TRADE_RETCODE_PLACED:
           return("Order placed");
      case TRADE_RETCODE_DONE:
           return("Request completed");
      case TRADE_RETCODE_DONE_PARTIAL:
           return("Only part of the request was completed");
      case TRADE_RETCODE_ERROR:
           return("Request processing error");
      case TRADE_RETCODE_TIMEOUT:
           return("Request canceled by timeout");
      case TRADE_RETCODE_INVALID:
           return("Invalid request");
      case TRADE_RETCODE_INVALID_VOLUME:
           return("Invalid volume in the request");
      case TRADE_RETCODE_INVALID_PRICE:
           return("Invalid price in the request");
      case TRADE_RETCODE_INVALID_STOPS:
           return("Invalid stops in the request");
      case TRADE_RETCODE_TRADE_DISABLED:
           return("Trade is disabled");
      case TRADE_RETCODE_MARKET_CLOSED:
           return("Market is closed");
      case TRADE_RETCODE_NO_MONEY:
           return("There is not enough money to complete the request");
      case TRADE_RETCODE_PRICE_CHANGED:
           return("Prices changed");
      case TRADE_RETCODE_PRICE_OFF:
           return("There are no quotes to process the request");
      case TRADE_RETCODE_INVALID_EXPIRATION:
           return("Invalid order expiration date in the request");
      case TRADE_RETCODE_ORDER_CHANGED:
           return("Order state changed");
      case TRADE_RETCODE_TOO_MANY_REQUESTS:
           return("Too frequent requests");
      case TRADE_RETCODE_NO_CHANGES:
           return("No changes in request");
      case TRADE_RETCODE_SERVER_DISABLES_AT:
           return("Autotrading disabled by server");
      case TRADE_RETCODE_CLIENT_DISABLES_AT:
           return("Autotrading disabled by client terminal");
      case TRADE_RETCODE_LOCKED:
           return("Request locked for processing");
      case TRADE_RETCODE_FROZEN:
           return("Order or position frozen");
      case TRADE_RETCODE_INVALID_FILL:
           return("Invalid order filling type");
      case TRADE_RETCODE_CONNECTION:
           return("No connection with the trade server");
      case TRADE_RETCODE_ONLY_REAL:
           return("Operation is allowed only for live accounts");
      case TRADE_RETCODE_LIMIT_ORDERS:
           return("The number of pending orders has reached the limit");
      case TRADE_RETCODE_LIMIT_VOLUME:
           return("The volume of orders has reached the limit");
   }
   return IntegerToString(retcode) + " Unknown Retcode";
}

// Init MQL4 compatible variables
void InitRates()
{
   ArraySetAsSeries(Open, true);
   ArraySetAsSeries(Low, true);
   ArraySetAsSeries(High, true);
   ArraySetAsSeries(Close, true);
   ArraySetAsSeries(Time, true);
   ArraySetAsSeries(Volume, true);
}

// Refresh MQL4 compatible variables
bool RefreshRates()
{
   if(!RefreshPrice(Bid, Ask)) return false;
   if(CopyOpen(_Symbol, PERIOD_CURRENT, 0, MY_BUFFER_SIZE, Open)
      < MY_BUFFER_SIZE) return false;
   if(CopyLow(_Symbol, PERIOD_CURRENT, 0, MY_BUFFER_SIZE, Low)
      < MY_BUFFER_SIZE) return false;
   if(CopyHigh(_Symbol, PERIOD_CURRENT, 0, MY_BUFFER_SIZE, High)
      < MY_BUFFER_SIZE) return false;
   if(CopyClose(_Symbol, PERIOD_CURRENT, 0, MY_BUFFER_SIZE, Close)
      < MY_BUFFER_SIZE) return false;
   if(CopyTime(_Symbol, PERIOD_CURRENT, 0, MY_BUFFER_SIZE, Time)
      < MY_BUFFER_SIZE) return false;
   if(CopyTickVolume(_Symbol, PERIOD_CURRENT, 0, MY_BUFFER_SIZE, Volume)
      < MY_BUFFER_SIZE) return false;
   return true;
}
