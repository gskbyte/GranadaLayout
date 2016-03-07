#import "GRXLayout.h"
#import "GRXRelativeLayoutParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface GRXRelativeLayout : GRXLayout

@property (nonatomic, getter = isHierarchyDirty) BOOL dirtyHierarchy;

@end

NS_ASSUME_NONNULL_END