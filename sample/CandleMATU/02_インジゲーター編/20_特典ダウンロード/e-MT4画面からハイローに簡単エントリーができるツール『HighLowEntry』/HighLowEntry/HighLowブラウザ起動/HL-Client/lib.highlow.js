// ver2022.0224.002
const { pseudoRandomBytes } = require('crypto');
const fs			= require('fs');
const puppeteer		= require('puppeteer');
const { isFunction } = require('util');
const libCommon		= require('./lib.common.js');
const cookie_dir	= 'cookie';
if(!fs.existsSync(cookie_dir))fs.mkdirSync(cookie_dir);

module.exports = {
	checkBalance : checkBalance,
	getLoginId : getLoginId,
	login : login,
	demologin : demologin,
	relogin : relogin,
	oneWayOn : oneWayOn,
	renewInfo : renewInfo,
	closeOverlay : closeOverlay,
	checkInputs : checkInputs,
	tradeV2 : tradeV2,
	prepTrade: prepTrade,
}

var mybalance    = 0;
var old_order_id = "none";

// 最新のmybalance と order_id を取得する //

function renewInfo(page){
	return new Promise(async function (resolve, reject) {
		try{
			mybalance = await checkBalance(page);
		}catch(error){
			libCommon.myerr("renewInfo error001");
			libCommon.myerr(error.toString());
		}
		try{
			old_order_id = await checkOrderId(page);
		}catch(error){
			libCommon.myerr("renewInfo error002");
			libCommon.myerr(error.toString());
			old_order_id = "";
		}
		libCommon.mylog("mybalance=[" + mybalance +"]");
		libCommon.mylog("old_order_id=[" + old_order_id +"]");
	});
}

async function checkOrderId(page){
	return new Promise(async function (resolve, reject) {
		try{
			let order_id = await page.evaluate( async () =>{

				function get_class_div(class_text){
					var divs = document.getElementsByTagName('div');
					for(let i=0;i<divs.length;i++){
						if(divs[i].className && divs[i].className.match(class_text)){
							return divs[i];
						}
					}
					return null;
				}
		
				function doSleep(mtime){
					return new Promise((resolve, reject) => {
						setTimeout(() => {
							resolve();
						}, mtime);
					});
				}

				var order_id = "";
				var toggle_div = null;
				var divs = document.getElementsByTagName('div');
				for(let i=0;i<divs.length;i++){
					if(divs[i].className && divs[i].className.match(/App_openTradesDrawerToggle/i)){
						toggle_div = divs[i];
						break;
					}
				}
				if(toggle_div){
					toggle_div.click();
					await doSleep(50);
					var temp_div = get_class_div("OpenTrades_openFullOpenTradesScreenButton");
					if(temp_div)temp_div.click();
					await doSleep(50);
					var divs = document.getElementsByTagName("div");
					for(let i=0;i<divs.length;i++){
						if(!divs[i].className)continue;
						if(!divs[i].className.match("tradeIdLabel"))continue;
						order_id = divs[i].innerText;
						break;
					}
					await doSleep(30);
					toggle_div.click();
					await doSleep(50);
				}
				// 必ず子ウィンドウ閉じる //
				for(let i=0;i<divs.length;i++){
					if(divs[i].style && divs[i].style.position && divs[i].style.position.match(/absolute/)){
						divs[i].click();
					}
				}
				return order_id;
			});
			resolve(order_id);
		}catch(error){
			libCommon.myerr("order_id check error" + error.toString());
			reject(error);
			return false;
		}
	});
}
   
async function checkBalance(page){
	return new Promise(async function (resolve, reject) {
		try{
			let mybalance = await page.evaluate( async () =>{
				var mybalance = 0;
				var div = document.getElementById('balanceValue');
				if(div){
					var temp = div.innerText.match(/[0-9\,]+/);
					if(temp){
						temp = temp[0].replace(/,/g,"");
					}
					if(temp && temp.length > 0){
						mybalance = parseInt(temp);
					}
				}
				var div = document.getElementById('cashBackValue');
				if(div){
					var temp = div.innerText.match(/[0-9\,]+/);
					if(temp){
						temp = temp[0].replace(/,/g,"");
					}
					if(temp && temp.length > 0){
						mybalance += parseInt(temp);
					}
				}
				return mybalance;
			});
			resolve(mybalance);
		}catch(error){
			libCommon.myerr("balance check error:" + error.toString());
			reject(error);
			return false;
		}
	});
}

