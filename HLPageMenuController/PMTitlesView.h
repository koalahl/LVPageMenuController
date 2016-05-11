//
//  HLTitlesView.h
//  PageMenu
//
//  Created by HanLiu on 16/4/14.
//  Copyright © 2016年 HanLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^titleViewScrollBlock)(CGFloat offset_x);
typedef void (^viewWillScrollEndBlock)(CGFloat offset_x);
typedef void (^titleViewClickButtonBlock)(NSInteger index);

@interface PMTitlesView : UIScrollView

- (instancetype)initWithTitles:(NSArray *)titles;
@property (nonatomic,copy) titleViewScrollBlock
titleViewScrollBlock;
@property (nonatomic,copy) titleViewClickButtonBlock titleViewClickButtonBlock;
@property (nonatomic,copy) viewWillScrollEndBlock
viewWillScrollEndBlock;
/*判断是否点击 Button 或 滚动 UIScrollView 进行页面的切换 */
@property (nonatomic,assign) BOOL isClickTitleButton;

@property (nonatomic,assign)NSInteger firstTitleIndex;
@end
