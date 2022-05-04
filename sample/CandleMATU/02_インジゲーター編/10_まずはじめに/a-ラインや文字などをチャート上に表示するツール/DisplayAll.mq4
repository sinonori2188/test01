//メタエディターでは、コードが自動的に色づけされます。初めのうちの認識としては、
//青と紫の文字になるものはすでにデフォルトで備わっている関数でサイトなどで全て確認できます。
//黒と緑の文字になるものは自分で好きな言葉で決めることができます。（日本語不可）
//色に関してはすでに決まった色の名前にしないといけません。最初を大文字にするのをお忘れなく。

//versionはインジケーターのバージョンを設定するもので、任意で決めることができます。
#property version "1.0"

//indicator_chart_windowはメインウィンドウに対して機能させたい場合
//サブウィンドウに何かを表示したい場合はindicator_separate_windowに変更します。
#property indicator_chart_window


//一番初めに、その中で使いたい変数の宣言をしておきます。これから下の項目を使いますよ、とプログラムに分からせるんですね。
//int型なら整数の数字、string型なら文字列を入れる変数たち、という意味になります。全部好きな言葉で決めることができます。
int NowBars, limit, a, b, c, d, e, f, g, h, j, k, t, indexhigh, indexlow = 0;
string text1 = "陽線", text2 = "陰線"; 
double Highest_Price, Lowest_Price, fibo_highest, fibo_lowest;

//init関数と言ってインジケーターを入れたとき一番最初に一度だけ通る箇所になります。
//ここではインジケーターを入れたときに必ず行いたい設定を書いておきます。
int init(){
   
   return(0);
}


