import UIKit
import SnapKit
import SwiftyUserDefaults


class SelectLiveVC: UIViewController {
    

    let qrBtn: UIButton = {
        let image3 : UIImage = UIImage(named:"qr")!
        let btn = UIButton()
        let label = UILabel()
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0)
        btn.setImage(image3, for: .normal)
        btn.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        qrBtn.layer.cornerRadius = 20
        qrBtn.addTarget(self, action: #selector(qrDidTap), for: .touchUpInside)
        
        self.view.addSubview(qrBtn)
        
        //レイアウト
        qrBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
            $0.height.equalTo(55)
            $0.width.equalTo(220)
        }
        
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
        let vc = QRcodeReaderVC()
        present(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

