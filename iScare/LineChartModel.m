//
//  LineChartModel.m
//  chartee
//
//  Created by zzy on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LineChartModel.h"
#import "Chart.h"

@implementation LineChartModel

-(void)drawSerie:(Chart *)chart serie:(NSMutableDictionary *)serie{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
	    return;
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, YES);
	CGContextSetLineWidth(context, 1.0f);
	
	NSMutableArray *data          = [serie objectForKey:@"data"];
	int            yAxis          = [[serie objectForKey:@"yAxis"] intValue];
	int            section        = [[serie objectForKey:@"section"] intValue];
	NSString       *color         = [serie objectForKey:@"color"];
	
	float R   = [[[color componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
	float G   = [[[color componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
	float B   = [[[color componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;	
    
	Section *sec = [chart.sections objectAtIndex:section];
	
    if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
        
        float value = 0;
        if ([[data objectAtIndex:chart.selectedIndex] isKindOfClass:[NSNumber class]] || [[data objectAtIndex:chart.selectedIndex] isKindOfClass:[NSString class]]) {
            value = [[data objectAtIndex:chart.selectedIndex] floatValue];
        }else
            value = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];
        
        CGContextSetShouldAntialias(context, NO);
        CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:1.0].CGColor);
        CGContextMoveToPoint(context, sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2, sec.frame.origin.y+sec.paddingTop);
        
        CGContextAddLineToPoint(context,sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2,sec.frame.size.height+sec.frame.origin.y);
        CGContextStrokePath(context);
        
        CGContextSetShouldAntialias(context, YES);
        CGContextBeginPath(context);

        if (chart.selectedIndex > chart.isNeedToDisplayPoint) {
            CGContextSetRGBFillColor(context, 1, 1, 0, 1.0);
        }else
            CGContextSetRGBFillColor(context, R, G, B, 1.0);

        CGContextAddArc(context, sec.frame.origin.x+sec.paddingLeft+(chart.selectedIndex-chart.rangeFrom)*chart.plotWidth+chart.plotWidth/2, [chart getLocalY:value withSection:section withAxis:yAxis], 3, 0, 2*M_PI, 1);
        CGContextFillPath(context);
    }
    
    
    CGContextSetShouldAntialias(context, YES);
    NSMutableArray *array = [[[NSMutableArray alloc]init]autorelease];

    for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count-1){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
        if (i<chart.rangeTo-1 && [data objectAtIndex:(i+1)] != nil) {
            float value = 0;
            if ([[data objectAtIndex:i] isKindOfClass:[NSNumber class]] || [[data objectAtIndex:i] isKindOfClass:[NSString class]]) {
                value = [[data objectAtIndex:i] floatValue];
            }else
                value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];

            float ix  = sec.frame.origin.x+sec.paddingLeft+(i-chart.rangeFrom)*chart.plotWidth;
            float iNx  = sec.frame.origin.x+sec.paddingLeft+(i+1-chart.rangeFrom)*chart.plotWidth;
            float iy = [chart getLocalY:value withSection:section withAxis:yAxis];				
            
            float value2 = 0;
            if ([[data objectAtIndex:(i+1)] isKindOfClass:[NSNumber class]] || [[data objectAtIndex:(i+1)] isKindOfClass:[NSString class]]) {
                value2 = [[data objectAtIndex:(i+1)] floatValue];
            }else
                value2 = [[[data objectAtIndex:(i+1)] objectAtIndex:0] floatValue];

            NSString *pointString = NSStringFromCGPoint(CGPointMake(iNx+chart.plotWidth/2,[chart getLocalY:value2 withSection:section withAxis:yAxis]));
            [array addObject:pointString];
            
            CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:R green:G blue:B alpha:1.0].CGColor);
            CGContextMoveToPoint(context, ix+chart.plotWidth/2, iy);

            CGContextAddLineToPoint(context, iNx+chart.plotWidth/2,[chart getLocalY:value2 withSection:section withAxis:yAxis]);
            CGContextStrokePath(context);
            
            if (i>=chart.isNeedToDisplayPoint) {
                CGContextSetRGBFillColor(context, 1, 1, 0, 1.0); // 添加预测的点
//                CGContextSetRGBFillColor(context, R, G, B, 1.0);
                CGContextAddArc(context, iNx+chart.plotWidth/2, [chart getLocalY:value2 withSection:section withAxis:yAxis], 2, 0, 2*M_PI, 1);
                CGContextFillPath(context);
                
                CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
                CGContextMoveToPoint(context, ix+chart.plotWidth/2, iy);
                
                CGContextAddLineToPoint(context, iNx+chart.plotWidth/2,[chart getLocalY:value2 withSection:section withAxis:yAxis]);
                CGContextStrokePath(context);

            }else
            {
                CGContextSetStrokeColorWithColor(context, [[UIColor alloc] initWithRed:R green:G blue:B alpha:1.0].CGColor);
                CGContextMoveToPoint(context, ix+chart.plotWidth/2, iy);
                
                CGContextAddLineToPoint(context, iNx+chart.plotWidth/2,[chart getLocalY:value2 withSection:section withAxis:yAxis]);
                CGContextStrokePath(context);

            }
        }
    }

    [self.delegate setUserDefinedPoints:array];
}

