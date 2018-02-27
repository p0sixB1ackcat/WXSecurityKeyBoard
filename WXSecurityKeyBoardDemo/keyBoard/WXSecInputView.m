//
//  WXSecInputView.m
//  WXSecurityKeyBoardDemo
//
//  Created by WuXian on 16/9/1.
//  Copyright © 2016年 WuXian. All rights reserved.
//

#import "WXSecInputView.h"
#import "WXSecKeyBoard.h"

#define WXSecInputViewNumCount 6

typedef enum
{
    WXSecInputButtonTypeCancel = 1000,
    WXSecInputButtonTypeOk = 2000
    
}WXSecInputButtonType;

@interface WXSecInputView ()
{
    
}

@property (nonatomic,strong) NSMutableArray * nums;

@property (nonatomic,weak) UIButton * okButton;

@property (nonatomic,weak) UIButton * cancelButton;

@end

@implementation WXSecInputView

- (NSMutableArray *)nums
{
    if(_nums == nil)
    {
        _nums = [NSMutableArray array];
    }
    return _nums;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self setupKeyboardNote];
        
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview
{
    UIButton * okbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:okbtn];
    self.okButton = okbtn;
    [self.okButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.okButton setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_ok_up"] forState:UIControlStateNormal];
    [self.okButton setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_ok_down"] forState:UIControlStateHighlighted];
    self.okButton.tag = WXSecInputButtonTypeOk;
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancelBtn];
    
    self.cancelButton = cancelBtn;
    
    [self.cancelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel_up"] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel_down"] forState:UIControlStateHighlighted];
    self.cancelButton.tag = WXSecInputButtonTypeCancel;
    
}

- (void)setupKeyboardNote
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete) name:WXSecKeyBoardDeleteButtonClick object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ok) name:WXSecKeyBoardOkButtonClick object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(number:) name:WXSecKeyBoardNumberButtonClick object:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect cancelBtnFrame;
    cancelBtnFrame.size.width = CURRENTDEVICESCREENWIDTH * 0.409375;
    cancelBtnFrame.size.height = CURRENTDEVICESCREENWIDTH * 0.128125;
    cancelBtnFrame.origin.x  = CURRENTDEVICESCREENWIDTH * 0.05;
    cancelBtnFrame.origin.y = self.frame.size.height - (CURRENTDEVICESCREENWIDTH * 0.05 + cancelBtnFrame.size.height);
    
    self.cancelButton.frame = cancelBtnFrame;
    
    CGRect okBtnFrame;
    okBtnFrame.origin.y = self.cancelButton.frame.origin.y;
    okBtnFrame.size.width = self.cancelButton.frame.size.width;
    okBtnFrame.size.height = self.cancelButton.frame.size.height;
    okBtnFrame.origin.x = CGRectGetMaxX(self.cancelButton.frame) + CURRENTDEVICESCREENWIDTH * 0.025;
    self.okButton.frame = okBtnFrame;
    
}

- (void)delete
{
    [self.nums removeLastObject];
    [self setNeedsDisplay];
}

- (void)ok
{
    
}
- (void)number:(NSNotification *)note
{
    if(self.nums.count >= WXSecInputViewNumCount)
        return;
    NSDictionary * userInfo = note.userInfo;
    NSNumber * numObj = userInfo[WXSecKeyBoardNumberKey];
    [self.nums addObject:numObj];
    [self setNeedsDisplay];
}

- (void)btnClick:(UIButton *)sender
{
    if(sender.tag == WXSecInputButtonTypeCancel)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(selectInputView:cancel:)])
        {
            [self.delegate selectInputView:self cancel:sender];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:WXSecInputViewCancelButtonClick object:self];
    }
    else if (sender.tag == WXSecInputButtonTypeOk)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(selectInputView:ok:)])
        {
            [self.delegate selectInputView:self ok:sender];
        }
        NSMutableString * pwd = [NSMutableString string];
        
        for(int i = 0; i < self.nums.count;i++)
        {
            [pwd appendFormat:@"%@",self.nums[i]];
        }
        
        
        NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
        
        userInfo[WXSecInputViewPwdKey] = pwd;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WXSecInputViewOkButtonClick object:self userInfo:userInfo];
    }
    else
    {
        
    }
}

- (void)drawRect:(CGRect)rect
{
    UIImage * bg = [UIImage imageNamed:@"trade.bundle/pssword_bg"];
    UIImage * field = [UIImage imageNamed:@"trade.bundle/password_in"];
    
    [bg drawInRect:rect];
    
    CGFloat x = CURRENTDEVICESCREENWIDTH * 0.096875 * 0.5;
    CGFloat y = CURRENTDEVICESCREENWIDTH * 0.40625 * 0.5;
    CGFloat w = CURRENTDEVICESCREENWIDTH * 0.846875;
    CGFloat h = CURRENTDEVICESCREENWIDTH * 0.121875;
    [field drawInRect:CGRectMake(x, y, w, h)];
    
    NSString * title = @"请输入交易密码";
    
    NSDictionary * arrts = @{NSFontAttributeName:[UIFont systemFontOfSize:CURRENTDEVICESCREENWIDTH * 0.053125]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
    CGFloat titleW = size.width;
    CGFloat titleH = size.height;
    CGFloat titleX = (self.frame.size.width - titleW) * 0.5;
    CGFloat titleY = CURRENTDEVICESCREENWIDTH * 0.03125;
    CGRect titleRect = CGRectMake(titleX, titleY, titleW, titleH);
    
    NSMutableDictionary * attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:CURRENTDEVICESCREENWIDTH * 0.053125];
    attr[NSForegroundColorAttributeName] = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1];
    [title drawInRect:titleRect withAttributes:attr];
    
    UIImage * pointImage = [UIImage imageNamed:@"trade.bundle/yuan"];
    CGFloat pointW = CURRENTDEVICESCREENWIDTH * 0.05;
    CGFloat pointH = pointW;
    CGFloat pointY = CURRENTDEVICESCREENWIDTH * 0.24;
    CGFloat pointX;
    CGFloat margin = CURRENTDEVICESCREENWIDTH * 0.0484375;
    CGFloat padding = CURRENTDEVICESCREENWIDTH * 0.045578125;
    for(int i = 0; i < self.nums.count;i++)
    {
        pointX = margin + padding + i * (pointW + 2 * padding);
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }
    BOOL statue = NO;
    if(self.nums.count == WXSecInputViewNumCount)
    {
        statue = YES;
    }
    else
    {
        statue = NO;
    }
    self.okButton.enabled = statue;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
