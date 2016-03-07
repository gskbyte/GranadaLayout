#import "GRXLayout+GRXLayoutInflater.h"

NS_ASSUME_NONNULL_BEGIN

static inline CGFloat GRXLayoutSizeFromString(NSString *sizeStr) {
    if (sizeStr == nil || [sizeStr isEqualToString:@"wrap_content"]) {
        return GRXWrapContent;
    } else if ([sizeStr isEqualToString:@"match_parent"]) {
        return GRXMatchParent;
    } else {
        return sizeStr.floatValue;
    }
}

@implementation GRXLayout (GRXLayoutInflater)

- (void)grx_configureFromDictionary:(NSDictionary *)dictionary {
    [super grx_configureFromDictionary:dictionary];

    BOOL paddingDefined = NO;
    UIEdgeInsets padding = UIEdgeInsetsZero;
    CGFloat p = [dictionary[@"padding"] floatValue];
    if (p != 0) {
        padding = UIEdgeInsetsMake(p, p, p, p);
        paddingDefined = YES;
    }

    p = [dictionary[@"paddingLeft"] floatValue];
    if (p != 0) {
        padding.left = p;
        paddingDefined = YES;
    }
    p = [dictionary[@"paddingRight"] floatValue];
    if (p != 0) {
        padding.right = p;
        paddingDefined = YES;
    }
    p = [dictionary[@"paddingTop"] floatValue];
    if (p != 0) {
        padding.top = p;
        paddingDefined = YES;
    }
    p = [dictionary[@"paddingBottom"] floatValue];
    if (p != 0) {
        padding.bottom = p;
        paddingDefined = YES;
    }

    if (paddingDefined) {
        self.padding = padding;
    }
}

- (void)configureSubviewLayoutParams:(GRXLayoutParams *)params
                      fromDictionary:(NSDictionary *)dictionary
                          inInflater:(GRXLayoutInflater *)inflater {
    [GRXLayout configureUnparentedLayoutParams:params
                                fromDictionary:dictionary];
}

+ (void)configureUnparentedLayoutParams:(GRXLayoutParams *)params
                         fromDictionary:(NSDictionary *)dictionary {
    if (dictionary[@"width"] != nil) {
        params.width = GRXLayoutSizeFromString(dictionary[@"width"]);
    }
    if (dictionary[@"height"] != nil) {
        params.height = GRXLayoutSizeFromString(dictionary[@"height"]);
    }

    BOOL definesMargins = NO;
    UIEdgeInsets margins = UIEdgeInsetsZero;

    CGFloat m = [dictionary[@"margin"] floatValue];
    if (m != 0) {
        margins = UIEdgeInsetsMake(m, m, m, m);
        definesMargins = YES;
    }

    // all margins can be overriden
    m = [dictionary[@"marginLeft"] floatValue];
    if (m != 0) {
        margins.left = m;
        definesMargins = YES;
    }

    m = [dictionary[@"marginRight"] floatValue];
    if (m != 0) {
        margins.right = m;
        definesMargins = YES;
    }

    m = [dictionary[@"marginTop"] floatValue];
    if (m != 0) {
        margins.top = m;
        definesMargins = YES;
    }

    m = [dictionary[@"marginBottom"] floatValue];
    if (m != 0) {
        margins.bottom = m;
        definesMargins = YES;
    }

    if (definesMargins) {
        params.margins = margins;
    }
}

@end

NS_ASSUME_NONNULL_END
