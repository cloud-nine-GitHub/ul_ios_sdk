//
//  ULCmd.h
//  ULGameDemo
//
//  Created by 一号机雷兽 on 2019/10/30.
//  Copyright © 2019 ul_mac04. All rights reserved.
//

#ifndef ULCmd_h
#define ULCmd_h


#endif /* ULCmd_h */

//发送方消息
static NSString *const MSG_CMD_SETVERSION = @"/c/setVersion";
static NSString *const MSG_CMD_OPENPAY = @"/c/openPay";//打开支付页
static NSString *const MSG_CMD_OPENADV = @"/c/openAdv";//请求广告
static NSString *const MSG_CMD_EXITGAME = @"/c/exitGame";// 退出游戏
static NSString *const MSG_CMD_CLICKNATIVEADV = @"/c/clickNativeAdv";//原生广告点击
static NSString *const MSG_CMD_CLOSEADV = @"/c/closeAdv";//关闭广告
static NSString *const MSG_CMD_OPENSHARE = @"/c/openShare";//打开分享
static NSString *const MSG_CMD_OPENWEBVIEW = @"/c/ulWebView";//打开webView
static NSString *const MSG_CMD_OPENMOREGAME = @"/c/openMoreGame";//打开渠道sdk更多游戏
static NSString *const MSG_CMD_OPENULMOREGAME = @"/c/openUlMoreGame";//打开互推更多游戏
static NSString *const MSG_CMD_USECDKEY = @"/c/useCdkey";//使用cdkey
static NSString *const MSG_CMD_EXCHANGEGIFT = @"/c/exchangeGift";//礼品兑换
static NSString *const MSG_CMD_CALLPHONE = @"/c/callPhone";//拨打电话
static NSString *const MSG_CMD_SAVEPICTOGALLERY = @"/c/savePicToGallery";//保存图片至相册
static NSString *const MSG_CMD_MEGADATASERVER = @"/c/megadataServer";// 大数据统计
static NSString *const MSG_CMD_INVITE_TO_COMMENT = @"/c/openInviteComment";// 邀评
//网游部分
static NSString *const MSG_CMD_ONLINE_OPENPAY = @"/o/openPay";//支付
static NSString *const MSG_CMD_ONLINE_LOGIN = @"/o/login";//登陆
static NSString *const MSG_CMD_ONLINE_SWITCH_ACCOUNT = @"/o/switchAccount";//切换账号
static NSString *const MSG_CMD_ONLINE_LOGOUT = @"/o/logout";//登出

//回复方消息
static NSString *const REMSG_CMD_CHANNELINFORESULT = @"/c/channelInfoResult";// 设置渠道信息
static NSString *const REMSG_CMD_PAYRESULT = @"/c/payResult";
static NSString *const REMSG_CMD_OPENADVRESULT = @"/c/openAdvResult";//广告展示结果回调
static NSString *const REMSG_CMD_EXITGAME = @"/c/exitGame";// 退出游戏
static NSString *const REMSG_CMD_CLICKNATIVEADVRESULT = @"/c/clickNativeAdvResult";//原生广告点击结果回调
static NSString *const REMSG_CMD_CLICKADVRESULT = @"/c/clickAdvResult";//广告点击结果回调
static NSString *const REMSG_CMD_CLOSEADVRESULT = @"/c/closeAdvResult";//广告关闭结果回
static NSString *const REMSG_CMD_CLOSENATIVEADVRESULT = @"/c/closeNativeAdvResult";//原生广告关闭结果回调
static NSString *const REMSG_CMD_SHARERESULT = @"/c/shareResult";// 分享回调
static NSString *const REMSG_CMD_PAUSESOUND = @"/c/pauseSound";// 暂停声音
static NSString *const REMSG_CMD_RESUMESOUND = @"/c/resumeSound";// 恢复声音
static NSString *const REMSG_CMD_PREPAYRESULT = @"/c/prePayResult";//预先处理订单
static NSString *const REMSG_CMD_LIFECYCLE = @"/c/lifeCycle";// 生命周期
static NSString *const REMSG_CMD_GIFTSHOWRESULT = @"/c/giftShowResult";//兑换回调
static NSString *const REMSG_CMD_USECDKEY = @"/c/useCdkey";// 使用通用类CDK
static NSString *const REMSG_CMD_COPINFO = @"/c/copInfoResult";// 反馈cop配置信息
static NSString *const REMSG_CMD_MEGADATASERVER = @"/c/megadataServer";// 大数据统计
static NSString *const REMSG_CMD_OPENNATIVEADVRESULT = @"/c/openNativeAdvResult";//原生广告信息获取回调
static NSString *const REMSG_CMD_ONLINE_PAYRESULT = @"/o/payResult";//付款结果
static NSString *const REMSG_CMD_ONLINE_LOGINRESULT = @"/o/loginResult";//登陆结果
static NSString *const REMSG_CMD_ONLINE_SWITCH_ACCOUNT_RESULT = @"/o/switchAccountResult";//切换账号
static NSString *const REMSG_CMD_ONLINE_LOGOUT_RESULT = @"/o/logoutResult";//登出
static NSString *const REMSG_CMD_CLOSEALLADVBYTYPERESULT = @"/c/closeAllAdvByTypeResult";//广告关闭结果回




@interface ULCmd : NSObject

@end
