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

    UIEdgeInsets padding = UIEdgeInsetsZero;
    CGFloat p = [dictionary[@"padding"] floatValue];
    if(p != 0) {
        padding = UIEdgeInsetsMake(p, p, p, p);
    }

    p = [dictionary[@"paddingLeft"] floatValue];
    if(p != 0) {
        padding.left = p;
    }
    p = [dictionary[@"paddingRight"] floatValue];
    if(p != 0) {
        padding.right = p;
    }
    p = [dictionary[@"paddingTop"] floatValue];
    if(p != 0) {
        padding.top = p;
    }
    p = [dictionary[@"paddingBottom"] floatValue];
    if(p != 0) {
        padding.bottom = p;
    }

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

    UIEdgeInsets margins = UIEdgeInsetsZero;

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
