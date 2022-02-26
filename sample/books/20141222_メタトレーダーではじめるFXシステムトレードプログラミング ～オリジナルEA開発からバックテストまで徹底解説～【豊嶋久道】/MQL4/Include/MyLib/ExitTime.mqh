//ExitTime.mqh

input int ExpMin = 360;  // ポジション決済時間(分)
input int ExitHour = 22; // ポジション決済時刻(時)

//手仕舞いシグナル
bool ExitSignal(int sig_entry, int pos_id=0)
{
   int type = MyOrderType(pos_id); //ポジションの種類

   //一定時間経過後に決済
   if(type != OP_NONE 
      && TimeCurrent() - MyOrderOpenTime(pos_id) >= ExpMin*60)
      return true;

   //一定時刻に決済
   if(type != OP_NONE && Hour() == ExitHour) return true;

   return sig_entry; //シグナルの出力
}
