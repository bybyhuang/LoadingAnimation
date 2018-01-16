//
//  LoadingViewForOC.m
//  LoadingAnimation
//
//  Created by huangbaoyu on 16/10/23.
//  Copyright © 2016年 chachong. All rights reserved.
//

#import "LoadingViewForOC.h"
#import "UIView+Extension.h"

//动画持续时间
static const CGFloat KAnimationDuration = 1.50f;

@interface LoadingViewForOC() <CAAnimationDelegate>

@property (nonatomic, strong) UIView *round1;
@property (nonatomic, strong) UIView *round2;
@property (nonatomic, strong) UIView *round3;

@property (nonatomic, strong) UIColor *round1Color;
@property (nonatomic, strong) UIColor *round2Color;
@property (nonatomic, strong) UIColor *round3Color;

@end

@implementation LoadingViewForOC

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _round1Color = [UIColor colorWithRed:206/255.0 green:7/255.0 blue:85/255.0 alpha:1.0];
        _round2Color = [UIColor colorWithRed:206/255.0 green:7/255.0 blue:85/255.0 alpha:0.6];
        _round3Color = [UIColor colorWithRed:206/255.0 green:7/255.0 blue:85/255.0 alpha:0.3];
        
        //宽高都是10
        CGFloat width = 10;
        UIView *round1 = [[UIView alloc] init];
        round1.width = width;
        round1.height = width;
        round1.backgroundColor = _round1Color;
        round1.layer.cornerRadius = round1.height / 2;
        
        
        UIView *round2 = [[UIView alloc] init];
        round2.width = width;
        round2.height = width;
        round2.backgroundColor = _round2Color;
        round2.layer.cornerRadius = round2.height / 2;
        
        
        UIView *round3 = [[UIView alloc] init];
        round3.width = width;
        round3.height = width;
        round3.backgroundColor = _round3Color;
        round3.layer.cornerRadius = round3.height / 2;
        
        [self addSubview:round1];
        [self addSubview:round2];
        [self addSubview:round3];
        
        round2.centerX = self.centerX;
        round2.centerY = self.centerY;
        
        round1.centerX = round2.centerX - 20;
        round1.centerY = round2.centerY;
        
        round3.centerX = round2.centerX + 20;
        round3.centerY = round2.centerY;
       
        
        _round1 = round1;
        _round2 = round2;
        _round3 = round3;
        
        
        [self startAnimation];
    }
    
    return self;
}

#pragma mark - Public

//显示加载动画在指定的view上
+ (LoadingViewForOC *)showLoadingWith:(UIView *)view
{
    LoadingViewForOC *loadingView = [[LoadingViewForOC alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    [view addSubview:loadingView];
    return loadingView;
}

//显示加载动画在指定的window上
+ (LoadingViewForOC *)showLoadingWithWindow
{
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    LoadingViewForOC *loadingView = [[LoadingViewForOC alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    [window addSubview:loadingView];
    return loadingView;
}

//可以手动调用隐藏动画
- (void)hideLoadingView
{
    [_round1.layer removeAllAnimations];
    [_round2.layer removeAllAnimations];
    [_round3.layer removeAllAnimations];
    [self removeFromSuperview];
}

#pragma mark - Private

- (void)startAnimation
{
    // 运动轨迹圆心
    CGPoint otherRoundCenter1 = CGPointMake(_round1.centerX + 10, _round1.centerY);
    CGPoint otherRoundCenter2 = CGPointMake(_round2.centerX + 10, _round2.centerY);
    
    // 圆1的路径
    UIBezierPath *path1 = [[UIBezierPath alloc] init];
    [path1 addArcWithCenter:otherRoundCenter1 radius:10 startAngle:-M_PI endAngle:0 clockwise:YES];
    UIBezierPath *path1_1 = [[UIBezierPath alloc] init];
    [path1_1 addArcWithCenter:otherRoundCenter2 radius:10 startAngle:-M_PI endAngle:0 clockwise:NO];
    [path1 appendPath:path1_1];
    
    [self viewMovePathAnimationWith:_round1 path:path1];
    [self viewColorAnimationWith:_round1 fromColor:_round1Color toColor:_round3Color];
    
    // 圆2的路径
    UIBezierPath *path2 = [[UIBezierPath alloc] init];
    [path2 addArcWithCenter:otherRoundCenter1 radius:10 startAngle:0 endAngle:-M_PI clockwise:YES];
    [self viewMovePathAnimationWith:_round2 path:path2];
    [self viewColorAnimationWith:_round2 fromColor:_round2Color toColor:_round1Color];
    
    // 圆3的路径
    UIBezierPath *path3 = [[UIBezierPath alloc] init];
    [path3 addArcWithCenter:otherRoundCenter2 radius:10 startAngle:0 endAngle:-M_PI clockwise:NO];
    [self viewMovePathAnimationWith:_round3 path:path3];
    [self viewColorAnimationWith:_round3 fromColor:_round3Color toColor:_round2Color];
}

///设置view的移动路线，这样抽出来因为每个圆的只有路径不一样
- (void)viewMovePathAnimationWith:(UIView *)view path:(UIBezierPath *)path
{
    // 告诉帧动画我们要改变它的位置
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 添加 UIBezierPath 路径
    animation.path = [path CGPath];
    // 动画完成后不要移除
    animation.removedOnCompletion = NO;
    // 设置结束状态，一直保持结束的状态
    animation.fillMode = kCAFillModeForwards;
    // 使运动轨迹圆滑
    animation.calculationMode = kCAAnimationCubic;
    // 重复次数
    animation.repeatCount = MAXFLOAT;
    // 动画持续时间
    animation.duration = KAnimationDuration;
    animation.delegate = self;
    // 动画效果：慢进慢出
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // 将帧动画添加到视图上
    [view.layer addAnimation:animation forKey:@"animation"];
    
}

///设置view的颜色动画
- (void)viewColorAnimationWith:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.fromValue = (__bridge id _Nullable)([fromColor CGColor]);
    animation.toValue = (__bridge id _Nullable)([toColor CGColor]);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = KAnimationDuration;
    animation.repeatCount = MAXFLOAT;
    [view.layer addAnimation:animation forKey:@"backgroundColor"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_round1.layer removeAllAnimations];
    [_round2.layer removeAllAnimations];
    [_round3.layer removeAllAnimations];
    [self removeFromSuperview];
}

@end
