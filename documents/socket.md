# websocket

## room
5種類のcolor。
* red
* yellow
* pink
* green
* purple

## 各色の room に入る
以下はwebのサンプル。アプリ用に治す必要あり。
```
socket.on('connect', () => {
    console.log('connected!!!');
    const data = {};
    socket.emit('join_room', data);
});
```
namespace を`join_room`にする。dataのJSONは
```
{
    "user": {
        "id": "thisisuniqueid",
        "color": "red"
    }
}
```
で統一する。

## 音楽スタート
### Server から App
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
        all: 1345,
        duration: 13
    },
    action: {
        type: 'vertical',
        strength: 3
    }
});
```
送信するJSONの形式は以下に統一。
```
{
    "user": {
        "id": "thisisuniqueid",
        "name": "mugicha",
        "color": "red"
    },
    "score": {
        "all": 1345,
        "duration": 13
    },
    "action": {
        "type": "vertical",
        "strength": 3
    }
}
```

### Server から
`app_to_server`で。サーバーから所属しているチームのデータが送られてくる。
```
// ブラウザのコード...。
socket.on('app_to_server', (data) => {
    const res = JSON.stringify(data);
});
```
取得できるJSONは以下の通り。
```
{
    "user": {
        "color": "red",
        "order": 3
    },
    "action": {
        "type": "order",
        "data": [
            "pink",
            "yellow",
            "red",
            "purple",
            "green"
        ]
    }
}
```

App から Server への送信タイミングはアプリ側で決める。
ユーザーがデータを更新したら、同じルームのユーザー全員は Server から データが送られる。