//
//  Chart.m
//  https://github.com/zhiyu/chartee/
//
//  Created by zhiyu on 7/11/11.
//  Copyright 2011 zhiyu. All rights reserved.
//

#import "Chart.h"

#define MIN_INTERVAL  3

@implementation Chart

@synthesize enableSelection, isInitialized, isSectionInitialized, borderColor, borderWidth, plotWidth, plotPadding, plotCount, paddingLeft, paddingRight, paddingTop, paddingBottom, padding, selectedIndex, touchFlag, touchFlagTwo, rangeFrom, rangeTo, range, series, sections, ratios, models, title,userDefinedPoints,BackgroundColor;
@synthesize ShangShengGuaiDianDay,XiaJiangGuaiDianDay;
@synthesize isNeedToDisplayPoint;

#pragma mark -

-(float)getLocalY:(float)val withSection:(int)sectionIndex withAxis:(int)yAxisIndex{
	Section *sec = [[self sections] objectAtIndex:sectionIndex];
	YAxis *yaxis = [sec.yAxises objectAtIndex:yAxisIndex];
	CGRect fra = sec.frame;
	float  max = yaxis.max;
	float  min = yaxis.min;
    return fra.size.height - (fra.size.height-sec.paddingTop)* (val-min)/(max-min)+fra.origin.y;
}

// 初始化，数据存放在 self.series 中
- (void)initChart{
	if(!self.isInitialized){ // 判断是否已经初始化过
		self.plotPadding = 1.f;
		if(self.padding != nil){
			self.paddingTop    = [[self.padding objectAtIndex:0] floatValue];
			self.paddingRight  = [[self.padding objectAtIndex:1] floatValue];
			self.paddingBottom = [[self.padding objectAtIndex:2] floatValue];
			self.paddingLeft   = [[self.padding objectAtIndex:3] floatValue];
		}
		
		if(self.series!=nil){
			self.rangeTo = [[[[self series] objectAtIndex:0] objectForKey:@"data"] count];
			if(rangeTo-range >= 0){
				self.rangeFrom = rangeTo-range;
			}else{
			    self.rangeFrom = 0;
			}
		}else{
			self.rangeTo   = 0;
			self.rangeFrom = 0;
		}
		self.selectedIndex = self.rangeTo-1;
		self.isInitialized = YES;
	}

	if(self.series!=nil){
		self.plotCount = [[[[self series] objectAtIndex:0] objectForKey:@"data"] count];
	}
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, 1.0); // 背景色
    CGContextFillRect (context, CGRectMake (0, 0, self.bounds.size.width,self.bounds.size.height)); 
}

-(void)reset{
	self.isInitialized = NO;
}

- (void)initXAxis{

}

- (void)initYAxis{
	for(int secIndex=0;secIndex<[self.sections count];secIndex++){
		Section *sec = [self.sections objectAtIndex:secIndex];
		for(int sIndex=0;sIndex<[sec.yAxises count];sIndex++){
			YAxis *yaxis = [sec.yAxises objectAtIndex:sIndex];
			yaxis.isUsed = NO;
		}
	}
	
	for(int secIndex=0;secIndex<[self.sections count];secIndex++){
		Section *sec = [self.sections objectAtIndex:secIndex];
		if(sec.paging){
			NSObject *serie = [[sec series] objectAtIndex:sec.selectedIndex];
			if([serie isKindOfClass:[NSArray class]]){
				for(int i=0;i<[(NSArray*)serie count];i++){
					[self setValuesForYAxis:[(NSArray*)serie objectAtIndex:i]];
				}
			}else {
				[self setValuesForYAxis:(NSDictionary*)serie];
			}
		}else{
			for(int sIndex=0;sIndex<[sec.series count];sIndex++){
				NSObject *serie = [[sec series] objectAtIndex:sIndex];
				if([serie isKindOfClass:[NSArray class]]){
					for(int i=0;i<[(NSArray*)serie count];i++){
						[self setValuesForYAxis:[(NSArray*)serie objectAtIndex:i]];
					}
				}else {
					[self setValuesForYAxis:(NSDictionary*)serie];
				}
			}
		}
		
		for(int i = 0;i<sec.yAxises.count;i++){
			YAxis *yaxis = [sec.yAxises objectAtIndex:i];
			yaxis.max += (yaxis.max-yaxis.min)*yaxis.ext;
			yaxis.min -= (yaxis.max-yaxis.min)*yaxis.ext;
			
			if(!yaxis.baseValueSticky){
				if(yaxis.max >= 0 && yaxis.min >= 0){
					yaxis.baseValue = yaxis.min;
				}else if(yaxis.max < 0 && yaxis.min < 0){
					yaxis.baseValue = yaxis.max;
				}else{
					yaxis.baseValue = 0;
				}
			}else{
				if(yaxis.baseValue < yaxis.min){
					yaxis.min = yaxis.baseValue;
				}
				
				if(yaxis.baseValue > yaxis.max){
					yaxis.max = yaxis.baseValue;
				}
			}
			
			if(yaxis.symmetrical == YES){
				if(yaxis.baseValue > yaxis.max){
					yaxis.max =  yaxis.baseValue + (yaxis.baseValue-yaxis.min);
				}else if(yaxis.baseValue < yaxis.min){
					yaxis.min =  yaxis.baseValue - (yaxis.max-yaxis.baseValue);
				}else {
					if((yaxis.max-yaxis.baseValue) > (yaxis.baseValue-yaxis.min)){
						yaxis.min =  yaxis.baseValue - (yaxis.max-yaxis.baseValue);
					}else{
						yaxis.max =  yaxis.baseValue + (yaxis.baseValue-yaxis.min);
					}
				}
			}	
		}
	}
}

