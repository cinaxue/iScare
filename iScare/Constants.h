//
//  Constants.h
//  XMLTest
//
//  Created by Xue Cina on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
enum {
    ScareDay=0,
    ScareWeek=1,
    ScareMonth=3,
    Scare3Month=4,
    Scare6Month=5,
    ScareYear=6,
    ScareAll=7,
};
typedef NSUInteger  ScrollType;

#define KServerAddress @"http://211.151.180.4:9853"           // regular server
#define kVersion_Current @"1.0" 
#define ImagePath(Name) [NSString stringWithFormat:@"%@%@",KImageServerAddress, Name]
#define KEmpty @""
#define KTitle @"title"
#define CLabelPostion 20
#define XMatrixNum 4
#define YMatrixNum 4
#define ErrorMessage_Error @"错误提示"
#define ErrorMessage_Success @"操作成功"
#define ErrorMessage_Normal @"有哇提示"
#define kWBSDKUID @"2389181193" // 有哇移动搜索的Sina微博ID
#define kWBSDKDemoAppKey @"2353658261"
#define kWBSDKDemoAppSecret @"4fed3ccf0cea2b10bd615d9a8fbea745"
#define kWBRedirectURL @"http://weiboconnect://weibo.TimeLineActivity"

#define kWBTencentAPPID @"801104113" // 有哇移动搜索的Tencent微博ID
#define kWBTencentAPPKey @"65cbc3df5e201a6e7382d6615ced6236" // 有哇移动搜索的Tencent微博APPKey

#define TagIndicater_999 999
#define TagBlankView_999 995

