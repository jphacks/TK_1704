import UIKit
import Material
import SnapKit
import SwiftyUserDefaults

class EditNameVC: UIViewController, UITextFieldDelegate {
    
    let nameField = TextField()
    let checkBtn: Button = {
        let btn = Button()
        let label = UILabel()
        label.text = "次へ"
        label.font = UIFont(name: "Arial",size: 22)
        btn.addSubview(label)
        label.snp.makeConstraints{
            $0.centerX.equalTo(btn.snp.centerX)
            $0.centerY.equalTo(btn.snp.centerY)
        }
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.text = "名前を入力してね"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.addSubview(label)
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        print(Defaults[.userName])
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: checkBtn)
        checkBtn.addTarget(self, action: #selector(checkDidTap), for: .touchUpInside)
 
        nameField.delegate = self
        nameField.text = Defaults[.userName]
        nameField.delegate = self
        nameField.returnKeyType = .done
        nameField.endEditing(true)
        nameField.placeholderActiveColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameField.dividerColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameField.dividerActiveColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.addSubview(nameField)
        self.view.addSubview(checkBtn)
        
        nameField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(150)
        }
        label.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nameField.snp.top).offset(-20)
        }
        checkBtn.snp.makeConstraints{
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
    }
    
    @objc func checkDidTap() {
        if nameField.text == "" {
        } else {
            Defaults[.userName] = nameField.text!
            print("なまえは\(Defaults[.userName])")
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
