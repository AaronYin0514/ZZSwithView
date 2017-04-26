//
//  ZZSwitchItemView.m
//  LEIS_CSE
//
//  Created by 尹中正(外包) on 15/12/15.
//  Copyright © 2015年 pingan. All rights reserved.
//

#import "ZZSwitchItemView.h"
#import "ZZSwitchItemButton.h"


static const CGFloat intervalLineHeight = 20.0f;
static const CGFloat intervalLineWidth = 1.0f;
static const CGFloat titleBottomViewHeight = 3.0;
static const CGFloat bottomLineHeight = 1.0f;

static const CGFloat interValue = 16.0;

@interface ZZSwitchItemView ()
{
    NSInteger _layoutFinish;
}

/**
 *  ZZSwitchItemButton数组
 */
@property (strong, nonatomic) NSArray *buttonArray;

@property (strong, nonatomic) NSArray *separatorViewArray;

@property (strong, nonatomic) UIView *bottomSeparatorView;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation ZZSwitchItemView

#pragma mark - 初始化
#pragma mark 初始化
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.alwaysBounceVertical = NO;
        self.scrollView.bouncesZoom = NO;
        [self addSubview:self.scrollView];
        self.separatorStyle = ZZSwitchItemViewSeparatorStyleSingleLine;
        self.separatorColor = SwitchButtonIntervalViewColor;
        self.bottomSeparatorColor = SwitchButtonBottomLineColor;
        self.tipStyle = ZZTipViewBottom;
        self.tipViewColor = SwitchButtonBottomViewColor;
        _bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - bottomLineHeight, CGRectGetWidth(frame), bottomLineHeight)];
        _bottomSeparatorView.backgroundColor = self.bottomSeparatorColor;
        [self addSubview:_bottomSeparatorView];
    }
    return self;
}

-(void)layoutSubviews {
    if (_layoutFinish <= 2) {
        _layoutFinish++;
    }
}

- (void)setBottomSeparatorColor:(UIColor *)bottomSeparatorColor {
    _bottomSeparatorColor = bottomSeparatorColor;
    _bottomSeparatorView.backgroundColor = bottomSeparatorColor;
}

- (void)setTipViewColor:(UIColor *)tipViewColor {
    _tipViewColor = tipViewColor;
    if (_tipView != nil) {
        _tipView.backgroundColor = tipViewColor;
    }
}

//- (void)setSeparatorStyle:(ZZSwitchItemViewSeparatorStyle)separatorStyle {
//    if (_separatorStyle == separatorStyle) {
//        return;
//    }
//    _separatorStyle = separatorStyle;
//    if (separatorStyle == ZZSwitchItemViewSeparatorStyleNone) {
//        
//    }
//}

#pragma mark 初始化底部线
-(void)initBottomLineView {
    if (self.tipStyle != ZZTipViewNone) {
        CGFloat width = [self buttomItemWidthForIndex:0];
        CGRect rect = CGRectMake(0, self.frame.size.height - titleBottomViewHeight, width, titleBottomViewHeight);
        _tipView = [[ZZSwitchBottomView alloc] initWithFrame:rect];
        _tipView.backgroundColor = self.tipViewColor;
        [self.scrollView addSubview:_tipView];
    }
}

#pragma mark - Actons
#pragma mark 选中某一个选项时，出发switchView:didSelectAtIndex:回调
-(void)buttonDidSelected:(ZZSwitchItemButton *)btn {
    if (self.isAnimating) {
        return;
    }
    CGFloat buttonWith = [self buttomItemWidthForIndex:btn.tag];
    __weak typeof(self) weakSelf = self;
    self.isAnimating = YES;
    [UIView animateWithDuration:0.25 animations:^{
        _tipView.frame = CGRectMake(CGRectGetMinX(btn.frame), self.frame.size.height - titleBottomViewHeight, buttonWith, titleBottomViewHeight);
    } completion:^(BOOL finished) {
        btn.selected = YES;
        weakSelf.isAnimating = NO;
    }];
    [self refreshButtonSelectedStatusWithIndex:btn.tag];
    if (_delegate && [_delegate respondsToSelector:@selector(switchView:didSelectAtIndex:)]) {
        [_delegate switchView:self didSelectAtIndex:btn.tag];
    }
}

