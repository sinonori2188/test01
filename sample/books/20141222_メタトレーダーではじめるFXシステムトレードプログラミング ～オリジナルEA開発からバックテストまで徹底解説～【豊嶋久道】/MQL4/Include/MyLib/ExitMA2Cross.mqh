//ExitMA2Cross.mqh
#include <Indicators\Indicators.mqh> //テクニカル指標クラスの定義

//テクニカル指標の設定
CiMA ExitFastMA, ExitSlowMA;     //移動平均のオブジェクト
input int ExitFastMAPeriod = 10; // 短期移動平均の期間
input int ExitSlowMAPeriod = 20; // 長期移動平均の期間

//手仕舞いシグナル
bool ExitSignal(int sig_entry, int pos_id=0)
{
   //テクニカル指標の初期化
   if(ExitFastMA.MaPeriod() < 0)
      ExitFastMA.Create(_Symbol, 0, ExitFastMAPeriod, 0,
                        MODE_SMA, PRICE_CLOSE);
   if(ExitSlowMA.MaPeriod() < 0)
      ExitSlowMA.Create(_Symbol, 0, ExitSlowMAPeriod, 0,
                        MODE_SMA, PRICE_CLOSE);

   //テクニカル指標の更新
   ExitFastMA.Refresh();
   ExitSlowMA.Refresh();

   int type = MyOrderType(pos_id); //ポジションの種類

   bool ret = false; //シグナルの初期化

   //買いシグナル
   if(type == OP_SELL
      && ExitFastMA.Main(1) > ExitSlowMA.Main(1)
      && ExitFastMA.Main(2) <= ExitSlowMA.Main(2)) ret = true;

   //売りシグナル
   if(type == OP_BUY
      && ExitFastMA.Main(1) < ExitSlowMA.Main(1)
      && ExitFastMA.Main(2) >= ExitSlowMA.Main(2)) ret = true;

   return ret | sig_entry; //シグナルの出力
}
