

#import "WhiteBoardView.h"

@implementation WhiteBoardView
@synthesize penSize;
@synthesize penColor;

//初始化uiview窗口的时候调用
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

        penSize = 5.0;
		self.backgroundColor = [UIColor clearColor];
		//创建一个rgb的颜色空间
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		//创建一个bitmap类型的图形上下文，指定图像数据，长宽，一个像素的字节数，一行像素的字节数，颜色空间，CGBitmapInfo类型的一个常量
		whiteBoardContext = CGBitmapContextCreate(NULL, self.frame.size.width, self.frame.size.height,
												  8, 4 * self.frame.size.width, colorSpace, kCGImageAlphaPremultipliedFirst);
		
		//释放颜色空间
		CGColorSpaceRelease(colorSpace);
		
		//创建一个不透明的，用于绘图的层，提供一个图形上下文和长宽
		whiteBoardLayer = CGLayerCreateWithContext(whiteBoardContext, self.frame.size, NULL);
		
		//从layer中获取图形上下文，不能直接用whiteBoardContext
		CGContextRef layerContext = CGLayerGetContext(whiteBoardLayer);
		//给图形上下文设置线宽
		CGContextSetLineWidth(layerContext, penSize);
		//给图形上下文设置线型
		CGContextSetLineCap(layerContext, kCGLineCapRound);
		//给图形上下文设置绘图使用的颜色，参数分别为：图形上下文，红，绿，蓝，透明度
//		CGContextSetRGBStrokeColor(layerContext, 1, 0.0, 0.0, 1);
        if (penColor) {
            CGContextSetStrokeColorWithColor(layerContext, penColor.CGColor);
        }else {
            CGContextSetStrokeColorWithColor(layerContext, [UIColor redColor].CGColor);
        }
//        CGContextSetFillColorWithColor(layerContext, [UIColor blueColor].CGColor);
    }
    return self;
}

//绘制窗口矩形的时候调用
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	//得到当前视图的图形上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
	//将创建的layer添加到当前视图的图形上下文中，提供size参数
	CGContextDrawLayerInRect(currentContext, [self bounds], whiteBoardLayer);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//UITouch *theTouch = [touches anyObject];
//	if ([theTouch tapCount] == 2) {
//		//在当前视图上下文中清除layer的内容，提供layer的size。
//		CGContextClearRect(CGLayerGetContext(whiteBoardLayer), [self bounds]);
//		[self setNeedsDisplay];
//	}else {
//		[self touchesMoved:touches withEvent:event];
//	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
	UITouch *theTouch = [touches anyObject];
	CGPoint currentTouchLocation = [theTouch locationInView:self];
	CGPoint lastTouchLocation = [theTouch previousLocationInView:self];
	
    //得到layer的图形上下文
	CGContextRef layerContext = CGLayerGetContext(whiteBoardLayer);
    
	//在图形上下文中重新开始一个path，之前的path销毁
	CGContextBeginPath(layerContext);
	
    //指定path在图形上下文的起点位置
	CGContextMoveToPoint(layerContext, lastTouchLocation.x, lastTouchLocation.y);
    
	//在图形上下文中增加一条线，从path起点到当前位置
    CGContextSetLineWidth(layerContext, penSize);
	CGContextAddLineToPoint(layerContext, currentTouchLocation.x, currentTouchLocation.y);
    
	//在图形上线文中绘制path
	CGContextStrokePath(layerContext);
    if (penColor) {
        CGContextSetStrokeColorWithColor(layerContext, penColor.CGColor);
        if (penColor == [UIColor clearColor]) {
            CGContextSetBlendMode(layerContext, kCGBlendModeClear);
        }else
        {
            CGContextSetBlendMode(layerContext, kCGBlendModeNormal);
        }
    }else {
        CGContextSetStrokeColorWithColor(layerContext, [UIColor redColor].CGColor);
    }
    
	[self setNeedsDisplay];
}



- (void)dealloc {
	CGContextRelease(whiteBoardContext);
	CGLayerRelease(whiteBoardLayer);
    [super dealloc];
}

@end
