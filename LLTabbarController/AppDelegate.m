//
//  AppDelegate.m
//  LLTabbarController
//
//  Created by 刘江 on 2019/12/6.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "AppDelegate.h"
#import "LLTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [(LLTabBarController *)self.window.rootViewController tabBar].tabBarItemTitlesArray = @[@"首页", @"播放", @"我的"];
    
    [(LLTabBarController *)self.window.rootViewController tabBar].tabBarItemsImageArray = @[@"tab_home01", @"bofang", @"tab_mine_01"];
    [(LLTabBarController *)self.window.rootViewController tabBar].tabBarItemsImageSelectedArray = @[@"tab_home", @"bofang", @"tab_mine"];
    
//    [[(LLTabBarController *)self.window.rootViewController tabBar] adjustItemOffsetVerticalAtIndex:1 offset:-20];
    [[(LLTabBarController *)self.window.rootViewController tabBar] setTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} state:UIControlStateSelected];
    
    
    
    UIBezierPath *bez = [UIBezierPath bezierPath];
    [bez moveToPoint:CGPointMake(0, 0 )];
    [bez addLineToPoint:CGPointMake(([UIScreen mainScreen].bounds.size.width-120)/2, 0)];
    [bez addArcWithCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, 0) radius:60 startAngle:M_PI endAngle:0 clockwise:YES];
    [bez addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];
//    [[(LLTabBarController *)self.window.rootViewController tabBar] setBarBackgroundImage:[UIImage imageNamed:@"timg"]];
    [[(LLTabBarController *)self.window.rootViewController tabBar] setBarBackgroundColor:[UIColor purpleColor]];
    
    [[(LLTabBarController *)self.window.rootViewController tabBar] setItemPersistWhenBadgeValueZero:YES atIndex:2];
    [[(LLTabBarController *)self.window.rootViewController tabBar] setSeparatorPath:bez];
    [[(LLTabBarController *)self.window.rootViewController tabBar] setItemBadgeValue:100 atIndex:1];
    [[(LLTabBarController *)self.window.rootViewController tabBar] setItemBadgeValue:9 atIndex:0];
    [[(LLTabBarController *)self.window.rootViewController tabBar] setItemBadgeValue:0 atIndex:2];
    

    [[(LLTabBarController *)self.window.rootViewController tabBar] moveItemBadgeAtIndex:1 offset:UIOffsetMake(-20, 10)];
    return YES;
}




@end
