//
//  CircularAnimator.swift
//  IBAnimatable
//
//  Created by phimage on 11/04/2017.
//  Copyright © 2017 IBAnimatable. All rights reserved.
//

import UIKit

public class CircularAnimator: NSObject, AnimatedTransitioning {
  // MARK: - AnimatedTransitioning
  public var transitionAnimationType: TransitionAnimationType = .circular
  public var transitionDuration: Duration = defaultTransitionDuration
  public var reverseAnimationType: TransitionAnimationType?
  public var interactiveGestureType: InteractiveGestureType?
  
  // MARK: - private
  //fileprivate var direction: TransitionAnimationType.Direction
  
  public init(duration: Duration) {
   // self.direction = direction
    transitionDuration = duration
    
    
    super.init()
  }
}

extension CircularAnimator: UIViewControllerAnimatedTransitioning {
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return retrieveTransitionDuration(transitionContext: transitionContext)
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let (tempfromView, tempToView, tempContainerView) = retrieveViews(transitionContext: transitionContext)
    guard let fromView = tempfromView, let toView = tempToView, let containerView = tempContainerView else {
      transitionContext.completeTransition(true)
      return
    }
    
    let (_, tempToViewController, _) = retrieveViewControllers(transitionContext: transitionContext)
    if let toViewController = tempToViewController {
      toView.frame = transitionContext.finalFrame(for: toViewController)
    }

      toView.alpha = 0
      containerView.addSubview(toView)
  
    
    UIView.animate(
      withDuration: transitionDuration(using: transitionContext),
      animations: {
        
        
        fromView.alpha = 0
        toView.alpha = 1 
    },
      completion: { _ in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    )
  }
}



extension UIView {
  
  func animateCircular(withDuration duration: TimeInterval, center: CGPoint, revert: Bool = false, animations: () -> Void, completion: ((Bool) -> Void)? = nil) {
    let snapshot = snapshotView(afterScreenUpdates: false)!
    snapshot.frame = bounds
    self.addSubview(snapshot)
    
    let center = convert(center, to: snapshot)
    let radius: CGFloat = {
      let x = max(center.x, frame.width - center.x)
      let y = max(center.y, frame.height - center.y)
      return sqrt(x * x + y * y)
    }()
    var animation : CircularRevealAnimator
    if !revert {
      animation = CircularRevealAnimator(layer: snapshot.layer, center: center, startRadius: 0, endRadius: radius, invert: true)
    } else {
      animation = CircularRevealAnimator(layer: snapshot.layer, center: center, startRadius: radius, endRadius: 0, invert: false)
    }
    animation.duration = duration
    animation.completion = {
      snapshot.removeFromSuperview()
      completion?(true)
    }
    animation.start()
    animations()
  }
}
private func SquareAroundCircle(_ center: CGPoint, radius: CGFloat) -> CGRect {
  assert(0 <= radius, "radius must be a positive value")
  return CGRect(origin: center, size: CGSize.zero).insetBy(dx: -radius, dy: -radius)
}

class CircularRevealAnimator {
  
  var completion: (() -> Void)?
  
  fileprivate let layer: CALayer
  fileprivate let mask: CAShapeLayer
  fileprivate let animation: CABasicAnimation
  
  var duration: TimeInterval {
    get { return animation.duration }
    set(value) { animation.duration = value }
  }
  
  var timingFunction: CAMediaTimingFunction! {
    get { return animation.timingFunction }
    set(value) { animation.timingFunction = value }
  }
  
  init(layer: CALayer, center: CGPoint, startRadius: CGFloat, endRadius: CGFloat, invert: Bool) {
    let startPath = CGPath(ellipseIn: SquareAroundCircle(center, radius: startRadius), transform: nil)
    let endPath = CGPath(ellipseIn: SquareAroundCircle(center, radius: endRadius), transform: nil)
    
    self.layer = layer
    
    mask = CAShapeLayer()
    mask.path = endPath
    
    animation = CABasicAnimation(keyPath: "path")
    animation.fromValue = startPath
    animation.toValue = endPath
    animation.delegate = AnimationDelegate {
      layer.mask = nil
      self.completion?()
      self.animation.delegate = nil
    }
  }
  
  func start() {
    layer.mask = mask
    mask.frame = layer.bounds
    mask.add(animation, forKey: "reveal")
  }
}
class AnimationDelegate: NSObject, CAAnimationDelegate {
  
  fileprivate let completion: () -> Void
  
  init(completion: @escaping () -> Void) {
    self.completion = completion
  }
  
  dynamic func animationDidStop(_: CAAnimation, finished: Bool) {
    completion()
  }
}
