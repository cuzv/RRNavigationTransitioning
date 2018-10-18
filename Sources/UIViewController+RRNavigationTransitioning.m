//
//  UIViewController+RRNavigationTransitioning.m
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/18/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "UIViewController+RRNavigationTransitioning.h"
#import <objc/runtime.h>

@implementation UIViewController (RRNavigationTransitioning)

- (BOOL)rr_interactivePopEnabled {
    return ![objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRr_interactivePopEnabled:(BOOL)rr_interactivePopEnabled {
    objc_setAssociatedObject(self, @selector(rr_interactivePopEnabled), @(!rr_interactivePopEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
