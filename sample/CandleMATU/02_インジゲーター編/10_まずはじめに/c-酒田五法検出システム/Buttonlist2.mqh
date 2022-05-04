//+------------------------------------------------------------------+
//|                                                       Buttonlist.mqh |
//|                                             Copyright 2018, ands |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, ands"
#property link      ""
#property strict

string obj_name[10] = {
                                          "akasanpeibutton", 
                                          "kurosanpeibutton", 
                                          "sanzanbutton", 
                                          "sansenbutton", 
                                          "sanzonbutton",
                                          "gyakusanzonbutton",
                                          "sankuhumibutton", 
                                          "sankutatakibutton",
                                          "agesanpoubutton",
                                          "sagesanpoubutton"
                                          /*"sansenake",
                                          "sansenyoi",
                                          "sansenuwabanare",
                                          "sansenyoizyu"
                                          "akasakidumari",
                                          "akasian",
                                          "bouzusanba",
                                          "douzisanba",
                                          "uwabanaresanpou",
                                          "sitabanaresanpou"*/
                                        };
                         
string obj_aname[10] = {
                                            "akasanpeiabutton", 
                                            "kurosanpeiabutton", 
                                            "sanzanabutton", 
                                            "sansenbutton", 
                                            "sanzonabutton",
                                            "gyakusanzonabutton",
                                            "sankuhumiabutton", 
                                            "sankutatakiabutton",
                                            "agesanpouabutton",
                                            "sagesanpouabutton"
                                          };
                                                  
string obj_text[10] = {
                                        "A 赤三兵",
                                        "B 黒三兵",
                                        "C 三山" ,
                                        "D 三川" ,
                                        "E 三尊" ,
                                        "F 逆三尊" ,
                                        "G三空踏み",
                                        "H三空叩き" ,
                                        "I上げ三法",
                                        "J下げ三法",
                                        
                                      };