function oneWayOn(page){
	return new Promise(async function (resolve, reject) {
		try{
			let clicked = await page.evaluate( () => { 
				//var checkbox = $('input[type="checkbox"][role="switch"][data-test="one-click-enabled-button"]');
				console.clear();
				var checkbox = null;
				var inputs = document.getElementsByTagName("input");
				for(var i=0;i<inputs.length;i++){
					console.log(i);
					if(inputs[i].getAttribute("type")!="checkbox")continue;
					if(inputs[i].getAttribute("role")!="switch")continue;
					if(inputs[i].getAttribute("data-test")!="one-click-enabled-button")continue;
					checkbox = inputs[i];
					console.log("match!");
					break;
				}
				if(!checkbox){
					return -1;
				}else if(checkbox.checked){
					return 0;
				}else{
					checkbox.click();
					return 1;
				}
			});
			if(clicked >=1){
				libCommon.mylog("1way clicked");
				resolve("ok");
			}else if(clicked >=0){
				libCommon.mylog("already 1way");
				resolve("ok");
			}else{
				libCommon.myerr('input[type="checkbox"][role="switch"][data-test="one-click-enabled-button"] not found.');
				reject('input[type="checkbox"][role="switch"][data-test="one-click-enabled-button"] not found.');
			}
		}catch(error){
			libCommon.myerr("oneWayOn error:" + error.toString());
			reject("oneWayOn error:" + error.toString());
			return false;
		}
	});
}

//
// フォームの選択・入力をチェック (checkInputs)
//
async function checkInputs(page){
	return new Promise(async function (resolve, reject) {
		try{
			input_now = await page.evaluate( async () =>{
				var input_now = {};
				input_now.game			= "";
				input_now.span			= "";
				input_now.time_index	= -1;
				input_now.currency		= "";
				input_now.amount		= "";
				input_now.balance		= 0;

				function get_target_text(label_text){
					var divs = document.getElementsByTagName('div');
					for(let i=0;i<divs.length;i++){
						if(!divs[i].className)continue;
						if(!divs[i].className.match(/ChartInfo_chartLabel/i))continue;
						if(!divs[i].innerText.match(label_text))continue;
						var divs2 = divs[i].getElementsByTagName('div');
						for(let j=0;j<divs2.length;j++){
							if(divs2[j].className && divs2[j].className.match(/ChartInfo_optionInfoValue/i)){
								return divs2[j].innerText;
							}
						}
					}
					return "";
				}

				function get_class_div(class_text){
					var divs = document.getElementsByTagName('div');
					for(let i=0;i<divs.length;i++){
						if(divs[i].className && divs[i].className.match(class_text)){
							return divs[i];
						}
					}
					return null;
				}

				function get_class_input(class_text){
					var inputs = document.getElementsByTagName('input');
					for(let i=0;i<inputs.length;i++){
						if(inputs[i].className && inputs[i].className.match(class_text)){
							return inputs[i];
						}
					}
					return null;
				}

				function calc_wait_sec(str){
					var _t = new Date();
					var str_full = _t.getFullYear() + "/" + ('0' + (_t.getMonth()+1)).slice(-2) + "/"+ ('0'+_t.getDate()).slice(-2) + " " + str;
					var _c = new Date(str_full);
					var temp = parseInt( (_c.getTime() - _t.getTime() ) / 1000 );
					if(temp < 0)temp += 24 * 60 * 60;
					return  temp;
				}			
				
				function doSleep(mtime){
					return new Promise((resolve, reject) => {
						setTimeout(() => {
							resolve();
						}, mtime);
					});
				}

				var divs = document.getElementsByTagName('div');

				// 1.ゲーム //
				//var temp = get_target_text("オプション");
				//if(temp.match(/Turboスプレッド/)){
				//	input_now.game = "FixedPayoutHLOOD0"; // TurboSpread
				//}else if(temp.match(/Turbo/)){
				//	input_now.game = "ChangingStrikeOOD0"; // Turbo
				//}else if(temp.match(/HighLowスプレッド/)){
				//	input_now.game = "FixedPayoutHL0"; // HighLowSpread
				//}else if(temp.match(/HighLow/)){
				//	input_now.game = "ChangingStrike0"; // HighLow
				//}
				function get_active_game(games){
					for(var i=0;i<games.length;i++){
						var temp = document.getElementById(games[i]);
						if(temp && temp.className && temp.className.match(/active/i))return games[i];
					}
					return "";
				}
				input_now.game = get_active_game(["FixedPayoutHLOOD0","ChangingStrikeOOD0","FixedPayoutHL0","ChangingStrike0"]);
				// 2.スパン と 3.タイムIndex //
				var wait_sec = 0;
				var temp = get_target_text("判定時刻");
				if(temp.length > 0){
					var temp2 = temp.match(/[0-9]{2}:[0-9]{2}/);
					if(temp2)wait_sec = calc_wait_sec(temp2[0]);
				}
				var temp = get_target_text("オプション");
				if(temp.match(/23時間/)){
					input_now.span = "86400000"; // 1day
					input_now.time_index = 0;
				}else if(temp.match(/1時間/)){
					input_now.span = "3600000"; // 1hour
					input_now.time_index = 0;
				}else if(temp.match(/15分/)){
					if(wait_sec < 60 * 5){
						input_now.span = "900000"; // 15short
						input_now.time_index = 0;
					}else if(wait_sec < 60 * 10){
						input_now.span = "900000"; // 15middle
						input_now.time_index = 1;
					}else{
						input_now.span = "900000"; // 15long
						input_now.time_index = 2;
					}
				}else if(temp.match(/5分/)){
					input_now.span = "300000"; // 5minute
					input_now.time_index = 0;
				}else if(temp.match(/3分/)){
					input_now.span = "180000"; // 3minute
					input_now.time_index = 0;
				}else if(temp.match(/1分/)){
					input_now.span = "60000"; // 1minute
					input_now.time_index = 0;
				}else if(temp.match(/30秒/)){
					input_now.span = "30000"; // 30sec
					input_now.time_index = 0;
				}
				// 4.通貨ペア //
				var temp_div = get_class_div("ChartInfo_optionAssetName");
				if(temp_div)input_now.currency = temp_div.innerText;			 
				// 5.金額 //
				var input = get_class_input("MoneyInputField_amount");
				if(input){
					var temp  = input.value.replace(/,/g,"");
					temp2 = temp.match(/[0-9]+/);
					if(temp2 && temp2.length > 0){
						input_now.amount = parseInt(temp2[0]);
					}
				}
				// 6.残高 //
				var div = document.getElementById('balanceValue');
				if(div){
					var temp = div.innerText.match(/[0-9\,]+/);
					if(temp){
						temp = temp[0].replace(/,/g,"");
					}
					if(temp && temp.length > 0){
						input_now.balance = parseInt(temp);
					}
				}
				var div = document.getElementById('cashBackValue');
				if(div){
					var temp = div.innerText.match(/[0-9\,]+/);
					if(temp){
						temp = temp[0].replace(/,/g,"");
					}
					if(temp && temp.length > 0){
						input_now.balance += parseInt(temp);
					}
				}
				return input_now;
			});
			resolve(input_now);
		}catch(error){
			libCommon.myerr("checkInputs error:" + error.toString());
			reject("checkInputs error:" + error.toString());
			return false;
		}

	});
}

