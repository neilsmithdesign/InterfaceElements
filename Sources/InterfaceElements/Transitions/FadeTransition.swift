//
//  FadeTransition.swift
//  
//
//  Created by Neil Smith on 29/10/2019.
//

import UIKit

public final class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    // MARK: Interface
    public var duration: TimeInterval
    public var isPresenting: Bool = true
    public init(duration: TimeInterval = 0.5) {
        self.duration = duration
        super.init()
    }
    
    
    // MARK: UIViewControllerAnimatedTransitioning
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let viewToAnimate = isPresenting ?
            transitionContext.view(forKey: .to)! :
            transitionContext.view(forKey: .from)!
        
        containerView.addSubview(viewToAnimate)
        viewToAnimate.alpha = isPresenting ? 0.0 : 1.0
        
        UIView.animate(withDuration: duration, animations: {
            viewToAnimate.alpha = self.isPresenting ? 1.0 : 0.0
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
}


