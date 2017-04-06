//
//  ViewController.m
//  ZZSwithViewDemo
//
//  Created by 尹中正(外包) on 16/3/16.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "ViewController.h"
#import "ZZSwitchItemView.h"

@interface ViewController () <ZZSwithViewDelegate, ZZSwithViewDataSource>
{
    NSArray *_dataArray;
    ZZSwitchItemView *_switchItemView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor redColor];
    _dataArray = @[@"测试一", @"测试二", @"测试三"];
    _switchItemView = [[ZZSwitchItemView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 44)];
    _switchItemView.delegate = self;
    _switchItemView.dataSource = self;
    [self.view addSubview:_switchItemView];
}

#pragma mark - ZZSwithViewDelegate
-(void)switchView:(ZZSwitchItemView *)switchView didSelectAtIndex:(NSInteger)index {
    NSLog(@"~~~~~~%ld", index);
}

#pragma mark - ZZSwithViewDataSource
- (NSInteger)numberOfItemInSwitchView:(ZZSwitchItemView *)switchView {
    return _dataArray.count;
}

- (NSString *)switchView:(ZZSwitchItemView *)switchView titleForItemAtIndex:(NSInteger)index {
    return _dataArray[index];
}


@end
