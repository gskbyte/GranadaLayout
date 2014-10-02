#import <XCTest/XCTest.h>

#import <GranadaLayout/GRXRelativeLayout.h>
#import <GranadaLayout/GRXLinearLayout.h>
#define EXP_SHORTHAND

#import <Expecta/Expecta.h>

@interface ExampleTests : XCTestCase

@end

@implementation ExampleTests

- (void)setUp {
    [super setUp];

}

- (void)testSomethingStupid {
    GRXLayout * rel = [[GRXRelativeLayout alloc] initWithFrame:CGRectZero];
    expect(rel).toNot.beNil();
}

@end
