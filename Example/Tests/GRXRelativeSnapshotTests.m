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
    UIView *rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_parent.grx"];
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);
}

- (void)testAlignRelative {
    UIView *rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_other_views.grx"];
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);
}

- (void)testAlignWrapped {
    UIView *rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_wrapped.grx"];
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);
}

- (void)testAlignWrappedPush {
    UIView *rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_wrapped_push.grx"];
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);
}

- (void)testAlignWrappedAroundCenter {
    UIView *rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_wrapped_around_center.grx"];
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);
}

- (void)testRelativeToGone {
    GRXLayoutInflater *inflater = [GRXTestHelper inflaterForFileWithName:@"relative_to_gone.grx"];
    UIView *rootView = inflater.rootView;
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);
}

- (void)testRelativeInRelative {
    GRXLayoutInflater *inflater = [GRXTestHelper inflaterForFileWithName:@"relative_in_relative.grx"];

    UIImageView *imageView = (UIImageView *) [inflater.rootView grx_findViewWithIdentifier:@"image"];
    imageView.image = [GRXTestHelper imageWithName:@"lab.png"];

    UITextView *title = (UITextView *) [inflater.rootView grx_findViewWithIdentifier:@"title"];

    title.attributedText = [[NSAttributedString alloc] initWithString:@"This is a test title with two lines"
                                                           attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AmericanTypewriter" size:18]}];

    UILabel *subtitle = (UILabel *) [inflater.rootView grx_findViewWithIdentifier:@"subtitle"];
    subtitle.textColor = [UIColor darkGrayColor];
    subtitle.text = @"This is a test subtitle";
    subtitle.font = [UIFont boldSystemFontOfSize:10];

    UITextView *message = (UITextView *) [inflater.rootView grx_findViewWithIdentifier:@"message"];
    message.text = @"This is a text message and should be long enough to have at least two lines";

    UIView *rootView = inflater.rootView;
    [rootView layoutSubviews];

    FBSnapshotVerifyView(rootView, nil);
}

@end
