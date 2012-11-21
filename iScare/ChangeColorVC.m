//
//  ChangeColorVC.m
//  caijing
//
//  Created by 薛 千 on 6/12/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import "ChangeColorVC.h"
#import "WhiteBoardView.h"

@interface ChangeColorVC ()

@end

@implementation ChangeColorVC
@synthesize delegate;

-(void)goChangeColor:(id)sender
{
    switch ([sender tag]) {
        case 0:
            [delegate setPenColor:[UIColor redColor]];
            break;
        case 1:
            [delegate setPenColor:[UIColor greenColor]];
            break;
        case 2:
            [delegate setPenColor:[UIColor purpleColor]];
            break;
        case 3:
            [delegate setPenColor:[UIColor blackColor]];
            break;
        case 4:
            [delegate setPenColor:[UIColor blueColor]];
            break;
        case 5:
            [delegate setPenColor:[UIColor yellowColor]];
            break;
        case 6:
            [delegate setPenColor:[UIColor orangeColor]];
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
