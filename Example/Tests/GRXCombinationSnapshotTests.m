#import "GRXTestHelper.h"
#define EXP_SHORTHAND

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

@interface GRXCombinationSnapshotTests : FBSnapshotTestCase

@end

@implementation GRXCombinationSnapshotTests

- (void)setUp {
    [super setUp];
    self.recordMode = NO;
}

- (void)testRecursiveInflation {
    UIView *rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"inflate_container.grx"];
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);
}

@end
