//
//  ChangeColorViewController.h
//  FinanceTest
//
//  Created by 薛 千 on 5/9/12.
//  Copyright (c) 2012 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeSizeVC : UIViewController
-(IBAction)goSliderValueChanged:(id)sender;
@property(nonatomic, retain) id delegate;
@property(nonatomic, retain) IBOutlet UISlider *mSlider;
@end
