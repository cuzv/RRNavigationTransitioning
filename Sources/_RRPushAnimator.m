//
//  _RRPushAnimator.m
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/16/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "_RRPushAnimator.h"
#import "UITabBar+RRNavigationTransitioning_Internal.h"

UIViewAnimationOptions const  _RRViewAnimationOptionCurveKeyboard = 7 << 16;

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
    
    UITabBarController *tabBarController = fromVC.tabBarController;
    UITabBar *tabBar = tabBarController.tabBar;
    if (tabBar && !fromVC.hidesBottomBarWhenPushed && toVC.hidesBottomBarWhenPushed) {
        [containerView insertSubview:tabBar belowSubview:toVC.view];
        tabBar._rr_pushing = YES;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:_RRViewAnimationOptionCurveKeyboard | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         toVC.view.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         if ([containerView.subviews containsObject:tabBar]) {
                             [tabBarController.view addSubview:tabBar];
                         }
                         if (tabBar._rr_pushing) {
                             tabBar._rr_pushing = NO;
                         }
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

@end
