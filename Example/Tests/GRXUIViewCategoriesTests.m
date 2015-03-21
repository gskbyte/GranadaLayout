#import <XCTest/XCTest.h>
#import "GRXTestHelper.h"

#import <GranadaLayout/GRXRelativeLayout.h>
#import <GranadaLayout/GRXLinearLayout.h>
#define EXP_SHORTHAND

#import <Expecta/Expecta.h>

@interface GRXUIViewCategoriesTests : XCTestCase

@end

@implementation GRXUIViewCategoriesTests

- (void)testLayoutParams {
    GRXLinearLayout *linear = [[GRXLinearLayout alloc] initWithFrame:CGRectZero];
    UIView *viewInLinear = [[UIView alloc] initWithDefaultParamsInLayout:linear];
    expect(viewInLinear.grx_layoutParams).to.beInstanceOf(GRXLinearLayoutParams.class);
    expect (^{[viewInLinear grx_relativeLayoutParams]; }).to.raiseAny();

    GRXRelativeLayout *relative = [[GRXRelativeLayout alloc] initWithFrame:CGRectZero];
    UIView *viewInRelative = [[UIView alloc] initWithDefaultParamsInLayout:relative];
    expect(viewInRelative.grx_layoutParams).to.beInstanceOf(GRXRelativeLayoutParams.class);
    expect (^{[viewInRelative grx_linearLayoutParams]; }).to.raiseAny();

    GRXLinearLayoutParams *linearParams = [GRXLinearLayoutParams alloc];
    UIView *standalone = [[UIView alloc] initWithLayoutParams:linearParams];
    expect (^{[relative addSubview:standalone]; }).to.raiseAny();

    UIView *viewWithSameParams = [[UIView alloc] initWithFrame:CGRectZero];
    viewWithSameParams.grx_layoutParams = linearParams;
    expect(viewWithSameParams.grx_layoutParams).notTo.beIdenticalTo(linearParams);
}

- (void)testVisibility {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.grx_visibility = GRXVisibilityGone;
    expect(view.hidden).to.beTruthy();

    view.grx_visibility = GRXVisibilityVisible;
    expect(view.hidden).to.beFalsy();

    view.grx_visibility = GRXVisibilityHidden;
    expect(view.hidden).to.beTruthy();

    view.hidden = NO;
    expect(view.grx_visibility).to.equal(GRXVisibilityVisible);
    view.hidden = YES;
    expect(view.grx_visibility).to.equal(GRXVisibilityHidden);
}

- (void)testIdentifiers {
    GRXLinearLayout *linear = [[GRXLinearLayout alloc] initWithFrame:CGRectZero];
    linear.grx_layoutParams = [[GRXLayoutParams alloc] initWithSize:CGSizeMake(200, 200)];
    linear.grx_identifier = @"linear";

    UIView *viewInLinear = [[UIView alloc] initWithDefaultParamsInLayout:linear];
    viewInLinear.grx_layoutParams.size = CGSizeMake(GRXMatchParent, GRXMatchParent);
    viewInLinear.grx_identifier = @"view";

    GRXRelativeLayout *relative = [[GRXRelativeLayout alloc] initWithDefaultParamsInLayout:linear];
    relative.grx_identifier = @"relative";

    UIView *blueView = [[UIView alloc] initWithDefaultParamsInLayout:relative];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.grx_identifier = @"blue";

    UIView *redView = [[UIView alloc] initWithDefaultParamsInLayout:relative];
    redView.backgroundColor = [UIColor redColor];
    redView.grx_identifier = @"red";

    expect(linear.grx_identifier).to.equal(@"linear");
    expect([linear grx_findViewWithIdentifier:@"view"]).to.beIdenticalTo(viewInLinear);
    expect([linear grx_subviewForIdentifier:@"view"]).to.beIdenticalTo(viewInLinear);
    expect([linear grx_findViewWithIdentifier:@"relative"]).to.beIdenticalTo(relative);
    expect([linear grx_findViewWithIdentifier:@"blue"]).to.beIdenticalTo(blueView);
    expect([linear grx_subviewForIdentifier:@"blue"]).to.beNil();
    expect([relative grx_subviewForIdentifier:@"blue"]).to.beIdenticalTo(blueView);
    expect([linear grx_findViewWithIdentifier:@"red"]).to.beIdenticalTo(redView);
    expect([linear grx_findViewWithIdentifier:@"green"]).to.beNil();
}

- (void)testDebugProperties {
    GRXLinearLayout *linear = [[GRXLinearLayout alloc] initWithFrame:CGRectZero];
    linear.grx_layoutParams = [[GRXLayoutParams alloc] initWithSize:CGSizeMake(200, 200)];
    linear.grx_identifier = @"linear";
    UIView *viewInLinear = [[UIView alloc] initWithDefaultParamsInLayout:linear];
    viewInLinear.grx_layoutParams.size = CGSizeMake(GRXMatchParent, GRXMatchParent);
    viewInLinear.grx_identifier = @"view";
    viewInLinear.backgroundColor = [UIColor redColor];

    [linear layoutSubviews];

    expect(linear.grx_debugDescription.length).to.beGreaterThan(0);
    expect(linear.grx_debugDescription).to.contain(@"200");
}

// by default, an imageview measurement will keep the relation of the image
// let's modify it using a block

- (void)testMeasurementBlock {
    UIImage *image = [UIImage imageNamed:@"lab.png"];
    expect(image.size.width).to.equal(image.size.height);

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

    GRXMeasureSpec wspec = GRXMeasureSpecMake(CGFLOAT_MAX, GRXMeasureSpecAtMost);
    GRXMeasureSpec hspec = GRXMeasureSpecMake(CGFLOAT_MAX, GRXMeasureSpecAtMost);

    CGSize normalSize = [imageView grx_measuredSizeForWidthSpec:wspec heightSpec:hspec];
    expect(normalSize.width).to.equal(normalSize.height);

    [imageView grx_setMeasurementBlock:^CGSize (GRXMeasureSpec wspec, GRXMeasureSpec hspec) {
        return CGSizeMake(200, 300);
    }];

    CGSize modSize = [imageView grx_measuredSizeForWidthSpec:wspec heightSpec:hspec];
    expect(modSize.width).to.equal(200);
    expect(modSize.height).to.equal(300);
}

@end
