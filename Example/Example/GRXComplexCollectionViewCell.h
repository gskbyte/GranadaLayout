#import <UIKit/UIKit.h>
#import "GRXComplexData.h"

@interface GRXComplexCollectionViewCell : UICollectionViewCell

@property (nonatomic) GRXComplexData *data;

+ (CGSize) sizeForData:(GRXComplexData*)data;

@end
