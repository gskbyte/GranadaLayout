#import "GRXTestHelper.h"

#import <GranadaLayout/GRXRelativeLayout.h>
#define EXP_SHORTHAND

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

@interface GRXRelativeLayoutSnapshotTests : FBSnapshotTestCase

@end

@implementation GRXRelativeLayoutSnapshotTests

- (void)setUp {
    [super setUp];
    self.recordMode = NO;
}

- (void)testAlignParent {
    UIView * rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_parent.grx"];
    [rootView layoutSubviews];

    // FIX minSize must be set for topLeft
    // FIX margin for align center ??

    NSLog(@"%@", rootView.description);
    FBSnapshotVerifyView(rootView, nil);
}

- (void) testAlignRelative {
    UIView * rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_other_views.grx"];
    [rootView layoutSubviews];

    // FIX views collide, see images

    FBSnapshotVerifyView(rootView, nil);
}

@end