//ここからのstart関数が最も重要になります。ほとんどすべての要素がこの中に入ります。
//考え方としてはロウソク足の値動きが１回あるたびにこのstart関数の中を一案上から一番↓まで超高速で一回駆け抜けるというイメージを持ってください。
//例えば１分足が完成するまでに３０回値段が動いたら３０周通ることになります。１回しか値動きがなかったら１回しか通りません。
//決して、ロウソク足１本につき１回通る、ということではないので注意が必要です。
int start(){  
//Bars-IndicatorCounted()-1これは定型として覚えておいたほうがいいでしょう。
//Barsはチャートの中にある全てのロウソク足の本数を取得します。
//IndicatorCounted()は確定してもう動かないロウソク足の数を取得します。
//インジケーターを入れた瞬間は確定したものはないとされ０が取得されますが、
//１度値動きがあってstart関数を２周目してきた時には今動いている足より前の足に関しては動かないとしてその数が取得されます。
//なのでBars-IndicatorCounted()では２回目以降は常に現在動いている足のみが取得され常に１になります。
//しかし、BarsとIndicatorCounted()の数の取得に誤差が起こり２になってしまうため、最後に-1しています。
//これで最新の今動いている足に関しての情報だけを判断するような設定にできました。
//そうする理由は、値動きの度に全ロウソク足をまた１から判断していくと処理に負担がかかり動作が重くなってしまうためです。

   limit = Bars-IndicatorCounted()-1;
   
//for関数は繰り返し処理を表します。iという値に最初にlimitという数字を入れて、0以上の間はずっと-1していく、という意味になります。
//一回forの最後まで到達するとiは-1されてまたforの上から下まで通る、ということをiが０になるまで繰り返すわけです。
//limitは最初はどんな数が入るでしょうか？IndicatorCounted()は一番最初は０なので、初めのBars-IndicatorCounted()-1;の
//値は全ロウソク足の数-1になります。
//仮に全ロウソク足が5000本あったとしたら、i=5000が初めの数になり、それが０になるまで4999,4998,4997....と１ずつ減っていき、
//０になったらforは役目を終えてfor文を抜けます。
//そして、これは値動きが一回あったらその瞬間にforを指定回数（i=5000なら一瞬で-5000まで）繰り返します。
//１回の値動きで-1されるわけではないので注意が必要です。
   for(int i=limit; i>=0; i--){

//下のif文は、iが１より大きい時、またはi=1でありNowBarsがBarsよりも小さい時にその中を通る、という意味になります。
//どういうことかというと、iが１より大きい時、つまり過去の足を遡って条件を探した時はそのまま通っていいが、i=1、
//つまり現在動いている足が確定した瞬間のその確定した足に関しての条件は
//次の足が確定するまでの間に一回しかとしたくないためこの処理をしています。
//if文中のすぐの所でNowBarsにBars、つまり現状の全ロウソク足の数を入れています。これで、チャートの足が１本増えない限りは
//NowBars < Barsを満たすことはないわけです。
//具体的な数字で考えると、最初はNowBarsは0のためNowBars < Barsを満たします。
//そしてすぐにNowBarsはBars（今回は5000とします）の数となります。
//値動きがもう一度あると再度forを通り、このifに戻ってきます。その時NowBarsは5000、Barsは足がまだ増えていなければ5000のままです。
//するとNowBars < Barsを満たしません。
//そして値動きが何回あろうと条件が合わないのでこのifの中を通ることはなく、足が増えるとNowBarsは5000、Barsは5001となるため
//NowBars < Barsを満たすので、if文を通るという仕組みです。
//こうしないと、値動きがあるたびにアラートが鳴ったりサインが重なって出てしまうなどの不具合が起こってしまいます。
      if(i > 1 || (i == 1 && NowBars < Bars)){
          NowBars = Bars;
          
          //文字の表示 陽線の上に「陽線」という文字を表示させてみます。
          if(iOpen(NULL,0,i) < iClose(NULL,0,i)){ 
          //陽線の条件は、その足の始値が終値よりも小さい時、となります。
          //iOpen,iCloseはそれぞれすでに決まっている関数で（）の中は左から通貨名/時間足/判断する足の位置となります。
              
              //ObjectCreateで作りたいオブジェクトを決めます。今回はテキストですね。
              //（）の中は左から、オブジェクトの名前, オブジェクトの種類, ,メインウィンドウ(0)かサブウィンドウ(1)か, オブジェクトを置く時間(縦軸), 
              //オブジェクトを置く価格(横軸).これらを必ず決めてあげます。
              //IntegerToString(a)というのはint型のaをstring型、つまり文字タイプに変換しています。
              //理由はaを今回は名前の一部として使用するため、数字型ではなく文字型にしています。
              //下でa++(aを＋１)することで、オブジェクトの名前は〇〇１、〇〇２・〇〇３と末尾が変わり別々のオブジェクトとして認識されます。
              //そうしなければ同じ名前のオブジェクトになってしまい、情報が上書きされてしまいます。
               ObjectCreate("DAyousen"+IntegerToString(a), OBJ_TEXT, 0, iTime(NULL,0,i), iHigh(NULL,0,i)+10*Point);
               ObjectSetText("DAyousen"+IntegerToString(a), text1, 12, "MSゴシック", Gold); 
              //ここで条件をセットするオブジェクトの名前を指定して、セットする内容を書いていきます。
              //ObjectSetText関数の場合は左からオブジェクト名, テキスト内容, フォントサイズ, 書体, 文字色が指定できます。
              a++; //オブジェクト名を変えるために末尾の数字を＋１します。
          }
          
          //【問題】
          //陰線の下10pipsの位置に「陰線」というテキストを表示させてみてください。
          //---ここから記述
          if(iClose(NULL,0,i) < iOpen(NULL,0,i)){ //陰線は、足の始値が終値よりも大きい時
          ObjectCreate("DAinsen"+IntegerToString(g), OBJ_TEXT, 0, iTime(NULL,0,i), iLow(NULL,0,i)-100*Point); //1Point=0.1pips
          ObjectSetText("DAinsen"+IntegerToString(g), text2, 12, "MSゴシック", Gold);
          g++;
          }
          //---ここまで
          
          
          //ラインの表示 陽線が4本連続したら最後の足に縦ラインを引いてみます。
          if(iOpen(NULL,0,i+3) < iClose(NULL,0,i+3) && //3本前が陽線
              iOpen(NULL,0,i+2) < iClose(NULL,0,i+2) && //2本前が陽線 
              iOpen(NULL,0,i+1) < iClose(NULL,0,i+1) && //1本前が陽線 
              iOpen(NULL,0,i) < iClose(NULL,0,i)){ //今足が陽線
              ObjectCreate("DAvline"+IntegerToString(b), OBJ_VLINE, 0, iTime(NULL,0,i), 0); 
               //縦線はOBJ_VLINEで作成でき、時間軸があれば価格は必要ないので０としています。
              ObjectSet("DAvline"+IntegerToString(b), OBJPROP_COLOR, Yellow); //OBJPROP_COLORという決まった関数で色を指定しています。
              b++;
          }
          
          //【問題】
          //陰線が２本続いて、その後に陽線が２本続いた時、最後の陽線の足に赤色の縦線を表示させてみてください。
          //---ここから記述
          if(iClose(NULL,0,i+3) < iOpen(NULL,0,i+3) && //3本前が陰線
             iClose(NULL,0,i+2) < iOpen(NULL,0,i+2) && //2本前が陰線
             iOpen(NULL,0,i+1) < iClose(NULL,0,i+1) && //1本前が陽線
             iOpen(NULL,0,i) < iClose(NULL,0,i)){ //今足が陽線
             ObjectCreate("DA2vline"+IntegerToString(h), OBJ_VLINE, 0, iTime(NULL,0,i), 0);
             ObjectSet("DA2vline"+IntegerToString(h), OBJPROP_COLOR, Red);
             h++;
          }
          //---ここまで          


          //記号の表示 3分おきにロウソク足の上に矢印を表示させてみます。
          if(MathMod(TimeMinute(TimeCurrent()), 3) == 0){ 
          //MathModは余りを出す関数、TimeMinuteは指定したタイミングの分数を取得します。TimeCurrent はMT4上の現在の時間のことです。
          //MathModの()は左が割られる数、右が割る数、＝＝のあとが余りなので、
          //意味としてはMT4の今の時間を3で割った余りが０、つまり3で割り切れる分数となります。
              ObjectCreate("DAallow"+IntegerToString(c), OBJ_ARROW, 0, iTime(NULL,0,i), iHigh(NULL,0,i)+30*Point);        
              ObjectSet("DAallow"+IntegerToString(c), OBJPROP_ARROWCODE, 242);  
              ObjectSet("DAallow"+IntegerToString(c), OBJPROP_COLOR, Aqua);
              ObjectSet("DAallow"+IntegerToString(c), OBJPROP_WIDTH, 3);      
              c++;
              //OBJ_ARROWで記号を表し、それをどこに表示させるかを指定します。記号は決まって点が必要なので、時間も価格も指定します。
              //OBJPROP_ARROWCODEで記号の種類を指定します。決まった記号番号の中から希望の番号を選ぶだけです。
              //番号リストはこちら→https://gyazo.com/034fcf7556aff433498835739def8049
          }   
            
          
          //【問題】
          //5分ごとの、その1分前（5分なら4分、10分なら9分、15分なら14分）の足の安値の下のどこかに爆弾記号を表示させてみてください。
          //---ここから記述
          if(MathMod(TimeMinute(TimeCurrent()), 5) == 0){ 
             ObjectCreate("DAbomb"+IntegerToString(j), OBJ_ARROW, 0, iTime(NULL,0,i+1), iLow(NULL,0,i)-30*Point);
             ObjectSet("DAbomb"+IntegerToString(j), OBJPROP_ARROWCODE, 77);
             ObjectSet("DAbomb"+IntegerToString(j), OBJPROP_COLOR, Aqua);
             ObjectSet("DAbomb"+IntegerToString(j), OBJPROP_WIDTH, 3);
             j++;
          }
          //---ここまで                         
          
          
          //長方形の作成 連続する５本のロウソク足の中で、３本目が一番高いような時、その５本のロウソク足を囲うように長方形を作成してみます。
          indexhigh = iHighest(NULL,0,MODE_HIGH,5,i); 
           //iHighestではバーの位置を取得できます。
           //()の右３つは高値を比べる, ５本の中で, i本前からとなり、５本中で最高値のバーの位置を取得しています。
          Highest_Price = iHigh(NULL,0,indexhigh); 
           //Highest_Priceでその最高値の位置のロウソク足の高値を保存します。あくまでiHighestは位置を取得しただけです。
          indexlow = iLowest(NULL,0,MODE_LOW,5,i);          
          Lowest_Price = iLow(NULL,0,indexlow);                    
          if(iHigh(NULL,0,i+2) == Highest_Price){ 
           //５本の真ん中はi+2となりますので、その高値と先ほどの５本の中の最高値が同じであれば真ん中が最高値だったということになります。
              ObjectCreate("DArec"+IntegerToString(d), OBJ_RECTANGLE, 0, iTime(NULL,0,i+4), Lowest_Price, iTime(NULL,0,i), Highest_Price);
              d++;
              //OBJ_RECTANGLEで長方形を意味し、長方形は４角の４点の情報が必要になりますので、時間と価格をそれぞれ２つずつ指定します。
              //時間は４本前と今の足の２つ、価格は最高値と最安値の２つです。これで５本中の最高値と最安値を覆う長方形が作成されました。
              //長方形に対しての追加の条件は他と同様にObjectSetで同じ名前を指定すれば可能です。
          }
          
          //【問題】
          //７本のロウソク足の中で真ん中が最安値であり、かつ「陽線」だった場合に、その７本の最高値と最安値と、
          //７本前から今の足を覆うような形で長方形を作成してみてください。
          //そして、その長方形の色をOrange（このまま色の名前として使えます）にしてみてください。
          //---ここから記述
          indexhigh = iHighest(NULL,0,MODE_HIGH,7,i); //７本中
          Highest_Price = iHigh(NULL,0,indexhigh);
          indexlow = iLowest(NULL,0,MODE_LOW,7,i);
          Lowest_Price = iLow(NULL,0,indexlow);
          if(iLow(NULL,0,i+3) == Lowest_Price && //７本の真ん中はi+3、その安値と７本中の最安値が同じなら真ん中は最安値
             iOpen(NULL,0,i+3) < iClose(NULL,0,i+3)){ //真ん中が陽線
             ObjectCreate("DA2rec"+IntegerToString(k), OBJ_RECTANGLE, 0, iTime(NULL,0,i+6), Lowest_Price, iTime(NULL,0,i), Highest_Price);
             ObjectSet("DA2rec"+IntegerToString(k), OBJPROP_COLOR, Orange);
             k++;
          }
          //---ここまで                  
          
          
         //その他
         //１０本前の高値と今の足の高値にトレンドラインを引いてみます。
         t++; 
          //トレンドラインが引かれている１０本間は他のトレンドラインを引いてほしくないので、
          //足が１本増えるたびにカウントを１つ増やしてそれが１０になった時だけ新規のトレンドラインを作ります。
         if(t == 10){
             ObjectCreate("DAtrend"+IntegerToString(e), OBJ_TREND, 0, iTime(NULL,0,i+9), iHigh(NULL,0,i+9), iTime(NULL,0,i), iHigh(NULL,0,i));        
             ObjectSet("DAtrend"+IntegerToString(e), OBJPROP_RAY, false); 
             //これは延長させないための条件です。falseだとトレンドラインの延長はさせません。trueだと延長させます。  
             e++;
             t = 0; //トレンドラインが引かれたらカウントは０に戻して、また１０カウントまでは次のトレンドラインは引かせません。
         }
          
         
         //フィボナッチリトリースメントを引いてみます。
         fibo_highest = iHigh(NULL,0,iHighest(NULL,0,MODE_HIGH,100,0));
         fibo_lowest = iLow(NULL,0,iLowest(NULL,0,MODE_LOW,100,0));
         ObjectCreate("DAfibo"+f, OBJ_FIBO, 0, iTime(NULL,0,100), fibo_highest, iTime(NULL,0,0), fibo_lowest);
         ObjectSet("DAfibo"+f, OBJPROP_FIBOLEVELS, 6); //レベルラインの数を指定します。
         ObjectSet("DAfibo"+f, OBJPROP_FIRSTLEVEL, 0.0); //各レベルの数値を決めていきます。
         ObjectSet("DAfibo"+f, OBJPROP_FIRSTLEVEL+1, 0.236);
         ObjectSet("DAfibo"+f, OBJPROP_FIRSTLEVEL+2, 0.382);
         ObjectSet("DAfibo"+f, OBJPROP_FIRSTLEVEL+3, 0.50);
         ObjectSet("DAfibo"+f, OBJPROP_FIRSTLEVEL+4, 0.618);
         ObjectSet("DAfibo"+f, OBJPROP_FIRSTLEVEL+5, 1.000);
         ObjectSet("DAfibo"+f,OBJPROP_HIDDEN,true); 
         //これはMT4の「表示中のライン」にオブジェクトを表示させるかを決められます。trueなら隠されるということで表示されません。動作が軽くなります。
         ObjectSet("DAfibo"+f, OBJPROP_LEVELWIDTH, 2);
         ObjectSetFiboDescription("DAfibo"+f,0,"0.0"); 
         //フィボナッチを引いた時の線の上にあるレベル数値の文字表示です。これを指定しない場合はどのレベルのラインかが表示されません。
         ObjectSetFiboDescription("DAfibo"+f,1,"23.6");
         ObjectSetFiboDescription("DAfibo"+f,2,"38.2");
         ObjectSetFiboDescription("DAfibo"+f,3,"50.0");
         ObjectSetFiboDescription("DAfibo"+f,4,"61.8");
         ObjectSetFiboDescription("DAfibo"+f,5,"100.0");         
         //f++; //今回、フィボナッチを増やしていくとかなり見にくくなってしまうため、
         //最新の１つしか表示しないように名前番号は増やさないようにしています。
                   
      } //この}でNowBarsで制限をかけていた条件を抜けます。この後値動きがあってもロウソク足が増えない限りは上記の条件文の中は通りません。 
   } //これがforの}で、ここから上までをi=limitからi=0になるまでiを-1していきます。
     //ここは値動き（ティック）毎に通るのですが、NowBarsによって弾かれる形です。

   return(0); //forも最後まで繰り返すと他の条件は何もなく、start関数は終わります。
              //次ティックでまたstart関数の一番初めに戻ります。それをティック毎に永遠と繰り返します。
}

