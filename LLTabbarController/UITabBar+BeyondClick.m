//
//  UITabBar+BeyondClick.m
//  RootViewController
//
//  Created by 刘江 on 2019/7/29.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "UITabBar+BeyondClick.h"

@implementation UITabBar (BeyondClick)
static id target_ = nil;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        if ([target_ respondsToSelector:@selector(viewForBeyondSuperViewInterationAtPoint:)]) {
           return [target_ viewForBeyondSuperViewInterationAtPoint:point];
        }
//                // 转换坐标系
//                CGPoint newPoint = [self.button convertPoint:point fromView:self];
//                // 判断触摸点是否在button上
//                if (CGRectContainsPoint(self.button.bounds, newPoint)) {
//                    view = self.button;
//                }
    }
    return view;
}

- (void)setBeyondClickCallbackTarget:(id)target {
    target_ = target;
}

@end
