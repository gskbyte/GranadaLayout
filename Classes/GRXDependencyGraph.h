#import "GRXRelativeLayoutParams_Protected.h"

@interface GRXDependencyGraph : NSObject

@property(nonatomic) NSMutableDictionary *nodes; //{viewIdentifier, node}

- (void)add:(UIView*)view;
- (NSArray*)sortedViewsWithRules:(NSArray*)rulesArray;
- (void)clear;

@end


@interface GRXDependencyNode : NSObject <NSCopying>

@property(nonatomic) UIView * view;
@property(nonatomic) NSMutableArray *dependents;
@property(nonatomic) NSMutableDictionary *dependencies;
#ifdef DEBUG
@property(nonatomic) NSNumber * viewId;
@property(nonatomic) NSString * accessibilityLabel;
#endif

+ (GRXDependencyNode*)nodeForView:(UIView *)view;
- (void)recycle;

@end

