//
//  ZZSwitchItemView.h
//  LEIS_CSE
//
//  Created by 尹中正(外包) on 15/12/15.
//  Copyright © 2015年 pingan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSwitchItemHeader.h"
#import "ZZSwitchBottomView.h"
@protocol ZZSwithViewDelegate;
@protocol ZZSwithViewDataSource;

typedef NS_ENUM(NSInteger, ZZSwitchItemViewSeparatorStyle) {
    ZZSwitchItemViewSeparatorStyleNone, // 不添加分割线
    ZZSwitchItemViewSeparatorStyleSingleLine  // 默认
};

typedef NS_ENUM(NSInteger, ZZTipViewStyle) {
    ZZTipViewNone, // 不添加
    ZZTipViewBottom,  // 默认
};

@interface ZZSwitchItemView : UIView
/**
 *  回调代理
 */
@property (weak, nonatomic) id <ZZSwithViewDelegate> delegate;
/**
 *  数据源
 */
@property (weak, nonatomic) id <ZZSwithViewDataSource> dataSource;

@property (assign, nonatomic, readonly) NSUInteger selectedIndex;
/**
 * 分割线样式，⚠️这个属性需要在设置代理前进行设置，一次设置不能更改。
 */
@property (assign, nonatomic) ZZSwitchItemViewSeparatorStyle separatorStyle;
/**
 * 分割线颜色，默认为[UIColor colorWithRed:(229 / 255.0) green:(230 / 255.0) blue:(231 / 255.0) alpha:1.0]
 */
@property (strong, nonatomic) UIColor *separatorColor;
/**
 * 底部分割线颜色
 */
@property (strong, nonatomic) UIColor *bottomSeparatorColor;
/**
 *  标题下面的view
 */
@property (strong, nonatomic, readonly) ZZSwitchBottomView *tipView;

@property (assign, nonatomic) ZZTipViewStyle tipStyle;

@property (strong, nonatomic) UIColor *tipViewColor;

/**
 *  设置选中item的索引
 *
 *  @param index    索引
 *  @param animated 是否有动画
 */
-(void)setSelectedItemIndex:(NSInteger)index animated:(BOOL)animated;

@end

@protocol ZZSwithViewDelegate <NSObject>

@optional
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

@optional

- (UIFont *)switchView:(ZZSwitchItemView *)switchView fontForSelectedStatus:(BOOL)status;

- (UIColor *)switchView:(ZZSwitchItemView *)switchView titleColorForselectedStatus:(BOOL)status;


@end
