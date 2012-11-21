//
//  EraserVC.m
//  caijing
//
//  Created by 薛 千 on 6/12/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import "EraserVC.h"
#import "WhiteBoardView.h"

@interface EraserVC ()

@end

@implementation EraserVC
@synthesize delegate;

-(void)goChangeEraserSize:(id)sender
{
    [delegate setPenColor:[UIColor clearColor]];

    switch ([sender tag]) {
        case 0:
            [delegate setPenSize:1];
            break;
        case 1:
            [delegate setPenSize:5];
            break;
        case 2:
            [delegate setPenSize:8];
            break;
        case 3:
            [delegate setPenSize:10];
            break;
        case 4:
            [delegate setPenSize:15];
            break;
        default:
            break;
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
