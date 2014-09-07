#import "GRXRelativeLayoutParams_Protected.h"

@interface GRXDependencyGraph : NSObject

- (void)add:(UIView*)view;
- (NSArray*)sortedViewsWithRules:(NSArray*)rulesArray;
- (void)clear;

@end



