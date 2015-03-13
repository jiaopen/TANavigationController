//
//  TAAnimator.m
//
//  Created by 李小盆 on 14/11/21.
//  Copyright (c) 2014年 ___LOTTO___. All rights reserved.
//

#import "TAAnimator.h"

UIViewAnimationOptions const TANavigationTransitionCurve = 7 << 16;


@implementation UIView (TransitionShadow)
/**
 *  左边缘部分增加阴影
 */
- (void)addLeftSideShadowWithFading
{
    CGFloat shadowWidth = 2.0f;
    CGFloat shadowVerticalPadding = -20.0f;
    CGFloat shadowHeight = CGRectGetHeight(self.frame) - 2 * shadowVerticalPadding;
    CGRect shadowRect = CGRectMake(-shadowWidth, shadowVerticalPadding, shadowWidth, shadowHeight);

    self.layer.masksToBounds = NO;
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.6;

    if (self.layer.shadowPath == NULL) {
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
    }
    else{
        CGRect currentPath = CGPathGetPathBoundingBox(self.layer.shadowPath);
        if (CGRectEqualToRect(currentPath, self.bounds) == NO){
            self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
        }
    }
}
@end


@interface TAAnimator()
@property (weak, nonatomic) UIViewController *toViewController;
@end

@implementation TAAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isInteractive] ? 0.25f : 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];

    CGFloat toViewControllerXTranslation = - CGRectGetWidth([transitionContext containerView].bounds) * 0.3f;
    toViewController.view.transform = CGAffineTransformMakeTranslation(toViewControllerXTranslation, 0);

    [fromViewController.view addLeftSideShadowWithFading];
    BOOL previousClipsToBounds = fromViewController.view.clipsToBounds;
    fromViewController.view.clipsToBounds = NO;

    UIView *dimmingView = [[UIView alloc] initWithFrame:toViewController.view.bounds];
    dimmingView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    [toViewController.view addSubview:dimmingView];

    UIViewAnimationOptions curveOption = [transitionContext isInteractive] ? UIViewAnimationOptionCurveLinear : TANavigationTransitionCurve;

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionTransitionNone | curveOption animations:^{
        toViewController.view.transform = CGAffineTransformIdentity;
        fromViewController.view.transform = CGAffineTransformMakeTranslation(toViewController.view.frame.size.width, 0);
        dimmingView.alpha = 0.0f;

    } completion:^(BOOL finished) {
        [dimmingView removeFromSuperview];
        fromViewController.view.transform = CGAffineTransformIdentity;
        fromViewController.view.clipsToBounds = previousClipsToBounds;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];

    }];

    self.toViewController = toViewController;
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    if (!transitionCompleted) {
        self.toViewController.view.transform = CGAffineTransformIdentity;
    }
}

@end
