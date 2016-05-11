//
//  PageMenuBaseViewController.m
//  PageMenu
//
//  Created by HanLiu on 16/4/14.
//  Copyright © 2016年 HanLiu. All rights reserved.
//

#import "PMBaseViewController.h"
#import "PMTableViewController.h"
#import "PMTitlesView.h"
#import "PageMenuConfig.h"
@interface PMBaseViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)NSArray * titlesArray;
@property (nonatomic,strong)UIViewController * userController;

/** 标题栏 */
@property (nonatomic, strong)PMTitlesView   *titleScrollView;

/** 下面的内容栏 */
@property (nonatomic, strong)UIScrollView *contentScrollView;

@end

@implementation PMBaseViewController

- (instancetype)initWithTitles:(NSArray *)titles{
    if (self == [super init]) {
        _titlesArray = titles;
    }
    return self;
}
- (instancetype)initWithTitles:(NSArray *)titles viewControllers:(UIViewController *)controllers{

    if (self == [super init]) {
        _titlesArray = titles;
        _userController  = controllers;
        NSLog(@"zzz %@",[_userController class]);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addControllers];

    /**
     *  根据项目来确定
     */
    if (self.navigationController) {
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"nav_back_icon") style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButton_touch:)];
        [back setTintColor:RGB_HEX(0x999999)];
        self.navigationItem.leftBarButtonItem = back;
    }
    
    
    CGFloat height = self.titleScrollView.frame.size.height;
    self.contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+height, SCREEN_WIDTH, SCREEN_HEIGHT-64-height)];
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.contentScrollView.contentSize = CGSizeMake(contentX, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    [self.view addSubview:self.contentScrollView];
    
    __WEAK_SELF_
    self.titleScrollView = [[PMTitlesView alloc]initWithTitles:self.titlesArray];
    self.titleScrollView.titleViewClickButtonBlock = ^(NSInteger index){
        CGFloat offset_x = index * self.contentScrollView.frame.size.width;
        CGFloat offset_y = weakSelf.contentScrollView.contentOffset.y;
        CGPoint offset = CGPointMake(offset_x, offset_y);
        [weakSelf.contentScrollView setContentOffset:offset animated:YES];
    };
    if(_firstVisibleViewIndex){
        self.titleScrollView.firstTitleIndex = _firstVisibleViewIndex;
        CGFloat offset_x = _firstVisibleViewIndex * self.contentScrollView.frame.size.width;
        CGFloat offset_y = self.contentScrollView.contentOffset.y;
        CGPoint offset = CGPointMake(offset_x, offset_y);
        [self.contentScrollView setContentOffset:offset animated:YES];
    }
    [self.view addSubview:self.titleScrollView];
    
    // 添加默认控制器
    if (_userController) {
        UIViewController *vc = nil;
        if (_firstVisibleViewIndex) {
            vc = [self.childViewControllers objectAtIndex:_firstVisibleViewIndex];
            
        }else{
            vc = [self.childViewControllers firstObject];
        }
        
        vc.view.frame = self.contentScrollView.bounds;
        [self.contentScrollView addSubview:vc.view];
    }else{
        PMTableViewController *vc = [self.childViewControllers firstObject];
        vc.view.frame = self.contentScrollView.bounds;
        [self.contentScrollView addSubview:vc.view];
    }
    
    
    
}

- (void)addControllers{
    
    for (int i=0 ; i<self.titlesArray.count ;i++){
        
        if (_userController) {
            Class class = [_userController class];
            UIViewController * vc = [class new];
            vc.title = self.titlesArray[i];
            NSLog(@"class = %@",[vc class]);
            [self addChildViewController:vc];
        }else{
            PMTableViewController *vc = [[PMTableViewController alloc] init];
            vc.title = self.titlesArray[i];
            [self addChildViewController:vc];
        }
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBarButton_touch:(UIBarButtonItem  *)leftBtn {
    [self back];
}

- (void)back {
    if (self.navigationController.viewControllers && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - ******* scrollView代理方法 *******

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndScrollingAnimation");
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    NSLog(@"index=%ld",index);
    // 滚动标题栏

    UIButton *titleBtn = (UIButton *)self.titleScrollView.subviews[index];
    CGFloat offsetx = titleBtn.frame.origin.x;
    self.titleScrollView.titleViewScrollBlock(offsetx);
    
    // 添加控制器
    PMTableViewController *newsVc = self.childViewControllers[index];
    newsVc.selectedBtnIndex = index;
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = scrollView.bounds;
    [self.contentScrollView addSubview:newsVc.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

@end
