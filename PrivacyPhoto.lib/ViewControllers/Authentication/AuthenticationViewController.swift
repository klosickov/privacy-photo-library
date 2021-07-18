import UIKit

class AuthenticationViewController: UIViewController {
    
    // MARK: - lets / vars
    
    private let authenticationFormView = AuthenticationFormView.instanceFromNib()
    private let const = Constants.AuthenticationVC.self
    private let manager = AppManager.shared
    
    private var isVCConfigured = false
    private var centerYConstraint = NSLayoutConstraint()
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticationFormView.cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        authenticationFormView.signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        registerForKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isVCConfigured {
            configureViewController()
            isVCConfigured = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Configure AuthenticationViewController
    
    private func configureViewController() {
        view.backgroundColor = const.backgroundColor
        view.addSubview(authenticationFormView)
        
        authenticationFormView.translatesAutoresizingMaskIntoConstraints = false
        authenticationFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const.authFormLeadingAnchor).isActive = true
        authenticationFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: const.authFormTrailingAnchor).isActive = true
        authenticationFormView.heightAnchor.constraint(equalToConstant: const.authFormViewHeight).isActive = true
        authenticationFormView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYConstraint =  authenticationFormView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerYConstraint.isActive = true
    }
    
    private func validateForm() -> Bool {
        guard let passwordTextField = authenticationFormView.passwordTextField,
              let userAccountData = manager.getAccountData() else { return false }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Oops!", message: "Please enter your password.")
            return false
        }
        guard let password = passwordTextField.text, !password.isEmpty, password == userAccountData.password else {
            showAlert(title: "Oops!", message: "Wrong password! Please try again.")
            return false
        }
        return true
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction private func signInButtonPressed() {
        self.view.endEditing(true)
        if validateForm() {
            showAlert(title: "Sign-in confirmed!", message: "You are now ready to use Privacy Photo Library.", style: .alert, actionTitle: "Ok", actionStyle: .default) { _ in
                self.goToMainViewController()
            }
        }
    }
    
    @IBAction private func cancelButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction private func goToMainViewController() {
        let mainController = ViewController()
        navigationController?.pushViewController(mainController, animated: true)
    }
    
    @IBAction private func keyboardWillHide(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        
        centerYConstraint.constant = 0
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let externalSpacing = self.view.frame.maxY - authenticationFormView.frame.maxY
        
        let verticalSpacing = keyboardScreenEndFrame.height - externalSpacing
        
        if keyboardScreenEndFrame.height > externalSpacing {
            centerYConstraint.constant = -(verticalSpacing + const.keyboardTopSpacing)
        }
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension AuthenticationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
