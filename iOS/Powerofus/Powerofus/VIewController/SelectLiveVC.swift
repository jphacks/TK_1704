import UIKit
import SnapKit
import SwiftyUserDefaults


class SelectLiveVC: UIViewController {
    
    let model = SocketModel()
    let qrBtn: UIButton = {
        let btn = UIButton()
        let label = UILabel()
        label.text = "QRコードを読み取る"
        label.font = UIFont(name:"ArialHebew", size:UIFont.labelFontSize)
        label.textColor = .white
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        btn.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        qrBtn.layer.cornerRadius = 20
        qrBtn.addTarget(self, action: #selector(qrDidTap), for: .touchUpInside)
        
        self.view.addSubview(qrBtn)
        
        //レイアウト
        qrBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
            $0.height.equalTo(40)
            $0.width.equalTo(160)
        }
        
        model.connect(uuid: Defaults[.uuid], color: "red")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Defaults[.uuid] == "" {
            Defaults[.uuid] = NSUUID().uuidString
            print("これがあなたのUUID、大切にしてね！！")
            print(Defaults[.uuid])
        } else {
            print("あなたはUUIDをもってるぅぅぅぅぅぅぅぅぅ")
            print(Defaults[.uuid])
        }
        
    }
    
    @objc func qrDidTap() {
        let vc = ViewController()
        present(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

