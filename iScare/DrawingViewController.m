//
//  DrawingViewController.m
//  YouCai
//
//  Created by Cina on 11/6/12.
//  Copyright (c) 2012 Cina. All rights reserved.
//

#import "DrawingViewController.h"
#import "ResourceHelper.h"
#import "Tools.h"
#import "ScrawlViewController.h"
#import "AddWeightViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface DrawingViewController ()

@end

@implementation DrawingViewController

@synthesize candleChart, autoCompleteView, candleChartFreqView, timer
, lastTime;


-(void)goPreviousController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self release];
}

-(void)goAddWeight:(id)sender
{
    AddWeightViewController *addWeightViewController = [[AddWeightViewController alloc] initWithNibName:@"AddWeightViewController" bundle:nil];
    addWeightViewController.title = @"财经日历";
    [self.navigationController pushViewController:addWeightViewController animated:YES];
    [addWeightViewController release];
}

-(void) goScrawlViewController:(id)sender
{
    ScrawlViewController *settingsVC = [[ScrawlViewController alloc]initWithNibName:@"ScrawlViewController" bundle:nil];
    settingsVC.mSinaShareContent = [NSString stringWithFormat:@"%@ (分享自@有哇移动搜索) ", @""];
    
    [self.navigationController presentModalViewController:settingsVC animated:YES];
    
    // 把当前的Source Scrawl View 拍照，发送到Scrawling View中去
    UIGraphicsBeginImageContext(self.view.bounds.size);
    
    [candleChart.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 如此保存到本地，暂时不用保存
    UIImageView *screenImage = [[[UIImageView alloc]initWithImage:screenShotimage] autorelease];
    [settingsVC.mSourceScrawingView addSubview:screenImage];
    [settingsVC.mSourceScrawingView sendSubviewToBack:screenImage];
    screenImage.center = settingsVC.mSourceScrawingView.center;
    [settingsVC release];
}


-(void)goDrawingChart:(id)sender
{
    NSMutableArray *data =[[NSMutableArray alloc] init];
	NSMutableArray *category =[[NSMutableArray alloc] init];
    
    if (![[Tools sharedTools]mUserWeights] && [[[Tools sharedTools]mUserWeights] count] < 1) {
        return;
    }
    
    for (int i = 0; i < [[[Tools sharedTools]mUserWeights] count]; i++) {
        [category addObject:[[[[Tools sharedTools]mUserWeights] objectAtIndex:i] valueForKey:@"date"]];
        [data addObject:[[[[Tools sharedTools]mUserWeights] objectAtIndex:i] valueForKey:@"weight"]];
    }
    
	if(data.count==0){
	    return;
	}
    
    if(self.timer != nil)
        [self.timer invalidate];
    [self.candleChart reset];
    [self.candleChart clearData];
    [self.candleChart clearCategory];
    
	self.lastTime = [category lastObject];
	
    // 设置Y轴的数据
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	[self generateData:dic From:data];
	[self setData:dic];
	[dic release];
	
    // 设置X轴的数据
    [self setCategory:category];
    
	[self.candleChart setNeedsDisplay]; //获取到数据后，重新展示CandleChart
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    self.candleChart = [[Chart alloc] initWithFrame:CGRectMake(-10, 40, self.view.frame.size.width+20, self.view.frame.size.height-235)];
    candleChart.layer.borderColor = [UIColor blackColor].CGColor;
    candleChart.layer.borderWidth = 1.0f;
	[self.view addSubview:candleChart];

    //init chart
    [self initChart];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self goDrawingChart:nil];
}

