//
//  AddWeightViewController.m
//  iScare
//
//  Created by Cina on 11/19/12.
//  Copyright (c) 2012 Cina. All rights reserved.
//

#import "AddWeightViewController.h"
#import "Tools.h"
@interface AddWeightViewController ()

@end

@implementation AddWeightViewController
@synthesize mButtonDismiss;
@synthesize mPickerView;
@synthesize mSelectedWeight;
@synthesize mUnit;
@synthesize rowOfSection,currentValue;

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
    float weightInt =[[self pickerView:mPickerView titleForRow:[mPickerView selectedRowInComponent:0] forComponent:0] floatValue];
    float weightFloat =[[self pickerView:mPickerView titleForRow:[mPickerView selectedRowInComponent:1] forComponent:1] floatValue];

    if ([Tools addWeight:weightInt + weightFloat]) {
        [self goPreviousController:nil];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.rowOfSection;
    }else
        return 10;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    float weightInt =[[self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:0] forComponent:0] floatValue];
    float weightFloat =[[self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:1] forComponent:1] floatValue];
    
    self.mSelectedWeight.text = [NSString stringWithFormat:@"%.1f%@", weightInt + weightFloat,self.mUnit];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%d", ((int) self.currentValue) + row- (int)((self.rowOfSection -1)/2)];
    }
    if (component == 1) {

        return [NSString stringWithFormat:@"%.1f", (float)row/10];
    }
    return [NSString stringWithFormat:@"%f", self.currentValue];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.rowOfSection = 15;
    if ([Tools sharedTools].mUserWeights.count > 0) {
        self.currentValue =[[[[Tools sharedTools].mUserWeights lastObject] valueForKey:@"weight"] floatValue];
    }else{
        float defaultWeight = 80.0f;
        self.currentValue =defaultWeight;
    }
    self.mUnit = [Tools sharedTools].mMeasureUnit;
    self.mSelectedWeight.text = [NSString stringWithFormat:@"%.1f%@", self.currentValue,self.mUnit];

    [mPickerView selectRow:(int)(self.rowOfSection/2) inComponent:0 animated:NO];
    [mPickerView selectRow:((int)(self.currentValue*10))%10 inComponent:1 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
