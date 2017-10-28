import UIKit
import SnapKit
import SwiftyUserDefaults

class TopVC: UIViewController{
    let model = MotionModel()
    let joinBtn: UIButton = {
        let btn = UIButton()
        let label = UILabel()
        label.text = "join"
        label.font = UIFont(name:"ArialHebew", size:UIFont.labelFontSize)
        label.textColor = .white
        btn.backgroundColor =  #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        btn.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        return btn
    }()
    let nameBtn: UIButton = {
        let btn = UIButton()
        let label = UILabel()
        label.text = "なまえの設定"
        label.font = UIFont(name:"ArialHebew", size:UIFont.labelFontSize)
        label.textColor = .white
        btn.backgroundColor =  #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        btn.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        return btn
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Power\n of us"
        label.font = UIFont.systemFont(ofSize: 60)
        label.font = UIFont(name: "GillSans-UltraBold",size: 65)
        label.textColor = .black
        return label
    }()
    let warn: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "会場に設置されたQRコードを\n      読み取ってください…"
        label.font = UIFont.systemFont(ofSize: 30)
        label.font = UIFont(name: "Arial",size: 20)
        label.textColor = .black
        return label
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        joinBtn.layer.cornerRadius = 20
        joinBtn.addTarget(self, action: #selector(joinDidTap), for: .touchUpInside)
        self.view.addSubview(joinBtn)
        nameBtn.layer.cornerRadius = 20
        nameBtn.addTarget(self, action: #selector(nameDidTap), for: .touchUpInside)
        self.view.addSubview(joinBtn)
        self.view.addSubview(nameBtn)
        self.view.addSubview(titleLabel)
        self.view.addSubview(warn)
        
        //レイアウト
        joinBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
            $0.height.equalTo(40)
            $0.width.equalTo(120)
        }
        nameBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(joinBtn.snp.top).offset(-10)
            $0.height.equalTo(40)
            $0.width.equalTo(120)
        }
        titleLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview().offset(-150)
            $0.centerX.equalToSuperview()
        }
        warn.snp.makeConstraints{
            $0.bottom.equalTo(nameBtn.snp.top).offset(-15)
            $0.centerX.equalToSuperview()
        }
        
        //        var familyNames : Array = UIFont.familyNames;
        //        let len = familyNames.count;
        //
        //        for i in 0 ..< len {
        //            let fontFamily = familyNames[i] as String;
        //            let fontNames = UIFont.fontNames(forFamilyName: fontFamily);
        //            print("\(fontFamily),\(fontNames)")
        //        }
        
        model.startAccelerometer()
    }
    
    @objc func joinDidTap() {
        if Defaults[.userName] != "" {
            let nv = UINavigationController(rootViewController: SelectLiveVC())
            present(nv, animated: true)
        } else {
            
            let alert: UIAlertController = UIAlertController(title: "", message: "なまえを設定してね", preferredStyle:  UIAlertControllerStyle.alert)
            
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                self.nameDidTap()
            })
            
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
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
