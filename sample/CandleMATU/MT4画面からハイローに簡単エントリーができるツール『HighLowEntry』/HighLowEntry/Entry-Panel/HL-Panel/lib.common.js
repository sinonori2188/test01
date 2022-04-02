
const fs = require('fs');
const request = require('request');
var cookiejar = request.jar();

module.exports.touch = (filename) =>{
	try {
		fs.statSync(filename);
		return true
	}catch(error){
		fs.closeSync(fs.openSync(filename, 'w'));
		return true;
	}
}


module.exports.now_stamp = (value) => {
	return now_stamp();
}
function now_stamp(){
	var t  = new Date();
	return (t.getFullYear()) + "-" + ('0' + (t.getMonth() + 1)).slice(-2) + "-" + ('0' + t.getDate()).slice(-2) + " " + ('0'+t.getHours()).slice(-2) + ":" + ('0'+t.getMinutes()).slice(-2) + ":" + ('0'+ t.getSeconds()).slice(-2);
}

module.exports.todays_file_name = (value) => {
	return todays_file_name();
}
function todays_file_name(){
	var t  = new Date();
	return (t.getFullYear()) + "" + ('0' + (t.getMonth() + 1)).slice(-2) + "" + ('0' + t.getDate()).slice(-2)
}


module.exports.wait_str = (wait) => {
	return wait_str(wait);
}
function wait_str(wait){
	var h = Math.floor( wait / ( 60 * 60 * 1000));
	var temp = wait - h * ( 60 * 60 * 1000);
	var m = Math.floor( temp / ( 60 * 1000));
	var temp = temp - m * ( 60 * 1000);
	var s = Math.floor( temp / 1000);
	return h + "h " + m + "m " + s + "s";

}


module.exports.doPost = (options) =>{
	options['jar'] = cookiejar;
  	return new Promise(function (resolve, reject) {
    	request.post(options, function (error, res, body) {
    		if (!error && res.statusCode == 200) {
       			resolve(body);
     		} else {
        		reject(error);
      		}
    	});
  	});
}

module.exports.doGet = (options) => {
	options['jar'] = cookiejar;
	return new Promise(function (resolve, reject) {
  		request.get(options,function (error, res, body) {
   			if (!error && res.statusCode == 200) {
      			resolve(body);
   			} else {
      			reject(error);
   			}
   		});
	});
}

module.exports.doSleep = (mtime) => {
   	return new Promise((resolve, reject) => {
       	setTimeout(() => {
           	resolve();
       	}, mtime);
   	});
}

module.exports.checkRes = (restext) => {
	var res ={};
	if(restext.match(/All Scraped/)){
		res.end = true;
	}else{
		res.end = false;
		res.scrape        = getTag("scrape",restext);
		res.scrape_set_id = getTag("scrape_set_id",restext);
		res.record_id     = getTag("record_id",restext);
		res.url           = getTag("url",restext);
		res.now_page      = getTag("now_age",restext);
	}
	return res;
}

function getTag(tag,res){
	var pattern = "<" + tag + ">(.*?)<\/" + tag + ">";
	var temp = res.match(pattern);
	if(temp){
		return temp[1];
	}else{
		return "";
	}
}

module.exports.get_a_text = (page,pattern) =>{

	console.log("check:" + pattern + " " + now_stamp());

  return new Promise(function (resolve, reject) {
	(async ()=>{
		try{
			var aa = await page.$$('a');
			console.log("aa.length=" + aa.length);
			for(var i=0;i<aa.length;i++){
				var text = await (await aa[i].getProperty('innerHTML')).jsonValue();
				//console.log("["+ i + "]" + text);
				if(text.match(pattern)){
					var text = text.trim();
					console.log(text);
					resolve(aa[i]);
					return true;
				}
			}
			resolve(null);
		}catch(error){
			reject(error);
		}
	})();
  });
}

