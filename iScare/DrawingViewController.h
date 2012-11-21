//
//  DrawingViewController.h
//  YouCai
//
//  Created by Cina on 11/6/12.
//  Copyright (c) 2012 Cina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chart.h"
#import <QuartzCore/QuartzCore.h>
#import "YAxis.h"

@interface DrawingViewController : UIViewController
{
	Chart *candleChart;
	UITableView *autoCompleteView;
	UIView *toolBar;
	UIView *candleChartFreqView;

	NSString *lastTime;
	NSTimer *timer;

    NSMutableArray * mDataList;
}

@property (nonatomic,retain) IBOutlet Chart *candleChart;
@property (nonatomic,retain) UITableView *autoCompleteView;
@property (nonatomic,retain) UIView *candleChartFreqView;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,retain) NSString *lastTime;

-(IBAction)goDrawingChart:(id)sender;
-(IBAction)goPreviousController:(id)sender;
-(IBAction)goAddWeight:(id)sender;
-(IBAction)goScrawlViewController:(id)sender;
-(void)initChart;
-(void)generateData:(NSMutableDictionary *)dic From:(NSArray *)data;
-(void)setData:(NSDictionary *)dic;
-(void)setCategory:(NSArray *)category;
@end
