//
//  SViewController.m
//  LLTabbarController
//
//  Created by 刘江 on 2019/12/6.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "SViewController.h"
#import "LLTabBarItem.h"
@interface SViewController ()

@end

@implementation SViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    LLTabBarItem *item = [[LLTabBarItem alloc] init];
    item.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:item];
    [item.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [item.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-200].active = YES;
    [item.widthAnchor constraintEqualToConstant:134].active = YES;
    
    item.imageView.image = [UIImage imageNamed:@"tab_home01"];
//    [item addTarget:self action:@selector(customAction)];
    
    
    
}
//- (void)customAction {
//    NSLog(@"hahahha");
//}

- (IBAction)exchange:(id)sender {
    self.tabBarController.selectedViewController = self.tabBarController.viewControllers[0];
    
    NSLog(@"%lu", self.tabBarController.selectedIndex);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
