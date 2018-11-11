//
//  RRNavigationTransition.m
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

#import "RRNavigationTransition.h"
#import "_RRPushAnimator.h"
#import "_RRPopAnimator.h"
#import "UIViewController+RRNavigationTransitioning.h"

@interface RRNavigationTransition()

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *leftEdgePanGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *rightEdgePanGesture;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) BOOL popFromRightEdge;

@end

@implementation RRNavigationTransition

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _navigationController = navigationController;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController.view addGestureRecognizer:self.leftEdgePanGesture];
    [self.navigationController.view addGestureRecognizer:self.rightEdgePanGesture];

    return self;
}

- (void)handleEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)sender {
    NSAssert(nil != sender.view, @"UIScreenEdgePanGestureRecognizer must attach to a responser view.");
    
    if (!self.navigationController.topViewController.rr_interactivePopEnabled) {
        return;
    }
    
    self.popFromRightEdge = sender.edges == UIRectEdgeRight;
    
    CGPoint translate = [sender translationInView:sender.view];
    CGFloat percent = translate.x / sender.view.bounds.size.width;
    if (self.popFromRightEdge) {
        percent *= -1;
    }
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            if (!self.interactiveTransition && self.navigationController.viewControllers.count > 1) {
                self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
                self.interactiveTransition.completionCurve = UIViewAnimationCurveEaseOut;
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        case UIGestureRecognizerStateChanged:
            [self.interactiveTransition updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateCancelled:
            [self.interactiveTransition cancelInteractiveTransition];
            self.interactiveTransition = nil;
            break;
        case UIGestureRecognizerStateEnded: {
            CGFloat velocity = [sender velocityInView:sender.view].x;
            if (self.popFromRightEdge) {
                velocity *= -1;
            }

            if (percent > 0.5 || velocity > 250) {
                [self.interactiveTransition updateInteractiveTransition:1.0];
                [self.interactiveTransition finishInteractiveTransition];
            } else {
                [self.interactiveTransition updateInteractiveTransition:0.0];
                [self.interactiveTransition cancelInteractiveTransition];
            }
            self.interactiveTransition = nil;
        }
            break;
        default:
            break;
    }
}

// MARK: - UINavigationControllerDelegate

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.interactiveTransition;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return [_RRPushAnimator new];
    }
    if (operation == UINavigationControllerOperationPop) {
        _RRPopAnimator *one = [_RRPopAnimator new];
        one.interactive = nil != self.interactiveTransition;
        one.fromRight = one.interactive && self.popFromRightEdge;
        return one;
    }
    return nil;
}

// MARK: -

- (UIScreenEdgePanGestureRecognizer *)leftEdgePanGesture {
    if (!_leftEdgePanGesture) {
        _leftEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanGesture:)];
        _leftEdgePanGesture.edges = UIRectEdgeLeft;
        _leftEdgePanGesture.maximumNumberOfTouches = 1;
    }
    return _leftEdgePanGesture;
}

- (UIScreenEdgePanGestureRecognizer *)rightEdgePanGesture {
    if (!_rightEdgePanGesture) {
        _rightEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanGesture:)];
        _rightEdgePanGesture.edges = UIRectEdgeRight;
        _rightEdgePanGesture.maximumNumberOfTouches = 1;
    }
    return _rightEdgePanGesture;
}

@end
