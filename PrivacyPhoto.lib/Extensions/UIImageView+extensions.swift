import Foundation
import UIKit

extension UIImageView {
    func dropShadow(radius: CGFloat, offset: CGSize = CGSize(width: 0, height: 0), shouldRasterize: Bool) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = offset
        layer.shadowRadius = radius        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = shouldRasterize
    }
}
