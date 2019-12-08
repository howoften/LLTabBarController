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
@property (nonatomic, strong)ExtraViewController * extraVC;

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

- (ExtraViewController *)extraVC {
    if (!_extraVC) {
        _extraVC = [ExtraViewController new];
        _extraVC.view.backgroundColor = [UIColor whiteColor];
        UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:_extraVC];
        na.navigationBar.translucent = YES;
        
    }
    return _extraVC;
}

//- (void)setCViewControllers:(NSMutableArray *)cViewControllers {
//    _cViewControllers = cViewControllers;
//    if (cViewControllers.count > 5) {
//        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
//        for (int i = 0; i < 5; i++) {
//            [temp addObject:cViewControllers[i]];
//        }
//        [temp replaceObjectAtIndex:temp.count-1 withObject:self.extraVC.navigationController];
//        self.viewControllers = temp;
//    }else {
//        self.viewControllers = cViewControllers;
//    }
//
//    NSMutableArray<NSString *> *titles = [NSMutableArray array];
//    for (int i = 0; i < cViewControllers.count; i++) {
//        [titles addObject:@"标签"];
//    }
//    _cTabBar.tabBarItemTitlesArray = [titles copy];
//}
//
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tabBar keepForeground];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

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

- (void)adjustItemOffsetVerticalAtIndex:(NSUInteger)index offset:(CGFloat)offset
{
    [self.tabBar.contentTabBar moveItemAtIndex:index offsetVertical:offset];
}


#pragma mark - LLTabBarDelegate
- (void)tabBar:(LLTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    [self setSelectedIndex:index];
}

- (void)switchToExtraViewControllers {
    NSLog(@"点击了 更多");
}

- (void)beyondMaxItemsNumLimit:(NSArray<NSString *> *)beyondItemsTitle {
    [self.extraVC.extraTitles removeAllObjects];
    [self.extraVC.extraTitles addObjectsFromArray:beyondItemsTitle];
}

//- (void)refreshExtraData {
//    if (self.cViewControllers.count > 5) {
//        if (self.cViewControllers.count == 6) {
//            [_extraVC.extraViewControllers addObject:self.cViewControllers[self.cViewControllers.count-2]];
//            [_extraVC.extraViewControllers addObject:self.cViewControllers[self.cViewControllers.count-1]];
//
//            [_extraVC.extraTitles addObject:self.cTabBar.tabBarItemTitlesArray[self.cTabBar.tabBarItemTitlesArray.count-2]];
//            [_extraVC.extraTitles addObject:self.cTabBar.tabBarItemTitlesArray[self.cTabBar.tabBarItemTitlesArray.count-1]];
//
//        }else {
//            [_extraVC.extraViewControllers addObject:_cViewControllers.lastObject];
//            [_extraVC.extraTitles addObject:self.cTabBar.tabBarItemTitlesArray.lastObject];
//        }
//    }
//}




@end


@interface ExtraViewController ()

@property (nonatomic, strong)CATransition *transition;

@end

static NSString * const CELLREUSEID = @"CELLREUSEID";

@implementation ExtraViewController
- (CATransition *)transition {
    if (!_transition) {
        _transition = [CATransition animation];
        _transition.duration = 1.0f;
        _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        _transition.type = kCATransitionPush;
        _transition.subtype = kCATransitionFromRight;
    }
    return _transition;
}

- (NSMutableArray *)extraViewControllers {
    if (!_extraViewControllers) {
        _extraViewControllers = [NSMutableArray arrayWithCapacity:0];
    }
    return _extraViewControllers;
}

- (NSMutableArray *)extraTitles {
    if (!_extraTitles) {
        _extraTitles = [NSMutableArray arrayWithCapacity:0];
    }
    return _extraTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    self.navigationItem.title = @"更多";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLREUSEID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _extraViewControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLREUSEID forIndexPath:indexPath];
    cell.textLabel.text = self.extraTitles[indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.navigationController) {
        id childVC;
        if ([self.extraViewControllers[indexPath.row] isKindOfClass:[UINavigationController class]]) {
            Class ChildClass = [[self.extraViewControllers[indexPath.row] topViewController] class];
            childVC = [ChildClass new];
        }else {
            childVC = self.extraViewControllers[indexPath.row];
        }
        ((UIViewController *)childVC).view.backgroundColor = [UIColor whiteColor];
        ((UIViewController *)childVC).title = self.extraTitles[indexPath.row];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:childVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else {
        [self presentViewController:self.extraViewControllers[indexPath.row] animated:YES completion:nil];
    }
    
}

@end

