//
//  CTabBar.h
//  CustomTabbarController
//
//  Created by Liu Jiang on 2017/9/27.
//  Copyright © 2017年 Liu Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLTabBarController-Protocol.h"
@interface LLTabBar : UIView
@property (nonatomic, strong)NSArray<NSDictionary *> *tabBarItemConfigArray;
//@property (nonatomic, assign)CGFloat offset;
@property (nonatomic, strong)UIImage *backgroundImage;
@property (nonatomic, assign)NSUInteger selectedIndex;
@property (nonatomic, assign)BOOL isShowTabbarShadow;
@property (nonatomic, strong)UIBezierPath *separatorPath;

@property (nonatomic, weak)id<LLTabBarDelegate> delegete;

- (void)setTextAttributes:(NSDictionary *)attributes state:(UIControlState)state;

- (void)setItemBadgeValue:(NSUInteger)value atIndex:(NSUInteger)index;
- (void)moveItemBadgeAtIndex:(NSUInteger)index offset:(UIOffset)offset;
- (void)setItemPersistWhenBadgeValueZero:(BOOL)isPersist atIndex:(NSUInteger)index;
- (void)persistAllItemWhenBadgeValueZero:(BOOL)isPersist;

- (__kindof UIView *)subviewAtPoint:(CGPoint)point;
@end

