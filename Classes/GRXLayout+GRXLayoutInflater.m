#import "GRXLayout+GRXLayoutInflater.h"

static inline CGFloat GRXLayoutSizeFromString(NSString *sizeStr) {
    if ([sizeStr isEqualToString:@"match_parent"]) {
        return GRXMatchParent;
    } else if ([sizeStr isEqualToString:@"wrap_content"]) {
        return GRXWrapContent;
    } else {
        return sizeStr.floatValue;
    }
}

@implementation GRXLayout (GRXLayoutInflater)

- (void)grx_configureFromDictionary:(NSDictionary *)dictionary {
    [super grx_configureFromDictionary:dictionary];

    UIEdgeInsets padding;

    padding.left = [dictionary[@"paddingLeft"] floatValue];
    padding.right = [dictionary[@"paddingRight"] floatValue];
    padding.top = [dictionary[@"paddingTop"] floatValue];
    padding.bottom = [dictionary[@"paddingBottom"] floatValue];

    self.padding = padding;
}

- (void)configureSubviewLayoutParams:(GRXLayoutParams *)params
                      fromDictionary:(NSDictionary *)dictionary
                          inInflater:(GRXLayoutInflater *)inflater {
    [GRXLayout configureUnparentedLayoutParams:params
                                fromDictionary:dictionary];
}

+ (void)configureUnparentedLayoutParams:(GRXLayoutParams *)params
                         fromDictionary:(NSDictionary *)dictionary {
    params.width = GRXLayoutSizeFromString(dictionary[@"width"]);
    params.height = GRXLayoutSizeFromString(dictionary[@"height"]);

    CGSize minSize;
    minSize.width = GRXLayoutSizeFromString(dictionary[@"minWidth"]);
    minSize.height = GRXLayoutSizeFromString(dictionary[@"minHeight"]);
    params.minSize = minSize;

    UIEdgeInsets margins;

    CGFloat m = [dictionary[@"margin"] floatValue];
    if(m != 0) {
        margins = UIEdgeInsetsMake(m, m, m, m);
    }

    // all margins can be overriden
    m = [dictionary[@"marginLeft"] floatValue];
    if(m != 0) {
        margins.left = m;
    }

    m = [dictionary[@"marginRight"]floatValue];
    if(m != 0) {
        margins.right = m;
    }

    m = [dictionary[@"marginTop"]floatValue];
    if(m != 0) {
        margins.top = m;
    }

    m = [dictionary[@"marginBottom"]floatValue];
    if(m != 0) {
        margins.bottom = m;
    }

    params.margins = margins;
}

@end
