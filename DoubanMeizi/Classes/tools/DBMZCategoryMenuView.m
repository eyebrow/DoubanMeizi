//
//  DBMZCategoryMenuView.m
//  DoubanMeizi
//
//  Created by iprincewang on 16/4/28.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

#import "DBMZCategoryMenuView.h"

@implementation DBMZCategoryMenuView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (self.titles && [self.titles count] > 0) {
        self.sectionTitles = self.titles;
    }
    //self.sectionTitles = @[@"所有", @"大胸", @"翘臀", @"黑丝", @"美腿", @"清新", @"杂烩"];
    self.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.selectionIndicatorHeight = 3.0;
    self.borderType = HMSegmentedControlBorderTypeBottom;
    self.borderColor = [UIColor lightGrayColor];
    self.borderWidth = 0.3;
    self.alpha = 0.9;
    self.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
    self.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0]};
}

@end
