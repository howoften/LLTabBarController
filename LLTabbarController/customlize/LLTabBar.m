
//
//  LLTabBar.m
//  CustomTabbarController
//
//  Created by Liu Jiang on 2017/9/27.
//  Copyright © 2017年 Liu Jiang. All rights reserved.
//

#import "LLTabBarItem.h"
#import "LLTabBar.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface LLTabBar ()
@property (nonatomic, strong)UIFont *font;
@property (nonatomic, strong)UIFont *selectedFont;
@property (nonatomic, strong)UIColor *normalColor;
@property (nonatomic, strong)UIColor *selectetColor;
@property (nonatomic, strong)LLTabBarItem *lastSelectedItem;
@property (nonatomic, strong)UIImageView *bgImageView;
@property (nonatomic, strong)NSMutableArray *tabBarItems;///存 item
@property (nonatomic, strong)NSMutableDictionary *offsetDic;

@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIVisualEffectView *backMaskView;
@property (nonatomic, strong)CAShapeLayer *separateLine;

@end

NSString * const LLTabBarItemTitleNormalKey = @"LLTabBarItemTitleNormalKey";
NSString * const LLTabBarItemTitleSelectKey = @"LLTabBarItemTitleSelectKey";
NSString * const LLTabBarItemImageNormalKey = @"LLTabBarItemImageNormalKey";
NSString * const LLTabBarItemImageSelectKey = @"LLTabBarItemImageSelectKey";
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
//    _isBeyondLimit = NO;
//    _offset = 0;
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
//        [_bgImageView.heightAnchor constraintGreaterThanOrEqualToConstant:ScreenHeight>736?83:49].active = YES;
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

//- (void)setOffset:(CGFloat)offset {
//    _offset = offset;
////    [self adjustFrame];
//}

- (void)setTabBarItemConfigArray:(NSArray *)tabBarItemConfigArray {
    NSAssert([tabBarItemConfigArray count] < 6, @"<%@ %p> -setTabBarItemConfigArray: config array count must lessThan 6.", NSStringFromClass(self.class), self);

    [[tabBarItemConfigArray copy] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert([obj isKindOfClass:[NSDictionary class]], @"<%@ %p> -setTabBarItemConfigArray: object must be dictionary in array.", NSStringFromClass(self.class), self);
        NSAssert(([[obj objectForKey:LLTabBarItemTitleNormalKey] isKindOfClass:[NSString class]] || [obj objectForKey:LLTabBarItemTitleNormalKey] == nil), @"<%@ %p> -setTabBarItemConfigArray: dictionary in array has invalid key-value pair.", NSStringFromClass(self.class), self);
        NSAssert(([[obj objectForKey:LLTabBarItemTitleSelectKey] isKindOfClass:[NSString class]] || [obj objectForKey:LLTabBarItemTitleSelectKey] == nil), @"<%@ %p> -setTabBarItemConfigArray: dictionary in array has invalid key-value pair.", NSStringFromClass(self.class), self);
        NSAssert(([[obj objectForKey:LLTabBarItemImageNormalKey] isKindOfClass:[NSString class]] || [obj objectForKey:LLTabBarItemImageNormalKey] == nil), @"<%@ %p> -setTabBarItemConfigArray: dictionary in array has invalid key-value pair.", NSStringFromClass(self.class), self);
        NSAssert(([[obj objectForKey:LLTabBarItemImageSelectKey] isKindOfClass:[NSString class]] || [obj objectForKey:LLTabBarItemImageSelectKey] == nil), @"<%@ %p> -setTabBarItemConfigArray: dictionary in array has invalid key-value pair.", NSStringFromClass(self.class), self);
        
        BOOL least = ([obj objectForKey:LLTabBarItemTitleNormalKey] == nil && [obj objectForKey:LLTabBarItemTitleSelectKey] == nil && [obj objectForKey:LLTabBarItemImageNormalKey] == nil && [obj objectForKey:LLTabBarItemImageSelectKey] == nil);
        NSAssert(!least, @"<%@ %p> -setTabBarItemConfigArray: dictionary in array  must have at least one valid key-value pair.", NSStringFromClass(self.class), self);

    }];
    _tabBarItemConfigArray = tabBarItemConfigArray;
    
    [self updateTabBarItems];
    [self refreshTabBarItems];
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
    [self refreshTabBarItems];
}
- (void)updateTabBarItems {
    if (self.tabBarItems.count > self.tabBarItemConfigArray.count) {
        NSMutableArray *temp = [self.tabBarItems mutableCopy];
        CGFloat itemWidth = (ScreenWidth) / MIN(5, self.tabBarItemConfigArray.count);
        for (int i = 0; i < self.tabBarItemConfigArray.count; i++) {
            LLTabBarItem *previous_item = self.tabBarItems[i];
            previous_item.leadingConstraint.constant = itemWidth*i;
            previous_item.widthConstraint.constant = itemWidth;
        }
        for (int i = (int)self.tabBarItemConfigArray.count; i < self.tabBarItems.count; i++) {
            UIButton *remove_item = self.tabBarItems[i];
            [remove_item removeFromSuperview];
        }
        [temp removeObjectsInRange:NSMakeRange(self.tabBarItemConfigArray.count, self.tabBarItems.count - self.tabBarItemConfigArray.count)];
        self.tabBarItems = [temp copy];
    }else if (self.tabBarItems.count < self.tabBarItemConfigArray.count) {
        CGFloat itemWidth = (ScreenWidth) / MIN(5, self.tabBarItemConfigArray.count);
        NSMutableArray *temp = [self.tabBarItems mutableCopy];
        for (int i = 0; i < self.tabBarItems.count; i++) {
            LLTabBarItem *previous_item = self.tabBarItems[i];
            previous_item.leadingConstraint.constant = itemWidth*i;
            previous_item.widthConstraint.constant = itemWidth;
        }
        for (int i = (int)self.tabBarItems.count; i < self.tabBarItemConfigArray.count; i++) {
            LLTabBarItem *tabBarButton = [[LLTabBarItem alloc] init];
            tabBarButton.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:tabBarButton];
            [tabBarButton addTarget:self action:@selector(didClicked:)];
            [tabBarButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
            tabBarButton.leadingConstraint = [tabBarButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:itemWidth*i];
            tabBarButton.leadingConstraint.active = YES;
            tabBarButton.widthConstraint = [tabBarButton.widthAnchor constraintEqualToConstant:itemWidth];
            tabBarButton.widthConstraint.active = YES;
            [tabBarButton.heightAnchor constraintGreaterThanOrEqualToConstant:49].active = YES;
            [temp addObject:tabBarButton];
            
        }
        self.tabBarItems = [temp copy];
    }
    
}

