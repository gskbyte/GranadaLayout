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
    UIView * rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_align_parent.grx"];

    [rootView layoutSubviews];
    rootView.size = rootView.grx_measuredSize;
    FBSnapshotVerifyView(rootView, nil);
}

- (void) testAlignRelative {

}

@end
