import SocketIO

final class SocketModel {
    let socket = SocketIOClient(socketURL: URL(string: "http://133.130.124.246:2017/")!, config: [.log(true), .compress])

    func connect (uuid: String, color: String) {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            let params = [
                "user": [
                    "id": uuid,
                    "color": color
                ]
            ]
            
            self.socket.emit("join_room", params)
        }
        socket.on("disconnect") { data, ack in
            print("socket disconnected!!")
        }
        
        socket.on("currentAmount") {data, ack in
            if let cur = data[0] as? Double {
                self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                    self.socket.emit("update", ["amount": cur + 2.50])
                }

                ack.with("Got your currentAmount", "dude")
            }
        }
        
        socket.on("from_server") { (data, emitter) in
            let message = data
            print("ここだよ！")
            print(message)
        }
        
        
        socket.connect()
    }
    
}
