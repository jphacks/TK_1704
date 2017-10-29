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
  if (req.query.dev !== undefined) {
    res.sendFile(path.join(__dirname + '/../views/index.dev.html'));
  } else {
    res.sendFile(path.join(__dirname + '/../views/index.html'));
  }
});



module.exports = router;
