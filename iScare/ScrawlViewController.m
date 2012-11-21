//
//  ScrawlViewController.m
//  caijing
//
//  Created by 薛 千 on 6/12/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import "ScrawlViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ChangeSizeVC.h"
#import "ShareViewController.h"
#import "ChangeColorVC.h"
#import "EraserVC.h"
#import "Tools.h"
#import "ShareManager.h"
#import "IndicateView.h"

#define kWBAlertViewLogOutTag 100
#define kWBAlertViewLogInTag  101

@interface ScrawlViewController ()

@end

@implementation ScrawlViewController
@synthesize mSourceScrawingView;
@synthesize mSinaShareContent;

-(void)goPreviousController:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    //    [self release];

}

-(void)goSendMessage:(id)sender
{
    if (!mSinaShareContent) {
        mSinaShareContent = @" (分享自@有哇移动搜索)";
    }
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.mSourceScrawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();

    [ShareManager shared].delegate = self;
    if (!mSinaShareContent) {
        [[ShareManager shared] goSendMessage:@"有哇移动搜索" :@"(分享自: 有哇移动搜索iPhone 客户端)" :screenShotimage];
    }else {
        NSString *shareContent = [mSinaShareContent stringByReplacingOccurrencesOfString:@"@有哇移动搜索" withString:@""];
        shareContent = [shareContent stringByAppendingString:@" <p> (分享自: 有哇移动搜索iPhone 客户端)"];

        [[ShareManager shared] goSendMessage:mSinaShareContent :shareContent :screenShotimage];
    }
}

-(void)goShareToSina:(id)sender
{
    if (!mSinaShareContent) {
        mSinaShareContent = @" 分享自@有哇移动搜索";
    }
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.mSourceScrawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();
    
    [[ShareManager shared] goShareToSina:mSinaShareContent AndImage:screenShotimage];
    [ShareManager shared].delegate = self;
}

//-(void)goSaveToLocal:(id)sender
//{
//    UIGraphicsBeginImageContext(self.view.bounds.size);
//    [self.mSourceScrawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // 如此保存到本地，暂时不用保存
//    UIImageWriteToSavedPhotosAlbum(screenShotimage, nil, nil, nil);
//    UIGraphicsEndImageContext();
//}
- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    if(error != nil) {
        [Tools showAlert:[error localizedDescription]];
    }else {
        [[self.view viewWithTag:TagIndicater_999] removeFromSuperview];
        [Tools ErrorMessageForDelegate:nil Title:ErrorMessage_Normal Message:@"保存成功！"];
    }
}

-(void)goSaveToLocal:(id)sender
{    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.mSourceScrawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 如此保存到本地，暂时不用保存
    UIImageWriteToSavedPhotosAlbum(screenShotimage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    IndicateView *indicaterView = [[IndicateView alloc] initWithNibName:@"IndicateView" bundle:nil];
    [self.view addSubview:indicaterView.view];
    [indicaterView.view setTag:TagIndicater_999];
    indicaterView.view.center = CGPointMake(160, 240);
    [indicaterView release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self goShareToSina:nil];
    }else if (buttonIndex == 1)
    {
        [self goSaveToLocal:nil];
    }else if (buttonIndex == 2)
    {
        [self goSendMessage:nil];
    }
}

-(void)goShareScrawlView:(id)sender
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"有哇分享" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"分享到新浪微博",@"保存到本地",@"发送邮件",@"取消", nil] autorelease];
    actionSheet.cancelButtonIndex = 3;
	[actionSheet showInView:self.view];

}

