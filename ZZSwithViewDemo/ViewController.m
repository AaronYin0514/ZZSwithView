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
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _dataArray = @[@"测试1", @"测试2", @"测试3", @"测试4", @"测试5", @"测试6", @"测试7", @"测试8", @"测试9", @"测试10", @"测试11", @"测试12"];
    _switchItemView = [[ZZSwitchItemView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    _switchItemView.tipStyle = ZZTipViewNone;
    _switchItemView.delegate = self;
    _switchItemView.dataSource = self;
    [self.view addSubview:_switchItemView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
    button.frame = CGRectMake(100, 300, 80, 40);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
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

#pragma mark - Action
- (void)buttonClick:(UIButton *)btn {
    if (_switchItemView.selectedIndex + 1 < _dataArray.count) {
        [_switchItemView setSelectedItemIndex:(_switchItemView.selectedIndex + 1) animated:YES];
    } else {
        [_switchItemView setSelectedItemIndex:0 animated:YES];
    }
}

@end
