//
//  LLTabBarItem.m
//  LLTabbarController
//
//  Created by 刘江 on 2019/12/13.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "LLTabBarItem.h"

@interface LLTabBarItem ()
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, strong)UIImage *imageNormal;
@property (nonatomic, strong)UIImage *imageSelected;
@property (nonatomic, strong)NSAttributedString *attrStringNormal;
@property (nonatomic, strong)NSAttributedString *attrStringSelected;

@property (nonatomic, weak)id target;
@property (nonatomic)SEL selector;

@end
@implementation LLTabBarItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].lastObject;
        [self addSubview:self.contentView];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [self viewWithTag:332 inView:self.contentView];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [self viewWithTag:333 inView:self.contentView];
    }
    return _titleLabel;
}

- (__kindof UIView *)viewWithTag:(NSInteger)tag inView:(UIView *)superView {
    for (UIView *subview in superView.subviews) {
        if (subview.tag == tag) {
            return subview;
        }else if (subview.subviews.count > 0) {
            return [self viewWithTag:tag inView:subview];
        }
    }
    return nil;
}
- (CGFloat)stringWidthFromLabel:(UILabel *)label {
    return MAX([label.text boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font} context:nil].size.width, 19);
}

- (UILabel *)boringBadge {
    if (!_boringBadge) {
        _boringBadge = [UILabel new];
        _boringBadge.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_boringBadge];
        [_boringBadge.leadingAnchor constraintEqualToAnchor:self.badgeLabel.leadingAnchor].active = YES;
        [_boringBadge.topAnchor constraintEqualToAnchor:self.badgeLabel.topAnchor constant:5].active = YES;
        [_boringBadge.widthAnchor constraintEqualToConstant:6].active = YES;
        [_boringBadge.heightAnchor constraintEqualToConstant:6].active = YES;
        _boringBadge.layer.cornerRadius = 3;
        _boringBadge.layer.masksToBounds = YES;
        _boringBadge.backgroundColor = self.badgeLabel.backgroundColor;
        _boringBadge.hidden = YES;
    }
    return _boringBadge;
}

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_badgeLabel];
        _badgeLabel.backgroundColor = [UIColor colorWithRed:249/255.f green:64/255.f blue:57/255.f alpha:1];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.layer.cornerRadius = 19/2.0;
        _badgeLabel.layer.masksToBounds = YES;
        if (UIOffsetEqualToOffset(self.badgeOffset, UIOffsetZero)) {
            [_badgeLabel.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:-7].active = YES;
            [_badgeLabel.topAnchor constraintEqualToAnchor:self.imageView.topAnchor constant:0].active = YES;
        }else {
            [_badgeLabel.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:self.badgeOffset.horizontal].active = YES;
            [_badgeLabel.topAnchor constraintEqualToAnchor:self.imageView.topAnchor constant:self.badgeOffset.vertical].active = YES;
        }
        [_badgeLabel.heightAnchor constraintEqualToConstant:19].active = YES;
        self.badgeLabel_width = [_badgeLabel.widthAnchor constraintEqualToConstant:19];
        self.badgeLabel_width.active = YES;
    }
    return _badgeLabel;
}

- (void)setBadgeOffset:(UIOffset)badgeOffset {
    _badgeOffset = badgeOffset;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(badgeOffset.horizontal, badgeOffset.vertical);
    self.badgeLabel.transform = transform;
}
- (void)setBadgeValue:(NSUInteger)badgeValue {
    if (badgeValue != _badgeValue || badgeValue == 0) {
        _badgeValue = badgeValue;
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

- (void)setSelected:(BOOL)selected {
    if (self.selected != selected) {
        _selected = selected;
        if (self.selected) {
            self.imageView.image = self.imageSelected;
            self.titleLabel.attributedText = self.attrStringSelected;
        }else {
            self.imageView.image = self.imageNormal;
            self.titleLabel.attributedText = self.attrStringNormal;
        }
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    if (state == UIControlStateNormal) {
        self.imageNormal = image;
        if (!self.selected) {
            self.imageView.image = image;
        }
    }else if (state == UIControlStateSelected) {
        self.imageSelected = image;
        if (self.selected) {
            self.imageView.image = image;
        }
    }
}
- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state {
    if (state == UIControlStateNormal) {
        self.attrStringNormal = title;
        if (!self.selected) {
            self.titleLabel.attributedText = title;
        }
    }else if (state == UIControlStateSelected) {
        self.attrStringSelected = title;
        if (self.selected) {
            self.titleLabel.attributedText = title;
        }
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)tapAction {
    [self.target performSelector:self.selector withObject:self];
}

#pragma clang diagnostic pop
- (void)addTarget:(id)target action:(SEL)aSelector {
    self.target = target;
    self.selector = aSelector;
}
@end
