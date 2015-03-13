//
//  SecondViewController.m
//  TANavigationDemo
//
//  Created by 李小盆 on 15/3/3.
//

#import "SecondViewController.h"
#import "UIViewController+NavigationbarAlpha.h"
#import "FirstViewController.h"

@interface SecondViewController ()
{
    BOOL _isInitialize;
}

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"second";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = (CGRect){0, 30, 100, 44};
    [self.view addSubview:backButton];
    
    UIButton* pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushButton setTitle:@"push" forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(actionPush:) forControlEvents:UIControlEventTouchUpInside];
    pushButton.frame = (CGRect){220, 30, 100, 44};
    [self.view addSubview:pushButton];
    _isInitialize = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //为了避免拖曳返回时导航栏的闪烁，这里需要特殊处理一下
    if (_isInitialize) {
        self.navigationBarAlpha = 0;
        _isInitialize = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationBarAlpha = 0;
}

-(void) actionBack:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) actionPush:(id) sender
{
    [self.navigationController pushViewController:[FirstViewController new] animated:YES];
}

@end