async function closeOverlay(page){
	return new Promise(async function (resolve, reject) {
		try{
			await page.evaluate( () =>{
					var closeButton = null;
					var divs = document.getElementsByTagName('div');
					for(var i=0;i<divs.length;i++){
						if(divs[i].className && divs[i].className.match(/SecondaryBanner_closeButton/)){
							closeButton = divs[i];
						}
					} 
					// jQuery を addScript済みの場合
					//if(closeButton && $(closeButton).is(':visible'))closeButton.click();
					//if(closeButton)closeButton.click();
					if(closeButton && document.defaultView.getComputedStyle(closeButton, null).display!="none"){
						closeButton.click();
					}
				});
			resolve(true);
		}catch(error){
			libCommon.myerr("overlay close error:"+ error.toString());
			reject("overlay close error:" +error);
		}
	});
}

//
//
// High/Lowクリック
//
// order.action (high / low)に合わせて(high/low)ボタンを押す！
// order.currency / order.span / order.amount が、input_nowと同一なら画面チェックをせずに アクション(high / low)ボタンを即押し
// input_nowと異なっている場合は、prepTradeと同じ操作をすませてから、アクション(high / low)ボタン押す
//
//
async function tradeV2(page, input_now, order){
	var ret_msg = "";
	let [game,span,time_index] = realSpan(order.span);
	let pair		= realPair(order.currency);

	// 0.子Window開いていたら閉じる
	try {
		await page.focus("body");
		await page.evaluate( async () =>{
			var divs = document.getElementsByTagName('div');
			for(let i=0;i<divs.length;i++){
				if(divs[i].style && divs[i].style.position && divs[i].style.position.match(/absolute/)){
					divs[i].click();
				}
			}
			return true;
		});
	}catch(error){
		ret_msg = "HIGH/LOW Click Error #0:" + error.toString();
		console.error(ret_msg);
		libCommon.myerr(ret_msg);
		return [false,ret_msg];
	}


	// 1.揃っているかチェック
	if(input_now.game !== game || span !== input_now.span || time_index!== input_now.time_index|| pair != input_now.currency ||  String(order.amount) !== String(input_now.amount)){

		// 1.1 再度事前準備
		for(let n=0;n<3;n++){
		//for(let n=0;n<1;n++){
			libCommon.mylog("prepLoop2 n=");
			var [ret, ret_msg] = await prepTrade(page, input_now, order);
			if(ret)break;
			await libCommon.doSleep(100);
		}
		if(!ret){
			return [false,ret_msg];
		}else{
			input_now = await checkInputs(page);
		}

		// 1.2 揃ったかチェック
		if(game !== input_now.game){
			ret_msg = "Couldn't set game=[" + game + "] form game=[" + input_now.game + "]";
			libCommon.mylog(ret_msg);
			return [false,ret_msg];
		}else if(pair !== input_now.currency){
			ret_msg = "Couldn't set currency=[" + pair + "] form currency=[" + input_now.currency + "]";
			libCommon.mylog(ret_msg);
			return [false,ret_msg];
		}else if(span !== input_now.span){
			ret_msg = "Couldn't set span=[" + span + "] form span=[" + input_now.span + "]";
			libCommon.mylog(ret_msg);
			return [false,ret_msg];
		}else if(time_index !== input_now.time_index){
			ret_msg = "Couldn't set time_index=[" + time_index + "] form time_index=[" + input_now.time_index + "]";
			libCommon.mylog(ret_msg);
			return [false,ret_msg];
		}else if(String(order.amount) !== String(input_now.amount)){
			ret_msg = "Couldn't set amount=[" + order.amount + "] form amount=[" + input_now.amount + "]";
			libCommon.mylog(ret_msg);
			return [false,ret_msg];
		}
	}
	//await libCommon.doSleep(500); // 0.5秒だけ待ちます //
	// 2.High/Lowボタンを押す
	try {
		await page.focus("body");

		if(order.action.match(/low/)){
			var pos = await page.evaluate( () =>{
				var divs = document.getElementsByTagName("div");
				for(var i=0;i<divs.length;i++){
					if(divs[i].className && divs[i].className.match(/TradePanel_buttonLabel/i)){
						if(divs[i].innerText=="Low"){
							const {top, left} = divs[i].getBoundingClientRect();
							return {top, left};
						}
					}
				}
				return null;
			});
			if(pos){
				await page.mouse.move(pos.left + 5, pos.top + 5);
				await page.mouse.click(pos.left + 5, pos.top + 5, { button: 'left' });
				libCommon.mylog("*** LOW Click OK *** pos=[" + pos.left + "][" + pos.top +"]");
			}else{
				libCommon.mylog("*** LOW Click ng *** Low BUTTON not found.");
			}
		}else if(order.action.match(/high/)){
			var pos = await page.evaluate( () =>{
				var divs = document.getElementsByTagName("div");
				for(var i=0;i<divs.length;i++){
					if(divs[i].className && divs[i].className.match(/TradePanel_buttonLabel/i)){
						if(divs[i].innerText=="High"){
							const {top, left} = divs[i].getBoundingClientRect();
							return {top, left};
						}
					}
				}
				return null;
			});
			if(pos){
				await page.mouse.move(pos.left + 5, pos.top + 5);
				await page.mouse.click(pos.left + 5, pos.top + 5, { button: 'left' });
				libCommon.mylog("*** HIGH Click OK *** pos=[" + pos.left + "][" + pos.top +"]");
			}else{
				libCommon.mylog("*** HIGH Click ng *** High BUTTON not found.");
			}
		}

		await libCommon.doSleep(500);
		var order_id = await checkOrderId(page);
		libCommon.mylog("*order_id=[" + order_id + "]");

		return [true,ret_msg];

	}catch(error){
		ret_msg = "HIGH/LOW Click Error:" + error.toString();
		console.error(ret_msg);
		libCommon.myerr(ret_msg);
		return [false,ret_msg];
	}
}