#pragma mark - 私有方法， 工具方法
#pragma mark 刷新选项的选中状态
-(void)refreshButtonSelectedStatusWithIndex:(NSInteger)index {
    _selectedIndex = index;
    [_buttonArray enumerateObjectsUsingBlock:^(ZZSwitchItemButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (button.tag != index && button.isSelected == YES) {
            button.selected = NO;
            *stop = YES;
        }
    }];
}

-(CGFloat)buttomItemWidthForIndex:(NSInteger)idx {
    NSInteger count = [self.dataSource numberOfItemInSwitchView:self];
    CGFloat aveWidth = (self.frame.size.width - count * intervalLineWidth) / count;
    
    UIFont *font = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(switchView:fontForSelectedStatus:)]) {
        font = [self.dataSource switchView:self fontForSelectedStatus:YES];
    }
    
    BOOL moreThanAve = NO;
    
    for (NSInteger i = 0; i < count; i++) {
        NSString *title = [self.dataSource switchView:self titleForItemAtIndex:i];
        CGFloat width = [self widthForTitle:title font:font];
        moreThanAve = (width + interValue > aveWidth);
        if (moreThanAve) {
            break;
        }
    }
    
    if (moreThanAve) {
        CGFloat totalWidth = 0.0;
        NSMutableString *totalTitleStr = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < count; i++) {
            NSString *title = [self.dataSource switchView:self titleForItemAtIndex:i];
            [totalTitleStr appendString:title];
        }
        totalWidth = [self widthForTitle:totalTitleStr font:font];
        
        NSString *title = [self.dataSource switchView:self titleForItemAtIndex:idx];
        CGFloat currentWidth = [self widthForTitle:title font:font] + interValue;
        
        if (totalWidth + count * interValue > self.bounds.size.width) {
            return currentWidth;
        } else {
            if (currentWidth > aveWidth) {
                return currentWidth;
            } else {
                CGFloat moreThanAveWidth = 0.0;
                NSInteger moreThanAveCount = 0;
                for (NSInteger i = 0; i < count; i++) {
                    NSString *title = [self.dataSource switchView:self titleForItemAtIndex:i];
                    CGFloat width = [self widthForTitle:title font:font];
                    if (width + interValue > aveWidth) {
                        moreThanAveCount++;
                        moreThanAveWidth += (width + interValue);
                    }
                }
                if (moreThanAveWidth > 0 && moreThanAveCount > 0) {
                    return (self.bounds.size.width - moreThanAveWidth) / (count - moreThanAveCount);
                } else {
                    return 0;
                }
            }
        }
    }
    return aveWidth;
}

