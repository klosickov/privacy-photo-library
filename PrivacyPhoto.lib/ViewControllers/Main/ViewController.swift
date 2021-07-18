import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - lets / vars
    
    private let homeButton = UIButton()
    private let imagePickerButton = UIButton()
    private let imageGalleryButton = UIButton()
    private let myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    private let manager = AppManager.shared
    private let const = Constants.MainVC.self
    
    private var isVCConfigured = false
    
    // MARK: - Lifecycle functions
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isVCConfigured {
            configureViewController()
            isVCConfigured = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myCollectionView.reloadData()
        shouldShowGalleryButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        imagePickerButton.addTarget(self, action: #selector(showImagePickerAlert), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        imageGalleryButton.addTarget(self, action: #selector(imageGalleryButtonPressed), for: .touchUpInside)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Configure MainViewController
    
    private func configureViewController() {
        self.view.backgroundColor = const.backgroundColor
        self.view.addSubview(imagePickerButton)
        self.view.addSubview(homeButton)
        self.view.addSubview(imageGalleryButton)
        self.view.addSubview(myCollectionView)
        
        // homeButton settings
        homeButton.setImage(UIImage(named: "home"), for: .normal)
        homeButton.setImage(UIImage(named: "home-2"), for: .highlighted)
        // homeButton constraints
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.widthAnchor.constraint(equalToConstant: Constants.Button.width).isActive = true
        homeButton.heightAnchor.constraint(equalToConstant: Constants.Button.height).isActive = true
        homeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: const.buttonTopSpacing).isActive = true
        homeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const.buttonLeading).isActive = true
        
        // imagePickerButton settings
        imagePickerButton.setImage(UIImage(named: "photoLibrary"), for: .normal)
        // imagePickerButton constraints
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        imagePickerButton.widthAnchor.constraint(equalToConstant: Constants.Button.width).isActive = true
        imagePickerButton.heightAnchor.constraint(equalToConstant: Constants.Button.height).isActive = true
        imagePickerButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: const.buttonBottomSpacing).isActive = true
        imagePickerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const.buttonLeading).isActive = true
        
        // imageGalleryButton settings
        imageGalleryButton.setImage(UIImage(named: "imageGallery"), for: .normal)
        // imageGalleryButton constraints
        imageGalleryButton.translatesAutoresizingMaskIntoConstraints = false
        imageGalleryButton.widthAnchor.constraint(equalToConstant: Constants.Button.width).isActive = true
        imageGalleryButton.heightAnchor.constraint(equalToConstant: Constants.Button.height).isActive = true
        imageGalleryButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: const.buttonBottomSpacing).isActive = true
        imageGalleryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: const.buttonTrailing).isActive = true
        
        // collectionView settings
        myCollectionView.backgroundColor = const.backgroundColor
        layout.scrollDirection = .vertical
        myCollectionView.setCollectionViewLayout(layout, animated: true)
        // collectionView constraints
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: const.collectionViewLeading).isActive = true
        myCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: const.collectionViewTrailing).isActive = true
        myCollectionView.topAnchor.constraint(equalTo: homeButton.bottomAnchor, constant: const.collectionViewTopSpacing).isActive = true
        myCollectionView.bottomAnchor.constraint(equalTo: imagePickerButton.topAnchor, constant: const.collectionViewBottomSpacing).isActive = true
    }
    
    // MARK: - Flow functions
    
    private func shouldShowGalleryButton() {
        if manager.isUserDefaultsEmpty() {
            imageGalleryButton.isHidden = true
        } else {
            imageGalleryButton.isHidden = false
        }
    }
    
    // MARK: - Image Picker functions
    
    private func showPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .overCurrentContext
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func showCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .overCurrentContext
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let uuidImage = manager.saveImage(image: selectedImage) {
                
                let imageData = ImageData(imageName: uuidImage)
                manager.saveImageData(imageData)
            }
        }
        myCollectionView.reloadData()
        shouldShowGalleryButton()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction private func homeButtonPressed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction private func imageGalleryButtonPressed() {
        self.navigationController?.pushViewController(PhotoLibViewController(), animated: true)
    }
    
    @IBAction private func showImagePickerAlert() {
        let alert = UIAlertController(title: "Please, choose image source", message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "Photo library", style: .default) { (_) in
            self.showPhotoLibrary()
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.showCamera()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - CollectionView functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imageDataArray = manager.getSavedImageData()
        return imageDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        let imageDataArray = manager.getSavedImageData()
        cell.configure(with: imageDataArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.size.width - const.horizontalSpacingForItem * (const.numberOfItemsInRow-1)) / const.numberOfItemsInRow
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return const.lineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let photoLibVC = PhotoLibViewController(index: indexPath.item)
        navigationController?.pushViewController(photoLibVC, animated: true)
    }
}
