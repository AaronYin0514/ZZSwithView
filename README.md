# ZZSwitchView

一款自定义分段选择器切换视图。类似系统UISegmentedControl，但UISegmentedControl往往不能满足UI设计。这款用于类似的问题。

## 解释
为了能说明问题，画一张图，为个部分起一个名词，方便解释。

![](https://raw.githubusercontent.com/AaronYin0514/ZZSwithView/master/product/004.png)

## 功能
* 使用上采用代理的方式，类似于UITableView。
* 所有分段Item长度加在一起长度小于整个控件长度时，会按照平均长度来设置分段Item长度，分配到整个控件上。
* 所有分段Item长度加在一起长度大于整个控件长度时，分段Item长度会按照标题长度来设置，并且整个控件可以滑动。
* 选择提示组件，用来提示当前控件选择到了哪里。可设置组件显示方式和颜色。
* 底部分隔线，可设置颜色。
* 间隙分割线，可设置显现方式和颜色。

## ⚠️常见问题
* 当这个控件被放置在导航栏下边时，如果发现控件可以上下滑动，这时设置控制器的automaticallyAdjustsScrollViewInsets属性为NO。
* 提示选择的视图组件设置需要在设置数据源之前进行设置。（问题解决中）

## 使用

使用

```obj-c
_switchItemView = [[ZZSwitchItemView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
// 设置选择提示组件显示方式
_switchItemView.tipStyle = ZZTipViewNone;
// 设置间隙分隔线显示方式
_switchItemView.separatorStyle = ZZSwitchItemViewSeparatorStyleNone;
_switchItemView.delegate = self;
_switchItemView.dataSource = self;
[self.view addSubview:_switchItemView];
// 更多设置可参考ZZSwitchItemView.h文件
```

数据源和代理

```obj-c
#pragma mark - ZZSwithViewDataSource
- (NSInteger)numberOfItemInSwitchView:(ZZSwitchItemView *)switchView {
    return _itemsArray.count;
}

- (NSString *)switchView:(ZZSwitchItemView *)switchView titleForItemAtIndex:(NSInteger)index {
    return _itemsArray[index];
}

- (UIFont *)switchView:(ZZSwitchItemView *)switchView fontForSelectedStatus:(BOOL)status {
    return status ? [UIFont boldSystemFontOfSize:15.0] : [UIFont systemFontOfSize:15.0];
}

- (UIColor *)switchView:(ZZSwitchItemView *)switchView titleColorForselectedStatus:(BOOL)status {
    return status ? QYPurpleColor : QYTextColorLight;
}

#pragma mark - ZZSwithViewDelegate
- (void)switchView:(ZZSwitchItemView *)switchView didSelectAtIndex:(NSInteger)index {
    [_pageViewController scrollToViewControllerWithIndex:index animated:YES];
}
```

选择到制定分段

```obj-c
[weakSelf.switchItemView setSelectedItemIndex:index animated:NO];
```

## 集成

下载压缩包，将ZZSwitchItem文件夹拖入工程。

## 产品展示

![](https://raw.githubusercontent.com/AaronYin0514/ZZSwithView/master/product/001.png)

![](https://raw.githubusercontent.com/AaronYin0514/ZZSwithView/master/product/002.png)

![](https://raw.githubusercontent.com/AaronYin0514/ZZSwithView/master/product/003.png)
