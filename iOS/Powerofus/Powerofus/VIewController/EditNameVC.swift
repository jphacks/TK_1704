import UIKit
import Material
import SnapKit

class EditNameVC: UIViewController, UITextFieldDelegate {
    
    let nameField = TextField()
    let checkBtn: Button = {
        let btn = Button()
        btn.backgroundColor = UIColor.red
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        nameField.placeholder = "なまえを入力してね"
        nameField.delegate = self
        nameField.returnKeyType = .done
        nameField.endEditing(true)
        nameField.placeholderActiveColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        nameField.dividerColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        nameField.dividerActiveColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.view.addSubview(nameField)
        self.view.addSubview(checkBtn)
        
        nameField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(150)
        }
    }
    
    func checkDidTap() {
        
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
