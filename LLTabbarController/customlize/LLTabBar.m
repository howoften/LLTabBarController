
//
//  LLTabBar.m
//  CustomTabbarController
//
//  Created by Liu Jiang on 2017/9/27.
//  Copyright © 2017年 Liu Jiang. All rights reserved.
//

#import <objc/runtime.h>
#import "LLTabBar.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MaxItemNum 5
//#define ContentEdgeLeft 2
#define ItemSpacing 2
#define ImageTitleSpacing 2
@interface LLTabBar ()
@property (nonatomic, strong)UIFont *font;
@property (nonatomic, strong)UIFont *selectedFont;
@property (nonatomic, strong)UIColor *normalColor;
@property (nonatomic, strong)UIColor *selectetColor;
@property (nonatomic, strong)UIButton *lastSelectedItem;
@property (nonatomic, strong)UIImageView *bgImageView;
@property (nonatomic, strong)NSMutableArray *tabBarItems;///存 button
@property (nonatomic, strong)NSMutableDictionary *offsetDic;

@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIVisualEffectView *backMaskView;
@property (nonatomic, strong)CAShapeLayer *separateLine;

@end
@implementation LLTabBar///007aff
- (instancetype)init {
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.width = frame.size.width != ScreenWidth ? ScreenWidth : frame.size.width;
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (NSMutableArray *)tabBarItems {
    if (!_tabBarItems) {
        _tabBarItems = [NSMutableArray arrayWithCapacity:0];
    }
    return _tabBarItems;
}

- (void)setFrame:(CGRect)frame {
    if (frame.size.width != ScreenWidth) {
        frame.size.width = ScreenWidth;
    }
    if (frame.origin.x != 0) {
        frame.origin.x = 0;
    }
    if (frame.size.height > ScreenHeight/2){
        frame.size.height = 49;
    }
    
    [super setFrame:frame];
}

- (void)_init {
    //    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = NO;
    self.offsetDic = [NSMutableDictionary dictionaryWithCapacity:0];
    _font = [UIFont systemFontOfSize:10];
    _selectedFont = [UIFont systemFontOfSize:10];
    _normalColor = [UIColor grayColor];
    _selectetColor = [UIColor colorWithRed:0 green:122/255.0 blue:255/255.0 alpha:1];
    _isBeyondLimit = NO;
    _offset = 0;
    [self contentView];
    [self sendSubviewToBack:self.backMaskView];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_contentView];
        [_contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [_contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [_contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        [_contentView.heightAnchor constraintEqualToConstant:49].active = YES;


    }
    return _contentView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        _bgImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_bgImageView];
        [_bgImageView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [_bgImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [_bgImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [_bgImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;

        [self sendSubviewToBack:_bgImageView];
    }
    return _bgImageView;
}

- (UIVisualEffectView *)backMaskView {
    if (!_backMaskView && !_bgImageView) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.55];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _backMaskView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _backMaskView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_backMaskView];
        [_backMaskView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [_backMaskView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [_backMaskView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [_backMaskView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    }
    return _backMaskView;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= 0 && selectedIndex < _tabBarItems.count) {
        [self didClicked:[_tabBarItems objectAtIndex:selectedIndex]];
    }
}

- (void)setOffset:(CGFloat)offset {
    _offset = offset;
//    [self adjustFrame];
}

- (void)setTabBarItemTitlesArray:(NSArray<NSString *> *)tabBarItemTitlesArray {
    if (!_tabBarItemTitlesArray) {
        _tabBarItemTitlesArray = tabBarItemTitlesArray;
    }else if (_tabBarItemTitlesArray.count > tabBarItemTitlesArray.count) {
        NSMutableArray *temp = [_tabBarItemTitlesArray mutableCopy];
        [temp replaceObjectsInRange:NSMakeRange(0, tabBarItemTitlesArray.count) withObjectsFromArray:tabBarItemTitlesArray];
        _tabBarItemTitlesArray = [temp copy];
    }else {
        NSMutableArray *temp = [_tabBarItemTitlesArray mutableCopy];
        [temp replaceObjectsInRange:NSMakeRange(0, _tabBarItemTitlesArray.count) withObjectsFromArray:tabBarItemTitlesArray range:NSMakeRange(0, _tabBarItemTitlesArray.count)];
        _tabBarItemTitlesArray = [temp copy];
    }
    [self layoutTabBarItems:_tabBarItemTitlesArray];
    
}

- (void)setTabBarItemsImageArray:(NSArray<NSString *> *)tabBarItemsImageArray {
    _tabBarItemsImageArray = tabBarItemsImageArray;
    [self setTabBarItemsImage];
}

- (void)setTabBarItemsImageSelectedArray:(NSArray<NSString *> *)tabBarItemsImageSelectedArray {
    _tabBarItemsImageSelectedArray = tabBarItemsImageSelectedArray;
    [self setTabBarItemsSelectedImage];
}

- (void)setLastSelectedItem:(UIButton *)lastSelectedItem {
    _lastSelectedItem = lastSelectedItem;
}

//bar 背景色

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (!_backMaskView) {
        [super setBackgroundColor:backgroundColor];
    }else {
        [super setBackgroundColor:[UIColor clearColor]];
        self.bgImageView.backgroundColor = backgroundColor;
        [_backMaskView removeFromSuperview];
    }
    
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.bgImageView.image = backgroundImage;
    
    [_backMaskView removeFromSuperview];
}

- (void)setTextAttributes:(NSDictionary *)attributes state:(UIControlState)state {
    if (state == UIControlStateNormal) {
        if (attributes[NSFontAttributeName]) {
            _font = attributes[NSFontAttributeName];
        }
        if (attributes[NSForegroundColorAttributeName]) {
            _normalColor = attributes[NSForegroundColorAttributeName];
        }
    }else if (state == UIControlStateSelected) {
        if (attributes[NSFontAttributeName]) {
            _selectedFont = attributes[NSFontAttributeName];
        }
        if (attributes[NSForegroundColorAttributeName]) {
            _selectetColor = attributes[NSForegroundColorAttributeName];
        }
    }
    [self resetTitleTextApperance];
}

- (void)layoutTabBarItems:(NSArray *)tabBarItemsArray {
    [self removeSubItems];
    CGFloat itemWidth = 0.f;
    itemWidth = (ScreenWidth) / MIN(5, tabBarItemsArray.count);
    
//    __kindof UIView *secondItem = self.contentView;
    for (int i = 0; i < tabBarItemsArray.count && i < 5; i++) {
        UIButton *tabBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tabBarButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:tabBarButton];
        [tabBarButton addTarget:self action:@selector(didClicked:) forControlEvents:UIControlEventTouchUpInside];
        tabBarButton.adjustsImageWhenHighlighted = NO;
//        [tabBarButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [tabBarButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [tabBarButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:itemWidth*i].active = YES;
        [tabBarButton.widthAnchor constraintEqualToConstant:itemWidth].active = YES;
        [tabBarButton.heightAnchor constraintGreaterThanOrEqualToConstant:49].active = YES;
        
//        tabBarButton.frame = CGRectMake(ContentEdgeLeft + i*ItemSpacing + i*itemWidth, 0, itemWidth, 49);
        [tabBarButton setAttributedTitle:[[NSAttributedString alloc] initWithString:tabBarItemsArray[i] attributes:@{NSFontAttributeName:_font, NSForegroundColorAttributeName:_normalColor}] forState:UIControlStateNormal];
        [tabBarButton setAttributedTitle:[[NSAttributedString alloc] initWithString:tabBarItemsArray[i] attributes:@{NSFontAttributeName:_selectedFont, NSForegroundColorAttributeName:_selectetColor}] forState:UIControlStateSelected];
        
        if (self.tabBarItemsImageArray.count > 0 && i < self.tabBarItemsImageArray.count && [self.tabBarItemsImageArray[i] length] > 0) {
            [tabBarButton setImage:[UIImage imageNamed:self.tabBarItemsImageArray[i]] forState:UIControlStateNormal];
        }
        if (self.tabBarItemsImageSelectedArray.count > 0 && i < self.tabBarItemsImageSelectedArray.count && [self.tabBarItemsImageSelectedArray[i] length] > 0) {
            [tabBarButton setImage:[UIImage imageNamed:self.tabBarItemsImageSelectedArray[i]] forState:UIControlStateSelected];
        }
        [tabBarButton layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:ImageTitleSpacing];
        [self.tabBarItems addObject:tabBarButton];
//        secondItem = tabBarButton;
    }
    _lastSelectedItem = self.tabBarItems.firstObject;
    _lastSelectedItem.selected = YES;
}

- (void)setTabBarItemsImage {
    for (UIButton *item in _tabBarItems) {
        NSInteger index = [_tabBarItems indexOfObject:item];
        if (_tabBarItemsImageArray.count > 0 && index < _tabBarItemsImageArray.count && [_tabBarItemsImageArray[index] length] > 0) {
            [item setImage:[UIImage imageNamed:_tabBarItemsImageArray[index]] forState:UIControlStateNormal];
            [item layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:ImageTitleSpacing];
        }
    }
}

- (void)setTabBarItemsSelectedImage {
    for (UIButton *item in _tabBarItems) {
        NSInteger index = [_tabBarItems indexOfObject:item];
        if (_tabBarItemsImageSelectedArray.count > 0 && index < _tabBarItemsImageSelectedArray.count && [_tabBarItemsImageSelectedArray[index] length] > 0) {
            
            [item setImage:[UIImage imageNamed:_tabBarItemsImageSelectedArray[index]] forState:UIControlStateSelected];
            [item layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:ImageTitleSpacing];
        }
    }
}

- (void)resetTitleTextApperance {
    for (UIButton *item in _tabBarItems) {
        if (item.titleLabel.text.length > 0) {
            [item setAttributedTitle:[[NSAttributedString alloc] initWithString:item.titleLabel.text attributes:@{NSFontAttributeName:_font, NSForegroundColorAttributeName:_normalColor}] forState:UIControlStateNormal];
            [item setAttributedTitle:[[NSAttributedString alloc] initWithString:item.titleLabel.text attributes:@{NSFontAttributeName:_selectedFont, NSForegroundColorAttributeName:_selectetColor}] forState:UIControlStateSelected];
        }
    }
}

- (void)didClicked:(UIButton *)sender {
    BOOL enabled = YES;
    NSInteger selectedIndex = [_tabBarItems indexOfObject:sender];
    if ([self.delegete respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        enabled = ([self.delegete tabBar:self shouldSelectItemAtIndex:selectedIndex]);
    }
    if ([self.delegete respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)] && enabled) {
        NSInteger selectedIndex = [_tabBarItems indexOfObject:sender];
        _selectedIndex = selectedIndex;
        if (sender != _lastSelectedItem) {
            _lastSelectedItem.selected = !_lastSelectedItem.selected;
            _lastSelectedItem = sender;
            _lastSelectedItem.selected = YES;
            [self.delegete tabBar:self didSelectItemAtIndex:selectedIndex];
        }
        
    }
}

- (void)removeSubItems {
    for (UIView *subview in self.contentView.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        }
    }
    _lastSelectedItem = nil;
    [_tabBarItems removeAllObjects];
}

- (void)setItemBadgeValue:(NSUInteger)value atIndex:(NSUInteger)index {
    if (index >= 0 && index < self.tabBarItems.count) {
        UIButton *target = [self.tabBarItems objectAtIndex:index];
        [target setBadgeValue:value];
    }
}
- (void)moveItemBadgeAtIndex:(NSUInteger)index offset:(UIOffset)offset {
    if (index >= 0 && index < self.tabBarItems.count) {
        UIButton *target = [self.tabBarItems objectAtIndex:index];
        [target setBadgeOffset:offset];
    }
}
- (void)setItemPersistWhenBadgeValueZero:(BOOL)isPersist atIndex:(NSUInteger)index {
    if (index >= 0 && index < self.tabBarItems.count) {
        UIButton *target = [self.tabBarItems objectAtIndex:index];
        [target setPersistWhenZero:isPersist];
    }
}
- (void)persistAllItemWhenBadgeValueZero:(BOOL)isPersist {
    for (UIButton *item in  self.tabBarItems) {
        [item setPersistWhenZero:isPersist];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)setIsShowTabbarShadow:(BOOL)isShowTabbarShadow {
    _isShowTabbarShadow = isShowTabbarShadow;
    if (isShowTabbarShadow) {
        [self.separateLine removeFromSuperlayer];
        self.layer.shadowColor = [UIColor colorWithRed:203/255.f green:203/255.f blue:203/255.f alpha:1].CGColor;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.7;
        
        [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 49)] CGPath]];
    }else {
        [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:CGRectZero] CGPath]];
        [self.layer addSublayer:self.separateLine];
        
    }
    [self setNeedsDisplay];
}
- (CAShapeLayer *)separateLine {
    if (!_separateLine) {
        _separateLine = [CAShapeLayer layer];
    }
    if (_separateLine.path == NULL) {
        UIBezierPath *line = [UIBezierPath bezierPath];
        [line moveToPoint:CGPointMake(0, 0)];
        [line addLineToPoint:CGPointMake(ScreenWidth, 0)];
        [line closePath];
        _separateLine.path = line.CGPath;

        [_separateLine setLineWidth:0.5/2];
        [_separateLine setStrokeColor:[UIColor colorWithWhite:0 alpha:0.3].CGColor];
        [_separateLine setFillColor:[UIColor clearColor].CGColor];
    }
    return _separateLine;
}

