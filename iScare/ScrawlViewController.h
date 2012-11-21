//
//  ScrawlViewController.h
//  caijing
//
//  Created by 薛 千 on 6/12/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhiteBoardView.h"
#import "WEPopoverController.h"
#import <MessageUI/MessageUI.h>

@interface ScrawlViewController : UIViewController<WEPopoverControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

{
    WhiteBoardView *writeBoard;
    WEPopoverController *popoverController;
    Class popoverClass;
    
    UIActivityIndicatorView *indicatorView;
    BOOL isPen;
    UIButton *logInBtnOAuth;
    UIButton *logInBtnXAuth;

    UIColor *currentColor;
}
@property(nonatomic, retain) NSString *mSinaShareContent;

-(IBAction)goPreviousController:(id)sender;
-(IBAction)goShareScrawlView:(id)sender;
-(IBAction)goPenSize:(id)sender;
-(IBAction)goPenColor:(id)sender;
//-(IBAction)goAddText:(id)sender;
-(IBAction)goEraserView:(id)sender;

// share
-(IBAction)goShareToSina:(id)sender;
-(IBAction)goSaveToLocal:(id)sender;
-(IBAction)goSendMessage:(id)sender;
@property (nonatomic, retain) IBOutlet UIView *mSourceScrawingView;
@end
