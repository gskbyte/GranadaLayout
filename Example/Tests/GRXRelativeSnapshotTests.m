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

    NSLog(@"%@", rootView.description);
    FBSnapshotVerifyView(rootView, nil);
}

- (void) testAlignRelative {
    UIView * rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_other_views.grx"];
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);
}

- (void) testAlignWrapped {
    UIView * rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_wrapped.grx"];
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);
}

- (void) testAlignWrappedPush {
    UIView * rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_wrapped_push.grx"];
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);
}
/*
- (void) testAlignWrappedAroundCenter {
    self.recordMode = YES;
    UIView * rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_wrapped_around_center.grx"];
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);
}
*/
@end
