#import "GRXLinearTestController1.h"

@interface GRXLinearTestController1 ()

@end

@implementation GRXLinearTestController1

+ (NSString *)selectionTitle {
    return @"Inflated linear layout";
}

+ (NSString *)selectionDetail {
    return @"Inflates a linear layout from a file";
}

- (NSString *)layoutFileNameInBundle {
    return @"linear_test_1.grx";
}

- (void)createViews {
    UIImageView *iv = [self.layoutInflater viewForIdentifier:@"image"];
    iv.image = [UIImage imageNamed:@"lab.png"];
}


@end
