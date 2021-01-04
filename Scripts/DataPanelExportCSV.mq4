//+------------------------------------------------------------------+
//|                                           DataPanelExportCSV.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#property    show_inputs      //実行する前にパラメーターウィンドウを表示する
#define      BUF_MAX 4        //保存するバッファ数（ただし、FileWriteのdata[0]～data[BUF_MAX-1]は自分で指定する必要あり）

input string InpFileName = "HeikenAshi.csv";    //CSVファイルの名前(\\MQL4\Files\ に配置)
input string InpIndicatorName = "Heiken Ashi";  //インディケーターの名前(\MQL4\Indicators から検索)


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    //ファイルのオープン。
    int handle;

    //ファイルの新規書き込み(上書き)
    handle=FileOpen(InpFileName,FILE_CSV|FILE_WRITE,',');
    
    //ファイルのオープンに失敗した時
    if(handle<1){
        Print("File("+InpFileName+") Open error(",GetLastError(),")");
        return;
    }

    //CSVファイルにヘッダーを書き込み
    if(FileWrite(handle,
                 "yyyy.mm.dd",
                 "hh:mi:ss",
                 "始値",
                 "高値",
                 "低値",
                 "終値",
                 "Volume",
                 "Low/High",
                 "High/Low",
                 "Open",
                 "Close") == 0 ){
        Print("書き込みエラー発生");
        return;
    }

    //データの書き込み
    for(int i=Bars-1; i>=0; i--) {
        
        //data配列の宣言
        double data[BUF_MAX];

        //対象インジゲーターの値を取得
        for(int j=0; j<BUF_MAX; j++) {
            data[j]=iCustom(NULL,              //通貨ぺア(NULLは現在の通貨ペア)
                            PERIOD_CURRENT,    //時間軸(現在チャートの時間軸)
                            InpIndicatorName,  //カスタムインジケーター名
                            Red,    //1 カスタムインジケーターの入力パラメタ
                            White,  //2 カスタムインジケーターの入力パラメタ
                            Red,    //3 カスタムインジケーターの入力パラメタ
                            White,  //4 カスタムインジケーターの入力パラメタ
                            j,   //ラインインデックス
                            i);  //足番号(0が最新)
        }

        //CSVファイルに１行書き込み
        if(FileWrite(handle,
                     TimeToStr(Time[i],TIME_DATE),     //"yyyy.mm.dd"フォーマット
                     TimeToStr(Time[i],TIME_SECONDS),  //"hh:mi:ss"フォーマット
                     Open[i],
                     High[i],
                     Low[i],
                     Close[i],
                     Volume[i],
                     data[0],
                     data[1],
                     data[2],
                     data[3]) == 0 ){
            Print("書き込みエラー発生");
            return;
        }

    }

    //ファイルのクローズ
    FileClose(handle);
    Print("書き込み成功");

}
//+------------------------------------------------------------------+
