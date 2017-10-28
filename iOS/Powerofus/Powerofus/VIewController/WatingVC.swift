import UIKit
import SnapKit
import Material


class WatingVC: UIViewController {
    
    let label = UILabel()
    let button: Button = {
        let btn = Button()
        let label = UILabel()
        label.text = "スタート"
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        btn.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        return btn
    }()
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
        button.layer.cornerRadius = 20
        self.view.addSubview(label)
        self.view.addSubview(button)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(40)
            $0.width.equalTo(120)
        }
        model.connect(color: color)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