void create_button(string name,string text,int y){

         int    chart_id = 0;
      
         ObjectCreate(chart_id,               // どのチャートに作成するか（chart_idを０という値で宣言していますが０は現在のチャートになります）
                                   name,                    // 作成するオブジェクトの名前
                                   OBJ_BUTTON,     // オブジェクトタイプ。今回はボタンを作成したいのですでに存在するOBJ_BUTTONを指定。
                                   0,                            // ウインドウ番号。０ならメインウィンドウ、１ならサブウィンドウにオブジェクトが作成されます。
                                   0,                            // 1番目の時間のアンカーポイント（位置の指定を行いますが後で細かく決めるので今は０で構いません。）
                                   0                             // 1番目の価格のアンカーポイント（位置の指定を行いますが後で細かく決めるので今は０で構いません。）
          );
          
          ObjectSet(name,OBJPROP_COLOR,clrBlack);    // 色設定
          ObjectSet(name,OBJPROP_BACK,false);            // オブジェクトの背景表示設定
          ObjectSet(name,OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定
          ObjectSet(name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
          ObjectSet(name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
          ObjectSet(name,OBJPROP_ZORDER,0);            // オブジェクトのチャートクリックイベント優先順位
            
          ObjectSetString(chart_id,name,OBJPROP_TEXT,text);            // 表示するテキスト
          ObjectSetString(chart_id,name,OBJPROP_FONT,"ＭＳ　ゴシック");          // フォント
      
          ObjectSet(name,OBJPROP_FONTSIZE,12);                  // フォントサイズ
          ObjectSet(name,OBJPROP_CORNER,0);                       // コーナーアンカー設定（0：左上　１：右上　２：左下　３：右下　の順になります）
          ObjectSet(name,OBJPROP_XDISTANCE,5);                // X座標（x座標は常に固定です。コーナーアンカーから中心に向かっての距離になります）
          ObjectSet(name,OBJPROP_YDISTANCE,y);                 // Y座標（yは元ファイルにて設定します）
          ObjectSet(name,OBJPROP_XSIZE, 80);                    // ボタンサイズ幅
          ObjectSet(name,OBJPROP_YSIZE,20);                     // ボタンサイズ高さ
          ObjectSet(name,OBJPROP_BGCOLOR,clrLightCyan);         // ボタン色
          ObjectSet(name,OBJPROP_BORDER_COLOR,clrAqua);       // ボタン枠色
          ObjectSet(name,OBJPROP_STATE,false);                  // ボタン押下状態          
}


void create_abutton(string name,int y){

         int    chart_id = 0;
      
         ObjectCreate(chart_id,               // どのチャートに作成するか（chart_idを０という値で宣言していますが０は現在のチャートになります）
                                   name,                    // 作成するオブジェクトの名前
                                   OBJ_BUTTON,     // オブジェクトタイプ。今回はボタンを作成したいのですでに存在するOBJ_BUTTONを指定。
                                   0,                            // ウインドウ番号。０ならメインウィンドウ、１ならサブウィンドウにオブジェクトが作成されます。
                                   0,                            // 1番目の時間のアンカーポイント（位置の指定を行いますが後で細かく決めるので今は０で構いません。）
                                   0                             // 1番目の価格のアンカーポイント（位置の指定を行いますが後で細かく決めるので今は０で構いません。）
          );
          
          ObjectSet(name,OBJPROP_COLOR,clrBlack);    // 色設定
          ObjectSet(name,OBJPROP_BACK,false);            // オブジェクトの背景表示設定
          ObjectSet(name,OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定
          ObjectSet(name,OBJPROP_SELECTED,false);      // オブジェクトの選択状態
          ObjectSet(name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
          ObjectSet(name,OBJPROP_ZORDER,0);            // オブジェクトのチャートクリックイベント優先順位
            
          ObjectSetString(chart_id,name,OBJPROP_TEXT,"♪");            // 表示するテキスト
          ObjectSetString(chart_id,name,OBJPROP_FONT,"ＭＳ　ゴシック");          // フォント
      
          ObjectSet(name,OBJPROP_FONTSIZE,12);                  // フォントサイズ
          ObjectSet(name,OBJPROP_CORNER,0);                       // コーナーアンカー設定（0：左上　１：右上　２：左下　３：右下　の順になります）
          ObjectSet(name,OBJPROP_XDISTANCE,90);                // X座標（x座標は常に固定です。コーナーアンカーから中心に向かっての距離になります）
          ObjectSet(name,OBJPROP_YDISTANCE,y);                 // Y座標（yは元ファイルにて設定します）
          ObjectSet(name,OBJPROP_XSIZE, 20);                    // ボタンサイズ幅
          ObjectSet(name,OBJPROP_YSIZE,20);                     // ボタンサイズ高さ
          ObjectSet(name,OBJPROP_BGCOLOR,clrLightCyan);         // ボタン色
          ObjectSet(name,OBJPROP_BORDER_COLOR,clrAqua);       // ボタン枠色
          ObjectSet(name,OBJPROP_STATE,false);                  // ボタン押下状態          
}

void hide_button(){

         int    chart_id = 0;
      
         ObjectCreate(chart_id,               // どのチャートに作成するか（chart_idを０という値で宣言していますが０は現在のチャートになります）
                                   "hideButton",                    // 作成するオブジェクトの名前
                                   OBJ_BUTTON,     // オブジェクトタイプ。今回はボタンを作成したいのですでに存在するOBJ_BUTTONを指定。
                                   0,                            // ウインドウ番号。０ならメインウィンドウ、１ならサブウィンドウにオブジェクトが作成されます。
                                   0,                            // 1番目の時間のアンカーポイント（位置の指定を行いますが後で細かく決めるので今は０で構いません。）
                                   0                             // 1番目の価格のアンカーポイント（位置の指定を行いますが後で細かく決めるので今は０で構いません。）
          );
          
          ObjectSet("hideButton",OBJPROP_COLOR,clrBlack);    // 色設定
          ObjectSet("hideButton",OBJPROP_BACK,false);            // オブジェクトの背景表示設定
          ObjectSet("hideButton",OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定
          ObjectSet("hideButton",OBJPROP_SELECTED,false);      // オブジェクトの選択状態
          ObjectSet("hideButton",OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
          ObjectSet("hideButton",OBJPROP_ZORDER,0);            // オブジェクトのチャートクリックイベント優先順位
            
          ObjectSetString(chart_id,"hideButton",OBJPROP_TEXT,"非表示");            // 表示するテキスト
          ObjectSetString(chart_id,"hideButton",OBJPROP_FONT,"ＭＳ　ゴシック");          // フォント
      
          ObjectSet("hideButton",OBJPROP_FONTSIZE,12);                  // フォントサイズ
          ObjectSet("hideButton",OBJPROP_CORNER,0);                       // コーナーアンカー設定（0：左上　１：右上　２：左下　３：右下　の順になります）
          ObjectSet("hideButton",OBJPROP_XDISTANCE,5);                // X座標（x座標は常に固定です。コーナーアンカーから中心に向かっての距離になります）
          ObjectSet("hideButton",OBJPROP_YDISTANCE,30);                 // Y座標（yは元ファイルにて設定します）
          ObjectSet("hideButton",OBJPROP_XSIZE, 80);                    // ボタンサイズ幅
          ObjectSet("hideButton",OBJPROP_YSIZE,20);                     // ボタンサイズ高さ
          ObjectSet("hideButton",OBJPROP_BGCOLOR,clrPink);              // ボタン色
          ObjectSet("hideButton",OBJPROP_BORDER_COLOR,clrAqua);       // ボタン枠色
          ObjectSet("hideButton",OBJPROP_STATE,false);                  // ボタン押下状態
}


void on_button(){

         int    chart_id = 0;
      
         ObjectCreate(chart_id,               // どのチャートに作成するか（chart_idを０という値で宣言していますが０は現在のチャートになります）
                                   "onbutton",                    // 作成するオブジェクトの名前
                                   OBJ_BUTTON,     // オブジェクトタイプ。今回はボタンを作成したいのですでに存在するOBJ_BUTTONを指定。
                                   0,                            // ウインドウ番号。０ならメインウィンドウ、１ならサブウィンドウにオブジェクトが作成されます。
                                   0,                            // 1番目の時間のアンカーポイント（位置の指定を行いますが後で細かく決めるので今は０で構いません。）
                                   0                             // 1番目の価格のアンカーポイント（位置の指定を行いますが後で細かく決めるので今は０で構いません。）
          );
          
          ObjectSet("onbutton",OBJPROP_COLOR,clrBlack);    // 色設定
          ObjectSet("onbutton",OBJPROP_BACK,false);            // オブジェクトの背景表示設定
          ObjectSet("onbutton",OBJPROP_SELECTABLE,false);     // オブジェクトの選択可否設定
          ObjectSet("onbutton",OBJPROP_SELECTED,false);      // オブジェクトの選択状態
          ObjectSet("onbutton",OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
          ObjectSet("onbutton",OBJPROP_ZORDER,0);            // オブジェクトのチャートクリックイベント優先順位
            
          ObjectSetString(chart_id,"onbutton",OBJPROP_TEXT,"ON");            // 表示するテキスト
          ObjectSetString(chart_id,"onbutton",OBJPROP_FONT,"ＭＳ　ゴシック");          // フォント
      
          ObjectSet("onbutton",OBJPROP_FONTSIZE,8);                  // フォントサイズ
          ObjectSet("onbutton",OBJPROP_CORNER,0);                       // コーナーアンカー設定（0：左上　１：右上　２：左下　３：右下　の順になります）
          ObjectSet("onbutton",OBJPROP_XDISTANCE,90);                // X座標（x座標は常に固定です。コーナーアンカーから中心に向かっての距離になります）
          ObjectSet("onbutton",OBJPROP_YDISTANCE,30);                 // Y座標（yは元ファイルにて設定します）
          ObjectSet("onbutton",OBJPROP_XSIZE, 25);                    // ボタンサイズ幅
          ObjectSet("onbutton",OBJPROP_YSIZE,20);                     // ボタンサイズ高さ
          ObjectSet("onbutton",OBJPROP_BGCOLOR,clrLime);              // ボタン色
          ObjectSet("onbutton",OBJPROP_BORDER_COLOR,clrAqua);       // ボタン枠色
          ObjectSet("onbutton",OBJPROP_STATE,false);                  // ボタン押下状態
}

