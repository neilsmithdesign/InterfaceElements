//
//  AlwaysLightViewController.swift
//  
//
//  Created by Neil Smith on 14/11/2019.
//

import UIKit

open class AlwaysLightViewController: UIViewController {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.overrideUserInterfaceStyle = .light
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.overrideUserInterfaceStyle = .light
    }
    
}

