import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - lets / vars
    
    private let registrationFormView = RegistrationFormView.instanceFromNib()
    private let manager = AppManager.shared
    private let const = Constants.RegistrationVC.self
    
    private var isVCConfigured = false
    private var centerYConstraint = NSLayoutConstraint()
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationFormView.cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        registrationFormView.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
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
    
    // MARK: - Configure RegistrationViewController
    
    private func configureViewController() {
        view.backgroundColor = const.backgroundColor
        view.addSubview(registrationFormView)
        
        registrationFormView.translatesAutoresizingMaskIntoConstraints = false
        registrationFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const.regFormLeadingAnchor).isActive = true
        registrationFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: const.regFormTrailingAnchor).isActive = true
        registrationFormView.heightAnchor.constraint(equalToConstant: const.regFormViewHeight).isActive = true
        registrationFormView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYConstraint =  registrationFormView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerYConstraint.isActive = true
    }
    
    private func validateForm() -> Bool {
        guard let userNameTextField = registrationFormView.userNameTextField,
              let passwordTextField = registrationFormView.passwordTextField,
              let confirmPasswordTextField = registrationFormView.confirmPasswordTextField else { return false }
        
        let passwordValidation = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
        
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            showAlert(title: "Oops!", message: "Please enter your name.")
            return false
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Oops!", message: "Please enter your password.")
            return false
        }
        guard let password = passwordTextField.text, !password.isEmpty, passwordValidation.evaluate(with: password) else {
            showAlert(title: "Oops!", message: "The password must be at least 8 characters, and include at least one lowercase letter, one uppercase letter, and a number.")
            return false
        }
        guard let confirmedPassword = confirmPasswordTextField.text,
              !confirmedPassword.isEmpty && password == confirmedPassword else {
            showAlert(title: "Oops!", message: "Confirmed password not matched. Please try again.")
            return false
        }
        return true
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction private func signUpButtonPressed() {
        self.view.endEditing(true)
        if validateForm() {
            showAlert(title: "The password will be saved", message: "You will not be able to change your password", style: .alert, actionTitle: (first: "Got it", second: "Back"), actionStyle: (first: .default, second: .cancel), actionHandler:  (first: {
                (_) in
                guard let userName = self.registrationFormView.userNameTextField.text,
                      let password = self.registrationFormView.passwordTextField.text else { return }
                self.manager.saveAccountData(for: User(name: userName, password: password))
                UserDefaults.setAppWasLaunched()
                self.goToMainViewController()
            }, second: nil))
        }
    }
    
    @IBAction private func cancelButtonPressed() {
        self.view.endEditing(true)
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
        
        let externalSpacing = self.view.frame.maxY - registrationFormView.frame.maxY
        
        let verticalSpacing = keyboardScreenEndFrame.height - externalSpacing
        
        if keyboardScreenEndFrame.height > externalSpacing {
            centerYConstraint.constant = -(verticalSpacing + const.keyboardTopSpacing)
        }
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}
