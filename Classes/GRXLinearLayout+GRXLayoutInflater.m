#import "GRXLinearLayout+GRXLayoutInflater.h"

@implementation GRXLinearLayout (GRXLayoutInflater)

- (void)grx_configureFromDictionary:(NSDictionary*)dictionary
                       layoutParams:(GRXLayoutParams*)params {
    NSString * directionStr = dictionary[@"direction"];
    if([directionStr isEqualToString:@"horizontal"]) {
        self.direction = GRXLinearLayoutDirectionVertical;
    } else if([directionStr isEqualToString:@"vertical"]) {
        self.direction = GRXLinearLayoutDirectionHorizontal;
    }

    NSString * weightSumStr = dictionary[@"weightSum"];
    if(weightSumStr) {
        self.weightSum = weightSumStr.floatValue;
    }
}

static NSDictionary * Gravities;

+ (void)initializeGravities {
    Gravities = @{
                  @"begin" : @(GRXLinearLayoutGravityBegin),
                  @"center" : @(GRXLinearLayoutGravityCenter),
                  @"end" : @(GRXLinearLayoutGravityEnd),
                  };
}

- (void)configureLayoutParams:(GRXLayoutParams*)params
                   forSubview:(UIView*)view
               fromDictionary:(NSDictionary*)dict
                   inInflater:(GRXLayoutInflater*)inflater {
    [super configureLayoutParams:params
                      forSubview:view
                  fromDictionary:dict
                      inInflater:inflater];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.class initializeGravities];
    });

    GRXLinearLayoutParams * p = (GRXLinearLayoutParams*)params;

    for(NSString * key in Gravities.allKeys) {
        NSString * value = dict[key];
        if(value == nil) {
            continue;
        }

        p.gravity = [value integerValue];
    }

    NSString * weightValue = dict[@"weight"];
    if(weightValue != nil) {
        p.weight = [weightValue floatValue];
    }
}

@end
