//
//  ChartModel.h
//  chartee
//
//  Created by zzy on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Chart;

@interface ChartModel:NSObject
@property(nonatomic, retain)  id delegate;

-(void)drawSerie:(Chart *)chart serie:(NSMutableDictionary *)serie;
-(void)setValuesForYAxis:(Chart *)chart serie:(NSDictionary *)serie;
-(void)setLabel:(Chart *)chart label:(NSMutableArray *)label forSerie:(NSMutableDictionary *) serie;
-(void)drawTips:(Chart *)chart serie:(NSMutableDictionary *)serie;

@end
