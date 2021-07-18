import Foundation
import UIKit

struct Constants {
    struct CornerRadius {
        static let signUpButton: CGFloat = 20.0
        static let signInButton: CGFloat = 20.0
        static let photoLibButton: CGFloat = 10.0
        static let view: CGFloat = 10.0
    }
    struct Button {
        static let width: CGFloat = 45.0
        static let height: CGFloat = 45.0
    }
    struct OnboardingVC {
        static let commonTopSpacing: CGFloat = 10
        static let commonBottomSpacing: CGFloat = -10
        static let commonTrailing: CGFloat = -20
        static let commonLeading: CGFloat = 20
        
        static let infoLabelTextColor: UIColor = .lightGray
        
        static let mainTitleLabelTextColor = UIColor(red: 216, green: 237, blue: 247)
        static let mainTitleLabelFontSize: CGFloat = 50.0
        
        static let infoLabelFont = UIFont(name: Fonts.courier.rawValue, size: 20.0)
        static let infoLabelLineSpacing: CGFloat = 10.0
        
        static let controllerButtonTitleLabelFontSize: CGFloat = 30.0
        static let controllerButtonBackgroundColor = UIColor(red: 25, green: 170, blue: 141)
        static let controllerButtonHeight: CGFloat = 40.0
    }
    struct RegistrationVC {
        static let backgroundColor = UIColor(red: 102, green: 114, blue: 135)
        static let regFormViewHeight: CGFloat = 400.0
        static let regFormTrailingAnchor: CGFloat = -20.0
        static let regFormLeadingAnchor: CGFloat = 20.0
        //        static let regFormFrameMargin: CGFloat = 40.0
        static let keyboardTopSpacing: CGFloat = 20.0
    }
    struct AuthenticationVC {
        static let backgroundColor = UIColor(red: 102, green: 114, blue: 135)
        static let authFormViewHeight: CGFloat = 400.0
        static let authFormTrailingAnchor: CGFloat = -20.0
        static let authFormLeadingAnchor: CGFloat = 20.0
        //        static let authFormFrameMargin: CGFloat = 40.0
        static let keyboardTopSpacing: CGFloat = 20.0
    }
    struct MainVC {
        static let backgroundColor = UIColor.systemGray5
        static let buttonLeading: CGFloat = 20.0
        static let buttonTrailing: CGFloat = -20.0
        static let buttonTopSpacing: CGFloat = 10.0
        static let buttonBottomSpacing: CGFloat = -20.0
        
        static let collectionViewTopSpacing: CGFloat = 20.0
        static let collectionViewBottomSpacing: CGFloat = -10.0
        static let collectionViewLeading: CGFloat = 10.0
        static let collectionViewTrailing: CGFloat = -10.0
        static let lineSpacingForSection: CGFloat = 10.0
        static let horizontalSpacingForItem: CGFloat = 10.0
        static let numberOfItemsInRow: CGFloat = 4.0
    }
    struct PhotoLibVC {
        static let backgroundColor = UIColor.systemGray5
        static let topButtonsContainerViewTopSpacing: CGFloat = 10.0
        static let topButtonsContainerViewLeading: CGFloat = 20.0
        static let topButtonsContainerViewTrailing: CGFloat = -20.0
        static let topButtonsContainerViewHeight: CGFloat = 45.0
        
        static let previousButtonHorizontalSpacing: CGFloat = -30.0
        
        static let imageViewTrailing: CGFloat = -20.0
        static let imageViewLeading: CGFloat = 20.0
        static let imageViewTopSpacing: CGFloat = 40.0
        static let imageViewBottomSpacing: CGFloat = -40.0
        static let imageViewBorderWidth: CGFloat = 2.0
        
        static let bottomButtonsContainerViewHeight: CGFloat = 50.0
        static let bottomButtonsContainerViewTopSpacing: CGFloat = 40.0
        
        static let commentTextFieldBottomSpacing: CGFloat = -40.0
        static let commentTextFieldHeight: CGFloat = 45.0
        
        static let keyboardTopSpacing: CGFloat = 20.0
    }
}
