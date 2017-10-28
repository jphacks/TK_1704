const path = require('path');
var express = require('express');
var router = express.Router();

const app = express();
const http = require('http').Server(app);
const io = require('socket.io')(http);

app.use(express.static(__dirname + '/node_modules'));

/* GET home page. */
router.get('/', function (req, res, next) {
  // res.render('index', { title: 'Express' });
  res.sendFile(path.join(__dirname + '/../views/index.html'));
});

// クライアントからの接続を待つ
io.on('connection', function (socket) {
  console.log('a user connected');
  socket.on('disconnect', function () {
    console.log('user disconnected');
  });
  // クライアントからメッセージを受け取ったら投げ返す
  socket.on('chat message', function (msg) {
    // 同じクライアントに送信する場合は socket.emit を io.emit に変える
    socket.emit('chat message', msg);
  });
});

module.exports = router;
