//
//  Created by Jake Lin on 12/13/15.
//  Copyright © 2015 IBAnimatable. All rights reserved.
//

import UIKit

/// A protocol provides mask designable feature.
public protocol MaskDesignable: class {
  /**
   The type of the mask used for masking an IBAnimatable UI element.

   When you create a class and conform to `MaskDesignable`, you need to implement this computed property like

   ```
   public var maskType: MaskType = .none {
     didSet {
       configureMask()
       configureBorder()
     }
   }
   ```

   Because Interface Builder doesn't support `enum` for `@IBInspectable` property. You need to create an `internal` property using optional String as the type like
   ```
   @IBInspectable var _maskType: String? {
     didSet {
       maskType = MaskType(string: _maskType)
     }
   }
   ```
   */
  var maskType: MaskType { get set }
}

// MARK: - UIView

extension MaskDesignable where Self: UIView {
  /// Mask the IBAnimatable UI element with provided `maskType`
  public func configureMask(previousMaskType: MaskType) {
    configureMask(in: self, previousMaskType: previousMaskType)
  }
}

// MARK: - Common

extension MaskDesignable {

  func configureMask(in view: UIView, previousMaskType: MaskType) {
    if case .none = maskType {
       MaskUtils.removePreviousMask(previousMaskType, in: view)
    } else {
      MaskUtils.installMask(maskType, in: view)
    }
  }
}

struct MaskUtils {
  /**
   Draw a Bezier path on `layer.mask` using `CAShapeLayer`.

   - Parameter path: The Bezier path to draw.
   */
  static func installMask(_ maskType: MaskType, in view: UIView) {
    let path = maskType.bezierPath(in: view.bounds)
    view.layer.mask?.removeFromSuperlayer()

    let maskLayer = CAShapeLayer()
    maskLayer.frame = CGRect(origin: .zero, size: view.bounds.size)
    
   /* let anim = CABasicAnimation(keyPath: "path")

    anim.fromValue = initpath.cgPath
    anim.toValue = path.cgPath
    anim.duration = 3.0
    anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    maskLayer.add(anim, forKey: nil)*/
    
    maskLayer.path = path.cgPath
    if path.usesEvenOddFillRule {
      maskLayer.fillRule = kCAFillRuleEvenOdd
    }
    view.layer.mask = maskLayer
  }
  
  static func removePreviousMask(_ previousMaskType: MaskType, in view: UIView) {
    // If `previousMaskType` is `.none`, then we will **not** remove `layer.mask` before re-adding it. This allows for custom masks to be preserved.
    if case .none = previousMaskType {
      return
    } else {
      view.layer.mask?.removeFromSuperlayer()
    }
  }
}
