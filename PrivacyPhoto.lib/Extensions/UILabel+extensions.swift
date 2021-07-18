import Foundation
import UIKit

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat) {
        let text = self.text
        if let text = text {
            let attributedString = NSMutableAttributedString(string: text)
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = lineSpacing
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            self.attributedText = attributedString
        }
    }
}