- (void)setSeparatorPath:(UIBezierPath *)separatorPath {
    _separatorPath = separatorPath;
    self.separateLine.path = separatorPath.CGPath;
    self.separateLine.lineWidth = separatorPath.lineWidth;
    [self setIsShowTabbarShadow:NO];
}

- (__kindof UIView *)subviewAtPoint:(CGPoint)point {
    
    for (UIButton *button in [self.tabBarItems copy]) {
        
        if (CGRectContainsPoint(button.frame, point)) {
            return button;
        }
    }
    return nil;
}

@end


#pragma mark -- UIButton (LayoutItem)
@interface UIButton ()
@property (nonatomic, strong)UILabel *badgeLabel;
@property (nonatomic, strong)UILabel *boringBadge;

@property (nonatomic, strong)NSLayoutConstraint *badgeLabel_width;

@end

@implementation UIButton (LayoutItem)
- (void)layoutButtonWithButtonStyle:(ButtonStyle)style imageTitleSpace:(CGFloat)space {
    /**
     * 知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     * 如果只有title，那它上下左右都是相对于button的，image也是一样；
     * 如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    if (self.titleLabel.text.length <= 0) {
        labelWidth = 0.f;
        labelHeight = 0.f;
    }
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
       switch (style) {
        case ButtonStyleImageTopTitleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case ButtonStyleImageLeftTitleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case ButtonStyleImageBottomTitleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case ButtonStyleImageRightTitleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
    
    if (CGRectGetMaxY(self.titleLabel.frame) > CGRectGetHeight(self.frame)) {
        CGFloat offset_v = CGRectGetMaxY(self.titleLabel.frame) - CGRectGetHeight(self.frame);
        offset_v*=2;
        if (style == ButtonStyleImageTopTitleBottom) {
            labelEdgeInsets.bottom += offset_v;
            self.titleEdgeInsets = labelEdgeInsets;

            imageEdgeInsets.top -= offset_v;
            self.imageEdgeInsets = imageEdgeInsets;
        }
    }
}

- (void)setPersistWhenZero:(BOOL)persistWhenZero {
    if (persistWhenZero != self.persistWhenZero) {
        objc_setAssociatedObject(self, @selector(persistWhenZero), @(persistWhenZero), OBJC_ASSOCIATION_ASSIGN);
    }
}

- (BOOL)persistWhenZero {
    return [objc_getAssociatedObject(self, @selector(persistWhenZero)) boolValue];
}


- (NSUInteger)badgeValue {
    return [objc_getAssociatedObject(self, @selector(badgeValue)) unsignedIntegerValue];

}

- (void)setBadgeValue:(NSUInteger)badgeValue {
    if (badgeValue != self.badgeValue || badgeValue == 0) {
        objc_setAssociatedObject(self, @selector(badgeValue), @(badgeValue), OBJC_ASSOCIATION_ASSIGN);
        NSString *strValue = [NSString stringWithFormat:@"%lu", badgeValue];
        if (badgeValue > 99) {
            strValue = @"99+";
        }else if (badgeValue == 0) {
            strValue =nil;
        }
        self.boringBadge.hidden = !(badgeValue == 0 && self.persistWhenZero);
        self.badgeLabel.hidden = badgeValue == 0;
        [self.badgeLabel setText:strValue];
    
        if (badgeValue < 10) {
            self.badgeLabel_width.constant = 19;
        }else {
            self.badgeLabel_width.constant = [self stringWidthFromLabel:self.badgeLabel]+10;
        }
    }

}
- (void)setBadgeOffset:(UIOffset)badgeOffset {
    objc_setAssociatedObject(self, @selector(badgeOffset), [NSValue valueWithUIOffset:badgeOffset], OBJC_ASSOCIATION_ASSIGN);
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(badgeOffset.horizontal, badgeOffset.vertical);
    self.badgeLabel.transform = transform;
}

- (UIOffset)badgeOffset {
    return [objc_getAssociatedObject(self, @selector(badgeOffset)) UIOffsetValue];
}

- (UILabel *)badgeLabel {
    UILabel  *label = objc_getAssociatedObject(self, @selector(badgeLabel));
    if (!label) {
        label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:label];
        label.backgroundColor = [UIColor colorWithRed:249/255.f green:64/255.f blue:57/255.f alpha:1];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 19/2.0;
        label.layer.masksToBounds = YES;
        if (UIOffsetEqualToOffset(self.badgeOffset, UIOffsetZero)) {
//            NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-7];
//            NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeTop multiplier:1 constant:7];
//            [label addConstraints:@[leading, bottom]];
            
            [label.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:-7].active = YES;
            [label.topAnchor constraintEqualToAnchor:self.imageView.topAnchor constant:0].active = YES;
        }else {
            [label.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:self.badgeOffset.horizontal].active = YES;
            [label.topAnchor constraintEqualToAnchor:self.imageView.topAnchor constant:self.badgeOffset.vertical].active = YES;
        }
        [label.heightAnchor constraintEqualToConstant:19].active = YES;
        self.badgeLabel_width = [label.widthAnchor constraintEqualToConstant:19];
        self.badgeLabel_width.active = YES;
        [self setBadgeLabel:label];
    }
    return label;
}

- (void)setBadgeLabel:(UILabel *)badgeLabel {
    objc_setAssociatedObject(self, @selector(badgeLabel), badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (CGFloat)stringWidthFromLabel:(UILabel *)label {
    return MAX([label.text boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font} context:nil].size.width, 19);
}

- (void)setBadgeLabel_width:(NSLayoutConstraint *)badgeLabel_width {
    objc_setAssociatedObject(self, @selector(badgeLabel_width), badgeLabel_width, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (NSLayoutConstraint *)badgeLabel_width {
    return objc_getAssociatedObject(self, @selector(badgeLabel_width));
}

- (UILabel *)boringBadge {
    UILabel *b = objc_getAssociatedObject(self, @selector(boringBadge));
    if (!b) {
        b = [UILabel new];
        b.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:b];
        [b.leadingAnchor constraintEqualToAnchor:self.badgeLabel.leadingAnchor].active = YES;
        [b.topAnchor constraintEqualToAnchor:self.badgeLabel.topAnchor constant:5].active = YES;
        [b.widthAnchor constraintEqualToConstant:6].active = YES;
        [b.heightAnchor constraintEqualToConstant:6].active = YES;
        b.layer.cornerRadius = 3;
        b.layer.masksToBounds = YES;
        b.backgroundColor = self.badgeLabel.backgroundColor;
        b.hidden = YES;
        [self setBoringBadge:b];
    }
    return b;
}

- (void)setBoringBadge:(UILabel *)boringBadge {
    objc_setAssociatedObject(self, @selector(boringBadge), boringBadge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}


@end
