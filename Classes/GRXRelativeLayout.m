#import "GRXRelativeLayout.h"
#import "GRXDependencyGraph.h"
#import "GRXRelativeLayoutParams_Protected.h"

@interface GRXRelativeLayout ()

@property (nonatomic) BOOL dirtyHierarchy;
@property (nonatomic, retain) NSMutableArray * sortedViewsVertical, *sortedViewsHorizontal;
@property (nonatomic) GRXDependencyGraph * dependencyGraph;

@end

@implementation GRXRelativeLayout

+ (Class) layoutParamsClass {
    return GRXRelativeLayoutParams.class;
}

#pragma mark - Initializiation

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setupPrivate];
    }
    return self;
}

- (void) setupPrivate {
    _sortedViewsVertical = [NSMutableArray array];
    _sortedViewsHorizontal = [NSMutableArray array];
    _dependencyGraph = [[GRXDependencyGraph alloc] init];
}

#pragma mark - Overriden methods

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    _dirtyHierarchy = YES;
}

// TODO optimize this
+ (void) centerHorizontalView:(UIView *)view
                       params:(GRXRelativeLayoutParams *)params
                      myWidth:(CGFloat)myWidth {
    CGFloat childWidth = view.grx_measuredSize.width;
    CGFloat left = (myWidth - childWidth) / 2;

    params.left = left;
    params.right = left + childWidth;
}

+ (void) centerVerticalView:(UIView *)child
                     params:(GRXRelativeLayoutParams *)params
                   myHeight:(CGFloat)myHeight {
    CGFloat childHeight = child.grx_measuredSize.height;
    CGFloat top = (myHeight - childHeight) / 2;

    params.top = top;
    params.bottom = top + childHeight;
}

- (void) sortChildren {
    [self.dependencyGraph clear];
    for(UIView * view in self.subviews) {
        [self.dependencyGraph add:view];
    }

    NSArray * vertical = [self.dependencyGraph sortedViewsWithRules:[GRXRelativeLayoutParams verticalRules]];
    [self.class debugViewArray:vertical title:@"Vertical"];

    NSArray * horizontal = [self.dependencyGraph sortedViewsWithRules:[GRXRelativeLayoutParams horizontalRules]];
    [self.class debugViewArray:horizontal title:@"Horizontal"];

    NSLog(@"hey");

}


+ (void) debugViewArray:(NSArray*)array title:(NSString*)title {
    NSLog(@"%@", title);
    [self.class debugViewArray:array];
}

+ (void) debugViewArray:(NSArray*)array {
    for(UIView *view in array) {
        NSString * viewName = view.accessibilityLabel ? view.accessibilityLabel : @"Unnamed";
        NSLog(@"  %@ : %@", viewName, view.description);
    }
    NSLog(@"");
}

- (void) layoutSubviews {
    [super layoutSubviews];
    if(_dirtyHierarchy) {
        [self sortChildren];
        _dirtyHierarchy = NO;
    }
}

@end
