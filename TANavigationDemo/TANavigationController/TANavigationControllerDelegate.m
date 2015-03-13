//
//  TANavigationControllerDelegate.m
//
//  Created by 李小盆 on 14/11/21.
//  Copyright (c) 2014年 ___LOTTO___. All rights reserved.
//

#import "TANavigationControllerDelegate.h"
#import "TAAnimator.h"
#import "TAPanGestureRecognizer.h"
#import "UIViewController+NavigationbarAlpha.h"
#import "TANavigationController.h"

@interface TANavigationControllerDelegate()
{
    CGFloat _currentNavbarAlpha;
    CGFloat _previousNavbarAlpha;
}
@property (weak, nonatomic) TANavigationController *navigationController;
@property (strong, nonatomic) TAAnimator *animator;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
@property (nonatomic) BOOL duringAnimation; //动画是否正在进行
@property (weak, readonly, nonatomic) TAPanGestureRecognizer *panRecognizer;
@property(weak, nonatomic) UIViewController *currentViewController; // 当前控制器
@property(weak, nonatomic) UIViewController *previousViewController;//上一控制器
@end

@implementation TANavigationControllerDelegate

- (void)dealloc
{
    [_panRecognizer removeTarget:self action:@selector(pan:)];
    [_navigationController.view removeGestureRecognizer:_panRecognizer];
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    NSCParameterAssert(!!navigationController);
    self = [super init];
    if (self) {
        self.navigationController.navigationBar.translucent = YES;
        _navigationController = navigationController;
        TAPanGestureRecognizer *panRecognizer = [[TAPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        panRecognizer.maximumNumberOfTouches = 1;
        [_navigationController.view addGestureRecognizer:panRecognizer];
        _panRecognizer = panRecognizer;
        
        _animator = [[TAAnimator alloc] init];
    }
    
    return self;
}

#pragma mark - UIPanGestureRecognizer
- (void)pan:(TAPanGestureRecognizer*)recognizer
{
    UIView *view = self.navigationController.view;
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if (self.navigationController.viewControllers.count > 1 && !_duringAnimation) {
            NSUInteger nControllers = self.navigationController.viewControllers.count;
            _currentViewController = self.navigationController.visibleViewController;
            _previousViewController = self.navigationController.viewControllers[nControllers - 2];
            _currentNavbarAlpha = _currentViewController.navigationBarAlpha;
            _previousNavbarAlpha = _previousViewController.navigationBarAlpha;
            self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
            self.interactionController.completionCurve = UIViewAnimationCurveEaseIn;
            if (recognizer.direction == TAPanDirectionRight) {
                [self.navigationController popViewControllerNormalAnimated:YES];
            }
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        if (!_duringAnimation) {
            return;
        }
        CGPoint translation = [recognizer translationInView:view];
        CGFloat distancePercent = translation.x > 0 ? translation.x / CGRectGetWidth(view.bounds) : 0;
        [self.interactionController updateInteractiveTransition:distancePercent];
        if (_currentNavbarAlpha > _previousNavbarAlpha) {
            self.navigationController.navigationBar.alpha = (1 - distancePercent)*(_currentNavbarAlpha - _previousNavbarAlpha);
        }
        else if (_currentNavbarAlpha < _previousNavbarAlpha)
        {
            self.navigationController.navigationBar.alpha = distancePercent*(_previousNavbarAlpha - _currentNavbarAlpha);
        }
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (!_duringAnimation) {
            return;
        }
        CGPoint translationInView = [recognizer translationInView:self.navigationController.topViewController.view];
        CGFloat translationThreshold = self.navigationController.topViewController.view.frame.size.width / 3;
        //判断方向是否向右并且移动幅度超过1/3个屏幕或者滑动速度大于80
        if (recognizer.horizontalDirection == TAPanDirectionRight &&
            (translationInView.x > translationThreshold  || [recognizer velocityInView:view].x > 80))
        {
            [self.interactionController finishInteractiveTransition];
            [UIView animateWithDuration:0.15 animations:^{
                self.navigationController.navigationBar.alpha = _previousNavbarAlpha;
            }];

        }
        else {
            [self.interactionController cancelInteractiveTransition];
            self.duringAnimation = NO;
            [UIView animateWithDuration:0.15 animations:^{
                self.navigationController.navigationBar.alpha = _currentNavbarAlpha;
            }];
        }
            self.interactionController = nil;
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return self.animator;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactionController;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (animated) {
        self.duringAnimation = YES;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.duringAnimation = NO;
    
    if (navigationController.viewControllers.count <= 1) {
        self.panRecognizer.enabled = NO;
    }
    else {
        self.panRecognizer.enabled = YES;
    }
}

@end
