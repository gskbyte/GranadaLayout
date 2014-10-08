#import "GRXTestHelper.h"

#import <GranadaLayout/GRXRelativeLayout.h>
#define EXP_SHORTHAND

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

@interface GRXLinearSnapshotTests : FBSnapshotTestCase

@end

@implementation GRXLinearSnapshotTests

- (void)setUp {
    [super setUp];
    self.recordMode = NO;
}

- (void)testVertical {
    GRXLayoutInflater *inflater = [GRXTestHelper inflaterForFileWithName:@"linear_vertical.grx"];

    UIImageView *imageView = [inflater viewForIdentifier:@"image"];
    imageView.image = [GRXTestHelper imageWithName:@"lab.png"];

    UIView *rootView = inflater.rootView;
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);}

@end
