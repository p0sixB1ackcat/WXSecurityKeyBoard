//
//  WXSecInputView.h
//  WXSecurityKeyBoardDemo
//
//  Created by WuXian on 16/9/1.
//  Copyright © 2016年 WuXian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXSecInputView;

static NSString * const WXSecInputViewCancelButtonClick = @"WXSecInputViewCancelButtonClick";
static NSString * const WXSecInputViewOkButtonClick = @"WXSecInputViewOkButtonClick";
static NSString * const WXSecInputViewPwdKey = @"WXSecInputViewPwdKey";

@protocol WXSecInputViewDelegate <NSObject>

@optional
- (void)selectInputView:(WXSecInputView *)inputView ok:(UIButton *)sender;

- (void)selectInputView:(WXSecInputView *)inputView cancel:(UIButton *)sender;

@end

@interface WXSecInputView : UIView

@property (nonatomic,weak) id <WXSecInputViewDelegate>delegate;

@end
