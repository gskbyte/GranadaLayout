#import "GRXRelativeLayoutParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface GRXDependencyNode : NSObject

@property (nonatomic) UIView *view;
@property (nonatomic) NSMutableArray *dependents;
@property (nonatomic) NSMutableDictionary *dependencies;
#ifdef DEBUG
@property (nonatomic) NSNumber *viewId;
@property (nonatomic) NSString *debugIdentifier;
#endif

+ (GRXDependencyNode *)nodeForView:(UIView *)view;
- (void)recycle;

@end

@interface GRXDependencyGraph : NSObject

@property (nullable, nonatomic) NSMutableDictionary<NSNumber *, GRXDependencyNode *> *nodes; // {viewIdentifier, node}

- (void)add:(UIView *)view;
- (NSArray<__kindof UIView *> *)sortedViewsWithRules:(NSArray<NSNumber *> *)rulesArray;
- (void)clear;

@end

NS_ASSUME_NONNULL_END
