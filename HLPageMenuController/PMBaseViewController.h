//
//  PageMenuBaseViewController.h
//  PageMenu
//
//  Created by HanLiu on 16/4/14.
//  Copyright © 2016年 HanLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMBaseViewController : UIViewController

/**
 *  普通初始化方法，使用内置的PMTableViewController用于演示
 *
 *  @param titles 标题数组
 *
 *  @return insatncetype
 */
- (instancetype)initWithTitles:(NSArray *)titles ;
/**
 *  初始化方法
 *
 *  @param titles      标题
 *  @param controllers 自定义的控制器
 *
 *  @return insatncetype
 */
- (instancetype)initWithTitles:(NSArray *)titles viewControllers:(UIViewController *)controllers;
/**
 *  设置起始视图
 */
@property (nonatomic,assign)NSInteger firstVisibleViewIndex;
/**
 *  若项目中存在自定义的返回按钮，则应设置该属性
 */
@property (nonatomic,strong)UIBarButtonItem * backBtn;
@end