-(void)setValuesForYAxis:(NSDictionary *)serie{
    NSString   *type  = [serie objectForKey:@"type"];
    ChartModel *model = [self getModel:type];
    [model setValuesForYAxis:self serie:serie];	
}

-(void)drawChart{
    for(int secIndex=0;secIndex<self.sections.count;secIndex++){
		Section *sec = [self.sections objectAtIndex:secIndex];
		if(sec.hidden){
		    continue;
		}
		plotWidth = (sec.frame.size.width-sec.paddingLeft)/(self.rangeTo-self.rangeFrom);
		for(int sIndex=0;sIndex<sec.series.count;sIndex++){
			NSObject *serie = [sec.series objectAtIndex:sIndex];
			
			if(sec.hidden){
				continue;
			}
			
			if(sec.paging){
				if (sec.selectedIndex == sIndex) {
					if([serie isKindOfClass:[NSArray class]]){
						for(int i=0;i<[(NSArray*)serie count];i++){
							[self drawSerie:[(NSArray*)serie objectAtIndex:i]];
						}
					}else{
						[self drawSerie:(NSMutableDictionary*)serie];
					}
					break;
				}
			}else{
				if([serie isKindOfClass:[NSArray class]]){
					for(int i=0;i<[(NSArray*)serie count];i++){
						[self drawSerie:[(NSArray*)serie objectAtIndex:i]];
					}
				}else{
					[self drawSerie:(NSMutableDictionary*)serie];
				}
			}			
		}
	}	
	[self drawLabels];
}

-(void)drawLabels{
	for(int i=0;i<self.sections.count;i++){
		Section *sec = [self.sections objectAtIndex:i];
		if(sec.hidden){
		    continue;
		}
		
		float w = 0;
		for(int s=0;s<sec.series.count;s++){
			NSMutableArray *label =[[NSMutableArray alloc] init];
		    NSObject *serie = [sec.series objectAtIndex:s];
			
			if(sec.paging){
				if (sec.selectedIndex == s) {
					if([serie isKindOfClass:[NSArray class]]){
						for(int i=0;i<[(NSArray *)serie count];i++){
							[self setLabel:label forSerie:[(NSArray *)serie objectAtIndex:i]];
						}
					}else{
						[self setLabel:label forSerie:(NSMutableDictionary *)serie];
					}
				}
			}else{
				if([serie isKindOfClass:[NSArray class]]){
					for(int i=0;i<[(NSArray *)serie count];i++){
						[self setLabel:label forSerie:[(NSArray *)serie objectAtIndex:i]];
					}
				}else{
					[self setLabel:label forSerie:(NSMutableDictionary *)serie];
				}
			}	
			for(int j=0;j<label.count;j++){
				NSMutableDictionary *lbl = [label objectAtIndex:j];
				NSString *text  = [lbl objectForKey:@"text"];
                if (![text hasPrefix:@":"]) { // 如果Title 中不是以：开头的，便展示出来
                    NSString *color = [lbl objectForKey:@"color"];
                    NSArray *colors = [color componentsSeparatedByString:@","];
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    CGContextSetShouldAntialias(context, YES);
                    CGContextSetRGBFillColor(context, [[colors objectAtIndex:0] floatValue], [[colors objectAtIndex:1] floatValue], [[colors objectAtIndex:2] floatValue], 1.0);
                    [text drawAtPoint:CGPointMake(sec.frame.origin.x+sec.paddingLeft+2+w,sec.frame.origin.y) withFont:[UIFont systemFontOfSize: 14]];
                    w += [text sizeWithFont:[UIFont systemFontOfSize:14]].width;
                }
			}
			[label release];
		}
	}
}

