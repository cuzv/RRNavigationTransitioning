//
//  RRTabBar.m
//  RRNavigationTransitioning
//
//  Created by Shaw on 10/17/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

#import "RRTabBar.h"

@implementation RRTabBar

- (void)setFrame:(CGRect)frame {
    if (frame.origin.x < 0) {
        return;
    }
    
    [super setFrame:frame];
    NSLog(@"%@", NSStringFromCGRect(frame));
}


@end
