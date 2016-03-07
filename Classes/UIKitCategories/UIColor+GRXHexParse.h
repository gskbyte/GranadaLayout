#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (GRXHexParse)

+ (UIColor *)grx_colorFromRGBHex:(NSInteger)RGBValue;

// Supports following formats: RGB, ARGB, RRGGBB, AARRGGBB
+ (UIColor *)grx_colorFromRGBHexString:(NSString *)RGBString;

@end

NS_ASSUME_NONNULL_END
