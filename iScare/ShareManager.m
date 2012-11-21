//
//  ShareManager.m
//  caijing
//
//  Created by 千 薛 on 6/21/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import "ShareManager.h"
#import "Tools.h"
//#import "AboutYouwaViewController.h"

static ShareManager *sharedManger;

@implementation ShareManager
@synthesize delegate;
@synthesize selector;
@synthesize weiBoEngine;
@synthesize sharedContent,sharedImage;

+ (ShareManager *)shared
{
    if (sharedManger) {
        return sharedManger;
    }else
    {
        sharedManger = [[ShareManager alloc] init];
        if (!sharedManger.weiBoEngine) {
            sharedManger.weiBoEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
            [sharedManger.weiBoEngine setRedirectURI:kWBRedirectURL];
            [sharedManger.weiBoEngine setIsUserExclusive:NO];
        }
        return sharedManger;
    }
}

-(id) init
{
    self = [super init];
    if (self) {
        popoverClass = [WEPopoverController class];
    }
    return self;
}

-(void)goShareToSina:(NSString*) content AndImage: (UIImage*) image
{
    if (!weiBoEngine) {
        weiBoEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        [weiBoEngine setRedirectURI:kWBRedirectURL];
        [weiBoEngine setIsUserExclusive:NO];
    }
    
    [weiBoEngine setRootViewController:delegate];
    [weiBoEngine setDelegate:self];
    
    if (![weiBoEngine isLoggedIn] && ![weiBoEngine isAuthorizeExpired])
    {
        [weiBoEngine logIn];
        self.sharedContent = content;
        self.sharedImage = image;
    }else {
        WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:content image:image];
        [sendView setDelegate:self];
        [sendView show:YES];
        [sendView release];
    }
}

-(void)goShareToTencent:(NSString*) content AndImage: (UIImage*) image
{
}

- (void)tencentDidLogin {
	// 登录成功
	NSLog(@"登陆成功！");
}

-(void)goSendMessage:(NSString*) title :(NSString*) content :(UIImage*) image
{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        if(mailController!=nil) {
            mailController.mailComposeDelegate = self;
            
            [mailController setSubject:title];
            [mailController setMessageBody:content isHTML:YES];
//            if ([delegate isKindOfClass:[AboutYouwaViewController class]]) {
//                [mailController setToRecipients:[NSArray arrayWithObject:@"service@biz-wiz.com.cn"]];
//            }
            if (image) {
                NSData *imageData = UIImagePNGRepresentation(image);
                [mailController addAttachmentData:imageData mimeType:@"image/png" fileName:@"MyImageName"];
            }
            [delegate presentModalViewController:mailController animated:YES];
            [mailController release];
        }
        else
        {
            //Do something like show an alert
            [Tools ErrorMessageForDelegate:nil
                                     Title:ErrorMessage_Normal
                                   Message:@"您还没有绑定邮箱，请先绑定邮箱在尝试分享：）"];
        }
    }
}

#pragma mark - WBSendViewDelegate Methods
- (void)sendViewDidFinishSending:(WBSendView *)view
{
    [view hide:YES];
    [Tools ErrorMessageForDelegate:nil Title:ErrorMessage_Normal Message:@"微博发送成功！"];
}
-(void) sendViewAuthorizeExpired:(WBSendView *)view
{
    [view hide:YES];
    [weiBoEngine logIn];
}
-(void)sendViewNotAuthorized:(WBSendView *)view
{
    [view hide:YES];
    [weiBoEngine logIn];
}
- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    [view hide:YES];

    if (error) {        
        if ([[[error userInfo] valueForKey:@"error_code"] intValue] == 21327 ||[[[error userInfo] valueForKey:@"error_code"] intValue] == 21332) {
            [Tools ErrorMessageForDelegate:nil Title:ErrorMessage_Normal Message:[NSString stringWithFormat:@"%@,请重新登录",[[error userInfo] valueForKey:@"error"]]];
            [weiBoEngine logIn];
        }else
            [Tools ErrorMessageForDelegate:nil Title:ErrorMessage_Normal Message:@"微博发送失败！"];
    }
}

-(void)engineDidLogIn:(WBEngine *)engine
{
    if (self.sharedImage || self.sharedContent) {
        WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:self.sharedContent image:self.sharedImage];
        [sendView setDelegate:self];
        [sendView show:YES];
        [sendView release];
    }
    if (delegate && selector) {
        [delegate performSelector:selector];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        [Tools ErrorMessageForDelegate:nil Title:ErrorMessage_Normal Message:@"发送邮件成功！"];
    }
    [delegate dismissModalViewControllerAnimated:YES];
}

@end
