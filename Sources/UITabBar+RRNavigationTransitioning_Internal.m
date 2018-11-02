//
//  UITabBar+RRNavigationTransitioning_Internal.m
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
