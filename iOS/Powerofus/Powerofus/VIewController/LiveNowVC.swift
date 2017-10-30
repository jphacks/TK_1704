import UIKit
import SnapKit
import Material
import AudioToolbox

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
        
        switch socketModel.color {
        case "red":
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case "yellow":
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        case "pink":
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.2825942436, blue: 0.7046276663, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 1, green: 0.2825942436, blue: 0.7046276663, alpha: 1)
        case "green":
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.758980453, blue: 0.1237550154, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0.758980453, blue: 0.1237550154, alpha: 1)
        case "purple":
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
        default:
            break
        }

        motionModel.startAccelerometer()
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = false
    }
    
    @objc func update(tm: Timer) {
        if motionModel.score >= 50 {
            UIScreen.main.brightness = CGFloat(1.0)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        } else if motionModel.score >= 40 {
            UIScreen.main.brightness = CGFloat(0.8)
        } else if motionModel.score >= 30 {
            UIScreen.main.brightness = CGFloat(0.7)
        } else if motionModel.score >= 20 {
            UIScreen.main.brightness = CGFloat(0.5)
        } else if motionModel.score >= 10 {
            UIScreen.main.brightness = CGFloat(0.3)
        } else {
            UIScreen.main.brightness = CGFloat(0.0)
        }
        print("\(motionModel.score)点を送信！")
        socketModel.sendScore(score: Int(motionModel.score), color: socketModel.color)
        motionModel.score = 0.0
        if !socketModel.isStart {
            dismiss(animated: true, completion: nil)
            if timer.isValid {
                timer.invalidate()
                UIScreen.main.brightness = CGFloat(0.8)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
