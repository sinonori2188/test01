// 2022.02.22.001
//
// hl-server.js
// 　HL-Panelからの操作をHL-Clientにチャット配信する チャットサーバー
//   ( +日別ログファイルにログ保存 )
//   ( +
'use strict';

const fs		= require('fs');
const csv		= require('csv');					// 2020.02.21 追加 //
const csvSync	= require('csv-parse/lib/sync');	// 2020.02.21 追加 //
const http		= require('http');
const express	= require('express');
const socketIO	= require('socket.io');
const ip		= require('ip');
const libCommon	= require('./lib.common.js');
const key		= "needfrom-2020-04-28-aabbcc888fff"; // 2020.04.28追加 //

const app		= express();
const server	= http.Server(app);
const io		= socketIO(server);

// listenポート //
const PORT		= process.env.PORT || 5733;
const CMD		= "gotomars";


// logファイル //
const log_dir	= 'log';
let	  log_file	= '';
if(!fs.existsSync(log_dir))fs.mkdirSync(log_dir);
log_touch();

// logファイル fs.appendFileSync(log_file,msg) を直後に呼べるようにする //
function log_touch(){
	let log_file_new = log_dir + '/' + libCommon.todays_file_name() + ".txt";
	if(log_file_new !== log_file){
		log_file = log_file_new;
		libCommon.touch(log_file);
	}
}


// ------ 2020.02.21 追加ここから ------ //
// 設定csvファイル //
let csvdata = [];
const csvinterval = 5 * 60 * 1000; // 5分間隔で読み直す //
//const csvinterval = 30 * 1000; // 30秒間隔で読み直す //
const csvfile = 'account.csv';
libCommon.touch(csvfile);
let account_reload_timer = null;
function reload_account(){
	if(account_reload_timer)clearTimeout(account_reload_timer);

	// 再読み込み //
	let data	= fs.readFileSync(csvfile);
	csvdata = csvSync(data, { columns: true, skip_empty_lines: true});
	console.log(csvdata);

	// log //
	let msg = "csvdata reloaded " + csvdata.length +  "records at:" +  libCommon.now_stamp();
	console.log(msg);
	log_touch();
	fs.appendFileSync(log_file,msg +"\n");

	account_reload_timer = setTimeout(reload_account, csvinterval);
}
reload_account();
// ------ 2020.02.21 追加ここまで ------ //


let client_socket_ids = {};

let panel_obj = null; // 2022.02.21 //

io.on('connection',(socket) => { // https://nodejs.org/api/net.html



	//console.log(socket.handshake.query);
	//console.log(libCommon.now_stamp());

	//--------------//
	//              //
	//   HL (All)   //
	//              //
	//--------------//

	socket.on('disconnect',()=>{

		// broadcast message //
		let msg = '[disconnect] socket.id='+socket.id + ' ip='+  socket.handshake.address  + ' at ' + libCommon.now_stamp();
		socket.broadcast.emit('message',msg);

		// log //
		console.log(msg);
		log_touch();
		//fs.appendFileSync(log_file,msg + "\n");
		fs.appendFile(log_file,msg + "\n",function(err){});

	});

	//--------------//
	//              //
	//   HL-Panel   //
	//              //
	//--------------//

	// 接続通知 //
	socket.on('panel-start', (obj) => {

		// keyチェック ここから 2020.04.28 //
		if(!obj.key || obj.key != key){
			var error_msg = '*** Rejected! key is missing *** => ' +  obj.msg;
			io.emit('message', error_msg);
			if(!socket.disconnected)socket.disconnect();

			// log //
			console.log(error_msg);
			log_touch();
			fs.appendFile(log_file,error_msg + "\n",function(err){});
			return false;
		}
		// keyチェック ここまで 2020.04.28 //

		// broadcast operation //
		io.emit('message', obj.msg);

		// log //
		console.log(obj.msg);
		log_touch();
		//fs.appendFileSync(log_file,obj.msg + "\n");
		fs.appendFile(log_file,obj.msg + "\n",function(err){});
	});


	// 操作通知 //
	socket.on('panel-operation', (obj) => {

		// keyチェック ここから 2020.04.28 //
		if(!obj.key || obj.key != key){
			var error_msg = '*** Rejected! key is missing *** => ' +  obj.msg;
			io.emit('message', error_msg);
			if(!socket.disconnected)socket.disconnect();

			// log //
			console.log(error_msg);
			log_touch();
			fs.appendFile(log_file,error_msg + "\n",function(err){});
			return false;
		}
		// keyチェック ここまで 2020.04.28 //

		// broadcast operation //
		delete obj.key; // 2022.02.01 //
		io.emit('operate', obj);

		panel_obj = obj; // 2022.02.21 //

		// log //
		//console.log(obj.msg);
		console.log(obj);
		log_touch();
		//fs.appendFileSync(log_file,obj.msg + "\n");
		fs.appendFile(log_file,obj.msg + "\n",function(err){});

	});

	// 全停止 //
	socket.on('stop-all', (obj) => {

		// broadchast stop //
		//io.emit('stop-all', obj); // --- 2020.02.21 強制停止無効化 --- //

		// log //
		console.log(obj.msg);
		log_touch();
		//fs.appendFileSync(log_file,obj.msg + "\n");
		fs.appendFile(log_file,obj.msg + "\n",function(err){});
	});


	//--------------//
	//              //
	//   HL-Client  //
	//              //
	//--------------//

    socket.on('client-start', (obj) => {

		var msg = '';

		var msg_mode = '';

		if(obj.first && parseInt(obj.first)==1){
			msg_mode = '[client add]';
		}else{
			msg_mode = '[client check]';
		}


		// ----- 2020.02.21 追加 ここから ----- //
		// HLIDとtokenで認証 //
		if(!obj.highlowId){
			msg = "client-start insufficient #000403 ip=" + socket.handshake.address + " at " + libCommon.now_stamp();
			console.log(msg);
			io.to(socket.id).emit('client-start-error', msg);
			return false;
		}
		if(!obj.token){
			msg = "client-start insufficient #000404 ip=" + socket.handshake.address + " at " + libCommon.now_stamp();
			console.log(msg);
			io.to(socket.id).emit('client-start-error', msg);
			return false;
		}

		//userid,amount,token
		for(let i in csvdata) {
			if(csvdata[i].highlowId == obj.highlowId){
				if(csvdata[i].token == obj.token){
					io.to(socket.id).emit('your-amount', csvdata[i].amount);
					msg = msg_mode + ' socket.id='+socket.id + ' ip='+  socket.handshake.address  + ' at ' + libCommon.now_stamp();
					socket.broadcast.emit('message',msg);
					console.log(msg);
					log_touch();
					//fs.appendFileSync(log_file,msg +"\n");
					fs.appendFile(log_file,msg +"\n",function(err){});
					return true;
				}else{
					msg = "client-start token not match ip=" + socket.handshake.address + " at " + libCommon.now_stamp();
					//socket.broadcast.emit('message',msg);
					io.to(socket.id).emit('client-start-error', msg);
					console.log(msg);
					log_touch();
					//fs.appendFileSync(log_file, msg +"\n");
					fs.appendFile(log_file, msg +"\n",function(err){});
					if(!socket.disconnected)socket.disconnect();　// 切断 //
					return false;
				}
			}
		}

		msg = "client-start highlowId not found:" + obj.highlowId + " ip=" + socket.handshake.address + " at " + libCommon.now_stamp();
		socket.broadcast.emit('message',msg);
		io.to(socket.id).emit('client-start-error', msg);
		console.log(msg);
		log_touch();
		//fs.appendFileSync(log_file, msg +"\n");
		fs.appendFile(log_file, msg +"\n",function(err){});
		if(!socket.disconnected)socket.disconnect();　// 切断 //
		return false;

		// ----- 2020.02.21 追加 ここまで ----- //

		// broadcast message //
		//let msg = '[client add] socket.id='+socket.id + ' ip='+  socket.handshake.address  + ' at ' + libCommon.now_stamp();
		//socket.broadcast.emit('message',msg);
		// log //
		//fs.appendFile(log_file,msg + "\n");

    });

    socket.on('client-message', (obj) => {

		socket.broadcast.emit('message',obj.msg);

		// log //
		console.log(obj.msg);
		log_touch();
		//fs.appendFileSync(log_file,obj.msg +"\n");
		fs.appendFile(log_file,obj.msg +"\n",function(err){});
    });

});


