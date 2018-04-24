//
//  MotionAnimator.swift
//  IBAnimatable
//
//  Created by phimage on 22/04/2018.
//  Copyright © 2018 IBAnimatable. All rights reserved.
//

import UIKit

public class MotionAnimator: NSObject, AnimatedTransitioning {

  // MARK: - AnimatedTransitioning
  public var transitionAnimationType: TransitionAnimationType = .motion
  public var transitionDuration: Duration = defaultTransitionDuration
  public var reverseAnimationType: TransitionAnimationType? = .motion
  public var interactiveGestureType: InteractiveGestureType?
  
  // MARK: - private
  //fileprivate var fromDirection: TransitionAnimationType.Direction
  
  public init( duration: Duration) {
    transitionDuration = duration
    //fromDirection = direction
    
    super.init()
  }
}

extension MotionAnimator {
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return retrieveTransitionDuration(transitionContext: transitionContext)
  }
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
   /* let (tempfromView, tempToView, tempContainerView) = retrieveViews(transitionContext: transitionContext)
    guard let fromView = tempfromView, let toView = tempToView, let containerView = tempContainerView else {
      transitionContext.completeTransition(true)
      return
    }
    
    if fromDirection == .forward {
      executeForwardAnimation(transitionContext: transitionContext, containerView: containerView, fromView: fromView, toView: toView)
    } else {
      executeBackwardAnimation(transitionContext: transitionContext, containerView: containerView, fromView: fromView, toView: toView)
    }*/
  }
}


