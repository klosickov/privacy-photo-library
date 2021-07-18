import Foundation
import UIKit

class RegistrationFormView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Functions
    
    class func instanceFromNib() -> RegistrationFormView {
        if let registrationFormView = UINib(nibName: "RegistrationFormView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? RegistrationFormView {
            registrationFormView.configure()
            return registrationFormView
        }
        return RegistrationFormView()
        
    }
    
    private func configure() {
        self.layer.cornerRadius = Constants.CornerRadius.view
        signUpButton.layer.cornerRadius = Constants.CornerRadius.signUpButton
        
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.minimumScaleFactor = 0.5
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
    }
}

extension RegistrationFormView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
