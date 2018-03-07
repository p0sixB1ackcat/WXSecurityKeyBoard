//
//  WXSecKeyBoardView.m
//  WXSecurityKeyBoardDemo
//
//  Created by WuXian on 16/9/2.
//  Copyright © 2016年 WuXian. All rights reserved.
//

#import "WXSecKeyBoardView.h"
#import "WXSecKeyBoard.h"
#import "WXSecInputView.h"
#import "WXKeyBoardAPI.h"
#import "WXSecKeyBoardUtils.h"

@interface WXSecKeyBoardView ()

@property (nonatomic,weak) WXSecKeyBoard * keyBoard;

@property (nonatomic,weak) WXSecInputView * inputView;

@property (nonatomic,weak) UIButton * cover;

@property (nonatomic,weak) UITextField * responsder;

@property (nonatomic,assign,getter=isKeyBoardShow) BOOL keyBoardShow;

@property (nonatomic,copy) NSString * pwd;

@end

@implementation WXSecKeyBoardView

+ (instancetype)sharedInstance
{
    return [[self alloc] init];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cover.frame = self.bounds;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:CURRENTDEVICESCREENBOUNDS])
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self setupCover];
        
        [self setupKeyBoard];
        
        [self setupInputView];
        
        //[self setupResponsder];
        
    }
    return self;
}



- (void)setupCover
{
    UIButton * cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cover];
    self.cover = cover;
    [self.cover setBackgroundColor:[UIColor grayColor]];
    //self.cover.alpha = 0.4;
    [self.cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupResponsder
{
    UITextField * response = [[UITextField alloc] init];
    [self addSubview:response];
    self.responsder = response;
}

- (void)setupKeyBoard
{
    WXSecKeyBoard * keyBoard = [[WXSecKeyBoard alloc] init];
    [self addSubview:keyBoard];
    self.keyBoard = keyBoard;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ok) name:WXSecKeyBoardOkButtonClick object:nil];
    
}

- (void)setupInputView
{
    WXSecInputView * inputView = [[WXSecInputView alloc] init];
    
    [self addSubview:inputView];
    self.inputView = inputView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel) name:WXSecInputViewCancelButtonClick object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputViewOk:) name:WXSecInputViewOkButtonClick object:nil];
    
}

- (void)coverClick
{
    if(self.isKeyBoardShow)
    {
        [self hideKeyBoard:nil];
    }
    else
    {
        [self showKeyBoard];
    }
    
}

- (void)showKeyBoard
{
    self.keyBoardShow = YES;
    
    CGFloat marginTop;
    
    if(iDevice3_5)
    {
        marginTop = 42;
    }
    else if (iDevice4_0)
    {
        marginTop = 100;
    }
    else if (iDevice4_7)
    {
        marginTop = 120;
    }
    else
    {
        marginTop = 140;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.keyBoard.transform = CGAffineTransformMakeTranslation(0, -self.keyBoard.frame.size.height);
        self.inputView.transform = CGAffineTransformMakeTranslation(0, marginTop - self.inputView.frame.origin.y);
        
        
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hideKeyBoard:(void (^)(BOOL finished))completion
{
    self.keyBoardShow = NO;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.keyBoard.transform = CGAffineTransformIdentity;
        self.inputView.transform = CGAffineTransformIdentity;
        
    } completion:completion];
}

- (void)ok
{
    NSLog(@"%s",__func__);
    [self hideKeyBoard:nil];
}

- (void)show
{
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    self.keyBoard.frame = CGRectMake(0, CURRENTDEVICESCREENHEIGHT, CURRENTDEVICESCREENWIDTH, CURRENTDEVICESCREENWIDTH * 0.65);
    
    CGRect frame;
    frame.size.height = CURRENTDEVICESCREENWIDTH * 0.5625;
    frame.origin.y = (self.frame.size.height - frame.size.height) * 0.5;
    frame.size.width = CURRENTDEVICESCREENWIDTH * 0.94375;
    frame.origin.x = (CURRENTDEVICESCREENWIDTH - frame.size.width) * 0.5;
    self.inputView.frame = frame;
    
    [self showKeyBoard];
    
}

- (void)inputViewOk:(NSNotification *)userInfo
{
    NSString * pwd = userInfo.userInfo[WXSecInputViewPwdKey];
    
    [WXSecKeyBoardUtils initializePrivate:nil];
    [WXSecKeyBoardUtils initializPublicKey:WXSecKeyBoardRSAPublicKey];
    
    NSString *encstr = [WXSecKeyBoardUtils encryptRSA:pwd];
    NSLog(@"加密键盘记录:%@",encstr);
    NSString *decstr = [WXSecKeyBoardUtils decryptRSA:encstr];
    NSLog(@"解密键盘记录 == %@",decstr);
    
    [WXSecKeyBoardUtils removeHomeKeyPath];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(finish:)])
    {
        [self.delegate finish:pwd];
    }
    
    if(self.finish)
    {
        self.finish(pwd);
    }
    
    [self hideKeyBoard:^(BOOL finished) {
        NSMutableArray * nums = [self.inputView valueForKeyPath:@"nums"];
        [nums removeAllObjects];
        
        [self removeFromSuperview];
        [self.inputView setNeedsDisplay];
    }];
}

- (void)cancel
{
    [self hideKeyBoard:^(BOOL finished) {
        
        self.inputView.hidden = NO;
        NSMutableArray * nums = [self.inputView valueForKeyPath:@"nums"];
        
        [nums removeAllObjects];
        
        [self removeFromSuperview];
        
        [self.inputView setNeedsDisplay];
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