-(void)setLabel:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
	NSString   *type  = [serie objectForKey:@"type"];
    ChartModel *model = [self getModel:type];
    [model setLabel:self label:label forSerie:serie];		
}

-(void)drawSerie:(NSMutableDictionary *)serie{
    NSString   *type  = [serie objectForKey:@"type"];
    ChartModel *model = [self getModel:type];
    [model drawSerie:self serie:serie];	
    
    NSEnumerator *enumerator = [self.models keyEnumerator];  
    id key;  
    while ((key = [enumerator nextObject])){  
        ChartModel *m = [self.models objectForKey:key];
        [m drawTips:self serie:serie];
    }
}

-(void)drawYAxis{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, NO );
	CGContextSetLineWidth(context, 1.0f);
//    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);

	for(int secIndex=0;secIndex<[self.sections count];secIndex++){
		Section *sec = [self.sections objectAtIndex:secIndex];
		if(sec.hidden){
			continue;
		}
		CGContextMoveToPoint(context, sec.frame.origin.x+sec.paddingLeft,sec.frame.origin.y+sec.paddingTop);
        
		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.paddingLeft,sec.frame.size.height+sec.frame.origin.y);
		CGContextMoveToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.origin.y+sec.paddingTop);
		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.size.height+sec.frame.origin.y);
		CGContextStrokePath(context);
	}
	
	CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1.0);
	CGFloat dash[] = {5};
	CGContextSetLineDash (context,0,dash,1);  

	for(int secIndex=0; secIndex<self.sections.count; secIndex++){
		Section *sec = [self.sections objectAtIndex:secIndex];
		if(sec.hidden){
			continue;
		}
		for(int aIndex=0;aIndex<sec.yAxises.count;aIndex++){
            
            //  最下边一个Y轴的Text
			YAxis *yaxis = [sec.yAxises objectAtIndex:aIndex];
			NSString *format=[@"%." stringByAppendingFormat:@"%df",yaxis.decimal];
			
			float baseY = [self getLocalY:yaxis.baseValue withSection:secIndex withAxis:aIndex];
			CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);
			CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,baseY);
			CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft-2,baseY);
			CGContextStrokePath(context);
			
			[[NSString stringWithFormat:@"%.1f", yaxis.baseValue] drawAtPoint:CGPointMake(sec.frame.origin.x-1,baseY-7) withFont:[UIFont systemFontOfSize: 12]];
			
			CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.15 green:0.15 blue:0.15 alpha:1.0].CGColor);
			CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,baseY);
			CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,baseY);
		
			if (yaxis.tickInterval%2 == 1) {
				yaxis.tickInterval +=1;
			}
			
            //  由上往下前五个
			float step = (float)(yaxis.max-yaxis.min)/yaxis.tickInterval;
			for(int i=1; i<= yaxis.tickInterval+1;i++){
				if(yaxis.baseValue + i*step <= yaxis.max){
					float iy = [self getLocalY:(yaxis.baseValue + i*step) withSection:secIndex withAxis:aIndex];
					
					CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);
                    
					
                    CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
					CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft-2,iy);
					CGContextStrokePath(context);
					
					[[NSString stringWithFormat:@"%.1f", yaxis.baseValue+i*step] drawAtPoint:CGPointMake(sec.frame.origin.x-1,iy-7) withFont:[UIFont systemFontOfSize: 12]];
					
					if(yaxis.baseValue + i*step < yaxis.max){
						CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.15 green:0.15 blue:0.15 alpha:1.0].CGColor);
						CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
						CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,iy);
					}
					
					CGContextStrokePath(context);
				}
			}
			for(int i=1; i <= yaxis.tickInterval+1;i++){
				if(yaxis.baseValue - i*step >= yaxis.min){
					float iy = [self getLocalY:(yaxis.baseValue - i*step) withSection:secIndex withAxis:aIndex];
					
					CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);
					CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
					CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft-2,iy);
					CGContextStrokePath(context);
					
					[[NSString stringWithFormat:@"%.1f", yaxis.baseValue-i*step] drawAtPoint:CGPointMake(sec.frame.origin.x-1,iy-7) withFont:[UIFont systemFontOfSize: 12]];
					
					if(yaxis.baseValue - i*step > yaxis.min){
						CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.15 green:0.15 blue:0.15 alpha:1.0].CGColor);
						CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,iy);
						CGContextAddLineToPoint(context,sec.frame.origin.x+sec.frame.size.width,iy);
					}
					
					CGContextStrokePath(context);
				}
			}
		}
	}	
	CGContextSetLineDash (context,0,NULL,0); 
}

