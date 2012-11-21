
#import <UIKit/UIKit.h>

@interface WhiteBoardView1 : UIView {
	CGContextRef whiteBoardContext;
	CGLayerRef   whiteBoardLayer;
}
@property(readwrite) float penSize;
@end
