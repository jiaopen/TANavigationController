// TAPanGestureRecognizer.m
//  triphare
//
//  Created by 李小盆 on 14/11/15.
//  Copyright (c) 2014年 ___LOTTO___. All rights reserved.
//

#import "TAPanGestureRecognizer.h"

@implementation TAPanGestureRecognizer

- (TAPanDirection)direction
{
  CGPoint velocity = [self velocityInView:self.view.window];

    if (fabs(velocity.y) > fabs(velocity.x))
    {
        if (velocity.y > 0)
        {
            return TAPanDirectionDown;
        }
        else
        {
            return TAPanDirectionUp;
        }
    }
    else
    {
        if (velocity.x > 0)
        {
            return TAPanDirectionRight;
        }
        else {
            return TAPanDirectionLeft;
        }
    }
}

- (TAPanDirection)horizontalDirection
{
    CGPoint velocity = [self velocityInView:self.view.window];
    if (velocity.x > 0) {
        return TAPanDirectionRight;
    }
    else {
        return TAPanDirectionLeft;
    }
}

- (TAPanDirection)verticalDirection
{
    CGPoint velocity = [self velocityInView:self.view.window];
    if (velocity.y > 0) {
        return TAPanDirectionDown;
    }
    else {
        return TAPanDirectionUp;
    }
}

- (TAPanWay)way
{
  CGPoint velocity = [self velocityInView:self.view.window];
  if (fabs(velocity.y) > fabs(velocity.x)) {
    return TAPanWayVertical;
  }
  else {
    return TAPanWayHorizontal;
  }
}

@end
