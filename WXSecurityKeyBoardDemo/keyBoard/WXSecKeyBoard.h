//
//  WXSecKeyBoard.h
//  WXSecurityKeyBoardDemo
//
//  Created by WuXian on 16/9/1.
//  Copyright © 2016年 WuXian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXKeyBoardAPI.h"

static NSString * const WXSecKeyBoardOkButtonClick = @"WXSecKeyBoardOkButtonClick";
static NSString * const WXSecKeyBoardDeleteButtonClick = @"WXSecKeyBoardDeleteButtonClick";
static NSString * const WXSecKeyBoardNumberButtonClick = @"WXSecKeyBoardNumberButtonClick";
static NSString * const WXSecKeyBoardNumberKey = @"WXSecKeyBoardNumberKey";

@class WXSecKeyBoard;

@protocol WXSecKeyBoardDelegate <NSObject>

- (void)selectKeyBoard:(WXSecKeyBoard *)keyBoard number:(NSInteger)num;

- (void)selectKeyBoardDelete;

- (void)selectKeyBoardOk;

@end

@interface WXSecKeyBoard : UIView

@property (nonatomic,weak) id <WXSecKeyBoardDelegate> delegate;

@end
