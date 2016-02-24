#import "UIDevice+Util.h"
#include <sys/sysctl.h>

@implementation UIDevice (Util)

+ (CGFloat)grx_screenScale {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = UIScreen.mainScreen.scale;
    });
    return scale;
}


@end
