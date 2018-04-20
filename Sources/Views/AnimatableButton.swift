//
//  Created by Jake Lin on 11/18/15.
//  Copyright © 2015 IBAnimatable. All rights reserved.
//

import UIKit

@IBDesignable
open class AnimatableButton: UIButton, CornerDesignable, FillDesignable, BorderDesignable, ShadowDesignable, MaskDesignable, Animatable {

  // MARK: - CornerDesignable
  @IBInspectable open var cornerRadius: CGFloat = CGFloat.nan {
    didSet {
      configureCornerRadius()
    }
  }

  open var cornerSides: CornerSides  = .allSides {
    didSet {
      configureCornerRadius()
    }
  }

  @IBInspectable var _cornerSides: String? {
    didSet {
      cornerSides = CornerSides(rawValue: _cornerSides)
    }
  }

  // MARK: - FillDesignable
  @IBInspectable open var fillColor: UIColor? {
    didSet {
      configureFillColor()
    }
  }

  open var predefinedColor: ColorType? {
    didSet {
      configureFillColor()
    }
  }
  @IBInspectable var _predefinedColor: String? {
    didSet {
      predefinedColor = ColorType(string: _predefinedColor)
    }
  }

  @IBInspectable open var opacity: CGFloat = CGFloat.nan {
    didSet {
      configureOpacity()
    }
  }

  // MARK: - BorderDesignable
  open var borderType: BorderType  = .solid {
    didSet {
      configureBorder()
    }
  }

  @IBInspectable var _borderType: String? {
    didSet {
      borderType = BorderType(string: _borderType)
    }
  }

  @IBInspectable open var borderColor: UIColor? {
    didSet {
      configureBorder()
    }
  }

  @IBInspectable open var borderWidth: CGFloat = CGFloat.nan {
    didSet {
      configureBorder()
    }
  }

   open var borderSides: BorderSides  = .AllSides {
    didSet {
      configureBorder()
    }
  }

  @IBInspectable var _borderSides: String? {
    didSet {
      borderSides = BorderSides(rawValue: _borderSides)
    }
  }

  // MARK: - ShadowDesignable
  @IBInspectable open var shadowColor: UIColor? {
    didSet {
      configureShadowColor()
    }
  }

  @IBInspectable open var shadowRadius: CGFloat = CGFloat.nan {
    didSet {
      configureShadowRadius()
    }
  }

  @IBInspectable open var shadowOpacity: CGFloat = CGFloat.nan {
    didSet {
      configureShadowOpacity()
    }
  }

  @IBInspectable open var shadowOffset: CGPoint = CGPoint(x: CGFloat.nan, y: CGFloat.nan) {
    didSet {
      configureShadowOffset()
    }
  }

  // MARK: - MaskDesignable
  open var maskType: MaskType = .none {
    didSet {
      configureMask(previousMaskType: oldValue)
      configureBorder()
      configureMaskShadow()
    }
  }

  /// The mask type used in Interface Builder. **Should not** use this property in code.
  @IBInspectable var _maskType: String? {
    didSet {
      maskType = MaskType(string: _maskType)
    }
  }

  // MARK: - Animatable
  open var animationType: AnimationType = .none
  @IBInspectable  var _animationType: String? {
    didSet {
     animationType = AnimationType(string: _animationType)
    }
  }
  @IBInspectable open var autoRun: Bool = true
  @IBInspectable open var duration: Double = Double.nan
  @IBInspectable open var delay: Double = Double.nan
  @IBInspectable open var damping: CGFloat = CGFloat.nan
  @IBInspectable open var velocity: CGFloat = CGFloat.nan
  @IBInspectable open var force: CGFloat = CGFloat.nan
  @IBInspectable var _timingFunction: String = "" {
    didSet {
      timingFunction = TimingFunctionType(string: _timingFunction)
    }
  }
  open var timingFunction: TimingFunctionType = .none

  // MARK: - Lifecycle
  open override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    configureInspectableProperties()
  }

  open override func awakeFromNib() {
    super.awakeFromNib()
    configureInspectableProperties()
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
    configureAfterLayoutSubviews()
    autoRunAnimation()
  }

  // MARK: - Private
  fileprivate func configureInspectableProperties() {
    configureAnimatableProperties()
  }

  fileprivate func configureAfterLayoutSubviews() {
    configureMask(previousMaskType: maskType)
    configureCornerRadius()
    configureBorder()
    configureMaskShadow()
  }
  
  // MARK: -TouchAnimatable
  
  override open var isHighlighted: Bool {
    didSet {
      guard oldValue != isHighlighted else { return }
      animateHighlight()
    }
  }
  
  func animateHighlight() {
    
  }
  
  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    touches.forEach { touch($0) }
    super.touchesBegan(touches, with: event)
  }
  
  override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touches.forEach { touch($0) }
    super.touchesEnded(touches, with: event)
  }
  override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    touches.forEach { touch($0) }
    super.touchesCancelled(touches, with: event)
  }
  
  open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    touches.forEach { touch($0) }
    super.touchesMoved(touches, with: event)
  }

  func touch(_ touch: UITouch) {
    switch touch.phase {
    case .began:
      animate(touchAnimationType)
      
    case .ended:
      stopBlock?()
    case .cancelled:
      break
    case .stationary:
      break
    case .moved:
      break
    }
  }
  var stopBlock: (()-> Void)? = nil
  
  func animate(_ touchAnimationType: TouchAnimationType) {
    switch touchAnimationType {
    case .activityIndicator(let animationType):

      /* let activityIndicator = ActivityIndicatorFactory.makeActivityIndicator(activityIndicatorType: type)
       activityIndicator.configureAnimation(in: layer, size: bounds.size, color: UIColor.red)
       layer.speed = 1*/
      
      let size = self.frame.size
      let indicatorSize = min(size.width, size.height)
      let frame = CGRect(origin: CGPoint(x: (size.width - indicatorSize) / 2, y: (size.height - indicatorSize) / 2) ,
                         size: CGSize(width: indicatorSize, height: indicatorSize))
      
      let indicator = AnimatableActivityIndicatorView(frame: frame)
      indicator.animationType = animationType
      indicator.color = self.tintColor ?? .black
      addSubview(indicator)
      
      indicator.startAnimating()
      
      // STOP block
      stopBlock = {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
      }
      
    case .animation(let animationType):
      break
    case .mask(let maskType):
      
      let view = self
      MaskUtils.installMask(maskType, in: view)
      
      stopBlock = {
        MaskUtils.removePreviousMask(maskType, in: view)
      }
      break
    case .none:
      break
    case .removeTitle:
      break
    }
  }

  var touchAnimationType: TouchAnimationType = .mask(.circle) //.activityIndicator(.ballBeat)

}
