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
#ifdef __IPHONE_2_0
        if (@available(iOS 2.0, *)) {
            Class clazz = self.class;
            SEL originalSelector = @selector(setFrame:);
            Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
            if (originalMethod) {
                IMP originalImpl = method_getImplementation(originalMethod);
                id block = ^(UITabBar *receiver, CGRect frame) {
                    if ([receiver isKindOfClass:clazz]) {
                        if (receiver._rr_inTransition)
                            return;
                    }
                    
                    // Invoke original impl.
                    ((void (*)(id, SEL, CGRect))originalImpl)(receiver, originalSelector, frame);
                };
                IMP overrideImpl = imp_implementationWithBlock(block);
                method_setImplementation(originalMethod, overrideImpl);
            }
        }
#endif
        
#ifdef __IPHONE_12_1
        // See: https://github.com/QMUI/QMUI_iOS/issues/410#issuecomment-432574291
        if (@available(iOS 12.1, *)) {
            Class clazz = NSClassFromString(@"UITabBarButton");
            if (!clazz) return;
            SEL originalSelector = @selector(setFrame:);
            Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
            if (originalMethod) {
                IMP originalImpl = method_getImplementation(originalMethod);
                id block = ^(UIView *receiver, CGRect frame) {
                    if ([receiver isKindOfClass:clazz]) {
                        if (!CGRectIsEmpty(receiver.frame) && CGRectIsEmpty(frame)) {
                            return;
                        }
                    }
                    
                    // Invoke original impl.
                    ((void (*)(id, SEL, CGRect))originalImpl)(receiver, originalSelector, frame);
                };
                IMP overrideImpl = imp_implementationWithBlock(block);
                method_setImplementation(originalMethod, overrideImpl);
            }
        }
#endif
    });
}

- (BOOL)_rr_inTransition {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)set_rr_inTransition:(BOOL)_rr_inTransition {
    objc_setAssociatedObject(self, @selector(_rr_inTransition), @(_rr_inTransition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
