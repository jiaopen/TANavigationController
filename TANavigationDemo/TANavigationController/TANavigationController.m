//
//  TANavigationController.m
//  NavigationTransitionTest
//
//  Created by 李小盆 on 14/11/22.
//  Copyright (c) 2014年 ___LOTTO___. All rights reserved.
//

#import "TANavigationControllerDelegate.h"
#import "TANavigationController.h"
#import "UIViewController+NavigationbarAlpha.h"

static NSTimeInterval const kTransitionDuration = 0.3f;
static NSString* const kAnimationKey = @"animationKey";
static NSString* const kPopAnimationValue = @"popAnimation";
static NSString* const kPushAnimationValue = @"pushAnimation";

@interface TANavigationController ()
{
    CALayer *_rootLayer;
    CALayer *_currentLayer;
    CALayer *_nextLayer;
    CALayer *_previousLayer;
}
@property (strong, nonatomic) TANavigationControllerDelegate *navDelegate;

@end

@implementation TANavigationController

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    NSString* animationValue = [animation valueForKey:kAnimationKey];
    if ([animationValue isEqualToString:kPushAnimationValue]) {
        [_currentLayer removeFromSuperlayer];
        [_nextLayer removeFromSuperlayer];
        _previousLayer = _currentLayer;
        _currentLayer = nil;
        _nextLayer = nil;
    }
    else if([animationValue isEqualToString:kPopAnimationValue])
    {
        [_currentLayer removeFromSuperlayer];
        [_previousLayer removeFromSuperlayer];
        _previousLayer = nil;
        _nextLayer = nil;
        _currentLayer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navDelegate = [[TANavigationControllerDelegate alloc] initWithNavigationController:self];
    self.delegate = _navDelegate;
}

-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController* currentViewController = self.visibleViewController;
    if (currentViewController == nil || currentViewController.navigationBarAlpha == viewController.navigationBarAlpha)
    {
        self.delegate = nil;
        [super pushViewController:viewController animated:animated];
        self.delegate = _navDelegate;
    }
    else
    {
        [self pushViewControllerWithSnapshot:viewController];
    }
}

-(UIViewController*) popViewControllerAnimated:(BOOL)animated
{
    NSUInteger nControllers = self.viewControllers.count;
    UIViewController* previousViewController = self.viewControllers[nControllers - 2];
    UIViewController* currentViewController = self.visibleViewController;
    UIViewController* vc = nil;
    if (currentViewController.navigationBarAlpha == previousViewController.navigationBarAlpha)
    {
        self.delegate = nil;
        vc = [super popViewControllerAnimated:animated];
        self.delegate = _navDelegate;
    }
    else
    {
        vc = [self popViewControllerWithSnapshot];
    }
    
    return vc;
}

-(NSArray*) popToRootViewControllerAnimated:(BOOL)animated
{
    UIViewController* rootViewController = self.viewControllers[0];
    UIViewController* currentViewController = self.visibleViewController;
    NSArray* array = nil;
    UIViewController* vc = nil;
    if (currentViewController.navigationBarAlpha == rootViewController.navigationBarAlpha)
    {
        self.delegate = nil;
        array = [super popToRootViewControllerAnimated:animated];
        self.delegate = _navDelegate;
    }
    else
    {
        array = [self popToRootViewControllerWithSnapshot];
    }
    return array;
}

-(NSArray*) popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.delegate = nil;
    NSArray* array = [super popToViewController:viewController animated:animated];
    self.delegate = _navDelegate;
    return array;
}

-(UIViewController*) popViewControllerNormalAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}

