import UIKit
import SnapKit
import Material


class WatingVC: UIViewController {
    
    let label = UILabel()
    let model: SocketModel
    let color: String
    
    var timer: Timer!
    
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
        // Do any additional setup after loading the view, typically from a nib.
        label.text = "ちょっとまってて"
        self.view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        model.connect(color: color)
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
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
