//メタエディターでは、コードが自動的に色づけされます。初めのうちの認識としては、
//青と紫の文字になるものはすでにデフォルトで備わっている関数でサイトなどで全て確認できます。
//黒と緑の文字になるものは自分で好きな言葉で決めることができます。（日本語不可）
//色に関してはすでに決まった色の名前にしないといけません。最初を大文字にするのをお忘れなく。

//versionはインジケーターのバージョンを設定するもので、任意で決めることができます。
#property version "1.0"

//indicator_chart_windowはメインウィンドウに対して機能させたい場合
//サブウィンドウに何かを表示したい場合はindicator_separate_windowに変更します。
#property indicator_chart_window

//indicator_buffersは下で設定する「バッファー」というものの数を指定します。表示させたい矢印や線など数がここの数字になります。
#property indicator_buffers 6

//末尾の１~6が各バッファーに対して割り当てられる設定になります。
//例えば「indicator_width1 3」の場合は、下で設定する１つ目のバッファーの〇〇（今回は矢印）の大きさを「３」に設定しています。
//その下では同様に１つ目のバッファーの色をRedに設定して、残り5つも同様にバッファーに対して大きさと色を設定しています。
//実際のバッファーの役割はこのあと与えていくことになります。
#property indicator_width1 3
#property indicator_color1 Red
#property indicator_width2 3
#property indicator_color2 White
#property indicator_width3 1
#property indicator_color3 Aqua
#property indicator_width4 1
#property indicator_color4 Orange
#property indicator_width5 1
#property indicator_color5 Blue
#property indicator_width6 1
#property indicator_color6 Magenta

//ここで各バッファーに対しての初期化ということを行います。これを「宣言」と言います。このあとこれらを使いますよ、ということをここで書いておきます。
//double型というのは小数点まで含めた実数に対してつけるもので、Buffer_0[]という中身は種数まで含める数ですよ、ということになります。
//それを６個設定します。このとき注意が必要なのはバッファーの設定は「０」から始まるため、１つ目のバッファーの番号は０にしています。
//ちなみに、Buffer_0~Buffer_5という6個の名前に関しては好きなものをつけられます。[]は箱を意味するもので名前ではありません。必ずつくものと覚えてください。
//例えば、Buffer_0の代わりにb1としてもいいですし、hitotsumeとしてもいいです。
//後々それを使っていきますので、自分が何のことを示しているのかがわかればいいのです。
double Buffer_0[];
double Buffer_1[];
double Buffer_2[];
double Buffer_3[];
double Buffer_4[];
double Buffer_5[];

//後で使う変数を今宣言しておきます。初期値に０を入れています。
int NowBars = 0;

//init関数と言ってインジケーターを入れたとき一番最初に一度だけ通る箇所になります。
//ここではインジケーターを入れたときに必ず行いたい設定を書いておきます。
int init(){

//今回は、上で初期化して用意しておいた各バッファーに役割を与えてあげます。
//これをしておかないとインジケーターがチャートを読み込んで指定した条件を満たしたとしてもバッファーの役割がないため、矢印等が出てくれません。
   IndicatorBuffers(6);
   //IndicatorDigits(Digits);
   //SetIndexBufferで上で用意したどのバッファーを何番目として役割を与えるか、という順番付けを行います。今回は１番目にBuffer_0を割り当てます。
   SetIndexBuffer(0,Buffer_0);
   //そしてSetIndexStyleではその役割の種類を決めてあげます。（）の中の左側が設定したいバッファーの番号（今回はBuffer_0）、右側が何の役割を与えたいか、になります。（今回は矢印）
   SetIndexStyle(0,DRAW_ARROW); /*役割の種類は決まった関数から選ぶだけになります。種類に関してはこちらをご参照ください。*///ここにURL
   //SetIndexArrowでは、上で矢印の役割を与えてあげたので、どんな矢印にするか？を決めてあげます。これも左側が何番目のバッファーか、右側が矢印のコードの番号になります。
   SetIndexArrow(0,241); //これも番号は決まっています。こちらをご覧ください。https://gyazo.com/034fcf7556aff433498835739def8049
   //これで１番目のバッファーに対しての設定が終わりました。残り5つに関しても同様に役割を設定してあげます。↓
     
   SetIndexBuffer(1,Buffer_1);  
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,242);
   
   //ラインの場合はSetIndexStyleでラインを指定、実線を指定、太さ２を指定という形になります。
   SetIndexBuffer(2,Buffer_2);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,2);
   
   SetIndexBuffer(3,Buffer_3);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,2);
   
   SetIndexBuffer(4,Buffer_4);
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,2);
   
   SetIndexBuffer(5,Buffer_5);
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,2);
   
   return(0);
}