function realSpan(span){
	switch(span){
		case "30s":		return ["ChangingStrikeOOD0","30000",0]; break;		// Turbo
		case "1m":		return ["ChangingStrikeOOD0","60000",0]; break;		// Turbo
		case "3m":		return ["ChangingStrikeOOD0","180000",0]; break;	// Turbo
		case "5m":		return ["ChangingStrikeOOD0","300000",0]; break;	// Turbo
		case "15short":	return ["ChangingStrike0","900000",0]; break;		// HighLow
		case "15middle":return ["ChangingStrike0","900000",1]; break;		// HighLow
		case "15long":	return ["ChangingStrike0","900000",2]; break;		// HighLow
		case "1h":		return ["ChangingStrike0","3600000",0]; break;		// HighLow
		case "1d":		return ["ChangingStrike0","86400000",0]; break;		// HighLow
		default:		return ["","",0]; break;
	}
}

function realPair(currency){
	switch(currency){
		case "AUDJPY":	return "AUD/JPY"; break;
		case "EURGBP":	return "EUR/GBP"; break;
		case "NZDJPY":	return "NZD/JPY"; break;
		case "AUDNZD":	return "AUD/NZD"; break;
		case "EURJPY":	return "EUR/JPY"; break;
		case "NZDUSD":	return "NZD/USD"; break;
		case "AUDUSD":	return "AUD/USD"; break;
		case "EURUSD":	return "EUR/USD"; break;
		case "USDCAD":	return "USD/CAD"; break;
		case "CADJPY":	return "CAD/JPY"; break;
		case "GBPAUD":	return "GBP/AUD"; break;
		case "USDCHF":	return "USD/CHF"; break;
		case "CHFJPY":	return "CHF/JPY"; break;
		case "GBPJPY":	return "GBP/JPY"; break;
		case "USDJPY":	return "USD/JPY"; break;
		case "EURAUD":	return "EUR/AUD"; break;
		case "GBPUSD":	return "GBP/USD"; break;
		case "GOLD":	return "GOLD"; break;
		case "BTCUSD":	return "BTC/USD"; break;
		case "ETHUSD":	return "ETH/USD"; break;
		default:	return ""; break;
	}
}

