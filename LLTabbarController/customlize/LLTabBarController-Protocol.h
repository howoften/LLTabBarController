//
//  LLTabBarController-Protocol.h
//  LLTabbarController
//
//  Created by 刘江 on 2019/12/9.
//  Copyright © 2019 Liujiang. All rights reserved.
//

@class LLTabBar;
@protocol LLTabBarDelegate <NSObject>
@required
- (void)tabBar:(LLTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index;

@optional
- (BOOL)tabBar:(LLTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index;

@end

extern NSString * const LLTabBarItemTitleNormalKey;
extern NSString * const LLTabBarItemTitleSelectKey;
extern NSString * const LLTabBarItemImageNormalKey;
extern NSString * const LLTabBarItemImageSelectKey;

