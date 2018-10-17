//
//  RRNavigationTransition.m
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/17/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "RRNavigationTransition.h"
#import "_RRPushAnimator.h"
#import "_RRPopAnimator.h"

@interface RRNavigationTransition()

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *leftEdgePanGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *rightEdgePanGesture;
@property (nonatomic, retain) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) BOOL popFromRightEdge;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

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
                [self.interactiveTransition finishInteractiveTransition];
            } else {
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
