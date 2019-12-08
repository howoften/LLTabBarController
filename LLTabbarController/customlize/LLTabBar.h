//
//  CTabBar.h
//  CustomTabbarController
//
//  Created by Liu Jiang on 2017/9/27.
//  Copyright © 2017年 Liu Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLTabBar;
@protocol LLTabBarDelegate <NSObject>
@required
- (void)tabBar:(LLTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index;
@optional
- (BOOL)tabBar:(LLTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index;
//- (void)gotoExtraViewControllers;
//- (void)isSetBarBackgroundColorOrImage;
//- (void)beyondMaxItemsNumLimit:(NSArray<NSString *> *)beyondItemsTitle;
@end

@interface LLTabBar : UIView
//如果某个Item 只显示图片  或某个Item 只显示文字, 请在相应数组对应位置 转入@""; 务必保证button数组 和 image数组长度一致
@property (nonatomic, strong)NSArray<NSString *> *tabBarItemTitlesArray; //item 标题
@property (nonatomic, strong)NSArray<NSString *> *tabBarItemsImageArray;
@property (nonatomic, strong)NSArray<NSString *> *tabBarItemsImageSelectedArray;
@property (nonatomic, readonly, assign)BOOL isBeyondLimit; //item 是否超过 5
@property (nonatomic, assign)CGFloat offset;
@property (nonatomic, strong)UIImage *backgroundImage;
@property (nonatomic, assign)NSUInteger selectedIndex;
@property (nonatomic, assign)BOOL isShowTabbarShadow;
@property (nonatomic, strong)UIBezierPath *separatorPath;


@property (nonatomic, weak)id<LLTabBarDelegate> delegete;
- (void)setTextAttributes:(NSDictionary *)attributes state:(UIControlState)state;
//- (void)addChildItemWithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage;
- (void)moveItemAtIndex:(NSUInteger)index offsetVertical:(CGFloat)offsetVertical;
- (void)setItemBadgeValue:(NSUInteger)value atIndex:(NSUInteger)index;
- (void)moveItemBadgeAtIndex:(NSUInteger)index offset:(UIOffset)offset;
- (void)setItemPersistWhenBadgeValueZero:(BOOL)isPersist atIndex:(NSUInteger)index;
- (void)persistAllItemWhenBadgeValueZero:(BOOL)isPersist;

- (__kindof UIView *)subviewAtPoint:(CGPoint)point;
@end

typedef NS_ENUM(NSUInteger, ButtonStyle) {
    ButtonStyleImageTopTitleBottom, // image在上，label在下
    ButtonStyleImageLeftTitleRight, // image在左，label在右
    ButtonStyleImageBottomTitleTop, // image在下，label在上
    ButtonStyleImageRightTitleLeft // image在右，label在左
};
@interface UIButton (LayoutItem)
@property (nonatomic, assign)BOOL persistWhenZero; //default is no
@property (nonatomic, assign)NSUInteger badgeValue;
@property (nonatomic, assign)UIOffset badgeOffset;

- (void)layoutButtonWithButtonStyle:(ButtonStyle)style imageTitleSpace:(CGFloat)space;
@end

