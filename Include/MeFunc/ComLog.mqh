//+------------------------------------------------------------------+
//|                                                       ComLog.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 関数名：LogWrite
//| 機　能：ログの出力
//| 詳　細：
//| 引　数：string str  ：ログ内容
//| 戻り値：なし
//+------------------------------------------------------------------+
void LogWrite(string str)
{
    string Filename = "aaa.txt"; //ここはＥＡ名などのお好きなファイル名（start関数の前に書くとスマートです）
    int Handle;
    Handle = FileOpen(Filename, FILE_READ|FILE_WRITE|FILE_CSV, "/t");

    if (Handle < 1){
        Print("Error opening audit file: Code ", GetLastError());
        return;
    }

    if (!FileSeek(Handle, 0, SEEK_END)){
        Print("Error seeking end of audit file: Code ", GetLastError());
        return;
    }

    if (FileWrite(Handle, TimeToStr(CurTime(), TIME_DATE|TIME_SECONDS) + " " + str) < 1){
        Print("Error writing to audit file: Code ", GetLastError());
        return;
    }
    FileClose(Handle);
}

//+------------------------------------------------------------------+
//| 関数名：WriteTradeLog
//| 機　能：取引ログの出力
//| 詳　細：
//| 引　数：signal　int str  ：シグナル
//| 戻り値：なし
//+------------------------------------------------------------------+
#ifdef DEBUG
//------------------------------------------------------------------
// 取引ログを出力する。
void WriteTradeLog(int signal)
{
    //ログファイル名が重複するのを避けるため、後ろに番号をつける。
    static string filename = "";
    if( filename == "" ){
        for( int i = 0 ; i < 9999; i++ ){
            filename = "sample1Log_" + IntegerToString(i) + ".csv";
            if( !FileIsExist(filename) ) break ;
        }
    }
    
    int handle = FileOpen(filename,  FILE_CSV|FILE_READ|FILE_WRITE, ',');
    
    // とりあえずログなのでファイルオープンできなかった場合は、何もしない。
    if( handle < 0 ) return ;
    
    // ヘッダ出力
    if( FileSize(handle) == 0 ){
        FileWrite(handle, "日本時間","シグナル","合計ポジション数", "マジックNo一致数", "シンボル一致数",
        "買","売","指値買","指値売","逆指値買","逆指値売");
    }

    // 最終行へ追加
    FileSeek(handle, 0, SEEK_END);
    
    int total = OrdersTotal();
    int matchingMagicCount = 0 ;
    int matchingSymbol = 0 ;
    
    int orderCount[6];
    ArrayInitialize(orderCount, 0);
    
    // 現時点でのオーダー数を取得する。
    for( int i = 0 ; i <total; i++){
        if( OrderSelect(i, SELECT_BY_POS) ){
            if( OrderMagicNumber() != MagicNumber ) continue;
                matchingMagicCount++;
            
            if( OrderSymbol() != Symbol() ) continue;
                matchingSymbol++;

            int orderType = OrderType();
            orderCount[orderType]++;
        }
    }
    
    FileWrite(handle, TimeToStr(TimeGMT() + 32400), signal,
              total, matchingMagicCount, matchingSymbol,
              orderCount[0], orderCount[1], orderCount[2],
              orderCount[3], orderCount[4], orderCount[5]);
    
    FileClose(handle);
}
#endif
