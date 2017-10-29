const fs = require('fs');
const path = require('path');
const Datastore = require('nedb-promises');


// DB設定
const db = {};
db.user = new Datastore({
  filename: path.join(__dirname, '../NeDB/user'),
  autoload: true
});
db.action = new Datastore({
  filename: path.join(__dirname, '../NeDB/action'),
  autoload: true
});
// db.live = new Datastore({
//   filename: path.join(__dirname, '../NeDB/live'),
//   autoload: true
// });


//appモジュールを読み込む（このappには、www内ですでにポート番号が登録されているので、ポート番号を取得したことにもなる）
const app = require('../app');

//httpモジュールを読み込んで、サーバーを立ち上げる（createServerと同じ扱い）
const http = require('http');

//必要な三要素を揃えて初めてサーバーを立ち上げられる
const server = http.createServer(app);

//サーバーをlistenしてsocketIOを設定
const io = require('socket.io')(server);

// 乱数を取得
const getRandom = (len = 16) => {
  var str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let result = '';
  for (let i = 0; i < len; i++) {
    result += str.charAt(Math.floor(Math.random() * str.length));
  }
  return result;
}

//socketIOモジュール
function socketIO() {
  //サーバーを立ち上げたら実行
  server.listen(app.get('port'), function () {
    console.log('listening 2017 !!!');
  });

  // ライブid
  let liveId = 'thisisliveid';
  let living = false;

  // socket の接続
  io.on('connection', (socket) => {
    console.log('a user connected');
    console.log('connections: ', socket.client.conn.server.clientsCount);

    // 色ごとの部屋に別ける
    socket.on('join_room', (msg) => {
      // ユーザーデータをDBに登録
      db.user.insert({
        color: msg.user.color,
        name: msg.user.name
      })
        .then(insertDoc => {
          // console.log(insertDoc);
          // 送信元にユーザートークンを返す
          io.sockets.connected[socket.id].emit('user_logged_in', {
            user: {
              name: insertDoc.name,
              color: insertDoc.color,
              id: insertDoc._id
            }
          });
        })
        .catch((error) => {
          console.log('🚨', error);
        });

      // ユーザーを色毎のルームへ入れる
      const color = msg.user.color;
      socket.join(color);
    });

    // アプリからサーバーへのアクションデータを取得
    socket.on('server_from_app', (msg) => {
      if (living !== true) {
        return;
      }

      const { all, duration } = msg.score;
      const { id, name, color } = msg.user;

      db.action.insert({
        userId: id,
        color: color,
        scoreDuration: duration,
        liveId: liveId
      })
        .then(insertDoc => {
          db.action.find({
            color: color,
            liveId: liveId
          })
            .then(findDoc => {
              let sumScore = 0; // チームの合計値
              findDoc.forEach((element) => {
                sumScore += element.scoreDuration;
              });

              // 同じ内容を同じチームの人に送る
              io.in(color).emit('app_from_server', {
                user: {
                  name: name,
                  color: color
                },
                team: {
                  color: color,
                  score: {
                    all: sumScore
                  }
                }
              });

            })
            .catch(error => {
              console.log(error);
            })

        })
        .catch(error => {
          console.log(error);
        });
    });

    //socket処理
    socket.on('app', (msg) => {
      console.log(`chat message ${msg}`);
      io.sockets.emit('app', msg);
    });

    // 音楽が開始された
    socket.on('start_web_music', () => {
      if (living === true) {
        return;
      }
      // ライブのidをランダムで設定
      liveId = getRandom();
      living = true;

      // アプリ側に音楽が始まったことを知らせる
      io.sockets.emit('start_music', {
        action: {
          type: "start"
        }
      });
    });

    // 音楽が終わった
    socket.on('stop_web_music', () => {
      if (living === false) {
        return;
      }
      living = false;

      // アプリ側に音楽が終わったことを知らせる
      io.sockets.emit('stop_music', {
        action: {
          type: "stop"
        }
      });
    });

    //jsonfileを読み出して返すイベント
    socket.on('read_json', () => {
      db.action.find({
        liveId: liveId
      })
        .then(findDoc => {

          const colorData = {
            red: 0,
            yellow: 0,
            pink: 0,
            green: 0,
            purple: 0
          };

          findDoc.forEach((element) => {
            switch (element.color) {
              case 'red':
              case 'yellow':
              case 'pink':
              case 'green':
              case 'purple':
                colorData[element.color] = colorData[element.color] + element.scoreDuration;
                break;
            }
          });
          console.log("all_color_sum")
          io.sockets.connected[socket.id].emit('all_color_sum', colorData);
        })
        .catch(error => {
          console.log(error);
        });

    });

  });
};


//export
module.exports = socketIO;