//
//  Tools.m
//  youwa
//
//  Created by 薛 千 on 4/18/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import "Tools.h"
#import "Constants.h"
#import "ErrorViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <sys/xattr.h>

@implementation UserWeight
@synthesize imputDate,imputWeight;
@end

static Tools *sharedTools;

@implementation Tools

@synthesize mBackgroundImagePath;
@synthesize delegate;
@synthesize selector;
@synthesize mUserWeights;
@synthesize mUserGender,mUserHight;
@synthesize mMeasureUnit;

-(id) init
{
    self = [super init];
    if (self) {
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

        // 从本地获取超市中的定制包 以及  本地用户的定制包
        NSString *path = [docPath stringByAppendingFormat:@"/Settings.plist"];
        // create words.plist if the local words plist does not exist
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:defaultPath]) {
                [[NSFileManager defaultManager] copyItemAtPath:defaultPath toPath:path error:nil];
                [Tools addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:docPath]];
                [Tools addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:path]];
            }else {
                [Tools showAlert:@"APP内的初始化列表没有找到！"];
            }
        }

        NSDictionary *aDic = [NSDictionary dictionaryWithContentsOfFile:path];
        mBackgroundImagePath = [[aDic objectForKey:@"BackgroundStyle"] intValue];
        mUserWeights = [[aDic objectForKey:@"UserWeights"] mutableCopy];
        mMeasureUnit = [[aDic objectForKey:@"MeasureUnit"] mutableCopy];
        mUserGender = [[aDic objectForKey:@"UserGender"] boolValue];
        mUserHight = [[aDic objectForKey:@"UserHight"] floatValue];
    }
    return self;
}

+ (BOOL) addWeight:(float) weight
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingFormat:@"/Settings.plist"];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setLocale:[NSLocale currentLocale]];
    NSDateComponents *nowComponents = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit  | NSDayCalendarUnit| NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    
    NSString *caldate = [NSString stringWithFormat:@"%d%d%d%d", [nowComponents year], [nowComponents month], [nowComponents day], [nowComponents hour]];
    
//    if ([[[[Tools sharedTools].mUserWeights lastObject] valueForKey:@"date"] isEqualToString:caldate]) {
//        [Tools showAlert:@"时间间隔为最小1小时，请您下一个小时在输入"];
//        return NO;
//    }
    
    NSMutableDictionary *dictionary  = [[[NSMutableDictionary alloc] init]autorelease];
    [dictionary setValue:caldate forKey:@"date"];
    [dictionary setValue:[NSString stringWithFormat:@"%f", weight] forKey:@"weight"];

    NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [[Tools sharedTools].mUserWeights addObject:dictionary];
    [aDic setValue:[Tools sharedTools].mUserWeights forKey:@"UserWeights"];

    if (![aDic writeToFile:path atomically:YES])
    {
        [Tools showAlert:@"Failed to save the News!"];
    }
    return YES;
}

+ (Tools *)sharedTools
{
    if (sharedTools) {
        return sharedTools;
    }else
    {
        sharedTools = [[Tools alloc] init];
        return sharedTools;
    }
}

+ (void) showAlert:(NSString*) aLog
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" 
                                                    message:aLog
                                                   delegate:nil 
                                          cancelButtonTitle:@"YES" 
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

+(NSString *)getDocumentFilePath{
	NSArray  *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [pathArray objectAtIndex:0];
	return documentPath;
}

+(float) getDistanceBetween:(CGPoint)P1:(CGPoint)P2
{
    CGFloat a = powf(P1.y-P2.y, 2.f);
    CGFloat b = powf(P1.x-P2.x, 2.f);
    return sqrtf(a + b);
}

+(NSString*) WeekOfDay: (NSInteger) weekOfDay
{
    switch (weekOfDay) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }
}

-(void) RemoveErrorMessageViewBy:(id) EMDelegate
{
    if (EMDelegate) {
        if ([[EMDelegate view] viewWithTag:9999]) {
            [[[EMDelegate view] viewWithTag:9999] removeFromSuperview];
        }
    }
}

+(void) ErrorMessageForDelegate:(id) delegate Title:(NSString*) Title Message:(NSString*) ErrorMessage
{
    if (delegate && [delegate isKindOfClass:[UIViewController class]]) {
        NSTimeInterval errorDisplayTime = 2.2f;
        if ([[delegate view]viewWithTag:9999]) {
            [[[delegate view]viewWithTag:9999] removeFromSuperview];
        }
        ErrorViewController *indicaterView = [[ErrorViewController alloc] initWithNibName:@"ErrorViewController" bundle:nil];
         ;
        [[delegate view] addSubview:indicaterView.view];

//        indicaterView.mErrorTitle.text = Title;
        indicaterView.mErrorDescription.text = ErrorMessage;
        [indicaterView.view setTag:9999];
        indicaterView.view.center = CGPointMake(160, 240);
        UIView *view = indicaterView.view;
        [UIView beginAnimations:@"dismissErrorMessageView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:errorDisplayTime];
        [view viewWithTag:9998].alpha=0.3;
        [UIView commitAnimations];
        [indicaterView release];

        [[Tools sharedTools] performSelector:@selector(RemoveErrorMessageViewBy:)  withObject:delegate afterDelay:errorDisplayTime];
    }else {
        [Tools showAlert:ErrorMessage];
    }
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}
@end
