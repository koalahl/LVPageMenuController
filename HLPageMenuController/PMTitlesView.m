//
//  HLTitlesView.m
//  PageMenu
//
//  Created by HanLiu on 16/4/14.
//  Copyright © 2016年 HanLiu. All rights reserved.
//

#import "PMTitlesView.h"
#import "PageMenuConfig.h"

static NSInteger const titleViewButtonTag = 28271;
#define buttonHeight 40

@interface PMTitlesView()<UIScrollViewDelegate>
{
    CGFloat buttonWidth  ;
    
}
@property (nonatomic,strong) NSArray   * titles;
@property (nonatomic,strong) UIView    * underline;

@property (nonatomic,strong) NSMutableArray   * buttonsArray;
@property (nonatomic,strong) UIButton  * lastButton;

@property (nonatomic,assign) NSInteger previousPage;

@end

@implementation PMTitlesView

- (instancetype)initWithTitles:(NSArray*)titles{
    
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake(0,64, SCREEN_WIDTH, 40);
        _buttonsArray        = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        _titles              = [titles copy];
        _previousPage        = 0;
        self.delegate        = self;
        self.showsHorizontalScrollIndicator = NO;
        [self configView];
        
    }
    
    return self;
}

- (void)configView{
    
    //设置 content size
    float totalButtonsWidth = 0.f;
    
    //将每个button的宽度固定值
    NSInteger maxButtonsCount = 5;
  
    
    if (_titles.count<5) {
        buttonWidth = SCREEN_WIDTH/_titles.count;
    }else{
        buttonWidth = SCREEN_WIDTH/maxButtonsCount;
    }
    
    for (NSUInteger i = 0; i<_titles.count; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        //每个button的frame
        CGRect frame;
        frame.origin = CGPointMake(totalButtonsWidth, 0);
        frame.size   = CGSizeMake(buttonWidth, buttonHeight);
        [button setFrame:frame];
        
        totalButtonsWidth += CGRectGetWidth(button.frame);
        
        button.tag             = titleViewButtonTag + i;
        button.backgroundColor = [UIColor clearColor];
        
        [button addTarget:self
                   action:@selector(buttonEvents:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [_buttonsArray addObject:button];
        
        [self configButtonWithOffsetx:0];
        
        [self addSubview:button];
    }
    
    self.contentSize = CGSizeMake(totalButtonsWidth, buttonHeight);
    
    __WEAK_SELF_
    
    self.titleViewScrollBlock =^(CGFloat offset_x){
        
        __STRONG_SELF_
        [strongSelf configButtonWithOffsetx:offset_x];
        
    };
    
    self.viewWillScrollEndBlock =^(CGFloat offsetx){
        
        __STRONG_SELF_
        //设置 Button 可见
        CGFloat x = offsetx * (60 / self.frame.size.width) - 60;
        
        [strongSelf scrollRectToVisible:CGRectMake(x, 0,
                                                   strongSelf.frame.size.width,
                                                   strongSelf.frame.size.height)
                               animated:YES];
        
    };
    
    self.underline = [[UIView alloc]initWithFrame:CGRectMake(0,buttonHeight -1 , buttonWidth, 1)];
    self.underline.backgroundColor = [UIColor colorWithRed:0.92 green:0.32 blue:0.32 alpha:1];
    UIButton * firstBtn = _buttonsArray[0];
    [firstBtn addSubview:self.underline];
    
    self.lastButton = firstBtn;
    
}

- (void)setFirstTitleIndex:(NSInteger)firstTitleIndex{
    CGFloat offset_x = firstTitleIndex * buttonWidth;
    _previousPage    = firstTitleIndex -1 ;
    NSLog(@"_previousPage = %ld",_previousPage);
    [self configButtonWithOffsetx:offset_x];
    
}
- (void)configButtonWithOffsetx:(CGFloat )offset_x{
    
    NSUInteger currentPage   = offset_x/buttonWidth;
    
    NSLog(@"index222=%f  %ld",offset_x,_previousPage);
    if (_previousPage != currentPage) {
        
        UIButton * previousButton = (UIButton*)[self viewWithTag:_previousPage +titleViewButtonTag];
        [previousButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }
    //当前button
    UIButton * currentButton = (UIButton*)[self viewWithTag:currentPage+titleViewButtonTag];
    [currentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
    UIButton * nextButton = [self viewWithTag:currentPage+1+titleViewButtonTag];
    [nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    _previousPage = currentPage;
    
    [self selectUnderline:currentButton];
}


- (void)buttonEvents:(UIButton*)button{
    
    self.isClickTitleButton = YES;
    
    if (_titleViewClickButtonBlock) {
        _titleViewClickButtonBlock(button.tag - titleViewButtonTag);
    }
    
    UIButton *previousButton = [self viewWithTag:_previousPage + titleViewButtonTag];
    [previousButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    UIButton *currentButton = [self viewWithTag:button.tag];
    [currentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self selectUnderline:button];
    NSLog(@"button.tag= %ld",button.tag);
    _previousPage = button.tag - titleViewButtonTag;
    
}

//改变下划线的坐标
- (void)selectUnderline:(UIButton *)button {
    if (!button) {
        return;
    }
    //当前点击button设置为红色选中
    [button    setTitleColor:[UIColor colorWithRed:0.92 green:0.32 blue:0.32 alpha:1] forState:UIControlStateNormal];
    
    const CGFloat height = 1;
    const CGFloat offset = 8;
    
    if (self.lastButton && self.lastButton != button) {
        //上一次点击的button设置为灰色未选中
        [self.lastButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = self.underline.frame;
            frame.size = CGSizeMake(CGRectGetWidth(button.frame) / 2.0, height);
            if (button.center.x > self.lastButton.center.x) {
                frame.origin = CGPointMake(CGRectGetMinX(self.lastButton.frame) + CGRectGetWidth(self.lastButton.frame) / 2.0, CGRectGetMaxY(self.lastButton.frame) - height);
            } else {
                frame.origin = CGPointMake(CGRectGetMinX(self.lastButton.frame), CGRectGetMaxY(self.lastButton.frame) - height);
            }
            self.underline.frame = frame;
            self.lastButton = button;
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CGRect frame = self.underline.frame;
                    frame.size = CGSizeMake(CGRectGetWidth(button.frame) - offset * 2, height);
                    frame.origin = CGPointMake(CGRectGetMinX(button.frame) + offset, CGRectGetMaxY(button.frame) - height);
                    self.underline.frame = frame;
                } completion:^(BOOL finished) {
                    //
                }];
            }
        }];
    } else {
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = self.underline.frame;
            frame.size = CGSizeMake(CGRectGetWidth(button.frame) - offset * 2, height);
            frame.origin = CGPointMake(CGRectGetMinX(button.frame) + offset, CGRectGetMaxY(button.frame) - height);
            self.underline.frame = frame;
            self.lastButton = button;
        } completion:^(BOOL finished) {
            if (finished) {
                //
            }
        }];
    }
}

@end
