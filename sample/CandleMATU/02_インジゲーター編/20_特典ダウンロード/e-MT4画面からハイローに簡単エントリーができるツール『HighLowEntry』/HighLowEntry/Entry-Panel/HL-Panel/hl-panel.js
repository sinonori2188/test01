
const fs		= require('fs');
const io		= require('socket.io-client');
const ip		= require('ip');
const request	= require('request');
const libCommon	= require('./lib.common.js');
const key		= "needfrom-2020-04-28-aabbcc888fff"; // 2020.04.28追加 //

console.log("");
console.log("***");
console.log("*** hl-panel.js start at:" + libCommon.now_stamp());
console.log("***");
console.log("");


//const {app,BrowserWindow,Menu,shell,dialog} = require('electron');
const {app,BrowserWindow,Menu,shell,dialog,ipcMain} = require('electron');

let win;

console.log("");
console.log("hl-panel init:" + libCommon.now_stamp());

function initWindow(){

	console.log("initWindow!");

	//win = new BrowserWindow({width:600, height:400, alwaysOnTop:true});
	//win = new BrowserWindow({width:600, height:400});
	win = new BrowserWindow({width:560, height:530, alwaysOnTop:true, useContentSize: true, webPreferences:{nodeIntegration:true}});
	//win.setMenu(null);
	win.loadURL(`file://${__dirname}/index.html`);
	myMenu();
	console.log("initWindow ok!");
	win.on('closed',()=>{ win = null;});
	console.log("hl-panel started:" + libCommon.now_stamp());

	win.on("resize", function () {
		var size = win.getSize();
		var width = size[0];
		var height = size[1];
		win.webContents.send("resized", {height:height,width:width});
		console.log("w=[" + width + "] h=[" + height + "]");
	  });
}
app.on('ready',initWindow);

app.on('window-all-closed',()=>{
	console.log("process.platform=" + process.platform);
	if(process.platform !=='darwin'){
		console.log("quit");
		app.quit();
	}
});

app.on('activate',()=>{
	if(win===null){
		initWindow();
	}
});


function myMenu(){

    const menulist = [
        {
            label: '接続設定(ctrl+S)',
			click () { openSetting(); }
		},
        {
            label: '実行ログ(ctrl+L)',
			click () { openLog(); }
        },
		{
			label: '終了(ctrl+X)',
			//accelerator: 'Ctrl+X',
			//accelerator: 'CmdOrCtrl+X',
			click: myExit
		},
		{
			label: 'クリア(F5)',
			click: myClear
		},
        {
            label: 'con(F12)',
			click () { BrowserWindow.getFocusedWindow().toggleDevTools(); }
        },
	]

	const menu = Menu.buildFromTemplate(menulist);
    Menu.setApplicationMenu(menu);
}

let subWin = null;

function loadSub(template_file){

	subWin = new BrowserWindow({
		parent: win,
		title: "接続設定",
		//modal: true,
		width: 600,
		height:700,
		webPreferences:{nodeIntegration:true},
    });
	subWin.setMenu(null);
    subWin.loadURL(`file://${__dirname}/${template_file}`);
}

function closeSub(){
	BrowserWindow.fromId(subWin.id).close();
	subWin = null;
}
exports.closeSub = closeSub;




function myClear(){
	console.log("Reload hl-panel");
	win.reload();
}


function myExit(){
	console.log("Quit hl-panel");
	app.quit();
}
exports.myExit = myExit;

function openSetting(){
	loadSub('setting.html');
}
exports.openSetting = openSetting;

function openLog(){

	//shell.openExternal('http://127.0.0.1:5901/');

	try {
		server_url	= fs.readFileSync("./server_url.txt", 'utf8');
		server_url	= server_url.replace(/\n/,"").replace(/\r/,"");

		if(server_url.length<=0){

			dialog.showMessageBox(win, {
				title: "未設定",
        		type:  "warning",
        		message: "接続設定をすませてください。\n" + libCommon.now_stamp(),
        		buttons: ['OK'],
    		});

		}else{
			var todays_log_url = server_url + "log/" + libCommon.todays_file_name() + ".txt";
			shell.openExternal(todays_log_url);
			return true;
		}

	}catch(error){

		dialog.showMessageBox(win, {
			title: "未設定",
        	type:  "warning",
        	message: "接続設定をすませてください。\n" + libCommon.now_stamp(),
        	buttons: ['OK'],
    	});
		return false;
	}

}
exports.openLog = openLog;

//----------------------------//
//
// hl-serverと連携
//
//----------------------------//


let socket		= null;
let server_url	= "";
let g_msg_type	= "";
let g_title		= "";
let g_msg		= "";


function myReadFileSync(path){
	try {
		return fs.readFileSync(path, 'utf8');
	}catch(error){
		return "";
	}
}
exports.myReadFileSync = myReadFileSync;

function myWriteFileSync(path,content){

	try {
		return fs.writeFileSync(path, content);
	}catch(error){
		return false;
	}
}
exports.myWriteFileSync = myWriteFileSync;

