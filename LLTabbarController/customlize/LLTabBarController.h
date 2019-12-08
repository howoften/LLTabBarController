//
//  CTabbarController.h
//  CustomTabbarController
//
//  Created by Liu Jiang on 2017/9/26.
//  Copyright © 2017年 Liu Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITabBar+Apperance.h"

@interface LLTabBarController : UITabBarController

//@property (nonatomic, readonly, strong)LLTabBar *tabBar;
//@property (nonatomic, assign)CGFloat cTabBarHeight;
//@property (nonatomic, assign)CGFloat cTabBarOffset;
//@property (nonatomic, strong)NSMutableArray *cViewControllers;
//@property (nonatomic, assign)BOOL cShowNavigationShadow;

//- (void)cAddChildViewController:(__kindof UIViewController *)childViewController;
//- (void)adjustItemOffsetVerticalAtIndex:(NSUInteger)index offset:(CGFloat)offset;
@end

//当item大于5个
@interface ExtraViewController : UITableViewController

@property (nonatomic, strong)NSMutableArray *extraTitles;
@property (nonatomic, strong)NSMutableArray *extraViewControllers;

@end
