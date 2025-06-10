//
//  UIView.swift
//  
//
//  Created by Rakibur Khan on 3/4/24.
//

#if canImport(UIKit)
import UIKit

public extension UIView {
    func setCornerRadius(cornerRadius:CGFloat){
        self.layer.cornerRadius = cornerRadius
    }
    
    func roundedCorner(corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner],radius cornerRadius: CGFloat = 10, masks: Bool = true, clips: Bool = false) {
        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
        clipsToBounds = clips
        layer.masksToBounds = masks
    }
    
    func rounded(masks: Bool = true, clips: Bool = true) {
        roundedCorner(radius: bounds.height / 2, masks: masks, clips: clips)
    }
    
    func setBorder(width borderWidth: CGFloat = 1, color borderColor: UIColor? = .secondaryLabel, background: UIColor? = nil, radius cornerRadius: CGFloat? = nil) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        layer.backgroundColor = background?.cgColor
        if let cornerRadius = cornerRadius {
            layer.cornerRadius = cornerRadius
        }
    }
    
    func setShadow(color: UIColor? = .secondaryLabel, background: UIColor? = .systemBackground, offset: CGSize = .zero, opacity: Float = 1, radius: CGFloat = 10, cornerRadius: CGFloat = 0, path: CGPath? = nil) {
        roundedCorner(radius: cornerRadius, masks: true, clips: false)
        
        layer.bounds = bounds
        layer.backgroundColor = background?.cgColor
        layer.shadowColor = color?.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = path
        layer.masksToBounds = false
    }
    
}

//MARK: Gradient Related
public extension UIView {
    func setLinearGradientBackground(colors: [UIColor]?, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil, location: [NSNumber]? = nil, type: CAGradientLayerType = .axial) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.type = type
        
        gradientLayer.colors = colors?.map{ $0.cgColor }
        
        gradientLayer.locations = location
        
        gradientLayer.startPoint = startPoint ?? .init(x: 0, y: 0)
        gradientLayer.endPoint = endPoint ?? .init(x: 1, y: 1)
        
        gradientLayer.position = self.center
        
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

//MARK: UIView Animations
public extension UIView{
    func showViewWithAnimation(isHidden: Bool) {
        UIView.transition(with: self, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.isHidden = isHidden
        })
    }
}

public extension UIView {
    func applyBlurEffect(style: UIBlurEffect.Style = .systemUltraThinMaterialDark) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}

#endif
