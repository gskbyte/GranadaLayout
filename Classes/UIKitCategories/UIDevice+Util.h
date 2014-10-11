#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>

@interface UIDevice (Helper)

+ (BOOL)grx_runningSystemLessThan7;
+ (BOOL)grx_runningSystemVersionGreaterOrEqualTo7;

+ (BOOL)grx_iPad;
+ (BOOL)grx_iPhone;
+ (BOOL)grx_hasLongScreen;

+ (BOOL)grx_isRetina;
+ (CGFloat) grx_screenScale;

@end
