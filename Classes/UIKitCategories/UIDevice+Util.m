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

+ (BOOL)grx_runningSystemVersionGreaterOrEqualTo7 {
    return [UIDevice grx_cachedSystemVersionPrefix] >= 7;
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
