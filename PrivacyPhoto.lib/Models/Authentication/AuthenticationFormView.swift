import UIKit

class AuthenticationFormView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Functions
    
    class func instanceFromNib() -> AuthenticationFormView {
        if let authenticationFormView = UINib(nibName: "AuthenticationFormView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? AuthenticationFormView {
            authenticationFormView.configure()
            return authenticationFormView
        }
        return AuthenticationFormView()
    }
    
    private func configure() {
        self.layer.cornerRadius = Constants.CornerRadius.view
        signInButton.layer.cornerRadius = Constants.CornerRadius.signInButton
        
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.minimumScaleFactor = 0.2
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2
        
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }
}

extension AuthenticationFormView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
