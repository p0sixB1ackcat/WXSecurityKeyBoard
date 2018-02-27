//
//  WXKeyBoardAPI.h
//  WXSecurityKeyBoardDemo
//
//  Created by WuXian on 16/9/2.
//  Copyright © 2016年 WuXian. All rights reserved.
//

#ifndef WXKeyBoardAPI_h
#define WXKeyBoardAPI_h

#define CURRENTDEVICESCREENBOUNDS [UIScreen mainScreen].bounds

#define CURRENTDEVICESCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define CURRENTDEVICESCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define iDevice3_5 ([UIScreen mainScreen].bounds.size.height == 480)
#define iDevice4_0 ([UIScreen mainScreen].bounds.size.height == 568)
#define iDevice4_7 ([UIScreen mainScreen].bounds.size.height == 667)
#define iDevice5_5 ([UIScreen mainScreen].bounds.size.height == 736)
#define iPadMini2 ([UIScreen mainScreen].bounds.size.height == 1024)

#endif /* WXKeyBoardAPI_h */
