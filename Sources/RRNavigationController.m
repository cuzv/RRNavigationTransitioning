//
//  RRNavigationTransitioning.m
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/16/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "RRNavigationController.h"
#import "RRNavigationTransition.h"

@interface RRNavigationController () <UINavigationControllerDelegate>
@property (nonatomic, strong) RRNavigationTransition *rrTransition;
@end

@implementation RRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self.rrTransition;
}

- (RRNavigationTransition *)rrTransition {
    if (!_rrTransition) {
        _rrTransition = [[RRNavigationTransition alloc] initWithNavigationController:self];
    }
    return _rrTransition;
}

@end
