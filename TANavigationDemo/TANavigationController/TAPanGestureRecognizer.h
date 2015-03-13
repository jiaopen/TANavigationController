// TAPanGestureRecognizer.h
//  triphare
//
//  Created by 李小盆 on 14/11/15.
//  Copyright (c) 2014年 ___LOTTO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <UIKit/UIKit.h>

typedef enum {
  TAPanDirectionRight,
  TAPanDirectionLeft,
  TAPanDirectionUp,
  TAPanDirectionDown
} TAPanDirection;

typedef enum {
  TAPanWayNone,
  TAPanWayHorizontal,
  TAPanWayVertical
} TAPanWay;


@interface TAPanGestureRecognizer : UIPanGestureRecognizer <UIGestureRecognizerDelegate>

@property (nonatomic, readonly) TAPanWay way;
@property (nonatomic, readonly) TAPanDirection direction;
@property (nonatomic, readonly) TAPanDirection horizontalDirection;
@property (nonatomic, readonly) TAPanDirection verticalDirection;

@end