app.use(express.static(__dirname + '/public'));

//
// logファイル表示
//
app.get('/log/:log_file', function (req, res) {

	let log_file = "./log/" + req.params.log_file;

	try {
		fs.statSync(log_file);
		res.send(fs.readFileSync(log_file));
	}catch(error){
		res.send(log_file + " not found!:" + libCommon.now_stamp());
	}
});

// 2022.02.21追加ここから //
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.post("/mt4-operation", function(req, res, next) {
	console.log(req.body);

	if(!req.body.key || req.body.key != key){
		var error_msg = '*** Rejected! key is missing *** => ' +  req.body.msg;
		io.emit('message', error_msg);
		console.log(error_msg);
		log_touch();
		fs.appendFile(log_file,error_msg + "\n",function(err){});
		res.send(error_msg + ":" + libCommon.now_stamp());
	}else{
		// broadcast operation //
		console.log("req.body");
		console.log(req.body);
		console.log("panel_obj");
		console.log(panel_obj);
		if(!panel_obj)panel_obj ={};
		if(!panel_obj.order)panel_obj.order ={};
		if(!panel_obj.order.span)panel_obj.order.span = "";
		if(!panel_obj.order.amount)panel_obj.order.amount = "";
		let obj 	= {};
		obj.type	= req.body.type;
		obj.msg		= req.body.msg;
		obj.order 	= {};
		obj.order.currency 	= req.body.currency;
		obj.order.span 		= (req.body.span.length > 0) ? req.body.span : panel_obj.order.span;
		obj.order.amount    = panel_obj.order.amount;
		obj.order.action	= req.body.action;
		setTimeout(function(){
 			io.emit('operate', obj);
			console.log("emit");
		},10,obj);
		console.log(obj);
		log_touch();
		fs.appendFile(log_file,obj.msg + "\n",function(err){});
		var order_msg = "currency=[" + obj.order.currency + "] span=["+obj.order.span + "] amount=[" + obj.order.amount +"] action=[" + obj.order.action + "]";
		res.send("sended! " + order_msg +  ":" + libCommon.now_stamp());
	}
});
// 2022.02.21追加ここまで //

server.listen(PORT, ()=>{

	//let server_url = "http://" + ip.address() + ":" + PORT +  "/?cmd=" + CMD;

	console.log("***");
	console.log("*** hl-server.js start at:" + libCommon.now_stamp());
	console.log("***");
	console.log("");
	//console.log(server_url);
	console.log("");
	console.log("");

	//console.log('server ip not setted starts on port: %d', PORT);
});
