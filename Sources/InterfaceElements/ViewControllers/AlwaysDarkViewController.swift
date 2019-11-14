//
//  AlwaysDarkViewController.swift
//  
//
//  Created by Neil Smith on 14/11/2019.
//

import UIKit

public class AlwaysDarkViewController: UIViewController {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.overrideUserInterfaceStyle = .dark
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.overrideUserInterfaceStyle = .dark
    }
    
}
