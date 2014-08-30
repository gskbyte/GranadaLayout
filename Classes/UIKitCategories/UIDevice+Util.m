#import "UIDevice+Util.h"
#include <sys/sysctl.h>

@implementation UIDevice (Util)


+ (NSString *)grx_cachedSystemVersion {
    __strong static NSString *kCachedSystemVersion;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		kCachedSystemVersion = [[UIDevice currentDevice] systemVersion];
	});
	return kCachedSystemVersion;
}

+ (BOOL)grx_runningSystemVersion6 {
    if ([[UIDevice grx_cachedSystemVersion] hasPrefix:@"6"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)grx_runningSystemVersion7 {
    if ([[UIDevice grx_cachedSystemVersion] hasPrefix:@"7"]) {
        return YES;
    }
    return NO;
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
    if ([[UIScreen mainScreen] scale] == 2.0f) {
        return YES;
    } else {
        return NO;
    }
}


@end
