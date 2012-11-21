//
//  AddWeightViewController.h
//  iScare
//
//  Created by Cina on 11/19/12.
//  Copyright (c) 2012 Cina. All rights reserved.
//

#import "iScareModelViewController.h"

@interface AddWeightViewController : iScareModelViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    int rowOfSection;
    float currentValue;
}
@property (nonatomic, retain) IBOutlet UIButton *mButtonDismiss;
@property (nonatomic, retain) IBOutlet UIPickerView *mPickerView;
@property (nonatomic, retain) IBOutlet UILabel *mSelectedWeight;
@property (nonatomic, retain) NSString *mUnit;
@property (readwrite) int rowOfSection;
@property (readwrite) float currentValue;

-(IBAction)goAddWeight:(id)sender;

@end
