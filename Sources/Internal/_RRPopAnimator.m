//
//  _RRPopAnimator.m
//  RRNavigationTransitioning
//
//  Created by Shaw <cuzval@gmail.com> on 10/17/18.
//  Copyright (c) 2018 RedRain.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "_RRPopAnimator.h"
#import "UITabBar+RRNavigationTransitioning_Internal.h"

extern UIViewAnimationOptions const _RRViewAnimationOptionCurveKeyboard;

@implementation _RRPopAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    if (!(fromVC && fromView && toVC && toView)) {
        [transitionContext completeTransition:NO];
        return;
    }
    
    fromView.layer.shadowColor = [UIColor.blackColor colorWithAlphaComponent:0.5].CGColor;
    fromView.layer.shadowOpacity = 1.0f;
    fromView.layer.shadowOffset = CGSizeMake(0, 0);
    fromView.layer.shadowRadius = 4.0f;
    fromView.layer.masksToBounds = NO;
    fromView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(fromView.bounds, 0, 4)].CGPath;
    
    UIView *containerView = transitionContext.containerView;
    [containerView insertSubview:toView belowSubview:fromView];
    [toView layoutIfNeeded];
    
    UITabBarController *tabBarController = toVC.tabBarController;
    UITabBar *tabBar = tabBarController.tabBar;
    if (tabBar && fromVC.hidesBottomBarWhenPushed && !toVC.hidesBottomBarWhenPushed) {
        CGRect newRect = tabBar.frame;
        newRect.origin.x = toView.frame.origin.x;
        tabBar.frame = newRect;
        [containerView insertSubview:tabBar belowSubview:fromView];
        tabBar._rr_inTransition = YES;
    }
    
    CGFloat offset = containerView.frame.size.width;
    if (self.fromRight) {
        offset *= -1;
    }

    UIViewAnimationOptions options = (self.interactive ? UIViewAnimationOptionCurveLinear : _RRViewAnimationOptionCurveKeyboard) | UIViewAnimationOptionBeginFromCurrentState;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:options
                     animations:^{
                         fromView.transform = CGAffineTransformMakeTranslation(offset, 0);
                     } completion:^(BOOL finished) {
                         if ([containerView.subviews containsObject:tabBar]) {
                             [tabBarController.view addSubview:tabBar];
                         }

                         if (tabBar._rr_inTransition) {
                             tabBar._rr_inTransition = NO;
                         }

                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

@end
