//
//  _RRPushAnimator.m
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/16/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "_RRPushAnimator.h"

@implementation _RRPushAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!toVC) {
        return;
    }
    
    [toVC.view layoutIfNeeded];
    UIView *containerView = transitionContext.containerView;
    toVC.view.frame = CGRectOffset(containerView.bounds, containerView.frame.size.width, 0);
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:7 << 16 | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         toVC.view.frame = containerView.bounds;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

@end