//股票中MA5,MA10,MA20,MA60这4条线分别是 5日（白）、10日（黄）、20日（紫）及60日（绿）均线。
-(void)initChart{
	NSMutableArray *padding = [NSMutableArray arrayWithObjects:@"20",@"20",@"20",@"20",nil];
	[self.candleChart setPadding:padding];
	NSMutableArray *secs = [[NSMutableArray alloc] init];
	[secs addObject:@"4"];
//	[secs addObject:@"1"];
//	[secs addObject:@"1"];
    
	[self.candleChart addSections:1 withRatios:secs];
//    [self.candleChart getSection:2].hidden = YES;
	[[[self.candleChart sections] objectAtIndex:0] addYAxis:0];
//	[[[self.candleChart sections] objectAtIndex:1] addYAxis:0];
//	[[[self.candleChart sections] objectAtIndex:2] addYAxis:0];
	
//	[self.candleChart getYAxis:2 withIndex:0].baseValueSticky = NO;
//	[self.candleChart getYAxis:2 withIndex:0].symmetrical = NO;
//	[self.candleChart getYAxis:0 withIndex:0].ext = 0.05;
  
    // test start
    
    // test end
	NSMutableArray *series = [[NSMutableArray alloc] init];
	NSMutableArray *secOne = [[NSMutableArray alloc] init];
	
	NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
	NSMutableArray *data = [[NSMutableArray alloc] init];
    
    
    [serie setObject:@"price" forKey:@"name"];
    [serie setObject:@"Weight" forKey:@"label"];

//	[serie setObject:@"Price" forKey:@"label"];
	[serie setObject:data forKey:@"data"];
	[serie setObject:@"candle" forKey:@"type"];
	[serie setObject:@"0" forKey:@"yAxis"];
	[serie setObject:@"0" forKey:@"section"];
	[serie setObject:@"249,222,170" forKey:@"color"];
	[serie setObject:@"249,222,170" forKey:@"negativeColor"];
	[serie setObject:@"249,222,170" forKey:@"selectedColor"];
	[serie setObject:@"249,222,170" forKey:@"negativeSelectedColor"];
	[serie setObject:@"176,52,52" forKey:@"labelColor"];
	[serie setObject:@"77,143,42" forKey:@"labelNegativeColor"];
	[series addObject:serie];
	[secOne addObject:serie];
	[data release];
	[serie release];
    
    //MA30  黄线
//    serie = [[NSMutableDictionary alloc] init];
//    data = [[NSMutableArray alloc] init];
//    [serie setObject:@"ma30" forKey:@"name"];
//    [serie setObject:@"MA30" forKey:@"label"];
//    [serie setObject:data forKey:@"data"];
//    [serie setObject:@"line" forKey:@"type"];
//    [serie setObject:@"0" forKey:@"yAxis"];
//    [serie setObject:@"0" forKey:@"section"];
//    [serie setObject:@"250,232,115" forKey:@"color"];
//    [serie setObject:@"250,232,115" forKey:@"negativeColor"];
//    [serie setObject:@"250,232,115" forKey:@"selectedColor"];
//    [serie setObject:@"250,232,115" forKey:@"negativeSelectedColor"];
//    [series addObject:serie];
//    [secOne addObject:serie];
//    [data release];
//    [serie release];
    
    //candleChart init
    [self.candleChart setSeries:series];
	[series release];

    [[[self.candleChart sections] objectAtIndex:0] setSeries:secOne];
	[secOne release];
//    [[[self.candleChart sections] objectAtIndex:1] setSeries:secTwo];
//    [secTwo release];
//    [[[self.candleChart sections] objectAtIndex:2] setSeries:secThree];
//    [[[self.candleChart sections] objectAtIndex:2] setPaging:YES];
//    [secThree release];

	NSString *indicatorsString =[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"indicators" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
	if(indicatorsString != nil){
		NSArray* indicators =  [indicatorsString JSONValue];
		for(NSObject *indicator in indicators){
			if([indicator isKindOfClass:[NSArray class]]){
				NSMutableArray *arr = [[NSMutableArray alloc] init];
				for(NSDictionary *indic in (NSDictionary*)indicator){
					NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
					[self setOptions:indic ForSerie:serie];
					[arr addObject:serie];
					[serie release];
				}
			    [self.candleChart addSerie:arr];
				[arr release];
			}else{
				NSDictionary *indic = (NSDictionary *) indicator;
				NSMutableDictionary *serie = [[NSMutableDictionary alloc] init];
				[self setOptions:indic ForSerie:serie];
				[self.candleChart addSerie:serie];
				[serie release];
			}
		}
	}
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 10.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.candleChart addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

-(void)setOptions:(NSDictionary *)options ForSerie:(NSMutableDictionary *)serie;{
	[serie setObject:[options objectForKey:@"name"] forKey:@"name"];
	[serie setObject:[options objectForKey:@"label"] forKey:@"label"];
	[serie setObject:[options objectForKey:@"type"] forKey:@"type"];
	[serie setObject:[options objectForKey:@"yAxis"] forKey:@"yAxis"];
	[serie setObject:[options objectForKey:@"section"] forKey:@"section"];
	[serie setObject:[options objectForKey:@"color"] forKey:@"color"];
	[serie setObject:[options objectForKey:@"negativeColor"] forKey:@"negativeColor"];
	[serie setObject:[options objectForKey:@"selectedColor"] forKey:@"selectedColor"];
	[serie setObject:[options objectForKey:@"negativeSelectedColor"] forKey:@"negativeSelectedColor"];
}

-(void)setCategory:(NSArray *)category{
	[self.candleChart appendToCategory:category forName:@"price"];
	[self.candleChart appendToCategory:category forName:@"line"];
}

//将获取来的数据转换为CandleChart 需要的数据
-(void)generateData:(NSMutableDictionary *)dic From:(NSArray *)data{
    
    //price
    NSMutableArray *price = [[NSMutableArray alloc] init];
    for(int i = 0;i < data.count;i++){
        [price addObject: [data objectAtIndex:i]];
    }
    [dic setObject:price forKey:@"price"];
    [price release];

}

//将获取来的数据转换为CandleChart 需要的数据
-(void)setData:(NSDictionary *)dic{
    
	[self.candleChart appendToData:[dic objectForKey:@"price"] forName:@"price"];
	
	[self.candleChart appendToData:[dic objectForKey:@"ma10"] forName:@"ma10"];
	[self.candleChart appendToData:[dic objectForKey:@"ma30"] forName:@"ma30"];
	[self.candleChart appendToData:[dic objectForKey:@"ma60"] forName:@"ma60"];
	
	NSMutableDictionary *serie = [self.candleChart getSerie:@"price"];
	if(serie == nil)
		return;
    [serie setObject:@"line" forKey:@"type"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (fromInterfaceOrientation != UIDeviceOrientationPortrait) {
        [self showTabBar:self.tabBarController];
    }
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIDeviceOrientationPortrait) {
//        candleChart.frame = CGRectMake(-10, 40, 340, 280);
        candleChart.frame = CGRectMake(-10, 40, 340, 225);
        
    }else
    {
        [self hideTabBar:self.tabBarController];
        candleChart.frame = CGRectMake(0, 0, 480, 300);
    }
    [candleChart setNeedsDisplay];
}

- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }

    [UIView commitAnimations];
}

- (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)]; 
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
	[self.timer invalidate];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
    if (candleChart) {
        [candleChart release];
        candleChart = nil;
    }
}

@end