- (ZZSwitchItemButton *)buttonForItemWithFrame:(CGRect)frame andIndex:(NSInteger)index {
    if (self.dataSource == nil) {
        return nil;
    }
    ZZSwitchItemButton *button = [[ZZSwitchItemButton alloc] initWithFrame:frame];
    button.selected = (index == 0);
    button.tag = index;
    
    NSString *title = [self.dataSource switchView:self titleForItemAtIndex:index];
    
    NSMutableDictionary *unSelectedDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *selectedDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(switchView:fontForSelectedStatus:)]) {
        UIFont *unSelectedFont = [self.dataSource switchView:self fontForSelectedStatus:NO];
        UIFont *selectedFont = [self.dataSource switchView:self fontForSelectedStatus:YES];
        unSelectedDict[NSFontAttributeName] = unSelectedFont;
        selectedDict[NSFontAttributeName] = selectedFont;
    } else {
        unSelectedDict[NSFontAttributeName] = [UIFont systemFontOfSize:ZZSwitchItemButtonTitleSize];
        selectedDict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:ZZSwitchItemButtonTitleSize];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(switchView:titleColorForselectedStatus:)]) {
        UIColor *unSelectedTitleColor = [self.dataSource switchView:self titleColorForselectedStatus:NO];
        UIColor *selectedTitleColor = [self.dataSource switchView:self titleColorForselectedStatus:YES];
        unSelectedDict[NSForegroundColorAttributeName] = unSelectedTitleColor;
        selectedDict[NSForegroundColorAttributeName] = selectedTitleColor;
    } else {
        unSelectedDict[NSForegroundColorAttributeName] = SwitchButtonNormalColor;
        selectedDict[NSForegroundColorAttributeName] = SwitchButtonSelectedColor;
    }
    
    NSAttributedString *unSelectedAttributedStr = [[NSAttributedString alloc] initWithString:title attributes:unSelectedDict];
    NSAttributedString *selectedAttributedStr = [[NSAttributedString alloc] initWithString:title attributes:selectedDict];
    
    [button setAttributedTitle:unSelectedAttributedStr forState:UIControlStateNormal];
    [button setAttributedTitle:selectedAttributedStr forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(buttonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (CGFloat)widthForTitle:(NSString *)title font:(UIFont *)font {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:ZZSwitchItemButtonTitleSize];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        CGRect rect = [title boundingRectWithSize:CGSizeMake(HUGE, HUGE) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [title sizeWithFont:font constrainedToSize:CGSizeMake(HUGE, HUGE) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    return result.width;
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
    if (index >= _buttonArray.count || index < 0) {
        return;
    }
    if (self.isAnimating) {
        return;
    }
    ZZSwitchItemButton *button = _buttonArray[index];
    CGFloat buttonWith = [self buttomItemWidthForIndex:index];
    if (animated) {
        __weak typeof(self) weakSelf = self;
        self.isAnimating = YES;
        [UIView animateWithDuration:0.25 animations:^{
            _tipView.frame = CGRectMake(CGRectGetMinX(button.frame), self.frame.size.height - titleBottomViewHeight, buttonWith, titleBottomViewHeight);
        } completion:^(BOOL finished) {
            button.selected = YES;
            weakSelf.isAnimating = NO;
        }];
    } else {
        _tipView.frame = CGRectMake(CGRectGetMinX(button.frame), self.frame.size.height - titleBottomViewHeight, buttonWith, titleBottomViewHeight);
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
        [self initBottomLineView];
        NSInteger count = [dataSource numberOfItemInSwitchView:self];
        if (count <= 0) {
            return;
        }
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:count];
        NSMutableArray *mutableIntervalViewArray = [NSMutableArray arrayWithCapacity:count - 1];
        
        UIFont *font = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(switchView:fontForSelectedStatus:)]) {
            font = [self.dataSource switchView:self fontForSelectedStatus:YES];
        }
        
        CGFloat totalWidth = 0.0;
        NSMutableString *totalTitleStr = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < count; i++) {
            NSString *title = [self.dataSource switchView:self titleForItemAtIndex:i];
            [totalTitleStr appendString:title];
        }
        totalWidth = [self widthForTitle:totalTitleStr font:font];
        if (totalWidth + count * interValue > self.bounds.size.width) {
            if (self.scrollView.contentSize.width <= self.bounds.size.width) {
                self.scrollView.contentSize = CGSizeMake(totalWidth + count * interValue, self.bounds.size.height);
            }
        }
        
        CGFloat startPoint = 0.0;
        
        for (NSInteger idx = 0; idx < count; idx++) {
            CGFloat buttonWith = [self buttomItemWidthForIndex:idx];
            ZZSwitchItemButton *button = [self buttonForItemWithFrame:CGRectMake(startPoint, 0, buttonWith, self.frame.size.height - bottomLineHeight) andIndex:idx];
            [self.scrollView addSubview:button];
            startPoint += buttonWith;
            [mutableArray addObject:button];
            
            if (self.separatorStyle != ZZSwitchItemViewSeparatorStyleNone) {
                if (idx != count - 1) {
                    UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), (CGRectGetHeight(button.frame) - intervalLineHeight) / 2, intervalLineWidth, intervalLineHeight)];
                    intervalView.backgroundColor = self.separatorColor;
                    [self.scrollView addSubview:intervalView];
                    [mutableIntervalViewArray addObject:intervalView];
                }
            }
        }
        _buttonArray = [NSArray arrayWithArray:mutableArray];
        _separatorViewArray = [NSArray arrayWithArray:mutableIntervalViewArray];
    }
}



@end
