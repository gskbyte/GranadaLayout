#import "UIDevice+Util.h"
#include <sys/sysctl.h>

@implementation UIDevice (Util)

+ (NSInteger)grx_cachedSystemVersionPrefix {
    static NSInteger GRXCachedSystemVersionPrefix;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * versionString = [[UIDevice currentDevice] systemVersion];
        NSArray * versionNumbers = [versionString componentsSeparatedByString:@"."];
        NSString * majorVersion = versionNumbers[0];
        GRXCachedSystemVersionPrefix = [majorVersion integerValue];
    });
    return GRXCachedSystemVersionPrefix;
}

+ (BOOL)grx_runningSystemBefore7 {
    return [UIDevice grx_cachedSystemVersionPrefix] < 7;
}

+ (BOOL)grx_runningSystemVersionAfterOrEqualTo7 {
    return [UIDevice grx_cachedSystemVersionPrefix] >= 7;
}

+ (UIUserInterfaceIdiom)grx_cachedUserInterfaceIdiom {
    static UIUserInterfaceIdiom idiom;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		idiom = UI_USER_INTERFACE_IDIOM();
	});
	return idiom;
}


+ (BOOL)grx_iPad {
    return [UIDevice grx_cachedUserInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

+ (BOOL)grx_iPhone {
    return [UIDevice grx_cachedUserInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

+ (BOOL)grx_hasLongScreen {
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        return YES;
    }
    return NO;
}

+ (BOOL)grx_isRetina {
    if ([UIDevice grx_screenScale] == 2.0f) {
        return YES;
    } else {
        return NO;
    }
}

+ (CGFloat) grx_screenScale {
    static CGFloat scale;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		scale = UIScreen.mainScreen.scale;
	});
	return scale;
}


@end
