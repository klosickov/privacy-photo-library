import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - lets / vars
    
    private let infoLabel = UILabel()
    private let mainTitleLabel = UILabel()
    private let controllerButton = UIButton(type: .system)
    private let logoImageView = UIImageView()
    private let infoLabelContainerView = UIView()
    private let logoImageContainerView = UIView()
    private let const = Constants.OnboardingVC.self
    private let manager = AppManager.shared
    
    private var isVCConfigured = false
    
    // MARK: - Lifecycle functions
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        if !isVCConfigured {
            configureViewController()
            isVCConfigured = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        //        UserDefaults.standard.synchronize()
        
        if UserDefaults.wasAppLaunched() {
            displaySignInMessage()
        } else {
            displaySignUpMessage()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Configure ViewController
    
    private func configureViewController() {
        let margins = self.view.layoutMarginsGuide
        self.view.backgroundColor = .black
        self.view.addSubview(mainTitleLabel)
        self.view.addSubview(infoLabelContainerView)
        self.view.addSubview(logoImageContainerView)
        infoLabelContainerView.addSubview(infoLabel)
        logoImageContainerView.addSubview(logoImageView)
        self.view.addSubview(controllerButton)
        
        // mainTitleLabel settings
        mainTitleLabel.adjustsFontSizeToFitWidth = true
        mainTitleLabel.minimumScaleFactor = 0.2
        mainTitleLabel.numberOfLines = 0
        mainTitleLabel.font = UIFont(name: Fonts.albaSuper.rawValue, size: const.mainTitleLabelFontSize)
        mainTitleLabel.textColor = const.mainTitleLabelTextColor
        mainTitleLabel.textAlignment = .left
        mainTitleLabel.text = "Privacy photo library"
        // mainTitleLabel constraints
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTitleLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: const.commonTopSpacing).isActive = true
        mainTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: const.commonLeading).isActive = true
        mainTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: const.commonTrailing).isActive = true
        
        // infoLabel settings
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.minimumScaleFactor = 0.2
        infoLabel.numberOfLines = 0
        infoLabel.setLineSpacing(lineSpacing: const.infoLabelLineSpacing)
        infoLabel.font = const.infoLabelFont
        infoLabel.textColor = const.infoLabelTextColor
        infoLabel.textAlignment = .right
        // infoLabel constraints
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.leadingAnchor.constraint(equalTo: infoLabelContainerView.leadingAnchor).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: infoLabelContainerView.trailingAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: infoLabelContainerView.centerYAnchor).isActive = true
        
        // controllerButton settings
        controllerButton.frame.size.height = const.controllerButtonHeight
        controllerButton.layer.cornerRadius = Constants.CornerRadius.signUpButton
        controllerButton.backgroundColor = const.controllerButtonBackgroundColor
        controllerButton.titleLabel?.font = UIFont(name: Fonts.gillSansSemiBold.rawValue, size: const.controllerButtonTitleLabelFontSize)
        controllerButton.setTitleColor(.white, for: .normal)
        controllerButton.titleLabel?.textAlignment = .center
        // controllerButton constraints
        controllerButton.translatesAutoresizingMaskIntoConstraints = false
        controllerButton.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor).isActive = true
        controllerButton.trailingAnchor.constraint(equalTo: logoImageView.trailingAnchor).isActive = true
        controllerButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        controllerButton.addTarget(self, action: #selector(controllerButtonPressed), for: .touchUpInside)
        
        // logoImageView settings
        logoImageView.image = UIImage(named: "privacyLogo")
        logoImageView.contentMode = .scaleAspectFit
        // logoImageView constraints
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 1.0 / 1.0).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: logoImageContainerView.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: logoImageContainerView.centerYAnchor).isActive = true
        
        // infoLabelContainer constraints
        infoLabelContainerView.translatesAutoresizingMaskIntoConstraints = false
        infoLabelContainerView.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: const.commonTopSpacing).isActive = true
        infoLabelContainerView.bottomAnchor.constraint(equalTo: controllerButton.topAnchor, constant: const.commonTopSpacing).isActive = true
        infoLabelContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: const.commonLeading).isActive = true
        infoLabelContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: const.commonTrailing).isActive = true
        
        // logoImageContainer constraints
        logoImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        logoImageContainerView.topAnchor.constraint(equalTo: controllerButton.bottomAnchor, constant: const.commonTopSpacing).isActive = true
        logoImageContainerView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: const.commonTopSpacing).isActive = true
        logoImageContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: const.commonLeading).isActive = true
        logoImageContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: const.commonTrailing).isActive = true
    }
    
    // MARK: - Flow functions
    
    private func displaySignInMessage() {
        if let userName = manager.getAccountData()?.name {
            infoLabel.text = "Welcome back, \(userName) :)"
        } else {
            infoLabel.text = "Welcome back"
        }
        controllerButton.setTitle("Sign in", for: .normal)
    }
    
    private func displaySignUpMessage() {
        infoLabel.text = "If you are a new user, you must sign up to the system."
        controllerButton.setTitle("Sign up", for: .normal)
    }
    
    private func goToRegistrationController() {
        let registrationController = RegistrationViewController.init()
        self.navigationController?.pushViewController(registrationController, animated: true)
    }
    
    private func goToAuthenticationController() {
        let authController = AuthenticationViewController.init()
        self.navigationController?.pushViewController(authController, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func controllerButtonPressed() {
        if UserDefaults.wasAppLaunched() {
            goToAuthenticationController()
        } else {
            goToRegistrationController()
        }
    }
}

extension OnboardingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
