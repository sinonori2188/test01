// ver2022.0210.001
const mode		= require('./mode.js');
const fs		= require('fs');
const ip		= require('ip');
const io		= require('socket.io-client');
const puppeteer	= require('puppeteer');
const libCommon	= require('./lib.common.js');
const highlow	= require('./lib.highlow.js');

libCommon.mylog("");
libCommon.mylog("***");
libCommon.mylog("*** hl-client.js start!");
libCommon.mylog("***");
libCommon.mylog("");

//
// パラメーター読み込み
//
//if(process.argv.length < 7){
if(process.argv.length < 5){ // 2020.02.21 //
	libCommon.mylog("<error>パラメーターが足りません。</error>");
	process.exit(1);
}


//const visible		= (process.argv[2]) ?  String(process.argv[2]) : 0;
//const real		= (process.argv[3]) ?  String(process.argv[3]) : 0;
//const fixamount	= (process.argv[3]) ?  String(process.argv[4]) : '*';
//const loginid		= (process.argv[4]) ?  String(process.argv[5]) : '';
//const password	= (process.argv[5]) ?  String(process.argv[6]) : '';
//const proxyip		= (process.argv[6]) ?  String(process.argv[7]) : '';
//const proxyport	= (process.argv[7]) ?  String(process.argv[8]) : '';
//const proxyauthid	= (process.argv[8]) ?  String(process.argv[9]) : '';
//const proxyauthpass	= (process.argv[9]) ?  String(process.argv[10]) : '';

// 2020.02.21 //
const visible		= "1";
//const real		= "1";
//const real 		= "0";
const real 			= mode.real; // 2022.02.03 mode.jsに外だし //
libCommon.mylog("real=["+real +"]");
let   fixamount		= ''; // サーバーのaccount.csvで設定されたものを受け取る fixamountがブランクの場合:トレードはできない //
const loginid		= (process.argv[2]) ?  String(process.argv[2]) : ''; // 第1引数
const password		= (process.argv[3]) ?  String(process.argv[3]) : ''; // 第2引数
const token			= (process.argv[4]) ?  String(process.argv[4]) : ''; // 第3引数
const proxyip		= '';
const proxyport		= '';
const proxyauthid	= '';
const proxyauthpass	= '';
// 2020.02.21 //


let trading = false; // 2020.09.08 //


if(loginid.length<=0){
	libCommon.mylog("<error>loginidパラメーターが足りません。</error>");
	process.exit(1);
}

let demo = false;

if(String(real)==="0"){
  demo = true;
}

headless = true;

if(visible === "1"){
  headless = false;
}

let proxy_server = "";

if(proxyip.length > 0 && proxyport.length > 0){
  proxy_server = proxyip + ":" + proxyport;
}

//-- 起動条件 --//
let runmsg ="";
runmsg += "ID=[" + loginid + "] ";
if(demo){
	runmsg += "[デモ]";
}else{
	runmsg += "[リアル]";
}
if(visible > 0){
	runmsg += "[表示]";
}else{
	runmsg += "[非表示]";
}
runmsg += " 接続(proxy)=[" + proxyip + "] ";
runmsg += "設置pc=[" + ip.address() + "] ";

libCommon.mylog("");
libCommon.mylog("Start");
libCommon.mylog(runmsg);
libCommon.mylog("");

let rate		= 1;		// 1倍固定
let device		= null;
let userAgent 	= 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.75 Safari/537.36';
let socket		= null;
let server_url	= "";
let browser		= null;
let page		= null;
let	cookie		= null;


//                                 //
// リアルタイムトレード実現用変数  //
//                                 //

// 直前のチャットメッセージ (重複トレード回避用) //
let chat_msg_pre	= "";

// 現在の画面状態保持 //
let input_now		= {};
input_now.game		= "";
input_now.span		= "";
input_now.time_index= 0;
input_now.currency	= "";
input_now.amount	= "";
input_now.balance	= 0;


//
// copyトレード操作
//

function client_loop_check(socket,obj){
	socket.emit("client-start", obj);
	libCommon.mylog("client-start send!");
	obj.first = 0;
	setTimeout(function(socket,obj){ client_loop_check(socket,obj); }, 60 * 60 * 1000, socket,obj);
}

