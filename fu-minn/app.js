// 1.モジュールオブジェクトの初期化
var fs = require("fs");
var server = require("http").createServer(function(req, res) {
     res.writeHead(200, {"Content-Type":"text/html"});
     var output = fs.readFileSync("./index.html", "utf-8");
     res.end(output);
}).listen(8081);
var io = require("socket.io").listen(server);


// 2.イベントの定義
io.sockets.on("connection", function (socket) {

  //jsonfileを読み出して返すイベント
  socket.on("readJSON",function(color){
    var rawdata = fs.readFileSync('id_data.json',"utf-8");
    var data = JSON.parse(rawdata);
    var score = data[color];
    var name = "json" + color
    io.sockets.emit(name,{value: score});
  });

  //音楽スタート開始イベント
  socket.on("startmusic",function(){

  });

  //音楽ストップイベント
  socket.on("stopmusic",function(){

  });
});
