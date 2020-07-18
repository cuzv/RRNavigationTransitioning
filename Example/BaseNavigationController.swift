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

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        viewControllers.lazy.forEach(suppressGestureRecognizerInterference(from:))
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        suppressGestureRecognizerInterference(from: viewController)
    }

    override func show(_ vc: UIViewController, sender: Any?) {
        super.show(vc, sender: sender)
        suppressGestureRecognizerInterference(from: vc)
    }

    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        super.showDetailViewController(vc, sender: sender)
        suppressGestureRecognizerInterference(from: vc)
    }
    
    private func suppressGestureRecognizerInterference(from vc: UIViewController) {
        vc.view.subviews.lazy.compactMap({ $0 as? UIScrollView }).map({ $0.panGestureRecognizer }).forEach(rrTransition.suppressGestureRecognizerInterference(from:))
    }
}

class _NavigationTransition: RRNavigationTransition {
}
