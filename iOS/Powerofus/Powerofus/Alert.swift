import UIKit

struct Alert {
    static func show(with message: String, _ title: String = "エラー") {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))

        if let presentedViewController = rootViewController.presentedViewController {
            presentedViewController.present(alertController, animated: true)
        } else {
            rootViewController.present(alertController, animated: true)
        }
    }
}
