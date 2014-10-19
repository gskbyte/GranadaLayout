#import <XCTest/XCTest.h>
#import "GRXTestHelper.h"

#import <GRXLayoutInflater.h>
#import <GranadaLayout/GRXLinearLayout.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

@interface GRXLinearLayoutUnitTests : XCTestCase

@end

@implementation GRXLinearLayoutUnitTests

- (void)testRootLinear {
    GRXLinearLayout *rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"linear_root.grx"];
    expect(rootView).notTo.beNil();
    expect(rootView).to.beInstanceOf(GRXLinearLayout.class);
    expect(rootView.direction).to.equal(GRXLinearLayoutDirectionHorizontal);
    expect(rootView.weightSum).to.equal(5);
}

- (void)testLinearVertical {
    GRXLayoutInflater *inflater = [GRXTestHelper inflaterForFileWithName:@"linear_vertical.grx"];
    GRXLinearLayout *rootView = inflater.rootView;
    expect(rootView).notTo.beNil();
    expect(rootView).to.beInstanceOf(GRXLinearLayout.class);
    expect(rootView.direction).to.equal(GRXLinearLayoutDirectionVertical);
    expect(rootView.subviews).to.haveCountOf(5);

    UIView *sw = [inflater viewForIdentifier:@"switch"];
    expect(sw).to.beInstanceOf(UISwitch.class);
    expect(sw.grx_linearLayoutParams.width).to.equal(GRXWrapContent);
    expect(sw.grx_linearLayoutParams.height).to.equal(GRXWrapContent);
    expect(sw.grx_linearLayoutParams.gravity).to.equal(GRXLinearLayoutGravityEnd);
    expect(sw.grx_linearLayoutParams.hasMargins).to.beTruthy();
    expect(sw.grx_linearLayoutParams.margins.top).to.equal(8);

    UIImageView *image = [inflater viewForIdentifier:@"image"];
    expect(image).to.beInstanceOf(UIImageView.class);
    expect(image.grx_linearLayoutParams.width).to.equal(GRXWrapContent);
    expect(image.grx_linearLayoutParams.height).to.equal(GRXWrapContent);
    expect(image.grx_linearLayoutParams.gravity).to.equal(GRXLinearLayoutGravityCenter);
    expect(image.grx_linearLayoutParams.hasMargins).to.beFalsy();
    expect(image.grx_linearLayoutParams.margins.top).to.equal(0);

    UIImageView *blueView = [inflater viewForIdentifier:@"blue"];
    expect(blueView).to.beInstanceOf(UIView.class);
    expect(blueView.grx_linearLayoutParams.width).to.equal(200);
    expect(blueView.grx_linearLayoutParams.height).to.equal(120);
    expect(blueView.grx_linearLayoutParams.gravity).to.equal(GRXLinearLayoutGravityBegin);
    expect(blueView.grx_linearLayoutParams.hasMargins).to.beTruthy();
    expect(blueView.grx_linearLayoutParams.margins.top).to.equal(10);

    [rootView layoutSubviews];

    expect(sw.top).to.equal(8);
    expect(sw.right).to.equal(rootView.width - 8);

    expect(image.width).to.beGreaterThanOrEqualTo(40);
    expect(image.height).to.beGreaterThanOrEqualTo(40);
    expect(image.top).to.equal(sw.bottom + 8);

    expect(blueView.top).to.beGreaterThan(image.bottom);
    expect(blueView.bottom).to.equal(rootView.height - 10);
    expect(blueView.left).to.equal(10);
    expect(blueView.width).to.equal(200);
    expect(blueView.height).to.equal(120);
}

- (void)testLinearVerticalWeighted {
    GRXLayoutInflater *inflater = [GRXTestHelper inflaterForFileWithName:@"linear_vertical_weight.grx"];
    GRXLinearLayout *rootView = inflater.rootView;
    expect(rootView).notTo.beNil();
    expect(rootView).to.beInstanceOf(GRXLinearLayout.class);
    expect(rootView.direction).to.equal(GRXLinearLayoutDirectionVertical);
    expect(rootView.subviews).to.haveCountOf(6);
    expect(rootView.weightSum).to.equal(100);

    UIImageView *image = [inflater viewForIdentifier:@"image"];
    expect(image).to.beInstanceOf(UIImageView.class);
    expect(image.grx_linearLayoutParams.width).to.equal(GRXWrapContent);
    expect(image.grx_linearLayoutParams.height).to.equal(0);
    expect(image.grx_linearLayoutParams.gravity).to.equal(GRXLinearLayoutGravityCenter);
    expect(image.grx_linearLayoutParams.hasMargins).to.beFalsy();
}

@end
