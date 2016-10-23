//
//  LoadingViewForOC.h
//  LoadingAnimation
//
//  Created by huangbaoyu on 16/10/23.
//  Copyright © 2016年 chachong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewForOC : UIView

+ (LoadingViewForOC *)showLoadingWith:(UIView *)view;
+ (LoadingViewForOC *)showLoadingWithWindow;
- (void)hideLoadingView;
@end
