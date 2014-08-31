#import "GRXRelativeLayoutParams.h"

@interface GRXRelativeLayoutParams ()

@property (nonatomic) NSPointerArray * mutableRules;
@property (nonatomic) NSMutableArray * mutableParentRules;

@end

@implementation GRXRelativeLayoutParams

- (instancetype) initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if(self) {
        [self setupMutableRules];
    }
    return self;
}

- (void) setupMutableRules {
    self.mutableRules = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsWeakMemory];
    [self.mutableRules setCount:GRXRelativeLayoutRuleCount]; // initializes array with null pointers

    self.mutableParentRules = [NSMutableArray arrayWithCapacity:GRXRelativeLayoutParentRuleCount];
    for(NSUInteger i=0; i<GRXRelativeLayoutParentRuleCount; ++i) {
        [self.mutableParentRules addObject:@(NO)];
    }
}

- (BOOL) hasRule:(GRXRelativeLayoutRule)rule {
    return [_mutableRules pointerAtIndex:rule] != nil;
}

- (UIView *)viewForRule:(GRXRelativeLayoutRule)rule {
    return [_mutableRules pointerAtIndex:rule];
}

- (void)setView:(UIView *)view forRule:(GRXRelativeLayoutRule)rule {
    [_mutableRules replacePointerAtIndex:rule
                             withPointer:(__bridge void *)(view)];
}

- (BOOL)hasParentRule:(GRXRelativeLayoutParentRule)parentRule {
    NSNumber * n = _mutableParentRules[parentRule];
    return n.boolValue;
}

- (void)setParentRule:(GRXRelativeLayoutRule)parentRule
               active:(BOOL)active {
    _mutableParentRules[parentRule] = @(active);
}

@end
