#import "GRXLayout+GRXLayoutInflater.h"

@implementation GRXLayout (GRXLayoutInflater)

static inline CGFloat sizeFromString(NSString * sizeStr) {
    if([sizeStr isEqualToString:@"match_parent"]) {
        return GRXMatchParent;
    } else if([sizeStr isEqualToString:@"wrap_content"]) {
        return GRXWrapContent;
    } else {
        return sizeStr.floatValue;
    }
}

+ (void) parseParamsFromDictionary:(NSDictionary*)dictionary
                   forLayoutParams:(GRXLayoutParams*)params {
    params.width = sizeFromString(dictionary[@"width"]);
    params.height = sizeFromString(dictionary[@"height"]);
}

+ (GRXLayoutParams*) layoutParamsForSubviewFromDictionary:(NSDictionary*)dictionary {
    GRXLayoutParams * params = [[[self.class layoutParamsClass] alloc] init];
    [self.class parseParamsFromDictionary:dictionary
                          forLayoutParams:params];
    return params;
}

@end