-(void) goDismissShareScrawlView:(id)sender
{
    UIView *ShareView = [self.view viewWithTag:777];
    if (ShareView) {
        [UIView beginAnimations:@"dismissPickerView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:0.3f];
        ShareView.frame = CGRectMake(ShareView.frame.origin.x, 480, ShareView.frame.size.width, ShareView.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)goPenSize:(id)sender
{
    
    if (!popoverController) {
		ChangeSizeVC *contentViewController = [[ChangeSizeVC alloc] initWithNibName:@"ChangeSizeVC" bundle:nil];
        contentViewController.delegate = writeBoard;
        contentViewController.contentSizeForViewInPopover = contentViewController.view.frame.size;
		popoverController = [[popoverClass alloc] initWithContentViewController:contentViewController];
        if ([popoverController respondsToSelector:@selector(setContainerViewProperties:)]) {
			[popoverController setContainerViewProperties:[self improvedContainerViewProperties]];
		}
		popoverController.delegate = self;		
        [popoverController presentPopoverFromRect:CGRectMake([sender frame].origin.x, [sender frame].origin.y, [sender frame].size.width, [sender frame].size.height)
                                           inView:self.mSourceScrawingView
                         permittedArrowDirections:UIPopoverArrowDirectionDown
                                         animated:YES];
        contentViewController.mSlider.value = writeBoard.penSize;

		[contentViewController release];
	} else {
        if (popoverController) {
            [popoverController dismissPopoverAnimated:YES];
            popoverController = nil;
        }
	}
}

-(void)goPenColor:(id)sender
{    
    if (!popoverController) {
        
		ChangeColorVC *contentViewController = [[ChangeColorVC alloc] initWithNibName:@"ChangeColorVC" bundle:nil];
        contentViewController.delegate = writeBoard;
        contentViewController.contentSizeForViewInPopover = contentViewController.view.frame.size;
		popoverController = [[popoverClass alloc] initWithContentViewController:contentViewController];
        if ([popoverController respondsToSelector:@selector(setContainerViewProperties:)]) {
			[popoverController setContainerViewProperties:[self improvedContainerViewProperties]];
		}
		popoverController.delegate = self;		
        [popoverController presentPopoverFromRect:CGRectMake([sender frame].origin.x, [sender frame].origin.y, [sender frame].size.width, [sender frame].size.height)
                                           inView:self.mSourceScrawingView
                         permittedArrowDirections:UIPopoverArrowDirectionDown
                                         animated:YES];
		[contentViewController release];
	} else {
        if (popoverController) {
            [popoverController dismissPopoverAnimated:YES];
            popoverController = nil;
        }
	}
}

-(void)goEraserView:(id)sender
{
    UIButton *button = (UIButton*) sender;

    if (isPen) {
        currentColor = writeBoard.penColor;
        [writeBoard setPenColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage imageNamed:@"ic_drawer_tool_brush_normal.png"]
                          forState:UIControlStateNormal];
        isPen = NO;
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"ic_drawer_tool_erase_normal.png"]
                          forState:UIControlStateNormal];
        [writeBoard setPenColor:currentColor];
        isPen = YES;
    }
}

- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] autorelease];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"popoverBg.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13 
	bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = contentMargin; 
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = 4.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;	
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    popoverClass = [WEPopoverController class];
    if (mSourceScrawingView.frame.size.width > mSourceScrawingView.frame.size.height) {
        writeBoard = [[WhiteBoardView alloc]initWithFrame: CGRectMake(0, 0, mSourceScrawingView.frame.size.height, mSourceScrawingView.frame.size.width)];
    }else
        writeBoard = [[WhiteBoardView alloc]initWithFrame: CGRectMake(0, 0, mSourceScrawingView.frame.size.width, mSourceScrawingView.frame.size.height)];

    writeBoard.layer.borderColor = [UIColor grayColor].CGColor;
//    writeBoard.layer.borderWidth = 1.0f;
    writeBoard.penColor = [UIColor redColor];
    writeBoard.penSize = 5.0f;
    [mSourceScrawingView addSubview:writeBoard];
    [mSourceScrawingView bringSubviewToFront:writeBoard];
    [writeBoard release];
    isPen = YES;
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    [mSourceScrawingView release];mSourceScrawingView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
