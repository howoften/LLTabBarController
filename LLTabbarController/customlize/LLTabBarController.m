//
//  LLTabBarController.m
//  EntranceControl
//
//  Created by 刘江 on 2018/7/18.
//  Copyright © 2018年 Liujiang. All rights reserved.
//

#import "LLTabBarController.h"
#import "UITabBar+BeyondClick.h"
#import "LLTabBar.h"

#define SafeAreaBottomMargin ([[UIApplication sharedApplication] statusBarFrame].size.height == 44 ? 34 : 0)

@interface UITabBar (CustomContent)
@property (nonatomic, strong)LLTabBar *contentTabBar;
@end
@interface LLTabBarController ()<LLTabBarDelegate>

@end

@implementation LLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.tabBarDelegate = self;
    if (!self.tabBar.contentTabBar.separatorPath) {
        self.tabBar.showTabBarShadow = NO;
    }

}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    NSAssert(self.viewControllers.count<6, @"<LLTabBarController %p>, childViewControllers count beyond max limit (5).", self);
    [super setSelectedIndex:selectedIndex];
    [self.tabBar.contentTabBar setSelectedIndex:selectedIndex];
}

- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController {
    [super setSelectedViewController:selectedViewController];
    NSUInteger index = [self.viewControllers indexOfObject:selectedViewController];
    if (index != NSNotFound) {
        [self.tabBar.contentTabBar setSelectedIndex:index];

    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tabBar keepForeground];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.tabBar keepForeground];
    
    CGRect barFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 49);
    barFrame.origin.y = CGRectGetHeight(self.view.frame)-CGRectGetHeight(barFrame)-SafeAreaBottomMargin;
    self.tabBar.frame = barFrame;
    
}

- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}

#pragma mark - LLTabBarDelegate
- (void)tabBar:(LLTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    [self setSelectedIndex:index];
}


@end
