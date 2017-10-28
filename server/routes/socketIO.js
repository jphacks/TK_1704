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
    console.log('listening 2017 !!!');
  });


  // socket の接続
  io.on('connection', (socket) => {
    console.log('a user connected');
    console.log('connections: ', socket.client.conn.server.clientsCount);

    // 色ごとの部屋に別ける
    socket.on('join_room', (msg) => {
      console.log(msg);
      color = msg.user.color;
      socket.join(color);
    });

    // アプリからサーバーへのアクションデータを取得
    socket.on('server_from_app', (msg) => {
      const { all, duration } = msg.score;
      const { id, name, color } = msg.user;

      const order = 1; // 所属している色の順番

      const data = {
        user: {
          color,
          order
        },
        action: {
          type: 'order',
          data: [
            'pink',
            'yellow',
            'red',
            'purple',
            'green'
          ]
        }
      };

      console.log('app_from_server', data)

      // 同じ内容を同じルームの人に送る
      io.in(color).emit('app_from_server', data);
    });

    //socket処理
    socket.on('app', (msg) => {
      console.log(`chat message ${msg}`);
      io.sockets.emit('app', msg);
    });

  });
};

//export
module.exports = socketIO;