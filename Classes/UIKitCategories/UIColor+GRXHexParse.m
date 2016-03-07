#import "UIColor+GRXHexParse.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIColor (GRXHexParse)

+ (UIColor *)grx_colorFromRGBHex:(NSInteger)RGBValue {
    return [UIColor colorWithRed:((float)((RGBValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((RGBValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(RGBValue & 0xFF)) / 255.0
                           alpha:1.0];
}

// kudos to http://stackoverflow.com/a/7180905/305582
+ (UIColor *)grx_colorFromRGBHexString:(NSString *)RGBString {
    NSString *colorString = [[RGBString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 6:// #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString range:NSMakeRange(0, 2)];
            green = [self colorComponentFrom:colorString range:NSMakeRange(2, 2)];
            blue  = [self colorComponentFrom:colorString range:NSMakeRange(4, 2)];
            break;
        case 8:// #AARRGGBB
            alpha = [self colorComponentFrom:colorString range:NSMakeRange(0, 2)];
            red   = [self colorComponentFrom:colorString range:NSMakeRange(2, 2)];
            green = [self colorComponentFrom:colorString range:NSMakeRange(4, 2)];
            blue  = [self colorComponentFrom:colorString range:NSMakeRange(6, 2)];
            break;
        default:
            [NSException raise:@"Invalid color value"
                        format:@"Color value %@ is invalid. It should be a hex value of the form #RRGGBB or #AARRGGBB", RGBString];
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string
                        range:(NSRange)range {
    NSString *substring = [string substringWithRange:range];
    unsigned hexComponent;
    [[NSScanner scannerWithString:substring] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

@end

NS_ASSUME_NONNULL_END