-(void)drawXAxis{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, NO);
	CGContextSetLineWidth(context, 1.f);
	CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);
	for(int secIndex=0;secIndex<self.sections.count;secIndex++){
		Section *sec = [self.sections objectAtIndex:secIndex];
		if(sec.hidden){
			continue;
		}
		CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,sec.frame.size.height+sec.frame.origin.y);
		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.size.height+sec.frame.origin.y);
        
		CGContextMoveToPoint(context,sec.frame.origin.x+sec.paddingLeft,sec.frame.origin.y+sec.paddingTop);
		CGContextAddLineToPoint(context, sec.frame.origin.x+sec.frame.size.width,sec.frame.origin.y+sec.paddingTop);
	}
	CGContextStrokePath(context);
}

-(void) setSelectedIndexByPoint:(CGPoint) point{
	
	if([self getIndexOfSection:point] == -1){
		return;
	}
	Section *sec = [self.sections objectAtIndex:[self getIndexOfSection:point]];
	
	for(int i=self.rangeFrom;i<self.rangeTo;i++) {
		if((plotWidth*(i-self.rangeFrom))<=(point.x-sec.paddingLeft-self.paddingLeft) && (point.x-sec.paddingLeft-self.paddingLeft)<plotWidth*((i-self.rangeFrom)+1)){
			if (self.selectedIndex != i) {
				self.selectedIndex=i;
				[self setNeedsDisplay];
			}
			
			return;
		}
	}
}

-(void)appendToData:(NSArray *)data forName:(NSString *)name{
    for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
			if([[self.series objectAtIndex:i] objectForKey:@"data"] == nil){
				NSMutableArray *tempData = [[NSMutableArray alloc] init];
			    [[self.series objectAtIndex:i] setObject:tempData forKey:@"data"];
				[tempData release];
			}
			
			for(int j=0;j<data.count;j++){
				[[[self.series objectAtIndex:i] objectForKey:@"data"] addObject:[data objectAtIndex:j]];
			}
	    }
	}
}

-(void)clearDataforName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
			if([[self.series objectAtIndex:i] objectForKey:@"data"] != nil){
				[[[self.series objectAtIndex:i] objectForKey:@"data"] removeAllObjects];
			}
	    }
	}
}

-(void)clearData{
	for(int i=0;i<self.series.count;i++){
		[[[self.series objectAtIndex:i] objectForKey:@"data"] removeAllObjects];
	}
}

-(void)setData:(NSMutableArray *)data forName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
		    [[self.series objectAtIndex:i] setObject:data forKey:@"data"];
		}
	}
}

-(void)appendToCategory:(NSArray *)category forName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
			if([[self.series objectAtIndex:i] objectForKey:@"category"] == nil){
				NSMutableArray *tempData = [[NSMutableArray alloc] init];
			    [[self.series objectAtIndex:i] setObject:tempData forKey:@"category"];
				[tempData release];
			}
			
			for(int j=0;j<category.count;j++){
				[[[self.series objectAtIndex:i] objectForKey:@"category"] addObject:[category objectAtIndex:j]];
			}
	    }
	}
}

-(void)clearCategoryforName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqual:name]){
			if([[self.series objectAtIndex:i] objectForKey:@"category"] != nil){
				[[[self.series objectAtIndex:i] objectForKey:@"category"] removeAllObjects];
			}
	    }
	}
}

-(void)clearCategory{
	for(int i=0;i<self.series.count;i++){
		[[[self.series objectAtIndex:i] objectForKey:@"category"] removeAllObjects];
	}
}

