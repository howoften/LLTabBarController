//
//  UITabBar+Apperance.m
//  LLTabbarController
//
//  Created by 刘江 on 2019/12/6.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <objc/runtime.h>
#import "LLTabBar.h"

#import "UITabBar+Apperance.h"
#import "UITabBar+BeyondClick.h"

#define ContentHeight (([[UIApplication sharedApplication] statusBarFrame].size.height == 44 ? 34 : 0) + 49)

@interface UITabBar()<LLTabBarDelegate>
@property (nonatomic, strong)LLTabBar *contentTabBar;
@end
@implementation UITabBar (Apperance)
- (void)config {
    BOOL configed = self.contentTabBar.delegete == nil;
    if (!configed) {
//        self.contentTabBar.delegete = self;
        [self setBeyondClickCallbackTarget:self];
        
        self.backgroundImage = [UIImage new];
        self.shadowImage = [UIImage new];
    }
}

- (LLTabBar *)contentTabBar {
    LLTabBar *bar = objc_getAssociatedObject(self, @selector(contentTabBar));
    if (!bar) {
        bar = [[LLTabBar alloc] init];
        [self addSubview:bar];
        bar.translatesAutoresizingMaskIntoConstraints = NO;
        [bar.topAnchor constraintEqualToAnchor:self.topAnchor constant:-0.5].active = YES;
        [bar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [bar.heightAnchor constraintEqualToConstant:ContentHeight].active = YES;
        [bar.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        bar.delegete = self.tabBarDelegate;
        [self setContentTabBar:bar];
    }
    return bar;
    
}

- (void)setContentTabBar:(LLTabBar *)contentTabBar {
    objc_setAssociatedObject(self, @selector(contentTabBar), contentTabBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFrame:(CGRect)frame {
    if (frame.size.width == 0) {
        return;
        
    }
    if (frame.size.height == 0) {
        return;
    }
    if (frame.origin.y >= CGRectGetHeight([UIScreen mainScreen].bounds)) {
        return;
    }
    if (frame.origin.x >= CGRectGetWidth([UIScreen mainScreen].bounds)) {
        return;
    }
    [super setFrame:frame];
}


//- (void)setTabBarHeight:(CGFloat)tabBarHeight {
//    objc_setAssociatedObject(self, @selector(tabBarHeight), @(tabBarHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    if (self.contentTabBar) {
//        CGRect rect = self.contentTabBar.frame;
//        rect.origin.y-=(tabBarHeight-rect.size.height);
//        rect.size.height = tabBarHeight;
//        self.contentTabBar.frame = rect;
//    }
//}
//- (CGFloat)tabBarHeight {
//    return [objc_getAssociatedObject(self, @selector(tabBarHeight)) floatValue];
//}

- (void)setShowTabBarShadow:(BOOL)showTabBarShadow {
    objc_setAssociatedObject(self, @selector(showTabBarShadow), @(showTabBarShadow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.contentTabBar.isShowTabbarShadow = showTabBarShadow;

}
- (void)setTextAttributes:(NSDictionary *)attributes state:(UIControlState)state {
    [self.contentTabBar setTextAttributes:attributes state:state];
}

- (BOOL)showTabBarShadow {
    return [objc_getAssociatedObject(self, @selector(showTabBarShadow)) boolValue];

}

- (UIView *)viewForBeyondSuperViewInterationAtPoint:(CGPoint)point {
    return [self.contentTabBar subviewAtPoint:point];
}

- (void)setTabBarDelegate:(id<LLTabBarDelegate>)tabBarDelegate {
    objc_setAssociatedObject(self, @selector(tabBarDelegate), tabBarDelegate, OBJC_ASSOCIATION_ASSIGN);
    if (!self.contentTabBar.delegete) {
        self.contentTabBar.delegete = tabBarDelegate;
    }
}

- (id<LLTabBarDelegate>)tabBarDelegate {
    return objc_getAssociatedObject(self, @selector(tabBarDelegate));

}

- (void)setTabBarItemConfigArray:(NSArray<NSDictionary *> *)tabBarItemConfigArray {
    self.contentTabBar.tabBarItemConfigArray = tabBarItemConfigArray;
}

- (NSArray<NSDictionary *> *)tabBarItemConfigArray {
    return self.contentTabBar.tabBarItemConfigArray;
}

- (void)setSeparatorPath:(UIBezierPath *)separatorPath {
    [self.contentTabBar setSeparatorPath:separatorPath];
}
- (void)keepForeground {
    for (UIView *sub in self.subviews) {
        if (sub != self.contentTabBar) {
            [sub removeFromSuperview];
        }
    }
    [self config];
    [self bringSubviewToFront:self.contentTabBar];
    
}

- (void)setItemBadgeValue:(NSUInteger)value atIndex:(NSUInteger)index {
    [self.contentTabBar setItemBadgeValue:value atIndex:index];
}

- (void)moveItemBadgeAtIndex:(NSUInteger)index offset:(UIOffset)offset {
    [self.contentTabBar moveItemBadgeAtIndex:index offset:offset];
}
- (void)setItemPersistWhenBadgeValueZero:(BOOL)isPersist atIndex:(NSUInteger)index {
    [self.contentTabBar setItemPersistWhenBadgeValueZero:isPersist atIndex:index];
}
- (void)persistAllItemWhenBadgeValueZero:(BOOL)isPersist {
    [self.contentTabBar persistAllItemWhenBadgeValueZero:isPersist];
}

- (void)setBarBackgroundImage:(UIImage *)barBackgroundImage {
    [self.contentTabBar setBackgroundImage:barBackgroundImage];
}
- (void)setBarBackgroundColor:(UIColor *)barBackgroundColor {
    [self.contentTabBar setBackgroundColor:barBackgroundColor];
}
@end
