#import "GRXDependencyGraph.h"
#import "UIView+GRXLayout.h"

@interface GRXDependencyGraph () {
    NSMutableArray *_roots;
}

@end

@implementation GRXDependencyGraph

- (instancetype)init {
    self = [super init];
    if (self) {
        _nodes = [NSMutableDictionary dictionary];
        _roots = [NSMutableArray array];
    }
    return self;
}

- (void)clear {
    for (GRXDependencyNode *node in _nodes) {
        [node recycle];
    }
    [_nodes removeAllObjects];
    [_roots removeAllObjects];
}

- (void)add:(UIView *)view {
    GRXDependencyNode *node = [GRXDependencyNode nodeForView:view];
    _nodes[view.grx_layoutId] = node;
}

- (NSArray *)sortedViewsWithRules:(NSArray *)rulesArray {
    NSMutableArray *sortedViews = [NSMutableArray new];

    [self findRootsWithRulesFilter:rulesArray];

    NSUInteger index = 0;
    while (_roots.count > 0) {
        GRXDependencyNode *node = [_roots firstObject];
        [_roots removeObjectAtIndex:0];

        UIView *view = node.view;
        NSNumber *identifier = view.grx_layoutId;

        ++index;
        [sortedViews addObject:view];
        for (GRXDependencyNode *dependent in node.dependents) {
            [dependent.dependencies removeObjectForKey:identifier];
            if (dependent.dependencies.count == 0) {
                [_roots addObject:dependent];
            }
        }
    }

    NSAssert(index >= sortedViews.count, @"There are circular dependencies in this relative layout");
    return sortedViews;
}

- (void)findRootsWithRulesFilter:(NSArray *)rulesFilter {
    for (GRXDependencyNode *node in _nodes.allValues) {
        [node.dependencies removeAllObjects];
        [node.dependents removeAllObjects];
    }

    for (GRXDependencyNode *node in _nodes.allValues) {
        UIView *view = node.view;
        GRXRelativeLayoutParams *params = view.grx_relativeLayoutParams;
        for (NSNumber *rule in rulesFilter) {
            UIView *referred = [params viewForRule:rule.unsignedIntegerValue];
            if (referred != nil) {
                GRXDependencyNode *dependency = _nodes[referred.grx_layoutId];
                NSAssert(dependency != nil, @"A view must not refer to a nonexisting view on RelativeLayout");
                NSAssert(dependency != node, @"A view must not refer to itself on RelativeLayout");

                // set as dependent on the obtained
                [dependency.dependents addObject:node];
                // add a dependency to the current node
                node.dependencies[referred.grx_layoutId] = dependency;
            }
        }
    }

    [_roots removeAllObjects];
    for (GRXDependencyNode *node in _nodes.allValues) {
        if (node.dependencies.count == 0) {
            [_roots addObject:node];
        }
    }
}

@end

@implementation GRXDependencyNode

static NSMutableArray *GRXDependencyNodePool;
static const NSUInteger GRXDependencyNodePoolCapacity = 64;

+ (GRXDependencyNode *)nodeForView:(UIView *)view {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GRXDependencyNodePool = [[NSMutableArray alloc] initWithCapacity:GRXDependencyNodePoolCapacity];
    });

    GRXDependencyNode *node = [GRXDependencyNodePool lastObject];
    [GRXDependencyNodePool removeLastObject];
    if (node == nil) {
        node = [GRXDependencyNode new];
    }
    node.view = view;
#ifdef DEBUG
    node.viewId = view.grx_layoutId;
    node.debugIdentifier = view.grx_identifier ? view.grx_identifier : @"UNNAMED";
#endif
    return node;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dependents = [NSMutableArray new];
        _dependencies = [NSMutableDictionary new];
    }
    return self;
}

- (void)recycle {
    _view = nil;
    [_dependents removeAllObjects];
    [_dependencies removeAllObjects];
    if (GRXDependencyNodePool.count < GRXDependencyNodePoolCapacity) {
        [GRXDependencyNodePool addObject:self];
    }
}

@end