-(void)setCategory:(NSMutableArray *)category forName:(NSString *)name{
	for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
		    [[self.series objectAtIndex:i] setObject:category forKey:@"category"];
		}
	}
}

/*
 * Sections
 */
-(Section *)getSection:(int) index{
    return [self.sections objectAtIndex:index];
}
-(int)getIndexOfSection:(CGPoint) point{
    for(int i=0;i<self.sections.count;i++){
	    Section *sec = [self.sections objectAtIndex:i];
		if (CGRectContainsPoint(sec.frame, point)){
		    return i;
		}
	}
	return -1;
}

/*
 * series
 */
-(NSMutableDictionary *)getSerie:(NSString *)name{
	NSMutableDictionary *serie = nil;
    for(int i=0;i<self.series.count;i++){
		if([[[self.series objectAtIndex:i] objectForKey:@"name"] isEqualToString:name]){
			serie = [self.series objectAtIndex:i];
			break;
		}
	}
	return serie;
}

-(void)addSerie:(NSObject *)serie{
	if([serie isKindOfClass:[NSArray class]]){
		int section = 0;
	    for (NSDictionary *ser in (NSArray *)serie) {
		    section = [[ser objectForKey:@"section"] intValue];
			[self.series addObject:ser];
		}
		[[[self.sections objectAtIndex:section] series] addObject:serie];
	}else{
		int section = [[(NSDictionary *)serie objectForKey:@"section"] intValue];
		[self.series addObject:serie];
		[[[self.sections objectAtIndex:section] series] addObject:serie];
	}
}

/*
 *  Chart Sections
 */ 
-(void)addSection:(NSString *)ratio{
	[ratio retain];
	Section *sec = [[Section alloc] init];
    [self.sections addObject:sec];
	[sec release];
	[self.ratios addObject:ratio];
	[ratio release];
}

-(void)removeSection:(int)index{
    [self.sections removeObjectAtIndex:index];
	[self.ratios removeObjectAtIndex:index];
}

-(void)addSections:(int)num withRatios:(NSArray *)rats{
	[rats retain];
	for (int i=0; i< num; i++) {
		Section *sec = [[Section alloc] init];
		[self.sections addObject:sec];
		[sec release];	
		[self.ratios addObject:[rats objectAtIndex:i]];
	}
	[rats release];
}

-(void)removeSections{
    [self.sections removeAllObjects];
	[self.ratios removeAllObjects];
}

-(void)initSections{
		float height = self.frame.size.height-(self.paddingTop+self.paddingBottom);
		float width  = self.frame.size.width-(self.paddingLeft+self.paddingRight);
		
		int total = 0;
		for (int i=0; i< self.ratios.count; i++) {
			if([[self.sections objectAtIndex:i] hidden]){
			    continue;
			}
			int ratio = [[self.ratios objectAtIndex:i] intValue];
			total+=ratio;
		}
		
		Section*prevSec = nil;
		for (int i=0; i< self.sections.count; i++) {
			int ratio = [[self.ratios objectAtIndex:i] intValue];
			Section *sec = [self.sections objectAtIndex:i];
			if([sec hidden]){
				continue;
			}
			float h = height*ratio/total;
			float w = width;
			
			if(i==0){
				[sec setFrame:CGRectMake(0+self.paddingLeft, 0+self.paddingTop, w,h)];
			}else{
				if(i==([self.sections count]-1)){
					[sec setFrame:CGRectMake(0+self.paddingLeft, prevSec.frame.origin.y+prevSec.frame.size.height, w,self.paddingTop+height-(prevSec.frame.origin.y+prevSec.frame.size.height))];
				}else {
					[sec setFrame:CGRectMake(0+self.paddingLeft, prevSec.frame.origin.y+prevSec.frame.size.height, w,h)];
				}
			}
			prevSec = sec;
			
		}
		self.isSectionInitialized = YES;
}


-(YAxis *)getYAxis:(int) section withIndex:(int) index{
	Section *sec = [self.sections objectAtIndex:section];
	YAxis *yaxis = [sec.yAxises objectAtIndex:index];
    return yaxis;
}

