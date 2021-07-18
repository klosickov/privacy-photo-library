import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String? = nil, message: String, style: UIAlertController.Style, actionTitle: String, actionStyle: UIAlertAction.Style, actionHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle, style: actionStyle, handler: actionHandler)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String? = nil, message: String, style: UIAlertController.Style, actionTitle: (first: String, second: String), actionStyle: (first: UIAlertAction.Style, second: UIAlertAction.Style), actionHandler: (first: ((UIAlertAction) -> Void)?, second: ((UIAlertAction) -> Void)?)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let firstAction = UIAlertAction(title: actionTitle.first, style: actionStyle.first, handler: actionHandler.first)
        
        let secondAction = UIAlertAction(title: actionTitle.second, style: actionStyle.second, handler: actionHandler.second)
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(alertTitle: String? = nil, alertMessage: String, alertStyle: UIAlertController.Style, alertActions: [UIAlertAction]) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: alertStyle)
        alertActions.forEach {
            alert.addAction($0)
        }
        present(alert, animated: true, completion: nil)
    }
}
