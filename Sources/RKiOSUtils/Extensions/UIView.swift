//
//  UIView.swift
//  
//
//  Created by Rakibur Khan on 3/4/24.
//

import UIKit

public extension UIView {
    func setCornerRadious(cornerRadious:CGFloat){
        self.layer.cornerRadius = cornerRadious
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
    
    func setBorder(width borderWidth: CGFloat = 1, color borderColor: UIColor? = .secondaryLabel, background: UIColor? = nil) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        layer.backgroundColor = background?.cgColor
    }
    
    func setBorderWithCorner(borderColor: UIColor = .black, cornerRadius: CGFloat = 6) {
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        backgroundColor = UIColor.white
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
    
    @discardableResult
    func loadViewFromNib<T : UIView>(nib: String? = nil, bundle: Bundle? = nil) -> T? {
        var bundleName: Bundle = Bundle(for: type(of: self))
        var nibName: String = String(describing: type(of: self))
        
        if let bundle: Bundle = bundle {
            bundleName = bundle
        }
        
        if let nib = nib {
            nibName = nib
        }
        
        guard let contentView = bundleName.loadNibNamed(nibName, owner: self, options: nil)?.first as? T else {
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutAttachAll()
        return contentView
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

//MARK: Constraint related
public extension UIView {
    /// attaches all sides of the receiver to its parent view
    func layoutAttachAll(margin : CGFloat = 0.0) {
        let view = superview
        layoutAttachTop(to: view, margin: margin)
        layoutAttachBottom(to: view, margin: margin)
        layoutAttachLeading(to: view, margin: margin)
        layoutAttachTrailing(to: view, margin: margin)
    }
    
    /// attaches the top of the current view to the given view's top if it's a superview of the current view, or to it's bottom if it's not (assuming this is then a sibling view).
    /// if view is not provided, the current view's super view is used
    @discardableResult
    func layoutAttachTop(to: UIView? = nil, margin : CGFloat = 0.0) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = view == superview
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: isSuperview ? .top : .bottom, multiplier: 1.0, constant: margin)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the bottom of the current view to the given view
    @discardableResult
    func layoutAttachBottom(to: UIView? = nil, margin : CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: isSuperview ? .bottom : .top, multiplier: 1.0, constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the leading edge of the current view to the given view
    @discardableResult
    func layoutAttachLeading(to: UIView? = nil, margin : CGFloat = 0.0) -> NSLayoutConstraint {
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: isSuperview ? .leading : .trailing, multiplier: 1.0, constant: margin)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the trailing edge of the current view to the given view
    @discardableResult
    func layoutAttachTrailing(to: UIView? = nil, margin : CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: isSuperview ? .trailing : .leading, multiplier: 1.0, constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        
        return constraint
    }
}

public extension UIView {
    func addDashBorder(dashColor: UIColor = .systemBackground) {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        
        let frameSize = frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = dashColor.cgColor
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [2,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath
        
        layer.masksToBounds = false
        
        layer.addSublayer(shapeLayer)
    }
}

public extension UIView {
    func customLayer(corners: Corners = .all,
                     radius: CGFloat = 10,
                     setShadow: Bool = false,
                     shadowColor: UIColor = .black,
                     setBorder: Bool = false,
                     borderType: Stroke = .line,
                     borderWidth: CGFloat = 1,
                     borderColor: UIColor = .black,
                     isRound: Bool = false) {
        
        var cornerMasks = [CACornerMask]()
        
        switch corners {
            case .all, .top, .topLeft, .allButTopRight, .allButBottomLeft, .allButBottomRight, .topLeftBottomRight:
                cornerMasks.append(CACornerMask(rawValue: UIRectCorner.topLeft.rawValue))
            default:
                break
        }
        
        // Top right corner
        switch corners {
            case .all, .top, .topRight, .allButTopLeft, .allButBottomLeft, .allButBottomRight, .topRightBottomLeft:
                cornerMasks.append(CACornerMask(rawValue: UIRectCorner.topRight.rawValue))
            default:
                break
        }
        
        // Bottom left corner
        switch corners {
            case .all, .bottom, .bottomLeft, .allButTopRight, .allButTopLeft, .allButBottomRight, .topRightBottomLeft:
                cornerMasks.append(CACornerMask(rawValue: UIRectCorner.bottomLeft.rawValue))
            default:
                break
        }
        
        // Bottom right corner
        switch corners {
            case .all, .bottom, .bottomRight, .allButTopRight, .allButTopLeft, .allButBottomLeft, .topLeftBottomRight:
                cornerMasks.append(CACornerMask(rawValue: UIRectCorner.bottomRight.rawValue))
            default:
                break
        }
        var cuttedRadius = radius
        
        if(isRound){
            cuttedRadius = self.frame.size.height/2
        }
        
        clipsToBounds = true
        layer.cornerRadius = cuttedRadius
        layer.maskedCorners = CACornerMask(cornerMasks)
        
        if setShadow {
            layer.shadowColor = UIColor(red: 0.09, green: 0.23, blue: 0.87, alpha: 0.20).cgColor
            layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            layer.shadowRadius = radius
            layer.masksToBounds = false
        }
        
        if setBorder {
            let shapeLayer:CAShapeLayer = CAShapeLayer()
            let frameSize = self.frame.size
            let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
            
            shapeLayer.bounds = shapeRect
            shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = borderColor.cgColor
            shapeLayer.lineWidth = borderWidth
            shapeLayer.name = "shapeLayer"
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            
            switch borderType {
                case .dash:
                    shapeLayer.lineDashPattern = [6,6]
                    break
                case .dot:
                    shapeLayer.lineDashPattern = [1,3]
                    break
                default:
                    break
            }
            
            shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: radius).cgPath
            
            self.layer.sublayers?.forEach { layer in
                if layer.name == "shapeLayer" {
                    layer.removeFromSuperlayer()
                }
            }
            
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    enum Stroke {
        case line
        case dash
        case dot
    }
    
    enum Corners {
        case all
        case top
        case bottom
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        case allButTopLeft
        case allButTopRight
        case allButBottomLeft
        case allButBottomRight
        case left
        case right
        case topLeftBottomRight
        case topRightBottomLeft
    }
}


public extension UIView {
    func comingFromRight(containerView: UIView) {
        let offset = CGPoint(x: containerView.frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        self.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        self.isHidden = false
        
        UIView.animate(
            withDuration: 0.3, delay: 0,
            options: .curveEaseOut) {
                self.transform = .identity
                self.alpha = 1
            }
    }
    
    func comingFromLeft(containerView: UIView) {
        let offset = CGPoint(x: containerView.frame.minX, y: 0)
        let x: CGFloat = -containerView.frame.width, y: CGFloat = 0
        self.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        self.isHidden = false
        
        UIView.animate(
            withDuration: 0.3, delay: 0,
            options: .curveEaseOut) {
                self.transform = .identity
                self.alpha = 1
            }
    }
}

public extension UIView {
    enum PeakSide: Int {
        case Top
        case Left
        case Right
        case Bottom
    }
    
    func addPikeOnView( side: PeakSide, size: CGFloat = 10.0) {
        self.layoutIfNeeded()
        let peakLayer = CAShapeLayer()
        var path: CGPath?
        
        switch side {
            case .Top:
                path = self.makePeakPathWithRect(rect: self.bounds, topSize: size, rightSize: 0.0, bottomSize: 0.0, leftSize: 0.0)
            case .Left:
                path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: 0.0, bottomSize: 0.0, leftSize: size)
            case .Right:
                path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: size, bottomSize: 0.0, leftSize: 0.0)
            case .Bottom:
                path = self.makePeakPathWithRect(rect: self.bounds, topSize: 0.0, rightSize: 0.0, bottomSize: size, leftSize: 0.0)
        }
        
        peakLayer.path = path
        let color = (self.backgroundColor?.cgColor)
        peakLayer.fillColor = color
        peakLayer.strokeColor = color
        peakLayer.lineWidth = 1
        peakLayer.position = CGPoint.zero
        self.layer.insertSublayer(peakLayer, at: 0)
    }
    
    func makePeakPathWithRect(rect: CGRect, topSize ts: CGFloat, rightSize rs: CGFloat, bottomSize bs: CGFloat, leftSize ls: CGFloat) -> CGPath {
        //                      P3
        //                    /    \
        //      P1 -------- P2     P4 -------- P5
        //      |                               |
        //      |                               |
        //      P16                            P6
        //     /                                 \
        //  P15                                   P7
        //     \                                 /
        //      P14                            P8
        //      |                               |
        //      |                               |
        //      P13 ------ P12    P10 -------- P9
        //                    \   /
        //                     P11
        
        let centerX = rect.width / 2
        let centerY = rect.height / 2
        var h: CGFloat = 0
        let path = CGMutablePath()
        var points: [CGPoint] = []
        // P1
        points.append(CGPoint(x:rect.origin.x,y: rect.origin.y))
        // Points for top side
        if ts > 0 {
            h = ts * sqrt(3.0) / 2
            let x = rect.origin.x + centerX
            let y = rect.origin.y
            points.append(CGPoint(x:x - ts,y: y))
            points.append(CGPoint(x:x,y: y - h))
            points.append(CGPoint(x:x + ts,y: y))
        }
        
        // P5
        points.append(CGPoint(x:rect.origin.x + rect.width,y: rect.origin.y))
        // Points for right side
        if rs > 0 {
            h = rs * sqrt(3.0) / 2
            let x = rect.origin.x + rect.width
            let y = rect.origin.y + centerY
            points.append(CGPoint(x:x,y: y - rs))
            points.append(CGPoint(x:x + h,y: y))
            points.append(CGPoint(x:x,y: y + rs))
        }
        
        // P9
        points.append(CGPoint(x:rect.origin.x + rect.width,y: rect.origin.y + rect.height))
        // Point for bottom side
        if bs > 0 {
            h = bs * sqrt(3.0) / 2
            let x = rect.origin.x + centerX
            let y = rect.origin.y + rect.height
            points.append(CGPoint(x:x + bs,y: y))
            points.append(CGPoint(x:x,y: y + h))
            points.append(CGPoint(x:x - bs,y: y))
        }
        
        // P13
        points.append(CGPoint(x:rect.origin.x, y: rect.origin.y + rect.height))
        // Point for left sidey:
        if ls > 0 {
            h = ls * sqrt(3.0) / 2
            let x = rect.origin.x
            let y = rect.origin.y + centerY
            points.append(CGPoint(x:x,y: y + ls))
            points.append(CGPoint(x:x - h,y: y))
            points.append(CGPoint(x:x,y: y - ls))
        }
        
        let startPoint = points.removeFirst()
        self.startPath(path: path, onPoint: startPoint)
        for point in points {
            self.addPoint(point: point, toPath: path)
        }
        self.addPoint(point: startPoint, toPath: path)
        return path
    }
    
    private func startPath( path: CGMutablePath, onPoint point: CGPoint) {
        path.move(to: CGPoint(x: point.x, y: point.y))
    }
    
    private func addPoint(point: CGPoint, toPath path: CGMutablePath) {
        path.addLine(to: CGPoint(x: point.x, y: point.y))
    }
}

import Lottie
//MARK: - Lottie extension
@MainActor
public extension UIView {
    func showLottieAnimation(json jsonName: String, speed: CGFloat = 1, loop: LottieLoopMode = .playOnce, contentMode: ContentMode = .scaleToFill, bundle: Bundle = .main) {
        let animation = LottieAnimation.named(jsonName, bundle: bundle)
        let animationView = LottieAnimationView(animation: animation)
        animationView.contentMode = contentMode
        animationView.animationSpeed = speed
        animationView.loopMode = loop
        animationView.backgroundBehavior = .pauseAndRestore
        
        addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        let leading = animationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        let trailing = animationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        let top = animationView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        let bottom = animationView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        let constraints = [leading, trailing, top, bottom]
        NSLayoutConstraint.activate(constraints)
        
        animationView.play()
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

public extension UIView{
    /**
     Sets anchor of current view with the provided anchors with padding
     - Parameters:
        - top: Receives  `NSLayoutYAxisAnchor?` as the anchor. Default value is `nil`
        - leading: Receives  `NSLayoutYAxisAnchor?` as anchor. Default value is `nil`
        - bottom: Receives  `NSLayoutYAxisAnchor?` as anchor. Default value is `nil`
        - trailing: Receives  `NSLayoutYAxisAnchor?` as anchor. Default value is `nil`
        - paddingTop: Receives  `CGFloat` as constant. Default value is 0
        - paddingLeading: Receives  `CGFloat` as constant. Default value is 0
        - paddingBottom: Receives  `CGFloat` as constant. Default value is 0
        - paddingTrailing: Receives  `CGFloat` as constant. Default value is 0
        - width: Receives  `CGFloat?` as constant. Default value is `nil`
        - height: Receives  `CGFloat?` as constant. Default value is `nil`
        - multiplier: Receives  `CGFloat?` as value. Default value is `nil`
     */
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeading: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingTrailing: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil,
                multiplier:CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let multiplier = multiplier{
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier, constant: 0).isActive = true
        }
        
    }
    
    /**
     Sets centerX of current view with centerX of the provied view with a constant
     - Parameters:
        - view: Receives  `UIView` as the parent view
        - constant: Receives  `CGFloat` as constant. Default value is 0
     */
    func centerX(inView view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
    }
    
    /**
     Sets centerY of current view with centerY of the provied view with a constant
     - Parameters:
        - view: Receives  `UIView` as the parent view
        - constant: Receives  `CGFloat` as constant. Default value is 0
     */
    
    func centerY(inView view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
    }
    
    /**
     Sets width, height  of a view
     - Parameters:
        - height: Receives  `CGFloat` as height
        - width: Receives  `CGFloat` as width
     */
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    /**
     Sets maximum width, minimum width, maximum height, minimum height of a view
     - Parameters:
        - minWidth: Receives `Optional<CGFloat>` or `CGFloat?`, Default value is `nil`
        - maxWidth: Receives `Optional<CGFloat>` or `CGFloat?`, Default value is `nil`
        - minHeight: Receives `Optional<CGFloat>` or `CGFloat?`, Default value is `nil`
        - maxHeight: Receives `Optional<CGFloat>` or `CGFloat?`, Default value is `nil`
     */
    func setDimensions(minWidth: CGFloat?, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, maxHeight: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let minWidth = minWidth {
            widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth).isActive = true
        }
        fillSuperview()
        if let minHeight = minHeight {
            heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        }
        
        
        if let maxWidth = maxWidth {
            widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        }
        
        if let maxHeight = maxHeight {
            heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight).isActive = true
        }
    }
    /**
    Sets Top, Bottom, Leading, Trailing anchor with specifit edge insets
    - Parameters:
       - padding: Receives `UIEdgeInsets`, Default value is .zero
     */
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
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

