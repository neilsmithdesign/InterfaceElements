//
//  FadeTransitionController.swift
//  
//
//  Created by Neil Smith on 29/10/2019.
//

import UIKit

public final class FadeTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    
    // MARK: Transition
    private var transition: FadeTransition
    
    
    // MARK: Interface
    public func set(duration: TimeInterval) {
        self.transition.duration = duration
    }
    
    public init(duration: TimeInterval) {
        self.transition = FadeTransition(duration: duration)
        super.init()
    }
    
    
    // MARK: UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
}


