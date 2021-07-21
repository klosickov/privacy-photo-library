import Foundation
import SwiftyKeychainKit

class AppManager {
    
    static let shared = AppManager()
    private init() {}
    
    private let keychain = Keychain(service: "userInfo")
    private let username = KeychainKey<String>(key: "username")
    private let password = KeychainKey<String>(key: "password")
    
    // MARK: - Registration functions
    
    public func saveAccountData(for user: User) {
        try? keychain.set(user.name, for: username)
        try? keychain.set(user.password, for: password)
    }
    
    public func getAccountData() -> User? {
        guard let username = try? keychain.get(username),
              let password = try? keychain.get(password) else {
            return nil
        }
        return User(name: username, password: password)
    }
    
    // MARK: - SaveImage & LoadImage functions
    
    public func saveImage(image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return nil}
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let error {
                print("couldn't remove file at path", error)
            }
        }
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
    private func loadImage(fileName: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageUrl = documentsDirectory.appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    //MARK: - UserDefaults functions
    
    public func getSavedImageData() -> [ImageData] {
        if let imageDataArray = UserDefaults.standard.value([ImageData].self, forKey: Keys.imageData.rawValue) {
            return imageDataArray
        } else {
            return [ImageData]()
        }
    }
    
    public func getUIImage(with uuidImage: String) -> UIImage? {
        if let image = loadImage(fileName: uuidImage) {
            return image
        }
        return UIImage()
    }
    
    public func saveImageData(_ imageData: ImageData) {
        var imageDataArray = getSavedImageData()
        imageDataArray.append(imageData)
        UserDefaults.standard.set(encodable: imageDataArray, forKey: Keys.imageData.rawValue)
    }
    
    public func saveImageData(_ imageDataArray: [ImageData]) {
        var currentImageDataArray = getSavedImageData()
        currentImageDataArray = imageDataArray
        UserDefaults.standard.set(encodable: currentImageDataArray, forKey: Keys.imageData.rawValue)
    }
    
    public func checkImageIsFavorite(_ value: Bool) -> UIImage {
        if value {
            return UIImage(named: "like") ?? UIImage()
        } else {
            return UIImage(named: "dislike") ?? UIImage()
        }
    }
    
    public func isUserDefaultsEmpty() -> Bool {
        guard UserDefaults.standard.value(forKey: Keys.imageData.rawValue) == nil ||
                getSavedImageData().count == 0 else { return false }
        return true
    }
    
    // MARK: - PhotoLib functions
    
    func increment(_ index: inout Int) {
        let array = getSavedImageData()
        guard index != -1 else { return }
        if index < array.count - 1 {
            index += 1
        } else {
            index = 0
        }
    }
    
    func decrement(_ index: inout Int) {
        let array = getSavedImageData()
        guard index != -1 else { return }
        if index > 0 {
            index -= 1
        } else if index == 0, array.count != 0 {
            index = array.count - 1
        } else {
            index = -1
        }
    }
    
    func showData(at index: Int, in views: (UIImageView, UITextField, UIButton)) {
        let array = getSavedImageData()
        let dataObject = array[index]
        
        views.0.image = getUIImage(with: dataObject.imageName)
        views.1.text = dataObject.comment
        
        if dataObject.isFavorite {
            views.2.setImage(UIImage(named: "like"), for: .normal)
        } else {
            views.2.setImage(UIImage(named: "dislike"), for: .normal)
        }
    }
    
    func removeData(at index: inout Int) {
        var array = getSavedImageData()
        array.remove(at: index)
        saveImageData(array)
        decrement(&index)
    }
    
    func updateData(type: DataType, at index: Int, in views: (UITextField?, UIButton?)) {
        var array = getSavedImageData()
        let dataObject = array[index]
        switch type {
        case .like:
            dataObject.isFavorite = !dataObject.isFavorite
            if let button = views.1 {
                if dataObject.isFavorite {
                    button.setImage(UIImage(named: "like"), for: .normal)
                } else {
                    button.setImage(UIImage(named: "dislike"), for: .normal)
                }
            }
        case .comment:
            if let textField = views.0 {
                dataObject.comment = textField.text ?? ""
            }
        }
        array[index] = dataObject
        saveImageData(array)
    }
    
    func setImage(to imageView: UIImageView, at index: Int) {
        let array = getSavedImageData()
        if index != -1 {
            imageView.image = getUIImage(with: array[index].imageName)
        } else {
            imageView.image = UIImage(named: "photo_icon")
        }
    }
}
