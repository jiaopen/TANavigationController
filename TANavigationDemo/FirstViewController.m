//
//  FirstViewController.m
//  TANavigationDemo
//
//  Created by 李小盆 on 15/3/3.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "UIViewController+NavigationbarAlpha.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"first";
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"push" style:UIBarButtonItemStyleDone target:self action:@selector(actionNavigationLeftItem:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationBarAlpha = 1;
}

-(void) actionNavigationLeftItem:(id) sender
{
    [self.navigationController pushViewController:[SecondViewController new] animated:YES];
}
@end
