//
//  UITabBar+RRNavigationTransitioning_Internal.m
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/17/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "UITabBar+RRNavigationTransitioning_Internal.h"
#import <objc/runtime.h>

@implementation UITabBar (RRNavigationTransitioning_Internal)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clazz = self.class;
        SEL originalSelector = @selector(setFrame:);
        SEL overrideSelector = @selector(_rr_setFrame:);
        Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
        Method overrideMethod = class_getInstanceMethod(clazz, overrideSelector);
        if (class_addMethod(clazz, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
            class_replaceMethod(clazz, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, overrideMethod);
        }
    });
}

- (void)_rr_setFrame:(CGRect)frame {
    if (self._rr_pushing) {
        return;
    }
    [self _rr_setFrame:frame];
}

- (BOOL)_rr_pushing {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)set_rr_pushing:(BOOL)_rr_pushing {
    objc_setAssociatedObject(self, @selector(_rr_pushing), @(_rr_pushing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
