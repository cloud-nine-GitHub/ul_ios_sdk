

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NSString* (^MGDebugCheckAdStateGetBlock)(NSString*,NSString*);

@interface SULogger : NSObject

@property(nonatomic,assign) BOOL isUpdateLogOnHiddenState;
@property (atomic,assign) BOOL isEnableCPLogMode;
@property (nonatomic,strong) NSString *aggregationAdConfigResult;
//@property (nonatomic,strong)  *<#object#>;
@property (nonatomic,strong) NSMutableDictionary *invokeInterfacesDic;
@property(nonatomic,strong) NSMutableArray* invokeFuncNames;
@property(nonatomic,strong) NSMutableArray* loggingCPUseBids;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic,strong) UIViewController *pannelVC;

-(void) updateUseBids:(NSString*)bid;

-(void)registAdStateReadySelector:(NSString*(^)(NSString*,NSString*))callBack;

-(void)registAdShowBlock:(BOOL(^)(NSString*,NSString*,UIViewController*))adShowBlock;

//给子类重写!
/**
 *  描述：初始化Logger
 */
- (void)start;

-(void) addCurrentInvokeTimeForFunc:(NSString*)funcName;

-(BOOL) isHasInvokeForFuncName:(NSString*)funcname;

-(NSString*) getTimeForFuncName:(NSString*)funcname;

+ (instancetype)logger;

- (void)start:(NSString*)log_file_path vc:(UIViewController*)vc;

#pragma mark -

/**
 *  描述：改变Log面板状态(隐藏->显示 or 显示->隐藏)
 */
- (void)visibleChange:(UIViewController*) vc;

-(double) getLoggerPannelOriginY;

//给子类调用
-(void) superSendLog:(NSString*)log level:(NSString*)level;

- (void)show:(UIViewController*) vc;

- (void)hide ;

-(void) alertView:(NSString*)message
            title:(NSString*)title;

-(void) sendMsg:(NSString*)msg
        adLevel:(int)adLevel;

-(void) showDebugUI:(UIViewController*) vc;

-(void) closeCurrentPage;

@end

