//
//  RRNavigationTransitioning.m
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/16/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "RRNavigationController.h"
#import "RRNavigationTransitioningDelegation.h"

@interface RRNavigationController () <UINavigationControllerDelegate>
@property (nonatomic, strong) RRNavigationTransitioningDelegation *rrDelegate;
@end

@implementation RRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self.rrDelegate;
}

- (RRNavigationTransitioningDelegation *)rrDelegate {
    if (!_rrDelegate) {
        _rrDelegate = [[RRNavigationTransitioningDelegation alloc] initWithNavigationController:self];
    }
    return _rrDelegate;
}

@end
