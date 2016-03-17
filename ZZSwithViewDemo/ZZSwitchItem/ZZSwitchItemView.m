//
//  ZZSwitchItemView.m
//  LEIS_CSE
//
//  Created by 尹中正(外包) on 15/12/15.
//  Copyright © 2015年 pingan. All rights reserved.
//

#import "ZZSwitchItemView.h"
#import "ZZSwitchItemButton.h"
#import "ZZSwitchBottomView.h"

static const CGFloat intervalLineHeight = 20.0f;
static const CGFloat intervalLineWidth = 1.0f;
static const CGFloat intervalBetweenTitleAndView = 4.0f;
static const CGFloat titleBottomViewHeight = 3.0;
static const CGFloat bottomLineHeight = 1.0f;

@interface ZZSwitchItemView ()
{
    NSInteger _layoutFinish;
}
/**
 *  标题下面的view
 */
@property (strong, nonatomic) ZZSwitchBottomView *bottomView;
/**
 *  ZZSwitchItemButton数组
 */
@property (strong, nonatomic) NSArray *buttonArray;

@end

@implementation ZZSwitchItemView

#pragma mark - 初始化
#pragma mark 初始化
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - bottomLineHeight, CGRectGetWidth(frame), bottomLineHeight)];
        bottomLineView.backgroundColor = SwitchButtonBottomLineColor;
        [self addSubview:bottomLineView];
    }
    return self;
}

-(void)layoutSubviews {
    if (_layoutFinish <= 2) {
        _layoutFinish++;
    }
    if (_layoutFinish == 2) {
        if (!_bottomView) {
            ZZSwitchItemButton *button = _buttonArray.firstObject;
            CGRect rect = button.titleLabel.frame;
            [self initBottomLineViewWithFrame:CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(rect) + intervalBetweenTitleAndView, CGRectGetWidth(rect), titleBottomViewHeight)];
        }
    }
}

#pragma mark 初始化底部线
-(void)initBottomLineViewWithFrame:(CGRect)frame {
    _bottomView = [[ZZSwitchBottomView alloc] initWithFrame:frame];
    _bottomView.backgroundColor = SwitchButtonBottomViewColor;
    [self addSubview:_bottomView];
}

#pragma mark - Actons
#pragma mark 选中某一个选项时，出发switchView:didSelectAtIndex:回调
-(void)buttonDidSelected:(ZZSwitchItemButton *)bnt {
    CGFloat buttonWith = self.frame.size.width / _buttonArray.count - _buttonArray.count * intervalLineWidth + intervalLineWidth;
    CGRect rect = bnt.titleLabel.frame;
    [UIView animateWithDuration:0.25 animations:^{
        _bottomView.frame = CGRectMake(buttonWith * bnt.tag + CGRectGetMinX(rect), CGRectGetMaxY(rect) + intervalBetweenTitleAndView, CGRectGetWidth(rect), titleBottomViewHeight);
    } completion:^(BOOL finished) {
        bnt.selected = YES;
    }];
    [self refreshButtonSelectedStatusWithIndex:bnt.tag];
    if (_delegate && [_delegate respondsToSelector:@selector(switchView:didSelectAtIndex:)]) {
        [_delegate switchView:self didSelectAtIndex:bnt.tag];
    }
}

#pragma mark - 私有方法， 工具方法
#pragma mark 刷新选项的选中状态
-(void)refreshButtonSelectedStatusWithIndex:(NSInteger)index {
    [_buttonArray enumerateObjectsUsingBlock:^(ZZSwitchItemButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (button.tag != index && button.isSelected == YES) {
            button.selected = NO;
            *stop = YES;
        }
    }];
}

-(CGFloat)buttomItemWidth {
    return self.frame.size.width / _buttonArray.count - _buttonArray.count * intervalLineWidth + intervalLineWidth;
}

#pragma mark - 公开方法
#pragma mark 手动设置选中哪一项
/**
 *  手动设置选中哪一项
 *
 *  @param index    要选中项的索引
 *  @param animated 是否有动画
 */
-(void)setSelectedItemIndex:(NSInteger)index animated:(BOOL)animated {
    if (index >= _buttonArray.count) {
        return;
    }
    ZZSwitchItemButton *button = _buttonArray[index];
    CGRect rect = button.titleLabel.frame;
    CGFloat buttonWith = [self buttomItemWidth];
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            _bottomView.frame = CGRectMake(buttonWith * index + CGRectGetMinX(rect), CGRectGetMaxY(rect) + intervalBetweenTitleAndView, CGRectGetWidth(rect), titleBottomViewHeight);
        } completion:^(BOOL finished) {
            button.selected = YES;
        }];
    } else {
        _bottomView.frame = CGRectMake(buttonWith * index + CGRectGetMinX(rect), CGRectGetMaxY(rect) + intervalBetweenTitleAndView, CGRectGetWidth(rect), titleBottomViewHeight);
        button.selected = YES;
    }
    [self refreshButtonSelectedStatusWithIndex:index];
}

#pragma mark - 设置
#pragma mark 数据源
-(void)setDataSource:(id<ZZSwithViewDataSource>)dataSource {
    if (!dataSource) {
        return;
    }
    _dataSource = dataSource;
    if ([dataSource respondsToSelector:@selector(numberOfItemInSwitchView:)]) {
        NSInteger count = [dataSource numberOfItemInSwitchView:self];
        if (count <= 0) {
            return;
        }
        CGFloat buttonWith = self.frame.size.width / count - count * intervalLineWidth + intervalLineWidth;
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger idx = 0; idx < count; idx++) {
            ZZSwitchItemButton *button = [[ZZSwitchItemButton alloc] initWithFrame:CGRectMake(buttonWith * idx, 0, buttonWith, self.frame.size.height - bottomLineHeight)];
            button.selected = (idx == 0);
            button.tag = idx;
            button.titleLabel.font = [UIFont systemFontOfSize:ZZSwitchItemButtonTitleSize];
            NSString *title = @"";
            if ([dataSource respondsToSelector:@selector(switchView:titleForItemAtIndex:)]) {
                title = [dataSource switchView:self titleForItemAtIndex:idx];
            }
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:SwitchButtonNormalColor forState:UIControlStateNormal];
            [button setTitleColor:SwitchButtonSelectedColor forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [mutableArray addObject:button];
            if (idx != count - 1) {
                UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), (CGRectGetHeight(button.frame) - intervalLineHeight) / 2, intervalLineWidth, intervalLineHeight)];
                intervalView.backgroundColor = SwitchButtonIntervalViewColor;
                [self addSubview:intervalView];
            }
        }
        _buttonArray = [NSArray arrayWithArray:mutableArray];
    }
}

@end
