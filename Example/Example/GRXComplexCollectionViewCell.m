#import "GRXComplexCollectionViewCell.h"
#import "GRXComplexHeaderView.h"
#import "GRXComplexBodyView.h"
#import <GranadaLayout/GRXLinearLayout.h>
#import <GranadaLayout/GRXLayoutInflater.h>

@interface GRXComplexCollectionViewCell ()

@property (nonatomic) GRXLinearLayout *root;
@property (nonatomic) GRXComplexHeaderView *headerView;
@property (nonatomic) GRXLinearLayout *bodyContainer;

@end

@implementation GRXComplexCollectionViewCell

+ (NSMutableArray*)bodyPool {
    static NSMutableArray *bodyPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bodyPool = [NSMutableArray array];
    });
    return bodyPool;
}

+ (void)recycleBodies:(NSArray*)bodyViews {
    for(GRXComplexBodyView *bodyView in bodyViews) {
        [bodyView removeFromSuperview];
        [self.class.bodyPool addObject:bodyView];
    }
}

+ (GRXComplexBodyView*)dequeueBody {
    GRXComplexBodyView *bodyView = nil;
    if(self.class.bodyPool.count>0) {
        bodyView = [self.class.bodyPool lastObject];
        [self.class.bodyPool removeLastObject];
    } else {
        bodyView = [[GRXComplexBodyView alloc] initWithFrame:CGRectZero];
    }

    return bodyView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        GRXLayoutInflater *inflater = [[GRXLayoutInflater alloc] initWithBundleFile:@"complex_cell.grx"];
        self.root = inflater.rootView;
        [self.contentView addSubview:self.root];
        self.headerView = [inflater viewForIdentifier:@"header"];
        self.bodyContainer = [inflater viewForIdentifier:@"bodyContainer"];

        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setData:(GRXComplexData *)data {
    _data = data;
    self.headerView.header = data.header;
    [self.headerView grx_setNeedsLayoutInParent];

    [self.class recycleBodies:self.bodyContainer.subviews];
    for(GRXComplexDataBody *body in data.bodies) {
        GRXComplexBodyView * bodyView = [self.class dequeueBody];
        bodyView.body = body;
        bodyView.grx_layoutParams = [[GRXLinearLayoutParams alloc] initWithSize:CGSizeMake(GRXMatchParent, GRXWrapContent)];
        [self.bodyContainer addSubview:bodyView];
        bodyView.grx_layoutParams.margins = UIEdgeInsetsMake(4, 0, 0, 0);
    }
    self.bodyContainer.grx_visibility = data.bodies.count>0 ? GRXVisibilityVisible : GRXVisibilityGone;
}

+ (CGSize) sizeForData:(GRXComplexData*)data {
    static GRXComplexCollectionViewCell *staticComplexCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticComplexCell = [[GRXComplexCollectionViewCell alloc] initWithFrame:CGRectZero];
    });
    staticComplexCell.data = data;
    [staticComplexCell.root layoutIfNeeded];
    CGSize size = staticComplexCell.root.grx_measuredSize;
    return size;
}

@end
