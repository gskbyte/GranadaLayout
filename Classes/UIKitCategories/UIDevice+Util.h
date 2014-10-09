#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>

@interface UIDevice (Helper)

+ (BOOL)grx_runningSystemBefore7;
+ (BOOL)grx_runningSystemVersionAfterOrEqualTo7;

+ (BOOL)grx_iPad;
+ (BOOL)grx_iPhone;
+ (BOOL)grx_hasLongScreen;

+ (BOOL)grx_isRetina;
+ (CGFloat) grx_screenScale;

@end
