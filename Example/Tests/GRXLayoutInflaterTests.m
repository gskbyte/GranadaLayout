#import <XCTest/XCTest.h>
#import "GRXTestHelper.h"

#import <GranadaLayout/GRXLayoutInflater.h>
#import <GranadaLayout/GRXRelativeLayout.h>
#import <GranadaLayout/GRXLinearLayout.h>
#define EXP_SHORTHAND

#import <Expecta/Expecta.h>

@interface ExampleTests : XCTestCase

@property (nonatomic) GRXLayoutInflater *linearInRelative;

@end

@implementation ExampleTests

- (void)setUp {
    [super setUp];
    self.linearInRelative = [GRXTestHelper inflaterForFileWithName:@"linear_in_relative.grx"];
}

- (void)testBrokenJSON {
    GRXLayoutInflater *inflater = [GRXTestHelper inflaterForFileWithName:@"broken.grx"];
    expect(inflater).to.beNil();
}

- (void)testEmptyInflation {
    UIView *rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"empty.grx"];
    expect(rootView).to.beNil();
}

- (void)testNoLayoutRoot {
    UIView *rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"no_layout_root.grx"];
    expect(rootView).notTo.beNil();
    expect(rootView).to.beInstanceOf(UIView.class);
}

- (void)testSubviewsClassMappingsAndParams {
    UIView *rootView = self.linearInRelative.rootView;
    expect(rootView.subviews).to.haveCountOf(3);

    GRXLinearLayout *linear = rootView.subviews[2];
    expect(linear.subviews).to.haveCountOf(2);
}

- (void)testClassMappings {
    UIView *rootView = self.linearInRelative.rootView;
    expect(rootView).to.beInstanceOf(GRXRelativeLayout.class);

    expect(rootView.subviews[0]).to.beInstanceOf(UIImageView.class);
    expect(rootView.subviews[1]).to.beInstanceOf(UISwitch.class);
    expect(rootView.subviews[2]).to.beInstanceOf(GRXLinearLayout.class);

    GRXLinearLayout *linear = rootView.subviews[2];
    expect(linear.subviews[0]).to.beInstanceOf(UILabel.class);
    expect(linear.subviews[1]).to.beInstanceOf(UIButton.class);
}

- (void)testLayoutParams {
    GRXRelativeLayout *relative = self.linearInRelative.rootView;
    expect(relative.grx_layoutParams.width).to.equal(GRXMatchParent);
    expect(relative.grx_layoutParams.height).to.equal(GRXMatchParent);
    expect(relative.padding.left).to.equal(12);
    expect(relative.padding.right).to.equal(8);
    expect(relative.padding.top).to.equal(20);
    expect(relative.padding.bottom).to.equal(8);

    UIImageView *image = relative.subviews[0];
    expect(image.grx_layoutParams.width).to.equal(60);
    expect(image.grx_layoutParams.height).to.equal(50);
    expect(image.grx_layoutParams.margins.left).to.equal(20);
    expect(image.grx_layoutParams.margins.right).to.equal(10);
    expect(image.grx_layoutParams.margins.top).to.equal(10);
    expect(image.grx_layoutParams.margins.bottom).to.equal(10);

    GRXLinearLayout *linear = relative.subviews[2];
    expect(linear.grx_layoutParams.width).to.equal(GRXMatchParent);
    expect(linear.grx_layoutParams.height).to.equal(GRXWrapContent);
}

- (void)testViewProperties {
    UIView *sw = [self.linearInRelative viewForIdentifier:@"switch"];
    expect(sw.grx_visibility).to.equal(GRXViewVisibilityGone);

    UIView *button = [self.linearInRelative viewForIdentifier:@"button"];
    expect(button.grx_visibility).to.equal(GRXViewVisibilityHidden);

    UILabel *label = [self.linearInRelative viewForIdentifier:@"label"];
    expect(label.grx_visibility).to.equal(GRXViewVisibilityVisible);
    expect(label.grx_minSize.width).to.equal(200);
    expect(label.grx_minSize.height).to.equal(50);
}

- (void)testViewByIdentifier {
    UIView *root = [self.linearInRelative viewForIdentifier:@"root"];
    expect(root).notTo.beNil();
    expect(root.superview).to.beNil();
    expect(root).to.beInstanceOf(GRXRelativeLayout.class);

    UIView *image = [self.linearInRelative viewForIdentifier:@"image"];
    expect(image).notTo.beNil();
    expect(image.superview).to.beIdenticalTo(root);
    expect(image).to.beInstanceOf(UIImageView.class);

    UIView *linear = [self.linearInRelative viewForIdentifier:@"linear"];
    expect(linear).notTo.beNil();
    expect(linear.superview).to.beIdenticalTo(root);
    expect(linear).to.beInstanceOf(GRXLinearLayout.class);

    UIView *button = [self.linearInRelative viewForIdentifier:@"button"];
    expect(button).notTo.beNil();
    expect(button.superview).to.beIdenticalTo(linear);
    expect(button).to.beInstanceOf(UIButton.class);
}

@end