- (void)refreshTabBarItems {
    for (int i = 0; i < self.tabBarItems.count && i < self.tabBarItemConfigArray.count; i++) {
        LLTabBarItem *tabBarButton = self.tabBarItems[i];
        NSDictionary *data = self.tabBarItemConfigArray[i];
        if ([[data objectForKey:LLTabBarItemTitleNormalKey] isKindOfClass:[NSString class]] && [[data objectForKey:LLTabBarItemTitleNormalKey] length] > 0) {
            [tabBarButton setAttributedTitle:[[NSAttributedString alloc] initWithString:data[LLTabBarItemTitleNormalKey] attributes:@{NSFontAttributeName:_font, NSForegroundColorAttributeName:_normalColor}] forState:UIControlStateNormal];
        }else {
            [tabBarButton setAttributedTitle:nil forState:UIControlStateNormal];
        }
        if ([[data objectForKey:LLTabBarItemTitleSelectKey] isKindOfClass:[NSString class]] && [[data objectForKey:LLTabBarItemTitleSelectKey] length] > 0) {
            [tabBarButton setAttributedTitle:[[NSAttributedString alloc] initWithString:data[LLTabBarItemTitleSelectKey] attributes:@{NSFontAttributeName:_selectedFont, NSForegroundColorAttributeName:_selectetColor}] forState:UIControlStateSelected];
        }else {
            [tabBarButton setAttributedTitle:nil forState:UIControlStateSelected];
        }
        
        if ([[data objectForKey:LLTabBarItemImageNormalKey] isKindOfClass:[NSString class]]) {
            [tabBarButton setImage:[UIImage imageNamed:data[LLTabBarItemImageNormalKey]] forState:UIControlStateNormal];
        }else {
            [tabBarButton setImage:nil forState:UIControlStateNormal];
        }
        if ([[data objectForKey:LLTabBarItemImageSelectKey] isKindOfClass:[NSString class]]) {
            [tabBarButton setImage:[UIImage imageNamed:data[LLTabBarItemImageSelectKey]] forState:UIControlStateSelected];
        }else {
            [tabBarButton setImage:nil forState:UIControlStateSelected];
        }
    }
}

- (void)didClicked:(LLTabBarItem *)sender {
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

- (void)setItemBadgeValue:(NSUInteger)value atIndex:(NSUInteger)index {
    if (index >= 0 && index < self.tabBarItems.count) {
        LLTabBarItem *target = [self.tabBarItems objectAtIndex:index];
        [target setBadgeValue:value];
    }
}
- (void)moveItemBadgeAtIndex:(NSUInteger)index offset:(UIOffset)offset {
    if (index >= 0 && index < self.tabBarItems.count) {
        LLTabBarItem *target = [self.tabBarItems objectAtIndex:index];
        [target setBadgeOffset:offset];
    }
}
- (void)setItemPersistWhenBadgeValueZero:(BOOL)isPersist atIndex:(NSUInteger)index {
    if (index >= 0 && index < self.tabBarItems.count) {
        LLTabBarItem *target = [self.tabBarItems objectAtIndex:index];
        [target setPersistWhenZero:isPersist];
    }
}
- (void)persistAllItemWhenBadgeValueZero:(BOOL)isPersist {
    for (LLTabBarItem *item in  self.tabBarItems) {
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