- (void)pushViewControllerWithSnapshot:(UIViewController *)viewController
{
    if (_currentLayer == nil) {
        _currentLayer = [self layerSnapshotWithTransform:CATransform3DIdentity];
    }
    [super pushViewController:viewController animated:NO];
    _nextLayer = [self layerSnapshotWithTransform:CATransform3DIdentity];
    _nextLayer.frame = (CGRect){{CGRectGetWidth(self.view.bounds), CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    [self.view.layer addSublayer:_currentLayer];
    [self.view.layer addSublayer:_nextLayer];
    [CATransaction flush];
    [_nextLayer addAnimation:[self animationWithTranslation:-CGRectGetWidth(self.view.bounds)] forKey:nil];
    [_currentLayer addAnimation:[self animationWithPushTranslation:-CGRectGetWidth(self.view.bounds)/3] forKey:nil];
}

- (UIViewController*) popViewControllerWithSnapshot
{
    if (_currentLayer == nil) {
        _currentLayer = [self layerSnapshotWithTransform:CATransform3DIdentity];
    }
    
    if (_previousLayer == nil) {
        UIViewController* vc = [super popViewControllerAnimated:NO];
        _previousLayer = [self layerSnapshotWithTransform:CATransform3DIdentity];
        _previousLayer.frame = (CGRect){{-CGRectGetWidth(self.view.bounds)/3, CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
        [self.view.layer addSublayer:_previousLayer];
        [self.view.layer addSublayer:_currentLayer];
        [CATransaction flush];
        [_previousLayer addAnimation:[self animationWithTranslation:CGRectGetWidth(self.view.bounds)/3] forKey:nil];
        [_currentLayer addAnimation:[self animationWithPopTranslation:CGRectGetWidth(self.view.bounds)] forKey:nil];
        return vc;
    }
    else
    {
        _previousLayer.frame = (CGRect){{-CGRectGetWidth(self.view.bounds)/3, CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
        [self.view.layer addSublayer:_previousLayer];
        [self.view.layer addSublayer:_currentLayer];
        [CATransaction flush];
        [_previousLayer addAnimation:[self animationWithTranslation:CGRectGetWidth(self.view.bounds)/3] forKey:nil];
        [_currentLayer addAnimation:[self animationWithPopTranslation:CGRectGetWidth(self.view.bounds)] forKey:nil];
        UIViewController* vc = [super popViewControllerAnimated:NO];
        return vc;
    }
}

- (NSArray*) popToRootViewControllerWithSnapshot
{
    if (_currentLayer == nil) {
        _currentLayer = [self layerSnapshotWithTransform:CATransform3DIdentity];
    }
    
    NSArray* array = [super popToRootViewControllerAnimated:NO];
    _previousLayer = [self layerSnapshotWithTransform:CATransform3DIdentity];
    _previousLayer.frame = (CGRect){{-CGRectGetWidth(self.view.bounds)/3, CGRectGetMinY(self.view.bounds)}, self.view.bounds.size};
    [self.view.layer addSublayer:_previousLayer];
    [self.view.layer addSublayer:_currentLayer];
    [CATransaction flush];
    [_previousLayer addAnimation:[self animationWithTranslation:CGRectGetWidth(self.view.bounds)/3] forKey:nil];
    [_currentLayer addAnimation:[self animationWithPopTranslation:CGRectGetWidth(self.view.bounds)] forKey:nil];
    
    return array;
}

- (CABasicAnimation *)animationWithPopTranslation:(CGFloat)translation
{
    CABasicAnimation *animation = [self animationWithTranslation:translation];
    [animation setValue:kPopAnimationValue forKey:kAnimationKey];
    return animation;
}

- (CABasicAnimation *)animationWithPushTranslation:(CGFloat)translation
{
    CABasicAnimation *animation = [self animationWithTranslation:translation];
    [animation setValue:kPushAnimationValue forKey:kAnimationKey];
    return animation;
}

- (CABasicAnimation *)animationWithTranslation:(CGFloat)translation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, translation, 0.f, 0.f)];
    animation.duration = kTransitionDuration;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CALayer *)layerSnapshotWithTransform:(CATransform3D)transform
{
    if (UIGraphicsBeginImageContextWithOptions){
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    }
    else {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CALayer *snapshotLayer = [CALayer layer];
    snapshotLayer.transform = transform;
    snapshotLayer.anchorPoint = CGPointMake(1.f, 1.f);
    snapshotLayer.frame = self.view.bounds;
    snapshotLayer.contents = (id)snapshot.CGImage;
    return snapshotLayer;
}

@end
