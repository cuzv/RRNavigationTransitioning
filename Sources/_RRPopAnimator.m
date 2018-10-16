//
//  _RRPopAnimator.m
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/16/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "_RRPopAnimator.h"

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
    
    [toVC.view layoutIfNeeded];
    UIView *containerView = transitionContext.containerView;
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGFloat offset = containerView.frame.size.width;
                         fromVC.view.frame = CGRectOffset(containerView.bounds, self.fromRight ? -offset : offset, 0);
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

@end
