#import "GRXLayout.h"
#import "GRXLinearLayoutParams.h"

typedef NS_ENUM (NSUInteger, GRXLinearLayoutDirection) {
    GRXLinearLayoutDirectionHorizontal = 0,
    GRXLinearLayoutDirectionVertical
};

const static GRXLinearLayoutDirection kGRXLinearLayoutDefaultDirection = GRXLinearLayoutDirectionVertical;
const static CGFloat kGRXLinearLayoutDefaultWeightSum = 0;

@interface GRXLinearLayout : GRXLayout

@property (nonatomic) GRXLinearLayoutDirection direction;
@property (nonatomic) CGFloat weightSum;

@end
