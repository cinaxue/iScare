//
//  ShareManager.h
//  caijing
//
//  Created by 千 薛 on 6/21/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "WBSendView.h"
#import <MessageUI/MessageUI.h>
#import "WEPopoverController.h"

@interface ShareManager : NSObject<UIPopoverControllerDelegate,WBEngineDelegate,WBSendViewDelegate, MFMailComposeViewControllerDelegate>
{
    WEPopoverController *popoverController;
    Class popoverClass;
        
    WBEngine *weiBoEngine;
    
    NSMutableArray* tencentPermissions;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSString *sharedContent;
@property (nonatomic, retain) UIImage *sharedImage;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) WBEngine *weiBoEngine;


+ (ShareManager *)shared;
-(void)goShareToSina:(NSString*) content AndImage: (UIImage*) image;
-(void)goSendMessage:(NSString*) title :(NSString*) content :(UIImage*) image;
-(void)goShareToTencent:(NSString*) content AndImage: (UIImage*) image;

@end
