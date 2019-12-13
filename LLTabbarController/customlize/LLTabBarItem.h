//
//  LLTabBarItem.h
//  LLTabbarController
//
//  Created by 刘江 on 2019/12/13.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLTabBarItem : UIView
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong)UILabel *badgeLabel;
@property (nonatomic, strong)UILabel *boringBadge;
@property (nonatomic, assign)BOOL persistWhenZero; //default is no
@property (nonatomic, assign)NSUInteger badgeValue;
@property (nonatomic, assign)UIOffset badgeOffset;
@property (nonatomic)BOOL selected;

@property (nonatomic, strong)NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong)NSLayoutConstraint *leadingConstraint;

@property (nonatomic, strong)NSLayoutConstraint *badgeLabel_width;

- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state;
- (void)addTarget:(id)target action:(SEL)aSelector;
@end