//deinit関数はinit関数の反対で、インジケーターをチャートから削除した時に一度だけ呼び出されます。
//もし長方形やラインなどをObject関数を使って描画していたらここの中で消す処理を書いておかないと、
//インジケーターを除外してもチャートにはオブジェクトが残ったままになってしまいます。
//インジケーター中で何かオブジェクトを作成した場合は必ずdeinitの中で消すことを忘れないようにしましょう。
int deinit(){
//ここでは今まで作成したオブジェクトをインジケーター削除と同時に消す処理を書きます。
//下の５行は定型として覚えておきましょう。
//iには今チャートにあるオブジェクトの総数は入り、それが０になるまで１つずつ遡って見られていきます。
//string ObjName=ObjectName(i);では、i番目のオブジェクトの名前をObjNameとして、
//StringFind(ObjName, "DA") >= 0で"DA"という文字列が含まれているかチェックします。
//0以上ということは含まれていたということで、その場合ObjectDeleteでそのオブジェクトを削除します。これをObjectsTotalの数だけ繰り返します。
//（このためにすべてのオブジェクト名の頭にDAをつけていました）
//ObjectsDeletAllという関数でオブジェクトを一括で削除もできるのですが、
//これだと別で引いていた水平線やトレンドラインも一緒に消されてしまうので注意が必要です。
   for(int i = ObjectsTotal(); 0 <= i; i--) {
	   string ObjName=ObjectName(i);
	   if(StringFind(ObjName, "DA") >= 0)
   	      ObjectDelete(ObjName);
   }
   return(0);
}