async function prepTrade(page, input_now, order){

	let [game,span,time_index] 	= realSpan(order.span);
	let currency 				= realPair(order.currency);
	let amount	 				= order.amount;
	let input					= null;

	return new Promise(async function (resolve, reject) {

		// 0.子Window開いていたら閉じる
		try {
			await page.bringToFront();
			await page.focus("body");
			await page.evaluate( async () =>{
				var divs = document.getElementsByTagName('div');
				for(let i=0;i<divs.length;i++){
					if(divs[i].style && divs[i].style.position && divs[i].style.position.match(/absolute/)){
						divs[i].click();
					}
				}
				return true;
			});
		}catch(error){
			var ret_msg = "close subwindow error:" + error.toString();
			libCommon.myerr(ret_msg);
			resolve [false,ret_msg];
			return;
		}
		// 4.amount //
		try{
			await page.bringToFront();
			await page.click('body');
			if(String(input_now.amount) != String(amount)){
				if(input_now.balance < parseInt(amount)){
					libCommon.mylog("not enough balance left balance=[" + input_now.balance + "] order amount=[" + amount + "]");
					resolve([false,"not enough balance left balance=[" + input_now.balance + "] order amount=[" + amount + "]"]);
					return;
				}
				libCommon.mylog("*input amount=[" + amount + "]");
				await libCommon.doSleep(200);
				var rc = await page.evaluate( (amount) =>{
					var inputs = document.getElementsByTagName('input');
					for(let i=0;i<inputs.length;i++){
						if(inputs[i].className && inputs[i].className.match(/MoneyInputField_amount/i)){
							inputs[i].focus();
							inputs[i].value= amount;
							return true;
						}
					}
					return false;
				},amount);
				if(rc){
					libCommon.mylog("*inputed amount=[" + amount + "]");
				}else{
					libCommon.mylog("input amount error1: "  + "input not found");
					resolve([false,"input amount not found"]);
					return;
				}
			}else{
				libCommon.mylog("*already inputed amount=[" + amount + "]");
			}
		}catch(error){
			libCommon.myerr("input amount error "  + error.toString());
			resolve([false,error.toString()]);
			return;
		}
		// 1.game //
		try{
			await page.bringToFront();
			await page.click('body');
			if(game.length > 0  && input_now.game != game){
				libCommon.mylog("*select game=[" + game + "]");
				var rc = await page.evaluate( (game) =>{
					var tab_div = document.getElementById(game);
					if(tab_div){
						tab_div.click();
						return true;
					}else{
						return false;
					}
				},game);
				if(rc){
					libCommon.mylog("*selected game=[" + game + "]");
				}else{
					libCommon.mylog("*couldn't selected game=[" + game + "]");
				}
				await libCommon.doSleep(200);
			}else{
				if(game.length > 0){
					libCommon.mylog("*already selected game=[" + game + "]");
				}else{
					libCommon.mylog("*skip select game=[" + game + "] , no game was set by panel");
				}
			}
		}catch(error){
			libCommon.myerr("select game error "  + error);
			resolve([false,error.toString()]);
			return;
		}
		// 2.currency //
		var need_time_index_click = false; 
		try{
			if(currency.length > 0  && (input_now.currency !== currency || input_now.span !== span || String(input_now.time_index) !== String(time_index))){
				libCommon.mylog("*select currency=[" + currency + "]");
				var rc = await page.evaluate( (currency) =>{
					var divs = document.getElementsByTagName("div");
					for(let i=0;i<divs.length;i++){
						if(divs[i].className && divs[i].className.match(/OptionBrowser_assetFilter/i)){
							var divs2 = divs[i].getElementsByTagName("div");
							for(let j=0;j<divs2.length;j++){
								if(divs2[j].className && divs2[j].className.match(/Dropdown_display/i)){
									divs2[j].click();
									clicked = true;
									break;
								}
							}
							if(clicked){
								var inputs = divs[i].getElementsByTagName("input");
								if(inputs.length>0){
									inputs[0].focus();
									inputs[0].value = currency;
									return true;
								}
							}
							break;
						}
					}
					return false;
				},currency);
				if(rc){
					for(var x=0;x<10;x++){
						await libCommon.doSleep(50);
						libCommon.mylog("*select currency=[" + currency + "] try_count=" + (x+1));
						var rc = await page.evaluate( (currency) =>{
							var div = document.getElementById(currency);
							if(div){
								div.click();
								return true;
							}else{
								return false;
							}
						},currency);
						if(rc)break;
					}
					if(!rc){
						libCommon.mylog("*couldn't selected currency=[" + currency + "] #2 pulldown option select error");
					}else{
						need_time_index_click = true; // タブをclickすることで実際にチャートの通貨ペアが変化する //
						libCommon.mylog("*selected currency=[" + currency + "] try_count=" + (x+1));
					}
				}else{
					libCommon.mylog("*couldn't selected currency=[" + currency + "] #1 asset pulldown open error");
				}
				await libCommon.doSleep(200);
			}else{
				if(game.length > 0){
					libCommon.mylog("*already selected currency=[" + currency + "]");
				}else{
					libCommon.mylog("*skip select currency=[" + currency + "] , no currency was set by panel");
				}
			}
		}catch(error){
			libCommon.myerr("select currency error:"  + error);
			resolve([false,error.toString()]);
			return;
		}
		// 3.span and time_index //
		try{
			if(input_now.span !== span || String(input_now.time_index) != String(time_index) || need_time_index_click){
				// 3.1 span //
				if(span.length <= 0){
					libCommon.mylog("*skip select span=[" + span + "] , no span was set by panel");
				}else{
					libCommon.mylog("*select span=[" + span + "]]");
					var rc = await page.evaluate( () =>{
						var divs = document.getElementsByTagName("div");
						for(let i=0;i<divs.length;i++){
							if(divs[i].className && divs[i].className.match(/OptionBrowser_durationFilter/i)){
								var divs2 = divs[i].getElementsByTagName("div");
								for(let j=0;j<divs2.length;j++){
									if(divs2[j].className && divs2[j].className.match(/Dropdown_display/i)){
										divs2[j].click();
										return true;
									}
								}
							}
						}
						return false;
					});
					if(rc){
						for(var x=0;x<10;x++){
							await libCommon.doSleep(50);
							libCommon.mylog("*select span=[" + span + "] try_count=" + (x+1));
							var rc = await page.evaluate( (span) =>{
								var div = document.getElementById(span);
								if(div){
									div.click();
									return true;
								}else{
									return false;
								}
							},span);
							if(rc)break;
						}
						if(rc){
							libCommon.mylog("*selected span=[" + span + "] try_count="+(x+1));
						}else{
							libCommon.mylog("*couldn't select span=[" + span + "] #2");
						}
					}else{
						libCommon.mylog("*couldn't select span=[" + span + "] #1");
					}
					await libCommon.doSleep(250);
				}
				// 3.2 time_index //
				for(var x=0;x<20;x++){
					await libCommon.doSleep(50);
					libCommon.mylog("*select time_index=[" + time_index + "] try_count=" + (x+1));
					var rc = await page.evaluate( (currency,span,time_index) =>{
						function calc_judge_time(str){
							var t = str.split(":");
							if(t.length>=3){
								return parseInt(t[0]) * 60 * 60 + parseInt(t[1]) * 60 + parseInt(t[2]);
							}else if(t.length>=2){
								return  parseInt(t[0]) * 60 + parseInt(t[1]);
							}else{
								return  parseInt(t[0]);
							}
						}
						function spanLabel(span){
							switch(span){
								case "30000":	return "30秒"; break;
								case "60000":	return "1分"; break;
								case "180000":	return "3分"; break;
								case "300000":	return "5分"; break;
								case "900000":	return "15分"; break;
								case "3600000":	return "1時間"; break;
								case "86400000":return "23時間"; break;
								default:		return ""; break;
							}
						}
						var span_label = spanLabel(span);
						var sort_divs = [];
						var div = document.getElementById("options_height_space_holder_0");
						if(div){
							var divs = div.getElementsByTagName("div");
							if(divs){
								for(let i=0; i< divs.length; i++){
									if(divs[i].className && divs[i].className.match(/OptionItem_container/i)){
										var currency_match = false;
										var span_match = false;
										if(currency.length<=0)currency_match = true;
										if(span_label.length<=0)span_match = true;

										var spans = divs[i].getElementsByTagName("span");
										for(let j=0;j<spans.length;j++){
											if(spans[j].className && spans[j].className.match(/OptionItem_ticker/i)){
												if(spans[j].innerText==currency)currency_match=true;
											}else if(spans[j].className && spans[j].className.match(/OptionItem_duration/i)){
												if(spans[j].innerText==span_label)span_match=true;
											}
										}
										if(currency_match && span_match){
											if(span_label =="15分"){
												var spans = divs[i].getElementsByTagName("span");
												for(let j=0; j<spans.length;j++){
													if(spans[j].className && spans[j].className.match(/OptionItem_timeLeft/i)){
														var temp = spans[j].getElementsByTagName("span");
														if(temp && temp.length > 0){
															sort_divs.push({div:divs[i],judge_time:calc_judge_time(temp[0].innerText)});
														}
													}
												}
											}else{
												sort_divs.push({div:divs[i],judge_time:0});
											}
										}
									}
								}
							}
							if(sort_divs.length > 0){
								sort_divs.sort( (a, b) => (a.judge_time > b.judge_time) ? 1 : -1 );
							}
						}
						time_index = parseInt(time_index);
						if(sort_divs.length > time_index){
							sort_divs[time_index].div.click();
							return true;
						}else{
							return false;
						}
					},currency,span,time_index);
					if(rc)break;
				}
				if(rc){
					libCommon.mylog("*selected time_index=[" + time_index + "] try_count="+(x+1));
				}else{
					libCommon.mylog("*couldn't selected time_index=[" + time_index + "] target tab not found.");
				}
				//await libCommon.doSleep(200);
			}else{
				libCommon.mylog("*already selected span=[" + span + "] time_index=[" + time_index + "]");
			}
		}catch(error){
			libCommon.myerr("select span & time_index error:"  + error);
			resolve([false,error.toString()]);
			return;
		}

		// Wait chart draw //
		try{
			for(var x=0;x<10;x++){
				libCommon.mylog("*wait chart draw try_count=" + (x+1));
				var input_changed = await checkInputs(page);
				if(game.length > 0  && input_changed.game != game){
					await libCommon.doSleep(50);
				}else if(input_changed.span !== span){
					await libCommon.doSleep(50);
				}else if(String(input_changed.time_index) != String(time_index)){
					await libCommon.doSleep(50);
				}else{
					libCommon.mylog("*chart draw ok! try_count=" + (x+1));
					break;
				}
			}
		}catch(error){
			libCommon.myerr("wait chart draw error:"  + error);
			resolve([false,error.toString()]);
			return;
		}

		// End. close other tabs //
		try{
			//await libCommon.doSleep(200);
			var close_count = await page.evaluate( async (currency,span) =>{
				function doSleep(mtime){
					return new Promise((resolve, reject) => {
						setTimeout(() => {
							resolve();
						}, mtime);
					});
				}
				function spanLabel(span){
					switch(span){
						case "30000":	return "30秒"; break;
						case "60000":	return "1分"; break;
						case "180000":	return "3分"; break;
						case "300000":	return "5分"; break;
						case "900000":	return "15分"; break;
						case "3600000":	return "1時間"; break;
						case "86400000":return "23時間"; break;
						default:		return ""; break;
					}
				}
				var span_label = spanLabel(span);

				close_count=0;
				var divs = document.getElementsByTagName('div');
				for(let i=0;i<divs.length;i++){
					if(!divs[i].className)continue;
					if(!divs[i].className.match(/RecentlyOpenOptions_tabContent/i))continue;
					if(divs[i].className.match(currency) && divs[i].className.match(span_label))continue; // 新しく開いたタブ候補 //
					var check_div = null;
					var divs2 = divs[i].getElementsByTagName('div');
					for(let j=0;j<divs2.length;j++){
						if(divs2[j].id && divs2[j].id=="RECENTLY_OPENED_OPTION_TAB"){
							check_div = divs2[j];
							break;
						}
					}
					if(check_div)continue;
					var divs2 = divs[i].getElementsByTagName('div');
					for(let j=0;j<divs2.length;j++){
						if(divs2[j].className && divs2[j].className.match(/RecentlyOpenOptions_tabClose/i)){
							divs2[j].click();
							close_count++;
							await doSleep(100);
						}
					}
				}
				return close_count;
			},currency,span);
			libCommon.mylog("*close old tabs closed_tab count=[" + close_count + "]");
		}catch(error){
			libCommon.myerr("close old tabs error:"  + error);
			resolve([false,error.toString()]);
		}

		resolve([true,""]);
	});
}

