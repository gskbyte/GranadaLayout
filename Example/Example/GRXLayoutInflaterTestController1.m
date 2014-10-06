#import "GRXLayoutInflaterTestController1.h"

@interface GRXLayoutInflaterTestController1 ()

@end

@implementation GRXLayoutInflaterTestController1

+ (NSString *)selectionTitle {
    return @"Inflation test 1";
}

+ (NSString *)selectionDetail {
    return @"Inflates a layout from a file";
}

- (NSString*) layoutFileNameInBundle {
    return @"relative_test_1.grx";
}

@end
