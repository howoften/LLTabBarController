//
//  UITabBar+Apperance.h
//  LLTabbarController
//
//  Created by 刘江 on 2019/12/6.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLTabBar.h"
@interface UITabBar (Apperance)
@property (nonatomic, strong)NSArray<NSString *> *tabBarItemTitlesArray; //item 标题
@property (nonatomic, strong)NSArray<NSString *> *tabBarItemsImageArray;
@property (nonatomic, strong)NSArray<NSString *> *tabBarItemsImageSelectedArray;
@property (nonatomic, strong)UIImage *barBackgroundImage;
@property (nonatomic, strong)UIColor *barBackgroundColor;

@property (nonatomic, assign)CGFloat tabBarHeight;
//@property (nonatomic, assign)CGFloat tabBarOffset;
@property (nonatomic, assign)BOOL showTabBarShadow;
@property (nonatomic, strong)UIBezierPath *separatorPath;
@property (nonatomic, weak)id<LLTabBarDelegate> tabBarDelegate;

- (void)setTextAttributes:(NSDictionary *)attributes state:(UIControlState)state;
- (void)setItemBadgeValue:(NSUInteger)value atIndex:(NSUInteger)index;
- (void)moveItemBadgeAtIndex:(NSUInteger)index offset:(UIOffset)offset;
- (void)setItemPersistWhenBadgeValueZero:(BOOL)isPersist atIndex:(NSUInteger)index;
- (void)persistAllItemWhenBadgeValueZero:(BOOL)isPersist;

- (void)keepForeground;
@end
