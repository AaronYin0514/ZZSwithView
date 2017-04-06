//
//  ZZSwitchItemButton.m
//  LEIS_CSE
//
//  Created by 尹中正(外包) on 15/12/15.
//  Copyright © 2015年 pingan. All rights reserved.
//

#import "ZZSwitchItemButton.h"

@implementation ZZSwitchItemButton

#pragma mark - Public Methods
-(CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font {
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    return CGSizeMake(titleRect.size.width, titleRect.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
