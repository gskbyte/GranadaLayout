#import <XCTest/XCTest.h>
#import "GRXTestHelper.h"

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

@end
