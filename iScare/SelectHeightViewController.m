//
//  SelectHeightViewController.m
//  iScare
//
//  Created by Cina on 11/19/12.
//  Copyright (c) 2012 Cina. All rights reserved.
//

#import "SelectHeightViewController.h"
#import "Tools.h"

@interface SelectHeightViewController ()

@end

@implementation SelectHeightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)goAddWeight:(id)sender
{
    float weightInt =[[self pickerView:self.mPickerView titleForRow:[self.mPickerView selectedRowInComponent:0] forComponent:0] floatValue];
    float weightFloat =[[self pickerView:self.mPickerView titleForRow:[self.mPickerView selectedRowInComponent:1] forComponent:1] floatValue];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingFormat:@"/Settings.plist"];
    NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [aDic setValue:[NSNumber numberWithFloat:(weightInt + weightFloat)] forKey:@"UserWeight"];
    [aDic writeToFile:path atomically:YES];
    [[Tools sharedTools] setMUserHight:(weightInt + weightFloat)];
    [self goPreviousController:nil];
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
    self.rowOfSection = 60;
    self.currentValue =[Tools sharedTools].mUserHight;
    self.mUnit = @"cm";
    self.mSelectedWeight.text = [NSString stringWithFormat:@"%.1f%@", self.currentValue,self.mUnit];
    
    [self.mPickerView selectRow:(int)(self.rowOfSection/1.9999) inComponent:0 animated:NO];
    [self.mPickerView selectRow:0 inComponent:1 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
