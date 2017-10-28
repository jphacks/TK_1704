//appモジュールを読み込む（このappには、www内ですでにポート番号が登録されているので、ポート番号を取得したことにもなる）
const app = require('../app');

//httpモジュールを読み込んで、サーバーを立ち上げる（createServerと同じ扱い）
const http = require('http');

//必要な三要素を揃えて初めてサーバーを立ち上げられる
const server = http.createServer(app);

//サーバーをlistenしてsocketIOを設定
const io = require('socket.io')(server);

//socketIOモジュール
function socketIO() {
  //サーバーを立ち上げたら実行
  server.listen(app.get('port'), function () {
    console.log('listening!!!');
  });

  //socket処理を記載する
  io.on('connection', (socket) => {
    console.log('a user connected');

    //socket処理
    socket.on('app', (msg) => {
      console.log(`chat message ${msg}`);
      io.sockets.emit('app', msg);
    });

  });
};

//export
module.exports = socketIO;