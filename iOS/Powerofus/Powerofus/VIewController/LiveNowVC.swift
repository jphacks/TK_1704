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
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)
        case "green":
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case "purple":
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
        default:
            break
        }

        motionModel.startAccelerometer()
        
        timer = Timer.scheduledTimer(timeInterval: 9.9, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func update(tm: Timer) {
        if motionModel.score >= 300 {
            UIScreen.main.brightness = CGFloat(1.0)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
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
