

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@protocol MGDebugCheckDelegate <NSObject>

@optional

-(NSString*) getAdIntergrateResult:(NSString*)adStyle;

-(NSString*) getAdIntergrateErrorResult:(NSString *)adStyle;

-(NSString*) generateAdStyle;

-(NSString*) getCurrentConfigId;

-(NSString*) getAppkeyConfigResult;

-(NSString*) getBlockidCheckResult;

//获取当前广告位对应的广告商状态
-(NSMutableArray*) getCurrentAdStateResult:(NSString*)bid;

//获取当前CP使用的广告位ID数组
-(NSMutableArray*) getCurrentValidBlockIds;

-(NSMutableArray*) getCurrentValidBlockIdNames;

-(NSMutableArray*) getCurrentInvokeResult;

-(NSString*) getConfigId;

-(NSString*) isAllBlockidValid;

//获取正确的游戏或应用校验
-(NSString*) getAppValidDes;

-(void) playAdForName:(NSString*)adName
                  bid:(NSString*)bid;

@end

@interface MGDebugCheckViewManager : NSObject

//@property (nonatomic,weak)id<MGSplashNativeViewManagerDelegate>   viewManagerDelegate;

@property(nonatomic,strong) NSString *htmlPath;
@property(nonatomic,strong) NSString *appIcon;

@property(nonatomic,strong) NSString *sdkVersion;
@property(nonatomic,strong) NSString *appVersion;
@property(nonatomic,strong) NSString *configId;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *packageName;
@property(nonatomic,strong) NSString *actionTitle;
@property(nonatomic,strong) NSString *rating;
@property(nonatomic,strong) NSString *adTime;
@property(nonatomic,strong) NSString *logoImagePath;
@property(nonatomic,strong) NSString *appName;
@property(nonatomic,strong) NSString *appDesc;
@property(nonatomic,strong) NSString *red;
@property(nonatomic,strong) NSString *green;
@property(nonatomic,strong) NSString *blue;
@property(nonatomic,strong) NSString*adStyle;
@property(nonatomic,strong) NSString*blockid;
@property(nonatomic,strong) NSString*selectedBid;
@property (nonatomic, weak)UIViewController *bgVC;

@property (nonatomic, strong)NSString   *jsonDataStr;

@property (nonatomic, strong)NSString   *secondJsonDataStr;

@property (nonatomic, strong)NSString   *thirdJsonDataStr;

@property (nonatomic, strong)WKWebView   *webview;

@property (nonatomic, strong)WKUserContentController   *userContentController;

@property (nonatomic, strong)UIView          *transparentView;

@property (nonatomic, strong)UITapGestureRecognizer *clickTap;
@property(nonatomic,strong) UIActivityIndicatorView*  activity;

@property(nonatomic,weak) id<MGDebugCheckDelegate> delegate;

-(void)setDebugAdViewController:(UIViewController*)viewController;

-(WKWebView *)createWkWebView;

-(UIView *)createTransparentView;

-(void)removeView;

-(void) closeCurrentPage;

@end
