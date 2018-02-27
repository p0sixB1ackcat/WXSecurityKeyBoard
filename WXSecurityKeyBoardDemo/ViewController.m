//
//  ViewController.m
//  WXSecurityKeyBoardDemo
//
//  Created by WuXian on 16/9/1.
//  Copyright © 2016年 WuXian. All rights reserved.
//

#import "ViewController.h"
#import "WXSecKeyBoardView.h"
#import "WXSecKeyBoardUtils.h"
#import <objc/runtime.h>


@interface ViewController ()
{
    WXSecKeyBoardView * _keyBoard;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setIostream:(id)object
{
    objc_setAssociatedObject(self, @selector(iostream), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSData *)iostream
{
    return objc_getAssociatedObject(self, @selector(iostream));
}

- (IBAction)showKeyBoard:(id)sender {
    
    if(_keyBoard == nil)
    {
        _keyBoard = [[WXSecKeyBoardView alloc] init];
        
    }
    
    [_keyBoard show];
    
    _keyBoard.finish = ^ (NSString * pwd)
    {
      
        NSLog(@"pwd is %@",pwd);
        
    };
    
}
- (IBAction)hide:(id)sender {
    
    [WXSecKeyBoardUtils removeHomeKeyPath];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
