//
//  Tools.h
//  youwa
//
//  Created by 薛 千 on 4/18/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface UserWeight : NSObject
{
    NSDate *imputDate;
    float imputWeight;
}
@property(readwrite) float imputWeight;
@property(nonatomic, retain) NSDate *imputDate;

@end

@interface Tools : NSObject 
{
    NSInteger mBackgroundImagePath;
}

@property(readwrite) NSInteger mBackgroundImagePath;
@property(nonatomic, retain) id delegate;
@property(readwrite) BOOL mUserGender;
@property(readwrite) float mUserHight;
@property(nonatomic, assign) SEL selector;
@property(nonatomic, retain) NSString *mMeasureUnit;
@property(nonatomic, retain) NSMutableArray *mUserWeights;

+ (Tools*) sharedTools;
+ (void) showAlert:(NSString*) aLog;
+(NSString*) WeekOfDay: (NSInteger) weekOfDay;

+(void) ErrorMessageForDelegate:(id) delegate Title:(NSString*) Title Message:(NSString*) ErrorMessage;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (BOOL) addWeight:(float) weight;
@end
