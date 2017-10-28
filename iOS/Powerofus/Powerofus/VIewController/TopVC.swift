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
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
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
        joinBtn.layer.cornerRadius = 20
        joinBtn.addTarget(self, action: #selector(joinDidTap), for: .touchUpInside)
        self.view.addSubview(joinBtn)
        nameBtn.layer.cornerRadius = 20
        nameBtn.addTarget(self, action: #selector(nameDidTap), for: .touchUpInside)
        self.view.addSubview(joinBtn)
        self.view.addSubview(nameBtn)
        
        //レイアウト
        joinBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
            $0.height.equalTo(40)
            $0.width.equalTo(120)
        }
        nameBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(joinBtn.snp.top).offset(-10)
            $0.height.equalTo(40)
            $0.width.equalTo(120)
        }
        
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
