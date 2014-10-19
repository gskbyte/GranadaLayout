#import <XCTest/XCTest.h>

#import <GranadaLayout/UIView+Frame.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

@interface GRXUIViewFrameUnitTests : XCTestCase

@end

@implementation GRXUIViewFrameUnitTests


- (void)testFrameMethods {
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(1, 2, 3, 4)];
    expect(v.origin.x).to.equal(1);
    expect(v.origin.y).to.equal(2);

    expect(v.size.width).to.equal(3);
    expect(v.size.height).to.equal(4);

    // setting origin and size
    v.size = CGSizeMake(200, 300);
    v.origin = CGPointMake(20, 50);
    expect(v.left).to.equal(20);
    expect(v.top).to.equal(50);
    expect(v.right).to.equal(220);
    expect(v.bottom).to.equal(350);
    expect(v.width).to.equal(200);
    expect(v.height).to.equal(300);

    v.width = 20;
    v.height = 30;
    expect(v.size.width).to.equal(20);
    expect(v.size.height).to.equal(30);

}

@end
