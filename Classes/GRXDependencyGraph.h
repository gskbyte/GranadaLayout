#import "GRXRelativeLayoutParams.h"

@interface GRXDependencyGraph : NSObject

@property (nonatomic) NSMutableDictionary *nodes; // {viewIdentifier, node}

- (void)add:(UIView *)view;
- (NSArray *)sortedViewsWithRules:(NSArray *)rulesArray;
- (void)clear;

@end


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

