//
//  _RRPushAnimator.m
//  RRNavigationTransitioning
//
//  Created by Shaw <cuzval@gmail.com> on 10/16/18.
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
        [transitionContext cancelInteractiveTransition];
        [transitionContext completeTransition:NO];
        return;
    }

    UIView *containerView = transitionContext.containerView;
    containerView.userInteractionEnabled = NO;
    [containerView addSubview:toVC.view];
    [toVC.view layoutIfNeeded];
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
                         containerView.userInteractionEnabled = YES;
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