startClient();

async function startClient(){

	libCommon.mylog("connect chat server!");
	//--------------------------//
	//                          //
	//     chatサーバー接続     //
	//                          //
	//--------------------------//

	try {
		server_url	= fs.readFileSync("./server_url.txt", 'utf8');
		server_url	= server_url.replace(/\n/,"").replace(/\r/,"");
		if(server_url.length<=0){
			let msg = "server_url.txt is blank. Please write HL-Server url to server_url.txt";
			libCommon.myerr(msg);
			return false;
		}
	}catch(error){
		let msg = "server_url.txt is missing.";
		console.error(error.toString());
		return false;
	}

	libCommon.mylog("server_url=[" + server_url + "]");

	try {

		libCommon.mylog("io.connect try!");

		socket = io.connect(server_url);

		if(!socket){
			let msg = "io.connect error1!:Cannot connect to [" + server_url + "]";
			libCommon.myerr(msg);
			myClose();
			return false;
		}

		socket.on('connect', () => {
			libCommon.mylog("io.connect ok");
			let obj = {};
			obj.msg = "HL-Client起動 ip=[" + ip.address() + "]";
			obj.highlowId = loginid; // --- 2020.02.21 追加 --- //
			obj.token	  = token;	 // --- 2020.02.21 追加 --- //
			obj.first	  = 1;		 // --- 2020.03.05 追加 --- //
			client_loop_check(socket,obj);
			//socket.emit("client-start", obj);
			//console.log("client-start send!:" + libCommon.now_stamp());

			//--------------------------//
			//                          //
			//       受信トレード       //
			//                          //
			//--------------------------//

			// --- 2020.02.21 無効化 --- //
			//socket.on('stop-all', (obj) => {
			//	myClose('stop all command');
			//});
			// --- 2020.02.21 無効化 --- //

			// --- 2020.02.21 追加ここから --- //
			socket.on('client-start-error',(msg) => {
				libCommon.mylog(msg);
				myClose('stopped!');
			});

			socket.on('your-amount',(amount) => {
				fixamount = amount;
			});
			// --- 2020.02.21 追加ここまで --- //


			socket.on('operate', async (obj) => {

				libCommon.mylog(JSON.stringify({msg:obj.msg,type:obj.type,order:obj.order}));

				//var msec = 0;
				//libCommon.mylog("random wait: " + msec + " msec");
				//await libCommon.doSleep(msec);

				// obj.orderをトレードする //
				// obj.type (currency  span  amount / action)
				// obj.order.currency
				// obj.order.span
				// obj.order.amount
				// obj.order.action

				//
				// 重複メッセージ除外
				//
				if(chat_msg_pre === obj.msg){
					libCommon.mylog("skipped! 直前のchatメッセージと同一メッセージ");
					return false;
				}else{
					chat_msg_pre = obj.msg;
				}

				//
				// 広告でてたら閉じる
				//
				await highlow.closeOverlay(page);

				//
				// 現在の入力状況チェック
				//

				input_now = await highlow.checkInputs(page);

				// --- 2020.02.21 追加ここから --- //
				if(fixamount.length <=0){
					libCommon.myerr("Your allowed fixamount is not setted");
					return false;
				}
				// --- 2020.02.21 追加ここまで --- //
				if(fixamount.length > 0 &&  fixamount !=="*"){
					obj.order.amount = fixamount;
				}

				//
				// トレード指示
				//
				if(obj.type === "action"){
					// --- 2020.09.08 追加ここから --- //
					if(trading){
						libCommon.mylog("Skip becase pre-trade action is still running");
						let retobj = {};
						retobj.msg = "直前のトレード遂行中につきスキップ:" + libCommon.now_stamp();
						socket.emit("client-message", retobj);
						return false;
					}else{
						trading = true;
					}
					// --- 2020.09.08 追加ここまで --- //

					//
					// 残高不足チェック
					//
					var amount = parseInt(obj.order.amount);
					if(amount > input_now.balance){
						libCommon.myerr("not enough balance left balance=[" + input_now.balance + "] bet=[" + amount + "]");
						let retobj = {};
						retobj.msg = "残高不足:" + "残高=[" + input_now.balance + "] トレード額=[" + amount + "] " + runmsg +  libCommon.now_stamp();
						socket.emit("client-message", retobj);
						trading = false; // 2020.09.08 追加 //
						return false;
					}

					//
					// High/Lowボタン押下！
					//
					let [ret, ret_msg] = await highlow.tradeV2(page,input_now,obj.order);
					trading = false; // 2020.09.08 追加 //
					if(!ret){
						let retobj = {};
						retobj.msg = "トレード失敗:" + runmsg + libCommon.now_stamp() + "\n" + ret_msg;
						libCommon.mylog("トレード失敗:" + runmsg + " "  + ret_msg)
						socket.emit("client-message", retobj);
					}else{
						let retobj = {};
						retobj.msg = "トレード成功:" + runmsg + libCommon.now_stamp() + "\n" + ret_msg;
						libCommon.mylog("トレード成功:" + runmsg + " "  + ret_msg)
						socket.emit("client-message", retobj);
					}
				}else{

					//
					// トレード準備
					//
					let [ret, ret_msg] = [false,""];

					for(let n=0;n<3;n++){
						libCommon.mylog("prepLoop1 n=" + n);
						[ret, ret_msg] = await highlow.prepTrade(page, input_now, obj.order);
						if(ret){
							break;
						}else{
							await libCommon.doSleep(100);
						}
					}

					if(!ret){
						let retobj = {};
						retobj.msg = "セット失敗:" + runmsg + libCommon.now_stamp() + "\n" + ret_msg;
						socket.emit("client-message", retobj);
						libCommon.mylog("セット失敗:" + runmsg +  " " + ret_msg);
						return false;
					}else{
						input_now = await highlow.checkInputs(page);
						let retobj = {};
						retobj.msg = "セット成功:" + runmsg + libCommon.now_stamp() + "\n" + ret_msg;
						libCommon.mylog("セット成功:" + runmsg +  " " + ret_msg);
						socket.emit("client-message", retobj);
					}

				}

				//
				// 最新の状況チェック
				//
				await libCommon.doSleep(300);
				input_now = await highlow.checkInputs(page);
				libCommon.mylog(JSON.stringify(input_now));
			});

		});

		socket.on('connect_error', function(err){
			let msg = "io.connect error2!:Cannot connect to [" + server_url + "] " + libCommon.now_stamp();
			console.error(msg);
			socket.disconnect(); // (注意) disconnectしない場合、loopしてエンドレスに connect retryが続く
			myClose();
			return false;
		});


	}catch(error){

		let msg = "io.connect error3!:Cannot connect to [" + server_url + "] " + libCommon.now_stamp();
		console.error(msg);
		console.error(error);
		if(socket)socket.disconnect();
		myClose();
		return false;

	}


	//--------------------------//
	//                          //
	//  ブラウザ起動＆ログイン  //
	//                          //
	//--------------------------//


	libCommon.mylog("start browser!");

	try{

		if(demo){
			libCommon.mylog("demo mode!");
			[browser,page,cookies] = await highlow.demologin(headless,device,userAgent,loginid,password,proxy_server,proxyauthid,proxyauthpass);
		}else{
			libCommon.mylog("real mode!");
			[browser,page,cookies] = await highlow.login(headless,device,userAgent,loginid,password,proxy_server,proxyauthid,proxyauthpass);
			libCommon.mylog("logined!");
		}

		let obj = {};
		obj.msg = "HL-Client起動成功:" + runmsg + libCommon.now_stamp();
		socket.emit("client-message", obj);

	}catch(error){
		console.error("login error:" + libCommon.now_stamp());
		console.error(error);

		let obj = {};
		obj.msg = "HL-Client起動失敗:" + runmsg + libCommon.now_stamp();
		obj.msg += error.toString();
		if(socket)socket.emit("client-message", obj);

		if(socket)socket.disconnect();
		return false;
	}

	//
	// overlayメッセージ閉じる
	//
	try{
		await libCommon.doSleep(1 * 2 * 1000); 					// 2022.01.31 追加 //
		//await page.addScriptTag({path: 'jquery.min.js'}) 	// 2022.01.31 追加 //
		await libCommon.doSleep(3000);

		if(! await highlow.closeOverlay(page) ){

			let obj = {};
			obj.msg = "HL Overlay広告を閉じられずトレード画面に移動できませんでした。#1:" + runmsg + libCommon.now_stamp();
			obj.msg += error.toString();
			if(socket)socket.emit("client-message", obj);

			if(socket)socket.disconnect();
			return false;

		}

		//var overlay = await page.$('.onboarding-overlay');
		//if(overlay){
		//	var classname = await (await overlay.getProperty('className')).jsonValue();
		//	if(classname.match(/active/)){
		//		await overlay.click();
		//	}
		//}

	}catch(error){
		console.error("overlay ad close error." + libCommon.now_stamp());
		console.error(error);

		let obj = {};
		obj.msg = "HL Overlay広告を閉じられずトレード画面に移動できませんでした。#2:" + runmsg + libCommon.now_stamp();
		obj.msg += error.toString();
		if(socket)socket.emit("client-message", obj);

		if(socket)socket.disconnect();
		return false;
	}


	//
	// 1wayをクリック
	//
	try{
		await highlow.oneWayOn(page);

	}catch(error){
		console.error("1way check error." + libCommon.now_stamp());
		console.error(error);

		let obj = {};
		obj.msg = "HL 1Wayを確認できませんでした。:" + runmsg + libCommon.now_stamp();
		obj.msg += error.toString();
		if(socket)socket.emit("client-message", obj);

		if(socket)socket.disconnect();
		return false;
	}

	//
	// 口座残高と最新のトレード履歴を取得
	//
	try{
		await highlow.renewInfo(page);

	}catch(error){

		console.error("check balance and trade history error." + libCommon.now_stamp());
		console.error(error);

		let obj = {};
		obj.msg = "HL 口座残高と最新のトレード履歴を読み取れませんでした。:" + runmsg + libCommon.now_stamp();
		obj.msg += error.toString();
		if(socket)socket.emit("client-message", obj);

		if(socket)socket.disconnect();
		return false;
	}

	//
	// 定期リロード(ログイン継続)
	//
	var counter_i = 0;
	while(1){
		try{
			await libCommon.doSleep(5 * 60 * 1000 + Math.random() * 100000); // 5分ちょい //
			await page.reload();
			libCommon.mylog("=== page auto reload === ");
			await libCommon.doSleep(1 * 5 * 1000);
			//await page.addScriptTag({path: 'jquery.min.js'}) 	// 2022.01.31 追加 //
			await libCommon.doSleep(1 * 2 * 1000); 				// 2022.01.31 追加 //
			await highlow.closeOverlay(page);
			await libCommon.doSleep(1 * 2 * 1000);
			await highlow.oneWayOn(page);
			await libCommon.doSleep(1 * 2 * 1000);
			//await highlow.renewInfo(page);
		}catch(error){
			libCommon.mylog("reload error:" + error.toString() + " "+ libCommon.now_stamp());
			console.error(error);
			console.error("continue:" + libCommon.now_stamp());

			let obj = {};
			obj.msg = "HL ページリロード失敗(5分後リトライ):" + runmsg + libCommon.now_stamp();
			obj.msg += error.toString();
			if(socket)socket.emit("client-message", obj);
		}
	}

	//
	// エラー時終了前
	//
    process.on("uncaughtException", () => { myClose("uncaughtException"); });
    process.on("unhandledRejection", () => { myClose("unhandledRejection"); });
}


function myClose(msg){

	let obj = {};
	obj.msg = "HL Client終了[" + msg + "]" + runmsg + libCommon.now_stamp();
	if(socket){
		socket.emit("client-message", obj);
		socket.disconnect();
	}
	libCommon.mylog(msg + libCommon.now_stamp());
	if(page)page.close();
	if(browser)browser.close();
	if(process)process.exit(1);
}