//ここからのstart関数が最も重要になります。ほとんどすべての要素がこの中に入ります。
//考え方としてはロウソク足の値動きが１回あるたびにこのstart関数の中を一案上から一番↓まで超高速で一回駆け抜けるというイメージを持ってください。
//例えば１分足が完成するまでに３０回値段が動いたら３０周通ることになります。１回しか値動きがなかったら１回しか通りません。
//決して、ロウソク足１本につき１回通る、ということではないので注意が必要です。
int start(){
//start関数の中の一番初めに、その中で使いたい変数の宣言をしておきます。先ほどのバッファーの宣言と同じで、これから下の項目を使いますよ、とプログラムに分からせるんですね。
//int型なら整数の数字、string型なら文字列を入れる変数たち、という意味になります。全部好きな言葉で決めることができます。
   int limit = 0;
   double ma141, ma142, ma143, ma144, ma751, ma752, ma753, ma754; //下で使うMAの種類を宣言しています。

//Bars-IndicatorCounted()-1こtれは定型として覚えておいたほうがいいでしょう。
//Barsはチャートの中にある全てのロウソク足の本数を取得します。
//IndicatorCounted()は確定してもう動かないロウソク足の数を取得します。インジケーターを入れた瞬間は確定したものはないとされ０が取得されますが、
//１度値動きがあってstart関数を２周目してきた時には今動いている足より前の足に関しては動かないとしてその数が取得されます。
//なのでBars-IndicatorCounted()では２回目以降は常に現在動いている足のみが取得され常に１になります。
//しかし、BarsとIndicatorCounted()の数の取得に誤差が起こり２になってしまうため、最後に-1しています。
//これで最新の今動いている足に関しての情報だけを判断するような設定にできました。
//そうする理由は、値動きの度に全ロウソク足をまた１から判断していくと処理に負担がかかり動作が重くなってしまうためです。

   limit = Bars-IndicatorCounted()-1;
   
//for関数は繰り返し処理を表します。iという値に最初にlimitという数字を入れて、0以上の間はずっと-1していく、という意味になります。
//一回forの最後まで到達するとiは-1されてまたforの上から下まで通る、ということをiが０になるまで繰り返すわけです。
//limitは最初はどんな数が入るでしょうか？IndicatorCounted()は一番最初は０なので、初めのBars-IndicatorCounted()-1;の値は全ロウソク足の数-1になります。
//仮に全ロウソク足が5000本あったとしたら、i=5000が初めの数になり、それが０になるまで4999,4998,4997....と１ずつ減っていき、０になったらforは役目を終えてfor文を抜けます。
//そして、これは値動きが一回あったらその瞬間にforを指定回数（i=5000なら一瞬で-5000まで）繰り返します。１回の値動きで-1されるわけではないので注意が必要です。
   for(int i=limit; i>=0; i--){

//下のif文は、iが１より大きい時、またはi=1でありNowBarsがBarsよりも小さい時にその中を通る、という意味になります。
//どういうことかというと、iが１より大きい時、つまり過去の足を遡って条件を探した時はそのまま通っていいが、i=1、つまり現在動いている足が確定した瞬間のその確定した足に関しての条件は
//次の足が確定するまでの間に一回しかとしたくないためこの処理をしています。
//if文中のすぐの所でNowBarsにBars、つまり現状の全ロウソク足の数を入れています。これで、チャートの足が１本増えない限りはNowBars < Barsを満たすことはないわけです。
//具体的な数字で考えると、最初はNowBarsは0のためNowBars < Barsを満たします。そしてすぐにNowBarsはBars（今回は5000とします）の数となります。
//値動きがもう一度あると再度forを通り、このifに戻ってきます。その時NowBarsは5000、Barsは足がまだ増えていなければ5000のままです。するとNowBars < Barsを満たしません。
//そして値動きが何回あろうと条件が合わないのでこのifの中を通ることはなく、足が増えるとNowBarsは5000、Barsは5001となるためNowBars < Barsを満たすので、if文を通るという仕組みです。
//こうしないと、値動きがあるたびにアラートが鳴ったりサインが重なって出てしまうなどの不具合が起こってしまいます。
      if(i > 1 || (i == 1 && NowBars < Bars)){
          NowBars = Bars;
          
//MAはiMAという標準関数を使って取得できます。取得できるのはi番前のロウソク足の位置にあるMAの価格になります。
/*iMAに関しての説明はこちらをご覧ください。*///iMAの説明URL
//下で、期間14のi本前からi+3本前までのMAの価格、期間14のi本前からi+3本前までのMAの価格を取得してma141~ma754の中に値を入れています。
          ma141 = iMA(NULL,0,14,0,0,0,i);
          ma142 = iMA(NULL,0,14,0,0,0,i+1);
          ma143 = iMA(NULL,0,14,0,0,0,i+2);
          ma144 = iMA(NULL,0,14,0,0,0,i+3);
          ma751 = iMA(NULL,0,75,0,0,0,i);
          ma752 = iMA(NULL,0,75,0,0,0,i+1);
          ma753 = iMA(NULL,0,75,0,0,0,i+2);
          ma754 = iMA(NULL,0,75,0,0,0,i+3);
          
          //--ここからは期間14と75のMAのクロスした時に矢印を出す条件を書きます。
          if(ma142 < ma752 && ma141 >= ma751){ //１本前では14MAが75MAよりも下にあって、今の足では14MAが75MA以上の時（これがゴールデンクロスした時の条件）
              Buffer_0[i] = iLow(NULL,0,i)-20*Point; //i番目のBuffer_0に、i番目の安値より20pips低い位置を代入する。Buffer_0は矢印なので、つまりその位置に矢印が表示される。
          }
          
          if(ma142 > ma752 && ma141 <= ma751){ //１本前では14MAが75MAよりも上にあって、今の足では14MAが75MA以下の時（これがデッドクロスした時の条件）
              Buffer_1[i] = iHigh(NULL,0,i)+20*Point; //i番目のBuffer_1に、i番目の高値より20pips高い位置を代入する。Buffer_1は矢印なので、つまりその位置に矢印が表示される。
          }
          //--ここまで
          
          //--ここからはMAの傾きが変わったらMAの色を変える条件を書きます。（正確には傾きが変わると異なる色のラインを描画します）
          if(ma142 < ma141){ //期間14MAが上昇中の時、１つ前の足との２点を結ぶラインを描画させる。iは-1されていくので１つ前の足はi+1となる。
              Buffer_2[i] = ma141;
              Buffer_2[i+1] = ma142;
          }
          
          if(ma142 > ma141){ //期間14MAが下降中の時
              Buffer_3[i] = ma141;
              Buffer_3[i+1] = ma142;
          }
          
          if(ma752 < ma751){ //期間75MAが上昇中の時
              Buffer_4[i] = ma751;
              Buffer_4[i+1] = ma752;
          }

          if(ma752 > ma751){ //期間75MAが下降中の時
              Buffer_5[i] = ma751;
              Buffer_5[i+1] = ma752;
          }       
          //--ここまで
      } //この}でNowBarsで制限をかけていた条件を抜けます。この後値動きがあってもロウソク足が増えない限りは上記の条件文の中は通りません。 
   } //これがforの}で、ここから上までをi=limitからi=0になるまでiを-1していきます。ここは値動き（ティック）毎に通るのですが、NowBarsによって弾かれる形です。

   return(0); //forも最後まで繰り返すと他の条件は何もなく、start関数は終わります。次ティックでまたstart関数の一番初めに戻ります。それをティック毎に永遠と繰り返します。
}

//deinit関数はinit関数の反対で、インジケーターをチャートから削除した時に一度だけ呼び出されます。
//もし長方形やラインなどをObject関数を使って描画していたらここの中で消す処理を書いておかないと、インジケーターを除外してもチャートにはオブジェクトが残ったままになってしまいます。
//インジケーター中で何かオブジェクトを作成した場合は必ずdeinitに中で消すことを忘れないようにしましょう。
int deinit(){
  //今回はオブジェクト関数によっては作成していないので消すものはありません。
   return(0);
}

