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
    GRXLinearLayout * linear = [[GRXLinearLayout alloc] initWithFrame:CGRectZero];
    UIView * viewInLinear = [[UIView alloc] initWithDefaultParamsInLayout:linear];
    expect(viewInLinear.grx_layoutParams).to.beInstanceOf(GRXLinearLayoutParams.class);
    expect(^{[viewInLinear grx_relativeLayoutParams];}).to.raiseAny();

    GRXRelativeLayout * relative = [[GRXRelativeLayout alloc] initWithFrame:CGRectZero];
    UIView * viewInRelative = [[UIView alloc] initWithDefaultParamsInLayout:relative];
    expect(viewInRelative.grx_layoutParams).to.beInstanceOf(GRXRelativeLayoutParams.class);
    expect(^{[viewInRelative grx_linearLayoutParams];}).to.raiseAny();

    GRXLinearLayoutParams * linearParams = [GRXLinearLayoutParams alloc];
    UIView * standalone = [[UIView alloc] initWithLayoutParams:linearParams];
    expect(^{[relative addSubview:standalone];}).to.raiseAny();

    UIView * viewWithSameParams = [[UIView alloc] initWithFrame:CGRectZero];
    viewWithSameParams.grx_layoutParams = linearParams;
    expect(viewWithSameParams.grx_layoutParams).notTo.beIdenticalTo(linearParams);
}

- (void)testVisibility {
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
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

@end