var w = {width:1200,height:900};
var zoom = 0.8;

async function getLoginId(page){
	return new Promise(async function (resolve, reject) {
		try{
			username = await page.evaluate( () => {
				var divs = document.getElementsByTagName('div');
				for(let i=0;i<divs.length;i++){
					if(divs[i].className && divs[i].className.match(/AccountMenu_username/i)){
						return divs[i].innerText.trim();
					}
				}
				return "";
			});
			demo_real = await page.evaluate( () => {
				var divs = document.getElementsByTagName('div');
				for(let i=0;i<divs.length;i++){
					if(divs[i].className && divs[i].className.match(/AccountMenu_accountTypeDropdown/i)){
						var divs2 = divs[i].getElementsByTagName('div');
						for(let j=0;j<divs2.length;j++){
							if(divs2[j].className && divs2[j].className.match(/Dropdown_display/i)){
								return divs2[j].innerText.trim();
							}
						}
					}
				}
				return "";
			});
			libCommon.mylog("getLoginId username=[" + username  +"] mode=[" + demo_real + "]");
			if(!demo_real.match(/本口座/)){
				resolve("demo");
			}else{
				resolve(username);
			}
			return true;
		}catch(error){
			libCommon.myerr("getLoginId error " + error.toString());
			resolve("error");
			return false;
		}
	});
}


