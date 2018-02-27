//
//  WXSecKeyBoardView.h
//  WXSecurityKeyBoardDemo
//
//  Created by WuXian on 16/9/2.
//  Copyright © 2016年 WuXian. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WXSecKeyBoardViewDelegate <NSObject>

@optional
- (NSString *)finish:(NSString *)pwd;

@end

@interface WXSecKeyBoardView : UIView

@property (nonatomic,weak) id <WXSecKeyBoardViewDelegate>delegate;

@property (nonatomic,copy) void (^finish)(NSString *);


+ (instancetype)sharedInstance;

- (void)show;

- (void)showInView:(UIView *)view;

@end
