#import <XCTest/XCTest.h>
#import "GRXTestHelper.h"

#import <GranadaLayout/GRXLayoutInflater.h>
#define EXP_SHORTHAND

#import <Expecta/Expecta.h>

@interface ExampleTests : XCTestCase

@end

@implementation ExampleTests

- (void)testEmptyInflation {
    UIView *rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"empty.grx"];
    expect(rootView).to.beNil();
}

- (void)testNoLayoutRoot {
    UIView *rootView = [GRXTestHelper rootViewForLayoutFileWithName:@"no_layout_root.grx"];
    expect(rootView).notTo.beNil();
    expect(rootView).to.beInstanceOf(UIView.class);
}

@end