async function relogin(page, loginid, password){
	return new Promise(async function (resolve, reject) {
		try{
			libCommon.mylog("goto relogin page!");
			var login_url = "https://app.highlow.com/login";
			await page.goto(login_url,{waitUntil: "domcontentloaded", timeout:15000});
			libCommon.mylog("page opened:" + login_url);
			await page.waitFor('#login-username');
			libCommon.mylog("Login form found!");
			await libCommon.doSleep(1300 + Math.floor( Math.random() * 500));
			await page.type("#login-username", loginid);
			await page.type("#login-password", password);
			await libCommon.doSleep(1300 + Math.floor( Math.random() * 500));
			libCommon.mylog("Login Submit click!");
			await page.click('div[id="login-submit-button"]'); // 新button!
			libCommon.mylog("Login Submit clicked!");
			await libCommon.doSleep(1300 + Math.floor( Math.random() * 500));
			var username = await page.evaluate( () => {
				var divs = document.getElementsByTagName('div');
				for(let i=0;i<divs.length;i++){
					if(divs[i].className && divs[i].className.match(/AccountMenu_username/i)){
						return divs[i].innerText.trim();
					}
				}
				return "";
			});
			if(username.length > 0){
				libCommon.mylog("relogin ok!  username=[" + username  +"]");
				resolve(true);
			}else{
				libCommon.mylog("relogin fail!  username =[" + username  +"]");
				resolve(false);
			}
			return true;
		}catch(error){
			libCommon.myerr("relogin error " + error.toString());
			resolve(false);
			return false;
		}
	});
}