function disconnect_hl_server(){
	if(socket){
		console.log("socket.disconnect:" + libCommon.now_stamp());
		socket.disconnect();
		socket = null;
	}
}
exports.disconnect_hl_server = disconnect_hl_server;


let is_connect_error = false;

async function connect_hl_server(){
//function connect_hl_server(){

  	return new Promise(function (resolve, reject) {

		g_msg = "";

		try {
			server_url	= fs.readFileSync("./server_url.txt", 'utf8');
			server_url	= server_url.replace(/\n/,"").replace(/\r/,"");
		}catch(error){
			g_msg_type	= "warning";
			g_title		= "未設定";
			g_msg		= "接続設定をすませてください。\n" + libCommon.now_stamp();
			is_connect_error = true;
			//return false;
		}

		if(g_msg.length > 0)reject();

		console.log("server_url=[" + server_url + "]" + libCommon.now_stamp());

		if(server_url.length <= 0){
			g_msg_type	= "warning";
			g_title		= "未設定";
			g_msg		= "接続設定をすませてください。\n" + libCommon.now_stamp();
			is_connect_error = true;
			reject();
			//return false;
		}else{

			try {

				if(socket){
					console.log("socket.disconnect:" + libCommon.now_stamp());
					socket.disconnect();
				}

				console.log("io.connect [" +  server_url + "]" + libCommon.now_stamp());

				//socket = io.connect(server_url,{'connect timeout':3000});
				socket = io.connect(server_url,{'connect timeout':3000, query:'key='+key}); // 2020.04.28 //

				if(!socket){
					console.log("io.connect error1!:" + libCommon.now_stamp());
					g_msg_type	= "error";
					g_title		= "接続エラー1";
					g_msg		= "接続設定されたHL-Serverに接続できませんでした。\n" + server_url + "\n" + libCommon.now_stamp();
					is_connect_error = true;
					reject();

				}else{
					console.log("socket ok!:" + libCommon.now_stamp());
					//console.log(socket);

					socket.on('connect', () => {
						let obj = {};
						obj.msg = "HL-Panel起動 ip=[" + ip.address() + "]" + libCommon.now_stamp();
						obj.key = key; // 2020.04.28 //
						socket.emit("panel-start", obj);
						console.log("connect ok:" + libCommon.now_stamp());
						is_connect_error = false;
						resolve();
					});

					socket.on('connect_error', function(err){
						console.log("io.connect error2!:" + libCommon.now_stamp());
						g_msg_type	= "error";
						g_title		= "接続エラー2";
						g_msg		= "接続設定されたHL-Serverに接続できませんでした。\n" + server_url + "\n" + libCommon.now_stamp();
						is_connect_error = true;
						socket.disconnect();
						//socket 		= null;
						reject();
					});
				}

			}catch(error){

				console.log("io.connect error3!:" + libCommon.now_stamp());
				g_msg_type	= "error";
				g_title		= "接続エラー3";
				g_msg		= "接続設定されたHL-Serverに接続できませんでした。\n" + server_url + "\n" + libCommon.now_stamp();
				//reject();
			}

			if(g_msg.length > 0){
				is_connect_error = true;
				reject();
			}

		}
	});
}
exports.connect_hl_server = connect_hl_server;


connect_hl_server();
console.log("server_url=[" + server_url + "]");


function getGlobalMsg(){

	if(g_msg.length<=0){
		return null;
	}else{
		var res		= {};
		res.type	= g_msg_type;
		res.title	= g_title;
		res.msg		= g_msg;
		g_msg_type	= "";
		return res;
	}
}
exports.getGlobalMsg = getGlobalMsg;


//let socket	= io.connect('http://localhost:3000');

function sendOrder(type,msg,order,try_cnt){

	if(is_connect_error){
		g_msg_type	= "error";
		g_title		= "接続エラー1";
		g_msg		= "接続設定されたHL-Serverに接続できませんでした。\n" + server_url + "\n" + libCommon.now_stamp();
		return false;

	}else if(!socket){
		g_msg_type	= "error";
		g_title		= "接続エラー2";
		g_msg		= "接続設定されたHL-Serverに接続できませんでした。\n" + server_url + "\n" + libCommon.now_stamp();
		return false;
	}

	var data = {};
	data.msg   = msg;
	data.type  = type;
	data.order = order;
	data.key   = key; // 2020.04.28 //

    socket.emit("panel-operation",data);

	console.log("[" + libCommon.now_stamp() + "][" + type + "]" +  JSON.stringify(order) );

	return true;
}
exports.sendOrder = sendOrder;

function stopAll(){

	if(!socket){
		g_msg_type	= "error";
		g_title		= "接続エラー";
		g_msg		= "接続設定されたHL-Serverに接続できませんでした。\n" + server_url + "\n" + libCommon.now_stamp();
		return false;
	}

	var data = {};
	data.msg  = "stop all client!:" + libCommon.now_stamp();
	socket.emit("stop-all",data);

}
exports.stopAll = stopAll;

// 不採用 //
ipcMain.handle("setWindowSize", (event, args) => {
	console.log("called");
    win.webContents.setZoomFactor(args.zoom);
    win.setContentSize(win * zoom, win * zoom);
});