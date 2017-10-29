import UIKit
import SnapKit
import SwiftyUserDefaults

class TopVC: UIViewController{
    
    private var myImageView: UIImageView!
    
    let joinBtn: UIButton = {
        let image0: UIImage = UIImage(named:"rainbow")!
        let btn = UIButton()
        let label = UILabel()
        label.font = UIFont(name:"ArialHebew", size:UIFont.labelFontSize)
        label.textColor = .white
        btn.backgroundColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0)
        btn.alpha = 1.0
        btn.addSubview(label)
        btn.setImage(image0, for: .normal)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        return btn
    }()
    
    let nojoinBtn: UIButton = {
        let image1: UIImage = UIImage(named:"gray")!
        let btn = UIButton()
        let label = UILabel()
        label.font = UIFont(name:"ArialHebew", size:UIFont.labelFontSize)
        label.textColor = .white
        btn.backgroundColor =  #colorLiteral(red: 1, green: 0.3857288696, blue: 0.7793558775, alpha: 0)
        btn.alpha = 1.0
        btn.isEnabled = false
        btn.setImage(image1, for: .normal)
        btn.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        return btn
    }()
    
    let nameBtn: UIButton = {
        let image2: UIImage = UIImage(named:"name")!
        let btn = UIButton()
        let label = UILabel()
        btn.backgroundColor =  #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 0)
        btn.setImage(image2, for: .normal)
        btn.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        return btn
    }()
    
    let image4: UIImage = UIImage(named:"icon")!
    
    let warn: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = "会場に設置されたQRコードを\n      読み取ってください…"
        label.font = UIFont.systemFont(ofSize: 30)
        label.font = UIFont(name: "Arial",size: 16)
        return label
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImageView = UIImageView()
        myImageView.image = UIImage(named: "icon")
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor =  #colorLiteral(red: 0.04313214868, green: 0.04314065725, blue: 0.04312644154, alpha: 1)
        joinBtn.layer.cornerRadius = 20
        if Defaults[.userName] == "" {
            joinBtn.isHidden = true
        }
        joinBtn.addTarget(self, action: #selector(joinDidTap), for: .touchUpInside)
        self.view.addSubview(joinBtn)
        nameBtn.layer.cornerRadius = 20
        nameBtn.addTarget(self, action: #selector(nameDidTap), for: .touchUpInside)
        self.view.addSubview(joinBtn)
        self.view.addSubview(nameBtn)
        self.view.addSubview(myImageView)
        self.view.addSubview(warn)
        self.view.addSubview(nojoinBtn)
        
        //レイアウト
        joinBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
            $0.height.equalTo(55)
            $0.width.equalTo(220)
        }
        nojoinBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
            $0.height.equalTo(55)
            $0.width.equalTo(220)
        }
        nameBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(joinBtn.snp.top).offset(-10)
            $0.height.equalTo(55)
            $0.width.equalTo(220)
        }
        myImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview().offset(-150)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(270)
        }
        warn.snp.makeConstraints{
            $0.bottom.equalTo(nameBtn.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        UIApplication.shared.statusBarStyle = (navigationController?.navigationBar.tintColor == .white ? .lightContent : .default)
        
        print(joinBtn.isEnabled)
        if Defaults[.userName] != "" {
            nojoinBtn.isHidden = true
            joinBtn.isHidden = false
        }
        
    }
    
    @objc func joinDidTap() {
        if Defaults[.userName] != "" {
            let nv = UINavigationController(rootViewController: QRcodeReaderVC())
            present(nv, animated: true)
        }
    }
        
    
    @objc func nameDidTap() {
        let nv = UINavigationController(rootViewController: EditNameVC())
        present(nv, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
