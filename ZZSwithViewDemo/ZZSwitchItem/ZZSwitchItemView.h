//
//  ZZSwitchItemView.h
//  LEIS_CSE
//
//  Created by 尹中正(外包) on 15/12/15.
//  Copyright © 2015年 pingan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSwitchItemHeader.h"
@protocol ZZSwithViewDelegate;
@protocol ZZSwithViewDataSource;

@interface ZZSwitchItemView : UIView
/**
 *  回调代理
 */
@property (weak, nonatomic) id <ZZSwithViewDelegate> delegate;
/**
 *  数据源
 */
@property (weak, nonatomic) id <ZZSwithViewDataSource> dataSource;
/**
 *  设置选中item的索引
 *
 *  @param index    索引
 *  @param animated 是否有动画
 */
-(void)setSelectedItemIndex:(NSInteger)index animated:(BOOL)animated;

@end

@protocol ZZSwithViewDelegate <NSObject>
/**
 *  当某一个item被点击时出发回调
 *
 *  @param switchView 选中的switchView
 *  @param index      选中item的索引
 */
- (void)switchView:(ZZSwitchItemView *)switchView didSelectAtIndex:(NSInteger)index;

@end

@protocol ZZSwithViewDataSource <NSObject>

@required

- (NSInteger)numberOfItemInSwitchView:(ZZSwitchItemView *)switchView;

- (NSString *)switchView:(ZZSwitchItemView *)switchView titleForItemAtIndex:(NSInteger)index;

@end
