import UIKit

class PhotoLibViewController: UIViewController {
    
    // MARK: - lets / vars
    
    private let mainContainerView = UIView()
    private let topButtonsContainerView = UIView()
    private let bottomButtonsContainerView = UIView()
    private let backButton = UIButton.init(type: .system)
    private let likeButton = UIButton()
    private let trashButton = UIButton()
    private let previousButton = UIButton.init(type: .system)
    private let nextButton = UIButton.init(type: .system)
    private let imageView = UIImageView()
    private let secondImageView = UIImageView()
    private let commentTextField = UITextField()
    private let manager = AppManager.shared
    private let const = Constants.PhotoLibVC.self
    
    private var bottomConstraint = NSLayoutConstraint()
    private var topConstraint = NSLayoutConstraint()
    private var isVCConfigured = false
    
    public var index: Int = 0 // value = -1 -> empty array
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(index: 0)
    }
    
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle functions
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isVCConfigured {
            configureViewController()
            isVCConfigured = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        commentTextField.delegate = self
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        trashButton.addTarget(self, action: #selector(trashButtonPressed), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !manager.getSavedImageData().isEmpty {
            manager.showData(at: index, in: (secondImageView, commentTextField, likeButton))
        } else {
            imageView.image = UIImage(named: "photo_icon")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Configure PhotoLibViewController
    
    private func configureViewController() {
        self.view.backgroundColor = const.backgroundColor
        self.view.addSubview(mainContainerView)
        
        // mainContainerView settings
        mainContainerView.addSubview(topButtonsContainerView)
        mainContainerView.addSubview(bottomButtonsContainerView)
        mainContainerView.addSubview(imageView)
        mainContainerView.addSubview(secondImageView)
        mainContainerView.addSubview(commentTextField)
        
        // mainContainerView constraints
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        topConstraint = mainContainerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor)
        mainContainerView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
        topConstraint.isActive = true
        
        // topButtonsContainerView settings
        topButtonsContainerView.addSubview(backButton)
        topButtonsContainerView.addSubview(likeButton)
        topButtonsContainerView.addSubview(trashButton)
        // topButtonsContainerView constraints
        topButtonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        topButtonsContainerView.topAnchor.constraint(equalTo: mainContainerView.topAnchor).isActive = true
        topButtonsContainerView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: const.topButtonsContainerViewLeading).isActive = true
        topButtonsContainerView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: const.topButtonsContainerViewTrailing).isActive = true
        topButtonsContainerView.heightAnchor.constraint(equalToConstant: const.topButtonsContainerViewHeight).isActive = true
        
        // backButton settings
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.tintColor = .black
        // backButton constraints
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalTo: topButtonsContainerView.heightAnchor).isActive = true
        backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor, multiplier: 1).isActive = true
        backButton.leadingAnchor.constraint(equalTo: topButtonsContainerView.leadingAnchor).isActive = true
        backButton.centerYAnchor.constraint(equalTo: topButtonsContainerView.centerYAnchor).isActive = true
        
        // likeButton constraints
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.heightAnchor.constraint(equalTo: topButtonsContainerView.heightAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor, multiplier: 1).isActive = true
        likeButton.centerYAnchor.constraint(equalTo: topButtonsContainerView.centerYAnchor).isActive = true
        likeButton.centerXAnchor.constraint(equalTo: topButtonsContainerView.centerXAnchor).isActive = true
        
        // trashButton settings
        trashButton.setImage(UIImage(named: "trash"), for: .normal)
        trashButton.setImage(UIImage(named: "trash-2"), for: .highlighted)
        // trashButton constraints
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        trashButton.heightAnchor.constraint(equalTo: topButtonsContainerView.heightAnchor).isActive = true
        trashButton.widthAnchor.constraint(equalTo: trashButton.heightAnchor, multiplier: 1).isActive = true
        trashButton.trailingAnchor.constraint(equalTo: bottomButtonsContainerView.trailingAnchor).isActive = true
        trashButton.centerYAnchor.constraint(equalTo: topButtonsContainerView.centerYAnchor).isActive = true
        
        // bottomButtonsContainer settings
        bottomButtonsContainerView.addSubview(previousButton)
        bottomButtonsContainerView.addSubview(nextButton)
        // bottomButtonsContainer constraints
        bottomButtonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonsContainerView.leadingAnchor.constraint(equalTo: topButtonsContainerView.leadingAnchor).isActive = true
        bottomButtonsContainerView.trailingAnchor.constraint(equalTo: topButtonsContainerView.trailingAnchor).isActive = true
        bottomButtonsContainerView.heightAnchor.constraint(equalToConstant: const.bottomButtonsContainerViewHeight).isActive = true
        bottomButtonsContainerView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor).isActive = true
        
        // previousButton settings
        previousButton.layer.cornerRadius = Constants.CornerRadius.photoLibButton
        previousButton.backgroundColor = .systemRed
        previousButton.setTitleColor(.white, for: .normal)
        previousButton.setTitle("Previous", for: .normal)
        // previousButton constraints
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.leadingAnchor.constraint(equalTo: bottomButtonsContainerView.leadingAnchor).isActive = true
        previousButton.heightAnchor.constraint(equalTo: bottomButtonsContainerView.heightAnchor).isActive = true
        previousButton.widthAnchor.constraint(equalTo: nextButton.widthAnchor, multiplier: 1).isActive = true
        previousButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: const.previousButtonHorizontalSpacing).isActive = true
        previousButton.centerYAnchor.constraint(equalTo: bottomButtonsContainerView.centerYAnchor).isActive = true
        
        // nextButton settings
        nextButton.layer.cornerRadius = Constants.CornerRadius.photoLibButton
        nextButton.backgroundColor = .systemYellow
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setTitle("Next", for: .normal)
        // nextButton constraints
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.trailingAnchor.constraint(equalTo: bottomButtonsContainerView.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalTo: previousButton.heightAnchor, multiplier: 1).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: previousButton.centerYAnchor).isActive = true
        
        // commentTextField settings
        commentTextField.placeholder = "Leave a comment"
        commentTextField.backgroundColor = .white
        commentTextField.borderStyle = .roundedRect
        // commentTextField constraints
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.leadingAnchor.constraint(equalTo: topButtonsContainerView.leadingAnchor).isActive = true
        commentTextField.trailingAnchor.constraint(equalTo: topButtonsContainerView.trailingAnchor).isActive = true
        bottomConstraint = commentTextField.bottomAnchor.constraint(equalTo: bottomButtonsContainerView.topAnchor, constant: const.commentTextFieldBottomSpacing)
        commentTextField.heightAnchor.constraint(equalToConstant: const.commentTextFieldHeight).isActive = true
        bottomConstraint.isActive = true
        
        func setSettingsAndConstraints(for imageView: UIImageView) {
            // imageView settings
            imageView.backgroundColor = const.backgroundColor
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.borderWidth = const.imageViewBorderWidth
            imageView.contentMode = .scaleAspectFit
            imageView.dropShadow(radius: 5, offset: CGSize(width: 0, height: 8), shouldRasterize: false)
            // imageView constraints
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: topButtonsContainerView.bottomAnchor, constant: const.imageViewTopSpacing).isActive = true
            imageView.bottomAnchor.constraint(equalTo: commentTextField.topAnchor, constant: const.imageViewBottomSpacing).isActive = true
            imageView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: const.imageViewLeading).isActive = true
            imageView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: const.imageViewTrailing).isActive = true
        }
        
        setSettingsAndConstraints(for: imageView)
        setSettingsAndConstraints(for: secondImageView)
    }
    
    // MARK: - Keyboard Notifications
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Flow functions
    
    private func disableViews() {
        nextButton.isEnabled = false
        previousButton.isEnabled = false
        commentTextField.isEnabled = false
    }
    
    private func enableViews() {
        nextButton.isEnabled = true
        previousButton.isEnabled = true
        commentTextField.isEnabled = true
    }
    
    // MARK: - IBActions
    
    @IBAction private func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func trashButtonPressed() {
        guard index != -1 else { return }
        showAlert(title: nil, message: "This photo will be deleted from this app", style: .actionSheet, actionTitle: (first: "Delete Photo", second: "Cancel"), actionStyle: (first: .destructive, second: .cancel), actionHandler: (first: { (_) in
            
            self.manager.removeData(at: &self.index)
            self.manager.showData(at: self.index, in: (self.secondImageView, self.commentTextField, self.likeButton))
        }, second: nil))
    }
    
    @IBAction private func likeButtonPressed(_ sender: UIButton) {
        guard index != -1 else { return }
        
        manager.updateData(type: .like, at: index, in: (nil, sender))
    }
    
    @IBAction private func previousButtonPressed() {
        guard !manager.getSavedImageData().isEmpty else { return }
        
        disableViews()
        manager.decrement(&index)
        imageView.image = manager.getUIImage(with: manager.getSavedImageData()[index].imageName)
        
        UIView.animate(withDuration: 1.3) {
            self.secondImageView.frame.origin.x = self.view.frame.origin.x - self.secondImageView.frame.size.width
            self.manager.showData(at: self.index, in: (self.imageView, self.commentTextField, self.likeButton))
        } completion: { (_) in
            self.secondImageView.image = self.manager.getUIImage(with: self.manager.getSavedImageData()[self.index].imageName)
            self.secondImageView.frame.origin.x = self.imageView.frame.origin.x
            self.enableViews()
        }
    }
    
    @IBAction private func nextButtonPressed() {
        guard !manager.getSavedImageData().isEmpty else { return }
        
        disableViews()
        imageView.image = manager.getUIImage(with: manager.getSavedImageData()[index].imageName)
        secondImageView.frame.origin.x = self.view.frame.width
        manager.increment(&index)
        self.secondImageView.image = manager.getUIImage(with: manager.getSavedImageData()[index].imageName)
        
        UIView.animate(withDuration: 1.3) {
            self.secondImageView.frame.origin.x = self.imageView.frame.origin.x
            self.manager.showData(at: self.index, in: (self.secondImageView, self.commentTextField, self.likeButton))
        } completion: { (_) in
            self.imageView.image = self.manager.getUIImage(with: self.manager.getSavedImageData()[self.index].imageName)
            self.enableViews()
        }
    }
    
    @IBAction private func keyboardWillHide(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        
        topConstraint.constant = self.view.safeAreaLayoutGuide.layoutFrame.origin.x
        bottomConstraint.constant = const.commentTextFieldBottomSpacing
        
        manager.updateData(type: .comment, at: index, in: (commentTextField, nil))
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let internalSpace = mainContainerView.bounds.maxY - commentTextField.frame.maxY
        let externalSpace = self.view.frame.maxY - mainContainerView.frame.maxY
        let verticalSpacing = keyboardScreenEndFrame.height - (internalSpace + externalSpace) + const.keyboardTopSpacing
        
        topConstraint.constant = -keyboardScreenEndFrame.height
        bottomConstraint.constant -= verticalSpacing
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension PhotoLibViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
