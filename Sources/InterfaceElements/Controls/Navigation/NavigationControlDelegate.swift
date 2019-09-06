//
//  NavigationControlDelegate.swift
//  
//
//  Created by Neil Smith on 26/08/2019.
//

import Foundation

public protocol NavigationControlDelegate: AnyObject {
    func navigationControl(_ navigationControl: NavigationControl, titleForButtonAt position: NavigationControl.ButtonPosition) -> String?
    func navigationControl(_ navigationControl: NavigationControl, stateForButtonAt position: NavigationControl.ButtonPosition) -> NavigationControl.ButtonState?
    func navigationControl(_ navigationControl: NavigationControl, didTapButtonAt position: NavigationControl.ButtonPosition)
}