function login(headless,device,userAgent,loginid,password,proxy_server,proxyauthid,proxyauthpass){
	return new Promise(async function (resolve, reject) {
		try{
			var args = [];
			args.push('--no-sandbox');
			args.push('--disable-setuid-sandbox');
			args.push('--window-size=' + w.width + ',' +  w.height);
			args.push('--disable-infobars');
			args.push('--force-device-scale-factor=' + zoom);
			if(proxy_server.length > 0){
				libCommon.mylog("use proxy=" + proxy_server);
				args.push('--proxy-server=' + proxy_server);
			}else{
				libCommon.mylog("no proxy");
			}
			var browser = await puppeteer.launch({ headless: headless, slowMo: 50, args: args });
			var page    = await browser.newPage();
			if(proxyauthid.length > 0 && proxyauthpass.length > 0){
				await page.authenticate({ username: proxyauthid, password:proxyauthpass});
			}
			if(device){
				await page.emulate(device);
			}
			await page.setViewport({width:w.width, height:w.height});
			if(userAgent.length > 0 )await page.setUserAgent(userAgent); 
			await page.evaluateOnNewDocument(() => {
    			Object.defineProperty(navigator, 'webdriver', ()=>{});
    			delete navigator.__proto__.webdriver;
			});
			if(userAgent.length > 0 )await page.setUserAgent(userAgent);
		}catch(error){
			reject(error);
			return false;
		}
		try{
			libCommon.mylog("goto login page!");
			await libCommon.doSleep(1300 + Math.floor( Math.random() * 500));
			var login_url = "https://app.highlow.com/login";
			await page.goto(login_url,{waitUntil: "domcontentloaded", timeout:15000});
			libCommon.mylog("page opened:" + login_url);
			await page.waitFor('#login-username');
			libCommon.mylog("Login form found!");
			await libCommon.doSleep(1300 + Math.floor( Math.random() * 500));
			await page.type("#login-username", loginid);
			await page.type("#login-password", password);
			await libCommon.doSleep(1300 + Math.floor( Math.random() * 500));
			libCommon.mylog("Login Submit click!");
			await page.click('div[id="login-submit-button"]'); // 新button!
			libCommon.mylog("Login Submit clicked!");
			await libCommon.doSleep(1300 + Math.floor( Math.random() * 500));
			var cookies = await page.cookies();
			var full_name = "";
			for(var x=0;x<50;x++){
				full_name = await page.evaluate( () => {
					var divs = document.getElementsByTagName('div');
					for(let i=0;i<divs.length;i++){
						if(divs[i].className && divs[i].className.match(/AccountMenu_fullname/i)){
							return divs[i].innerText.trim();
						}
					}
					return "";
				});
				if(full_name.length > 0)break;
				await libCommon.doSleep(100);
			}
			if(full_name.length<=0){
				libCommon.myerr("Login failed ＞＜:" + "ログイン済み確認できず! wait_loop="+x);
	   			reject("Login failed ＞＜:" + "ログイン済み確認できず!"+ " wait_loop=" + x + " " + libCommon.now_stamp());
				return false;
			}else{
				libCommon.mylog("login ok!  acount name found!=[" + full_name  +"] wait_loop=[" + x + "]");
			}
		}catch(error){
			libCommon.myerr("login error " + error.toString());
			reject("login error " + error.toString()+ " " + libCommon.now_stamp());
			return false;
		}
		resolve([browser,page,cookies]);
	});
}


function demologin(headless,device,userAgent,loginid,password,proxy_server,proxyauthid,proxyauthpass){
	return new Promise(async function (resolve, reject) {
		try{
			var args = [];
			args.push('--no-sandbox');
			args.push('--disable-setuid-sandbox');
			args.push('--window-size=' + w.width + ',' +  w.height);
			args.push('--disable-infobars');
			args.push('--force-device-scale-factor=' + zoom);
			if(proxy_server.length > 0){
				libCommon.mylog("use proxy=" + proxy_server);
				args.push('--proxy-server=' + proxy_server);
			}else{
				libCommon.mylog("no proxy");
			}
			var browser = await puppeteer.launch({ headless: headless, slowMo: 50, args: args });
			var page    = await browser.newPage();
			if(proxyauthid.length > 0 && proxyauthpass.length > 0){
				await page.authenticate({ username: proxyauthid, password:proxyauthpass});
			}
			if(device){
				await page.emulate(device);
			}
			await page.evaluateOnNewDocument(() => {
    			Object.defineProperty(navigator, 'webdriver', ()=>{});
    			delete navigator.__proto__.webdriver;
			});
			await page.setViewport({width:w.width, height:w.height});
			if(userAgent.length > 0 )await page.setUserAgent(userAgent);
		}catch(error){
			reject(error);
			return false;
		}
		try{
			var url = "https://app.highlow.com/quick-demo"; // 新URL!
			await page.goto(url,{waitUntil: "domcontentloaded", timeout:25000});
			await libCommon.doSleep(1300 + Math.floor( Math.random() * 500));
			await page.click('body');
			await libCommon.doSleep(1300 + Math.floor( Math.random() * 500));
			cookies = await page.cookies();
		}catch(error){
			libCommon.myerr("demologin error:" + error.toString());
			reject(error);
			return false;
		}
		resolve([browser,page,cookies]);
	});
}

