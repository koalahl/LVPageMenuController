# LVPageMenuController
a viewController contain multi page。
提供一个数组就可以创建一个可滑动的多菜单页面。

![](/snapshot.gif)



###Inital:

```objc
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
```

###Usage

```objc
//创建你自己的视图控制器
MyOrderViewController *orderVC = [[MyOrderViewController alloc]init];
orderVC.selectedBtnIndex = 7;
//提供titles数组
PMBaseViewController * baseVC = [[PMBaseViewController alloc]initWithTitles:titles viewControllers:orderVC];
[self.navigationController pushViewController:baseVC animated:YES];
```

