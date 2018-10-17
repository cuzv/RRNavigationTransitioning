//
//  _RRPopAnimator.m
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/16/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "_RRPopAnimator.h"

extern UIViewAnimationOptions const _RRViewAnimationOptionCurvekeyboard;

@implementation _RRPopAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!fromVC || !toVC) {
        return;
    }
    
    fromVC.view.layer.shadowColor = [UIColor.blackColor colorWithAlphaComponent:0.5].CGColor;
    fromVC.view.layer.shadowOpacity = 1.0f;
    fromVC.view.layer.shadowOffset = CGSizeMake(0, 0);
    fromVC.view.layer.shadowRadius = 4.0f;
    fromVC.view.layer.masksToBounds = NO;
    fromVC.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(fromVC.view.bounds, 0, 4)].CGPath;
    
    [toVC.view layoutIfNeeded];
    UIView *containerView = transitionContext.containerView;
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    UITabBar *tabBar = toVC.tabBarController.tabBar;
    if (tabBar && fromVC.hidesBottomBarWhenPushed && !toVC.hidesBottomBarWhenPushed) {
        CGRect newRect = tabBar.frame;
        newRect.origin.x = toVC.view.frame.origin.x;
        tabBar.frame = newRect;
        [containerView insertSubview:tabBar belowSubview:fromVC.view];
    }
    
    CGFloat offset = containerView.frame.size.width;
    if (self.fromRight) {
        offset *= -1;
    }
    UIViewAnimationOptions options = (self.interactive ? UIViewAnimationOptionCurveLinear : _RRViewAnimationOptionCurvekeyboard) | UIViewAnimationOptionBeginFromCurrentState;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:options
                     animations:^{
                         fromVC.view.transform = CGAffineTransformMakeTranslation(offset, 0);
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

@end
