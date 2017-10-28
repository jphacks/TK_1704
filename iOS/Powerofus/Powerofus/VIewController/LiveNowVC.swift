import UIKit
import SnapKit
import Material


class LiveNowVC: UIViewController {
    

    let socketModel: SocketModel
    let motionModel = MotionModel()
    
    var timer: Timer!
    
    init(_ model: SocketModel) {
        self.socketModel = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        motionModel.startAccelerometer()
        
        timer = Timer.scheduledTimer(timeInterval: 9.9, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func update(tm: Timer) {
        if motionModel.score >= 300 {
            UIScreen.main.brightness = CGFloat(1.0)
        } else if motionModel.score >= 250 {
            UIScreen.main.brightness = CGFloat(0.8)
        } else if motionModel.score >= 200 {
            UIScreen.main.brightness = CGFloat(0.7)
        } else if motionModel.score >= 150 {
            UIScreen.main.brightness = CGFloat(0.5)
        } else if motionModel.score >= 100 {
            UIScreen.main.brightness = CGFloat(0.3)
        } else {
            UIScreen.main.brightness = CGFloat(0.0)
        }
        socketModel.sendScore(score: Int(motionModel.score), color: socketModel.color)
        motionModel.score = 0.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
