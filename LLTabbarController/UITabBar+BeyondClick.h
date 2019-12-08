//
//  UITabBar+BeyondClick.h
//  RootViewController
//
//  Created by 刘江 on 2019/7/29.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (BeyondClick)

- (void)setBeyondClickCallbackTarget:(id)target;
- (UIView *)viewForBeyondSuperViewInterationAtPoint:(CGPoint)point;
    
@end

NS_ASSUME_NONNULL_END
