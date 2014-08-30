#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>

@interface UIDevice (Helper)

+ (BOOL)grx_runningSystemVersion6;
+ (BOOL)grx_runningSystemVersion7;

+ (BOOL)grx_iPad;
+ (BOOL)grx_iPhone;
+ (BOOL)grx_hasLongScreen;

+ (BOOL)grx_isRetina;

@end
