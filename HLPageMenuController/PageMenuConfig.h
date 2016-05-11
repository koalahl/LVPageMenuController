//
//  PageMenuConfig.h
//  PageMenu
//
//  Created by HanLiu on 16/4/14.
//  Copyright © 2016年 HanLiu. All rights reserved.
//

#ifndef PageMenuConfig_h
#define PageMenuConfig_h

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#endif

#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#endif

#define Color(R,G,B) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:1.0]

#define __WEAK_SELF_     __weak typeof(self) weakSelf = self;
#define __STRONG_SELF_   __strong typeof(weakSelf) strongSelf = weakSelf;

#endif /* PageMenuConfig_h */
