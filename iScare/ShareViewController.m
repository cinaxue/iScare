//
//  ShareViewController.m
//  caijing
//
//  Created by 薛 千 on 6/12/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize mButtonSaveToLocal,mButtonSendMessage,mButtonShareToSina;
@synthesize mButtonDismiss;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [mButtonShareToSina release];mButtonShareToSina = nil;
    [mButtonSaveToLocal release];mButtonSaveToLocal = nil;
    [mButtonSendMessage release];mButtonSendMessage = nil;
    [mButtonDismiss release];mButtonDismiss = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
