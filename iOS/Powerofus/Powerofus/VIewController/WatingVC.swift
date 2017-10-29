import UIKit
import SnapKit
import Material


class WatingVC: UIViewController {
    
    let model: SocketModel
    let color: String
    
    var timer: Timer!
    var loadingTimer: Timer!
    let iv = UIImageView(image: UIImage(named:"icon2"))
    
    init(_ url: String, _ color: String) {
        model = SocketModel(url, color)
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch model.color {
        case "red":
            iv.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case "yellow":
            iv.tintColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        case "pink":
            iv.tintColor = #colorLiteral(red: 1, green: 0.2825942436, blue: 0.7046276663, alpha: 1)
        case "green":
            iv.tintColor = #colorLiteral(red: 0, green: 0.758980453, blue: 0.1237550154, alpha: 1)
        case "purple":
            iv.tintColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
        default:
            break
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
        navigationController?.navigationBar.barTintColor = UIColor.black
        self.view.addSubview(iv)
        
        iv.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        model.connect(color: color)
        startloading()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer.fire()
        
    }
    
    @objc func update(tm: Timer) {
        if model.isStart {
            let nv = LiveNowVC(model)
            self.navigationController?.pushViewController(nv, animated: true)
            if timer.isValid {
                timer.invalidate()
            }
            if loadingTimer.isValid {
                loadingTimer.invalidate()
            }
        }
    }
    
    func startloading(){
        loadingTimer =  Timer.scheduledTimer(
            timeInterval: 0.55,
            target: self,
            selector: #selector(self.loading),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func loading(){
        let layer = iv.layer;
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = Double.pi * 2
        animation.duration = 0.35
        //animation.repeatCount = MAXFLOAT
        layer.add(animation, forKey: "transform.rotation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
