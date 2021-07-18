import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likedImageView: UIImageView!
    
    private let manager = AppManager.shared
    static let identifier = "CollectionViewCell"
    
    // MARK: - Cell configuration function
    
    public func configure(with data: ImageData?) {
        
        guard let data = data else { return }
        
        imageView.image = manager.getUIImage(with: data.imageName)
        if data.isFavorite {
            likedImageView.isHidden = false
            likedImageView.dropShadow(radius: 10, shouldRasterize: true)
        } else {
            likedImageView.isHidden = true
        }
    }
}
