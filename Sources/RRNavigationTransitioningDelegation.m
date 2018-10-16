//
//  RRNavigationTransitioningDelegation.m
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/17/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "RRNavigationTransitioningDelegation.h"
#import "_RRPushAnimator.h"
#import "_RRPopAnimator.h"

@interface RRNavigationTransitioningDelegation()
@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *leftEdgePanGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *rightEdgePanGesture;
@property (nonatomic, retain) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) BOOL popFromRightEdge;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation RRNavigationTransitioningDelegation

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.navigationController = navigationController;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController.view addGestureRecognizer:self.leftEdgePanGesture];
    [self.navigationController.view addGestureRecognizer:self.rightEdgePanGesture];

    return self;
}

- (void)handleEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)sender {
    NSAssert(nil != sender.view, @"UIScreenEdgePanGestureRecognizer must attach to a responser view.");
    
    self.popFromRightEdge = sender.edges == UIRectEdgeRight;
    
    CGPoint translate = [sender translationInView:sender.view];
    CGFloat percent = fabs(translate.x / sender.view.bounds.size.width);
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            if (!self.interactiveTransition && self.navigationController.viewControllers.count > 0) {
                self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
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
            CGPoint velocity = [sender velocityInView:sender.view];
            if (percent > 0.5 || (self.popFromRightEdge && velocity.x < -300) || (!self.popFromRightEdge && velocity.x > 300)) {
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
        one.fromRight = self.popFromRightEdge;
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
