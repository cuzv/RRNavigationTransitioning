//
//  UIViewController+RRNavigationTransitioning.h
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/18/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (RRNavigationTransitioning)
/// Default value is true. Toggle this value to ignore/response interactive pop transition request.
@property (nonatomic, assign) IBInspectable BOOL rr_interactivePopEnabled;
@end

NS_ASSUME_NONNULL_END
