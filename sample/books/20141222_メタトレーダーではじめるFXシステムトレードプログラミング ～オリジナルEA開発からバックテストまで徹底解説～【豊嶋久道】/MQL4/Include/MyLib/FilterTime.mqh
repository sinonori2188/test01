//FilterTime.mqh

input int StartHour = 12; // 開始時刻（時）
input int EndHour = 20;   // 終了時刻（時）

//フィルタ関数
int FilterSignal(int signal, int pos_id=0)
{
   int ret = 0; //シグナルの初期化

   if(StartHour < EndHour) //日付をまたがない場合
   {
      if(Hour() >= StartHour && Hour() <= EndHour) ret = signal;
   }
   else //日付をまたぐ場合
   {
      if(Hour() >= StartHour || Hour() <= EndHour) ret = signal;
   }

   return ret; //シグナルの出力
}
