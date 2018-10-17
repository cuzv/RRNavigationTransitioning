//
//  _RRPushAnimator.m
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/16/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "_RRPushAnimator.h"

UIViewAnimationOptions const  _RRViewAnimationOptionCurvekeyboard = 7 << 16;

@implementation _RRPushAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!fromVC || !toVC) {
        return;
    }

    [toVC.view layoutIfNeeded];
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:toVC.view];
    toVC.view.transform = CGAffineTransformMakeTranslation(containerView.bounds.size.width, 0);
    
    UITabBar *tabBar = toVC.tabBarController.tabBar;
    if (tabBar && !fromVC.hidesBottomBarWhenPushed && toVC.hidesBottomBarWhenPushed) {
//        [containerView insertSubview:tabBar belowSubview:toVC.view];
        // FIXME:
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:_RRViewAnimationOptionCurvekeyboard | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         toVC.view.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

@end
