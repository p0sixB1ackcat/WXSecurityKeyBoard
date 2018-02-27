//
//  WXSecKeyBoard.m
//  WXSecurityKeyBoardDemo
//
//  Created by WuXian on 16/9/1.
//  Copyright © 2016年 WuXian. All rights reserved.
//

#import "WXSecKeyBoard.h"
#import <AudioToolbox/AudioToolbox.h>

#define WXSecKeyBoardBtnCount 12
#define TENASCIIGAPBETWEEN 48

@interface WXSecKeyBoard ()

@property (nonatomic,strong) NSMutableArray * numBtns;

@property (nonatomic,strong) NSMutableArray * titles;

@end

@implementation WXSecKeyBoard

- (NSMutableArray *)numBtns
{
    if(_numBtns == nil)
    {
        _numBtns = [NSMutableArray array];
    }
    return _numBtns;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger totalCol = 3;
    
    CGFloat pad = CURRENTDEVICESCREENWIDTH * 0.015625;
    
    CGFloat x,y;
    CGFloat w = CURRENTDEVICESCREENWIDTH * 0.3125;
    CGFloat h = CURRENTDEVICESCREENWIDTH * 0.14375;
    
    NSInteger row;
    NSInteger col;
    
    int i;
    for(i = 0;i < WXSecKeyBoardBtnCount; i++)
    {
        row = i / totalCol;
        col = i % totalCol;
        x = pad + col * (w + pad);
        y = pad + row * (h + pad);
        UIButton * btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, w, h);
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if(self == [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
                
        [self addBtn];
        
        
    }
    return self;
}



- (void)addBtn
{
    int i;
    [self setRandTitleArr];
    for(i = 0; i < WXSecKeyBoardBtnCount; i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchDown];
        [btn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/number_bg"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        if(i == 9)
        {
            [btn setTitle:@"隐藏" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width * 0.046875];
            [btn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (i == 10)
        {
            [btn setTitle:self.titles[i-1] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:CURRENTDEVICESCREENWIDTH * 0.06875];
            btn.tag = [[self.titles objectAtIndex:i-1] intValue] + TENASCIIGAPBETWEEN;
            [btn addTarget:self action:@selector(numberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.numBtns addObject:btn];
        }
        else if (i == 11)
        {
            [btn setTitle:@"删除" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:CURRENTDEVICESCREENWIDTH * 0.046875];
            [btn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [btn setTitle:self.titles[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:CURRENTDEVICESCREENWIDTH * 0.06875];
            btn.tag = [[self.titles objectAtIndex:i] integerValue] + TENASCIIGAPBETWEEN;
            [btn addTarget:self action:@selector(numberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)setRandTitleArr
{
    if(self.titles == nil)
    {
        self.titles = [NSMutableArray array];
    }
    NSMutableArray * lastTitles = nil;
    if(self.titles.count > 0)
    {
        lastTitles = [self.titles mutableCopy];
        [self.titles removeAllObjects];
    }
    
    for(int i = 0; i < 10; i++)
    {
        NSString * lastnumstr = @"0";
        if(lastTitles.count > 0)
        {
            lastnumstr = lastTitles[i];
        }
        int lastnum = [lastnumstr intValue];
        
        int num = arc4random() % 10;
        
        while(abs(lastnum - num) < 3)
        {
            num = arc4random() % 10;
            
        }
        
        NSString * title = [NSString stringWithFormat:@"%d",num];
        
        while([self.titles containsObject:title])
        {
            num = arc4random() % 10;
            
            //if(num >= lastnum - 3 || num < lastnum - 3)
            {
                title = [NSString stringWithFormat:@"%d",num];
            }
            
        }
        [self.titles addObject:title];
        
    }
}


- (void)numberBtnClick:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectKeyBoard:number:)])
    {
        [self.delegate selectKeyBoard:self number:sender.tag-TENASCIIGAPBETWEEN];
    }
    
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
    
    userInfo[WXSecKeyBoardNumberKey] = @(sender.tag - TENASCIIGAPBETWEEN);
    [[NSNotificationCenter defaultCenter] postNotificationName:WXSecKeyBoardNumberButtonClick object:sender userInfo:userInfo];
    
    [self setRandTitleArr];
    
    for(int i = 0; i < self.titles.count;i++)
    {
        UIButton * btn = self.subviews[i];
        if(i<self.titles.count - 1)
        {
            [btn setTitle:self.titles[i] forState:UIControlStateNormal];
            btn.tag = TENASCIIGAPBETWEEN + [[self.titles objectAtIndex:i] intValue];
        }
    }
    
    UIButton * zeroBtn = self.subviews[10];
    [zeroBtn setTitle:[self.titles lastObject] forState:UIControlStateNormal];
    zeroBtn.tag = [[self.titles lastObject] integerValue] + TENASCIIGAPBETWEEN;

    
}

- (void)deleteBtnClick
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectKeyBoardDelete)])
    {
        [self.delegate selectKeyBoardDelete];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WXSecKeyBoardDeleteButtonClick object:nil];
}

- (void)okBtnClick
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectKeyBoardOk)])
    {
        [self.delegate selectKeyBoardOk];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:WXSecKeyBoardOkButtonClick object:nil];
}

/**
 *  键盘音
 */
- (void)playAudio
{
    NSString * soundPath = @"/System/Library/Audio/UISounds/Tock.caf";
    UInt32 soundID = kSystemSoundID_Vibrate;
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
    if(error != kAudioServicesNoError)
    {
        perror("AudioServiceCreateSystemSoundId");
        return;
    }
    
    AudioServicesPlaySystemSound(soundID);
    
}

@end
