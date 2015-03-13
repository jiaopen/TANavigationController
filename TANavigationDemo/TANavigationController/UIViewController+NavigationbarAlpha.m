//
//  UIViewController+NavigationbarAlpha.m
//  NavigationTransitionTest
//
//  Created by 李小盆 on 14/11/22.
//  Copyright (c) 2014年 ___LOTTO___. All rights reserved.
//

#import "UIViewController+NavigationbarAlpha.h"
#import <objc/runtime.h>

static const char *assoKeyNavigationbarAlpha="__aknba";

@implementation UIViewController (NavigationbarAlpha)

-(CGFloat)navigationBarAlpha{
    NSNumber *navigationBarAlphaNumber = objc_getAssociatedObject(self, assoKeyNavigationbarAlpha);
    if (navigationBarAlphaNumber) {
        return [navigationBarAlphaNumber floatValue];
    }
    return 1.f;
}

-(void) setNavigationBarAlpha:(CGFloat)navigationBarAlpha
{
    NSNumber *navigationBarAlphaNumber = [NSNumber numberWithFloat:navigationBarAlpha];
    objc_setAssociatedObject(self, assoKeyNavigationbarAlpha, navigationBarAlphaNumber, OBJC_ASSOCIATION_RETAIN);
    self.navigationController.navigationBar.alpha = navigationBarAlpha;
}

@end
