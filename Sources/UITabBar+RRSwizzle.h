//
//  UITabBar+RRSwizzle.h
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/17/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (RRSwizzle)
@property (nonatomic, assign) BOOL _rr_pushing;
@end

NS_ASSUME_NONNULL_END
