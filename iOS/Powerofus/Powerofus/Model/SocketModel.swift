import SocketIO
import SwiftyUserDefaults

final class SocketModel {

    let socket: SocketIOClient
    let color: String
    var token = ""
    var getJson: NSDictionary!
    var jsonIp = ""
    var isStart = false
    
    init(_ url: String, _ color: String) {
        socket = SocketIOClient(socketURL: URL(string: url)!, config: [.log(true), .compress])
        self.color = color
    }

    func connect (color: String) {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            let params = [
                "user": [
                    "id": Defaults[.userName],
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
        
        socket.on("user_logged_in") { data, ack in
            print("うわー")
            print(data)
            
            if let arr = data as? [[String: [String:String]]] {
                print("aaaaaaa")
                print(arr)
                if let arr2 = arr[0]["user"] {
                    if let txt = arr2["id"] {
                        self.token = txt
//                        print("トークン\(txt)")
                    }
                    
                }
            }
        }
        
        socket.on("server_from_app") { data, ack in
            print("うへへへへ")
            print(data)
            
        }
        
        socket.on("start_music") { data, ack in
            if let arr = data as? [[String: [String:String]]] {
                print("aaaaaaa")
                print(arr)
                if let arr2 = arr[0]["action"] {
                    if let txt = arr2["type"] {
                        print("今の状況\(txt)")
                        if txt == "start" {
                            self.isStart = true
                        }
                    }
                }
            }
        }
        
        socket.on("stop_music") { data, ack in
            if let arr = data as? [[String: [String:String]]] {
                print("aaaaaaa")
                print(arr)
                if let arr2 = arr[0]["action"] {
                    if let txt = arr2["type"] {
                        print("今の状況\(txt)")
                        if txt == "stop" {
                            self.isStart = false
                        }
                    }
                }
            }
        }
        socket.connect()
    }
    
    func sendScore(score: Int, color: String) {
        let params: [String : Any] = [
            "user": [
                "id": token,
                "name": Defaults[.userName],
                "color": color
            ],
            "score": [
                "duration": score
            ],
        ]
        socket.emit("server_from_app", params)
    }
    
}