-(void)setValuesForYAxis:(Chart *)chart serie:(NSDictionary *)serie{
    if([[serie objectForKey:@"data"] count] == 0){
		return;
	}
    
	NSMutableArray *data    = [serie objectForKey:@"data"];
	NSString       *yAxis   = [serie objectForKey:@"yAxis"];
	NSString       *section = [serie objectForKey:@"section"];
	
	YAxis *yaxis = [[[chart.sections objectAtIndex:[section intValue]] yAxises] objectAtIndex:[yAxis intValue]];
	if([serie objectForKey:@"decimal"] != nil){
		yaxis.decimal = [[serie objectForKey:@"decimal"] intValue];
	}
	
	float value=0;
    if ([[data objectAtIndex:chart.rangeFrom] isKindOfClass:[NSNumber class]] || [[data objectAtIndex:chart.rangeFrom] isKindOfClass:[NSString class]]) {
        value = [[data objectAtIndex:chart.rangeFrom] floatValue];
    }else
        value = [[[data objectAtIndex:chart.rangeFrom] objectAtIndex:0] floatValue];

    if(!yaxis.isUsed){
        [yaxis setMax:value];
        [yaxis setMin:value];
        yaxis.isUsed = YES;
    }
    
    for(int i=chart.rangeFrom;i<chart.rangeTo;i++){
        if(i == data.count){
            break;
        }
        if([data objectAtIndex:i] == nil){
            continue;
        }
                
        float value = 0;
        if ([[data objectAtIndex:i] isKindOfClass:[NSNumber class]] || [[data objectAtIndex:i] isKindOfClass:[NSString class]]) {
            value = [[data objectAtIndex:i] floatValue];
        }else
            value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];

        
        if(value > [yaxis max])
            [yaxis setMax:value];
        if(value < [yaxis min])
            [yaxis setMin:value];
    }
}

-(void)setLabel:(Chart *)chart label:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie{
    if([serie objectForKey:@"data"] == nil || [[serie objectForKey:@"data"] count] == 0){
	    return;
	}
	
	NSMutableArray *data          = [serie objectForKey:@"data"];
	NSString       *lbl           = [serie objectForKey:@"label"];
	NSString       *color         = [serie objectForKey:@"color"];
	
	NSString *format=[@"%." stringByAppendingFormat:@"%df",1];

	float R   = [[[color componentsSeparatedByString:@","] objectAtIndex:0] floatValue]/255;
	float G   = [[[color componentsSeparatedByString:@","] objectAtIndex:1] floatValue]/255;
	float B   = [[[color componentsSeparatedByString:@","] objectAtIndex:2] floatValue]/255;

    if(chart.selectedIndex!=-1 && chart.selectedIndex < data.count && [data objectAtIndex:chart.selectedIndex]!=nil){
        
        float value=0;
        if ([[data objectAtIndex:chart.selectedIndex] isKindOfClass:[NSNumber class]] || [[data objectAtIndex:chart.selectedIndex] isKindOfClass:[NSString class]]) {
            value = [[data objectAtIndex:chart.selectedIndex] floatValue];
        }else
            value = [[[data objectAtIndex:chart.selectedIndex] objectAtIndex:0] floatValue];

        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
        NSMutableString *l = [[NSMutableString alloc] init];
        NSString *fmt = [@"%@:" stringByAppendingFormat:@"%@",format];
        [l appendFormat:fmt,lbl,value];
        [tmp setObject:l forKey:@"text"];
        [l release];
        
        NSMutableString *clr = [[NSMutableString alloc] init];
        [clr appendFormat:@"%f,",R];
        [clr appendFormat:@"%f,",G];
        [clr appendFormat:@"%f",B];
        [tmp setObject:clr forKey:@"color"];
        [clr release];
        
        [label addObject:tmp];
        [tmp release];
    }	    
}

@end
