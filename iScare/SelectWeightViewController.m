//
//  SelectWeightViewController.m
//  iScare
//
//  Created by Cina on 11/19/12.
//  Copyright (c) 2012 Cina. All rights reserved.
//

#import "SelectWeightViewController.h"
#import "Tools.h"

@interface SelectWeightViewController ()

@end

@implementation SelectWeightViewController

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
    
    if ([Tools sharedTools].mUserWeights.count > 0) {
        [Tools showAlert:@"您已经设置过体重了，如果重新设置以前的记录将会被清楚，您确定要重新开始记录么？"];
    }else{
        [Tools addWeight:weightInt + weightFloat];
        [self goPreviousController:nil];
    }
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
    self.rowOfSection = 75;
    if ([Tools sharedTools].mUserWeights.count > 0) {
        self.currentValue =[[[[Tools sharedTools].mUserWeights lastObject] valueForKey:@"weight"] floatValue];
    }else{
        float defaultWeight = 80.0f;
        self.currentValue =defaultWeight;
    }

    self.mUnit = [Tools sharedTools].mMeasureUnit;
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
