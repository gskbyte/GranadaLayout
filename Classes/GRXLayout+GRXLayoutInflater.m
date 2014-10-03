#import "GRXLayout+GRXLayoutInflater.h"

static inline CGFloat GRXLayoutSizeFromString(NSString * sizeStr) {
    if([sizeStr isEqualToString:@"match_parent"]) {
        return GRXMatchParent;
    } else if([sizeStr isEqualToString:@"wrap_content"]) {
        return GRXWrapContent;
    } else {
        return sizeStr.floatValue;
    }
}

@implementation GRXLayout (GRXLayoutInflater)

- (void)grx_configureFromDictionary:(NSDictionary *)dictionary{
    [super grx_configureFromDictionary:dictionary];

    UIEdgeInsets padding;

    padding.left = [dictionary[@"paddingLeft"] floatValue];
    padding.right = [dictionary[@"paddingRight"] floatValue];
    padding.top = [dictionary[@"paddingTop"] floatValue];
    padding.bottom = [dictionary[@"paddingBottom"] floatValue];

    self.padding = padding;
}

- (void)configureSubviewLayoutParams:(GRXLayoutParams*)params
                      fromDictionary:(NSDictionary*)dictionary
                          inInflater:(GRXLayoutInflater*)inflater {
    params.width = GRXLayoutSizeFromString(dictionary[@"width"]);
    params.height = GRXLayoutSizeFromString(dictionary[@"height"]);
}

+ (void)configureUnparentedLayoutParams:(GRXLayoutParams*)params
                         fromDictionary:(NSDictionary*)dictionary {
    params.width = GRXLayoutSizeFromString(dictionary[@"width"]);
    params.height = GRXLayoutSizeFromString(dictionary[@"height"]);
}

@end
