//
//  ViewController.m
//  Up
//
//  Created by bamq on 16/7/19.
//  Copyright © 2016年 bamq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 100)];
    [self.view addSubview:btn];
    btn.backgroundColor =[UIColor blueColor];
    [btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)clickAction{
    NSLog(@"%@",[NSDate date]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
