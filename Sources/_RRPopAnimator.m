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

extern UIViewAnimationOptions const _RRViewAnimationOptionCurveKeyboard;

@implementation _RRPopAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!fromVC || !toVC) {
        [transitionContext cancelInteractiveTransition];
        [transitionContext completeTransition:NO];
        return;
    }
    
    fromVC.view.layer.shadowColor = [UIColor.blackColor colorWithAlphaComponent:0.5].CGColor;
    fromVC.view.layer.shadowOpacity = 1.0f;
    fromVC.view.layer.shadowOffset = CGSizeMake(0, 0);
    fromVC.view.layer.shadowRadius = 4.0f;
    fromVC.view.layer.masksToBounds = NO;
    fromVC.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(fromVC.view.bounds, 0, 4)].CGPath;
    
    UIView *containerView = transitionContext.containerView;
    containerView.userInteractionEnabled = NO;
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [toVC.view layoutIfNeeded];
    
    UITabBarController *tabBarController = toVC.tabBarController;
    UITabBar *tabBar = tabBarController.tabBar;
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
    UIViewAnimationOptions options = (self.interactive ? UIViewAnimationOptionCurveLinear : _RRViewAnimationOptionCurveKeyboard) | UIViewAnimationOptionBeginFromCurrentState;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:options
                     animations:^{
                         fromVC.view.transform = CGAffineTransformMakeTranslation(offset, 0);
                     } completion:^(BOOL finished) {
                         containerView.userInteractionEnabled = YES;
                         if ([containerView.subviews containsObject:tabBar]) {
                             [tabBarController.view addSubview:tabBar];
                         }
                         
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

@end
