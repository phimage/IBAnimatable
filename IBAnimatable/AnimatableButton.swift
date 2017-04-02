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

  let touchAnimator: TouchAnimator? = TouchAnimator.zoomOutIn
  var touchAnimationConfiguration: AnimationConfiguration {
    return AnimationConfiguration(damping: 0, velocity: 1, duration: 0.3, delay: 0, force: 1)
  }

  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    touchAnimator?.touchesBegan(touches, on: self, configuration: touchAnimationConfiguration)
  }

  open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    touchAnimator?.touchesMoved(touches, on: self, configuration: touchAnimationConfiguration)
  }

  override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchAnimator?.touchesEnded(touches, on: self, configuration: touchAnimationConfiguration)
    super.touchesEnded(touches, with: event)
  }

  override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchAnimator?.touchesCancelled(touches, on:self, configuration: touchAnimationConfiguration)
    super.touchesCancelled(touches, with: event)
  }

}

enum TouchAnimator {
  // XXX add parameters like scale and alpha
  case zoomOutIn

  // XXX could also add tevent
  func touchesBegan(_ touches: Set<UITouch>, on view: UIView, configuration: AnimationConfiguration) {
    // TODO sitch case according to animator
    UIView.animate(withDuration: configuration.duration,
                   delay: configuration.delay,
                   options: .curveEaseIn,
                   animations: {() -> Void in
                    view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                    view.alpha = 0.7
    },
                   completion: nil
    )

  }

  func touchesEnded(_ touches: Set<UITouch>, on view: UIView, configuration: AnimationConfiguration){
    UIView.animate(withDuration: configuration.duration,
                   delay: configuration.delay,
                   options: .curveEaseIn,
                   animations: {() -> Void in
                    view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    view.alpha = 1
    },
                   completion: nil
    )
  }

  func touchesCancelled(_ touches: Set<UITouch>, on view: UIView, configuration: AnimationConfiguration){
    UIView.animate(withDuration: configuration.duration,
                   delay: configuration.delay,
                   options: .curveEaseIn,
                   animations: {() -> Void in
                    view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    view.alpha = 1
    },
                   completion: nil
    )
  }
  
  
  func touchesMoved(_ touches: Set<UITouch>, on view: UIView, configuration: AnimationConfiguration){
  
  }
}


