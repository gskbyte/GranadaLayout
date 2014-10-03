#import <XCTest/XCTest.h>
#import "GRXTestHelper.h"

#import <GranadaLayout/GRXRelativeLayout.h>
#define EXP_SHORTHAND

#import <Expecta/Expecta.h>

@interface GRXRelativeLayoutUnitTests : XCTestCase

@end

@implementation GRXRelativeLayoutUnitTests

- (void)testRootRelative {
    GRXRelativeLayout *rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"relative_root.grx"];
    expect(rootView).notTo.beNil();
    expect(rootView).to.beInstanceOf(GRXRelativeLayout.class);
}


@end
