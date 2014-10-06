#import "GRXLinearLayout+GRXLayoutInflater.h"

@implementation GRXLinearLayout (GRXLayoutInflater)

- (void)grx_configureFromDictionary:(NSDictionary *)dictionary {
    [super grx_configureFromDictionary:dictionary];

    NSString *directionStr = dictionary[@"direction"];
    if ([directionStr isEqualToString:@"horizontal"]) {
        self.direction = GRXLinearLayoutDirectionHorizontal;
    } else if ([directionStr isEqualToString:@"vertical"]) {
        self.direction = GRXLinearLayoutDirectionVertical;
    }

    NSString *weightSumStr = dictionary[@"weightSum"];
    if (weightSumStr) {
        self.weightSum = weightSumStr.floatValue;
    }
}

static NSDictionary *Gravities;

+ (void)initializeGravities {
    Gravities = @{
        @"begin": @(GRXLinearLayoutGravityBegin),
        @"center": @(GRXLinearLayoutGravityCenter),
        @"end": @(GRXLinearLayoutGravityEnd),
    };
}

- (void)configureSubviewLayoutParams:(GRXLayoutParams *)params
                      fromDictionary:(NSDictionary *)dict
                          inInflater:(GRXLayoutInflater *)inflater {
    [super configureSubviewLayoutParams:params
                         fromDictionary:dict
                             inInflater:inflater];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.class initializeGravities];
    });

    GRXLinearLayoutParams *lp = (GRXLinearLayoutParams *)params;

    for (NSString *key in Gravities.allKeys) {
        NSString *value = dict[@"gravity"];
        if ([value isEqualToString:key]) {
            lp.gravity = [Gravities[key] integerValue];
            break;
        }
    }

    NSString *weightValue = dict[@"weight"];
    if (weightValue != nil) {
        lp.weight = [weightValue floatValue];
    }
}

@end
