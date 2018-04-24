//
//  Created by Tom Baranes on 25/07/16.
//  Copyright © 2016 Jake Lin. All rights reserved.
//

import UIKit

public protocol ViewControllerAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
  /**
   Transition duration
   */
  var transitionDuration: Duration { get set }

}

public extension ViewControllerAnimatedTransitioning {
  public func retrieveViews(transitionContext: UIViewControllerContextTransitioning) -> (UIView?, UIView?, UIView?) {
    return (transitionContext.view(forKey: .from),
            transitionContext.view(forKey: .to),
            transitionContext.containerView)
  }

  public func retrieveViewControllers(transitionContext: UIViewControllerContextTransitioning) -> (UIViewController?, UIViewController?, UIView?) {
    return (transitionContext.viewController(forKey: .from),
            transitionContext.viewController(forKey: .to),
            transitionContext.containerView)
  }

  public func retrieveTransitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    if let transitionContext = transitionContext {
      return transitionContext.isAnimated ? transitionDuration : 0
    }
    return 0
  }
}
