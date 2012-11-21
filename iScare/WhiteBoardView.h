
#import <UIKit/UIKit.h>

@interface WhiteBoardView : UIView {
	CGContextRef whiteBoardContext;
	CGLayerRef   whiteBoardLayer;
}
@property(readwrite) float penSize;
@property(nonatomic, retain)  UIColor *penColor;
@end
