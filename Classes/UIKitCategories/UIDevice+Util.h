#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>

@interface UIDevice (Helper)

+ (BOOL)grx_runningSystemVersionGreaterOrEqualTo7;

+ (CGFloat)grx_screenScale;

@end
