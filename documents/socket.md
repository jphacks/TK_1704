# websocket

## room
5種類のcolor。
* red
* yellow
* pink
* green
* purple

## イベント
* join_room
* user_logged_in
* start_music
* server_from_app
* app_from_server
* stop_music

## 各色の room に入る
以下はwebのサンプル。アプリ用に治す必要あり。
```
socket.on('connect', () => {
    console.log('connected!!!');
    const data = {};
    socket.emit('join_room', data);
});
```
room名は`join_room`にする。dataのJSONは
```
{
    "user": {
        "name": "beach3",
        "color": "red"
    }
}
```
で統一する。


## ユーザーidを取得
`join_room` したあと、`user_logged_in` にてサーバーからトークンが送られる。以後の通信にはこのトークンを用いてユーザーの識別を行う。
```
socket.on('user_logged_in', (msg) => {
    console.log(msg)
});
```

```
{
    "user": {
        "name": "beach3",
        "color": "red",
        "id": "this_is_user_id"
    }
}
```

## 音楽スタート
### Server から App
音楽が始まると`start_music` イベントが発火される。
以下のデータが送られる。
```
{
    "action": {
        "type": "start"
    }
}
```
後はスマホ側で加速度センサーでデータを取得する。

## 音楽再生中の通信データ
### App から Server
`server_from_app` でアプリからサーバーへ加速度のデータを送信する。
```
// ブラウザでのコード。アプリ用にする必要あり。
socket.emit('server_from_app', {
    user: {
        id: userId,
        name: userName,
        color: color,
    },
    score: {
        all: 1345, // なくてもいい
        duration: 13
    },
    action: { // actionは未実装。無くても可。
        type: 'vertical',
        strength: 3
    }
});
```
送信するJSONの形式は以下に統一。
```
{
    "user": {
        "id": "this_id_user_id",
        "name": "mugicha",
        "color": "red"
    },
    "score": {
        "all": 1345, // なくてもいい
        "duration": 13
    },
    "action": { // 未実装
        "type": "vertical",
        "strength": 3
    }
}
```

### Server から
`app_from_server`で。サーバーから所属しているチームのデータが送られてくる。
```
// ブラウザのコード...。
socket.on('app_from_server', (data) => {
    const res = JSON.stringify(data);
});
```
取得できるJSONは以下の通り。
(うそ、このレスポンスは使わないかも。要検討)
```
{
    "user": {
        "color": "red",
        "name": ""
    },
    "team": {
        "color": "red",
        "score": {
            "all": 165 // チームの合計値
        }
    }
}
```

App から Server への送信タイミングはアプリ側で決める。
ユーザーがデータを更新したら、同じルームのユーザー全員は Server から データが送られる。


## 音楽終了
### Server から App
音楽が始まると`stop_music` イベントが発火される。
以下のデータが送られる。
```
{
    "action": {
        "type": "stop"
    }
}
```
