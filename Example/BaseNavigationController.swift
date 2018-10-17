//
//  BaseNavigationController.swift
//  Example
//
//  Created by Shaw on 10/17/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

import UIKit
import RRNavigationTransitioning

class BaseNavigationController: UINavigationController {
    private lazy var rrTransition: RRNavigationTransition = {
       return _NavigationTransition(navigationController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = rrTransition
    }
}

class _NavigationTransition: RRNavigationTransition {
}