/* 
 * UIView Methods
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self) {
		self.enableSelection = YES;
		self.isInitialized   = NO;
		self.isSectionInitialized   = NO;
		self.selectedIndex   = -1;
		self.padding         = nil;
		self.paddingTop      = 0;
		self.paddingRight    = 0;
		self.paddingBottom   = 0;
		self.paddingLeft     = 0;
		self.rangeFrom       = 0;
		self.rangeTo         = 0;
		self.range           = 120;
		self.touchFlag       = 0;
		self.touchFlagTwo    = 0;
		NSMutableArray *rats = [[NSMutableArray alloc] init];
		self.ratios          = rats; 
		[rats release];
		
		NSMutableArray *secs = [[NSMutableArray alloc] init];
		self.sections        = secs; 
		[secs release];
        
        NSMutableDictionary *mods = [[NSMutableDictionary alloc] init];
		self.models        = mods; 
		[mods release];
		
		[self setMultipleTouchEnabled:YES];
        
        //init models
        [self initModels];
    } 
    return self;
}

-(void)initModels{
    //line
    ChartModel *model = [[LineChartModel alloc] init];
    [self addModel:model withName:@"line"];
    [model release];
    
    //area
    model = [[AreaChartModel alloc] init];
    [self addModel:model withName:@"area"];
    [model release];
    
    //column
    model = [[ColumnChartModel alloc] init];
    [self addModel:model withName:@"column"];
    [model release];
    
    //candle
    model = [[CandleChartModel alloc] init];
    [self addModel:model withName:@"candle"];
    [model release];

}

-(void)addModel:(ChartModel *)model withName:(NSString *)name{
    model.delegate = self;
    [self.models setObject:model forKey:name];
}

-(ChartModel *)getModel:(NSString *)name{
    return [self.models objectForKey:name];
}

- (void)drawRect:(CGRect)rect {

	[self initChart]; // 初始化Chart
	[self initSections]; // 上下共有几个段落
//	[self initXAxis];
	[self initYAxis]; // 画线，根据Y轴的坐标画线
	[self drawXAxis];
	[self drawYAxis]; // Y轴上的标示符
	[self drawChart];// 画线，根据Y轴的坐标画线
    
//    if (userDefinedPoints) {
//        [self drawLineBy:userDefinedPoints];
//    }
    
    if (ShangShengGuaiDianDay) {
        [self drawLineByShangShengGuaidian:ShangShengGuaiDianDay];
    }
}

-(void) drawLineByShangShengGuaidian:(NSArray*) ShangShengGuaidian
{
    NSArray *category = [[self.series valueForKey:@"category"] objectAtIndex:0];
    NSArray *data = [[self.series valueForKey:@"data"] objectAtIndex:0];

    int yAxis  = 0;
    Section *sec = [sections objectAtIndex:0];

    CGPoint lowestPoint = CGPointZero;
    CGPoint highestPoint = CGPointMake(1000, 1000);

    
    NSMutableArray *highPoints = [[[NSMutableArray alloc]init]autorelease];
    NSMutableArray *lowPoints = [[[NSMutableArray alloc]init]autorelease];


    for(int i=rangeFrom;i<rangeTo;i++){
        if(i == data.count){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        float high  = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
        float low   = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
        
        float ix  = sec.frame.origin.x+sec.paddingLeft+(i-rangeFrom)*plotWidth;

        float iyh = [self getLocalY:high withSection:0 withAxis:yAxis];
        float iyl = [self getLocalY:low withSection:0 withAxis:yAxis];

        if (iyh < highestPoint.y) {
            highestPoint = CGPointMake( ix+plotWidth/2, iyh);
        }
        
        if (iyl > lowestPoint.y) {
            lowestPoint = CGPointMake( ix+plotWidth/2, iyl);
        }
        
        NSString *highPoint = NSStringFromCGPoint(CGPointMake( ix+plotWidth/2, iyh));
        [highPoints addObject:highPoint];

        NSString* lowPoint = NSStringFromCGPoint(CGPointMake( ix+plotWidth/2, iyl));
        [lowPoints addObject:lowPoint];
    }
    float CurrentSlope = 0.0f;
    
    CGPoint lastPoint = CGPointFromString([lowPoints lastObject]);
    CurrentSlope = [self getSlopeByP1:lowestPoint :lastPoint];
    
    // 用最低点跟所有的上升拐点相连接
    for (int j = 0; j< [ShangShengGuaidian count]; j++) {
        for(int i=rangeFrom;i<rangeTo;i++){
            if(i == data.count){
                break;
            }
            if([data objectAtIndex:i] == nil){
                continue;
            }

            if ([[category objectAtIndex:i] isEqualToString:[ShangShengGuaidian objectAtIndex:j]]) {
                
                // 算出该点的坐标位置
                float ix  = sec.frame.origin.x+sec.paddingLeft+(i-rangeFrom)*plotWidth;
                
                if (ix > lowestPoint.x ) {
                    float low   = [[[data objectAtIndex:i] objectAtIndex:3] floatValue];
                    float lowPoint = [self getLocalY:low withSection:0 withAxis:yAxis];
                    
                    CGPoint theConnectedPoint = CGPointMake( ix+plotWidth/2, lowPoint);
                    
                    // 把上升拐点的连线延伸到最右端
                    float endX  = plotWidth/2 + sec.frame.origin.x+sec.paddingLeft+(rangeTo-rangeFrom)*plotWidth;
                    float aSlope = [self getSlopeByP1:lowestPoint :theConnectedPoint];
                    float endY  = aSlope*(endX-lowestPoint.x) + lowestPoint.y;
                    theConnectedPoint = CGPointMake(endX, endY);
                    
                    if (CurrentSlope <= aSlope) {
                        // 连接
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetLineWidth(context, 1.f);
                        CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
                        
                        CGContextAddLineToPoint(context, lowestPoint.x, lowestPoint.y);
                        CGContextAddRect(context, CGRectMake(lowestPoint.x, lowestPoint.y, 0.1, 0.1));// add point
                        
                        CGContextAddLineToPoint(context, theConnectedPoint.x, theConnectedPoint.y);
                        CGContextAddRect(context, CGRectMake(theConnectedPoint.x, theConnectedPoint.y, 0.1, 0.1));// add point
                        
                        CGContextStrokePath(context);

                    }
                }
            }
        }
    }
    
}

-(float) getSlopeByP1:(CGPoint) P1 :(CGPoint) P2
{
    return (P2.y - P1.y)/(P2.x - P1.x);
}

-(void)drawLineBy:(NSArray*) points
{
    if (points && [points count]>0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.f);
        CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
        
        CGPoint P1 =CGPointFromString([points objectAtIndex:0]);
        CGContextAddLineToPoint(context, P1.x, P1.y);
        CGContextAddRect(context, CGRectMake(P1.x, P1.y, 0.1, 0.1));// add point
        
        P1 =CGPointFromString([points lastObject]);
        CGContextAddLineToPoint(context, P1.x, P1.y);
        CGContextAddRect(context, CGRectMake(P1.x, P1.y, 0.1, 0.1));// add point
        
        CGContextStrokePath(context);
    }
}

- (void)dealloc {
    [super dealloc];
	[borderColor release];	
	[padding release];
	[series release];
	[title release];
	[sections release];
	[ratios release];
}

#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSArray *ts = [touches allObjects];
	self.touchFlag = 0;
	self.touchFlagTwo = 0;
	if([ts count]==1){
		UITouch* touch = [ts objectAtIndex:0];
		if([touch locationInView:self].x < 40){
		    self.touchFlag = [touch locationInView:self].y;
		}
	}else if ([ts count]==2) {
		self.touchFlag = [[ts objectAtIndex:0] locationInView:self].x ;
		self.touchFlagTwo = [[ts objectAtIndex:1] locationInView:self].x;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	NSArray *ts = [touches allObjects];	
	if([ts count]==1){
		UITouch* touch = [ts objectAtIndex:0];
		int i = [self getIndexOfSection:[touch locationInView:self]];
		if(i!=-1){
			Section *sec = [self.sections objectAtIndex:i];
			if([touch locationInView:self].x > sec.paddingLeft)
				[self setSelectedIndexByPoint:[touch locationInView:self]];
			int interval = 5;
			if([touch locationInView:self].x < sec.paddingLeft){
				if(abs([touch locationInView:self].y - self.touchFlag) >= MIN_INTERVAL){
					if([touch locationInView:self].y - self.touchFlag > 0){
						if(self.plotCount > (self.rangeTo-self.rangeFrom)){
							if(self.rangeFrom - interval >= 0){
								self.rangeFrom -= interval;
								self.rangeTo   -= interval;
								if(self.selectedIndex >= self.rangeTo){
									self.selectedIndex = self.rangeTo-1;
								}
							}else {
								self.rangeFrom = 0;
								self.rangeTo  -= self.rangeFrom;
								if(self.selectedIndex >= self.rangeTo){
									self.selectedIndex = self.rangeTo-1;
								}
							}
							[self setNeedsDisplay];
						}
					}else{
						if(self.plotCount > (self.rangeTo-self.rangeFrom)){
							if(self.rangeTo + interval <= self.plotCount){
								self.rangeFrom += interval;
								self.rangeTo += interval;
								if(self.selectedIndex < self.rangeFrom){
									self.selectedIndex = self.rangeFrom;
								}
							}else {
								self.rangeFrom  += self.plotCount-self.rangeTo;
								self.rangeTo     = self.plotCount;
								
								if(self.selectedIndex < self.rangeFrom){
									self.selectedIndex = self.rangeFrom;
								}
							}
							[self setNeedsDisplay];
						}
					}
					self.touchFlag = [touch locationInView:self].y;
				}
			}
		}
		
	}else if ([ts count]==2) {
		float currFlag = [[ts objectAtIndex:0] locationInView:self].x;
		float currFlagTwo = [[ts objectAtIndex:1] locationInView:self].x;
		if(self.touchFlag == 0){
		    self.touchFlag = currFlag;
			self.touchFlagTwo = currFlagTwo;
		}else{
			int interval = 5;
			
			if((currFlag - self.touchFlag) > 0 && (currFlagTwo - self.touchFlagTwo) > 0){
				if(self.plotCount > (self.rangeTo-self.rangeFrom)){
					if(self.rangeFrom - interval >= 0){
						self.rangeFrom -= interval;
						self.rangeTo   -= interval;
						if(self.selectedIndex >= self.rangeTo){
							self.selectedIndex = self.rangeTo-1;
						}
					}else {
						self.rangeFrom = 0;
						self.rangeTo  -= self.rangeFrom;
						if(self.selectedIndex >= self.rangeTo){
							self.selectedIndex = self.rangeTo-1;
						}
					}
					[self setNeedsDisplay];
				}
			}else if((currFlag - self.touchFlag) < 0 && (currFlagTwo - self.touchFlagTwo) < 0){
				if(self.plotCount > (self.rangeTo-self.rangeFrom)){
					if(self.rangeTo + interval <= self.plotCount){
						self.rangeFrom += interval;
						self.rangeTo += interval;
						if(self.selectedIndex < self.rangeFrom){
							self.selectedIndex = self.rangeFrom;
						}
					}else {
						self.rangeFrom  += self.plotCount-self.rangeTo;
						self.rangeTo     = self.plotCount;
						
						if(self.selectedIndex < self.rangeFrom){
							self.selectedIndex = self.rangeFrom;
						}
					}
					[self setNeedsDisplay];
				}
			}else {
				if(abs(abs(currFlagTwo-currFlag)-abs(self.touchFlagTwo-self.touchFlag)) >= MIN_INTERVAL){
					if(abs(currFlagTwo-currFlag)-abs(self.touchFlagTwo-self.touchFlag) > 0){
						if(self.plotCount>self.rangeTo-self.rangeFrom){
							if(self.rangeFrom + interval < self.rangeTo){
								self.rangeFrom += interval;
							}
							if(self.rangeTo - interval > self.rangeFrom){
								self.rangeTo -= interval;
							}
						}else{
							if(self.rangeTo - interval > self.rangeFrom){
								self.rangeTo -= interval;
							}
						}
						[self setNeedsDisplay];
					}else{
						
						if(self.rangeFrom - interval >= 0){
							self.rangeFrom -= interval;
						}else{
							self.rangeFrom = 0;
						}
						self.rangeTo += interval;
						[self setNeedsDisplay];
					}
				}
			}
		}
		self.touchFlag = currFlag;
		self.touchFlagTwo = currFlagTwo;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSArray *ts = [touches allObjects];	
	UITouch* touch = [[event allTouches] anyObject];
	if([ts count]==1){
		int i = [self getIndexOfSection:[touch locationInView:self]];
		if(i!=-1){
			Section *sec = [self.sections objectAtIndex:i];
			if([touch locationInView:self].x > sec.paddingLeft){
				if(sec.paging){
					[sec nextPage];
					[self setNeedsDisplay];
				}else{
					[self setSelectedIndexByPoint:[touch locationInView:self]];
				}
			}
		}
	}
	self.touchFlag = 0;
}

@end
