//
//  TANavigationControllerDelegate.h
//
//  Created by 李小盆 on 14/11/21.
//  Copyright (c) 2014年 ___LOTTO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  实现自定义页面跳转动画和手势
 */
@interface TANavigationControllerDelegate : NSObject <UINavigationControllerDelegate>


- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end
