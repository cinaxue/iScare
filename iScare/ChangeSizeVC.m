//
//  ChangeColorViewController.m
//  FinanceTest
//
//  Created by 薛 千 on 5/9/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import "ChangeSizeVC.h"
#import "WhiteBoardView.h"

@interface ChangeSizeVC ()

@end

@implementation ChangeSizeVC
@synthesize delegate;
@synthesize mSlider;

-(void)goSliderValueChanged:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    if (delegate) {
        [delegate setPenSize:[slider value]];
    }else {
        NSLog(@"No value");
    }
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [mSlider release];mSlider = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
