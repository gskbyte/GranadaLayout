#import <XCTest/XCTest.h>
#import "GRXTestHelper.h"

#import <GranadaLayout/GRXRelativeLayout.h>
#define EXP_SHORTHAND

#import <Expecta/Expecta.h>

@interface GRXRelativeLayoutUnitTests : XCTestCase

@end

@implementation GRXRelativeLayoutUnitTests

- (void)setUp {
    [super setUp];
}

#define expectParentRule(ident, rule) \
    expect([self viewForId:ident hasParentRule:rule inInflater:inflater]).to.beTruthy()

- (void)testAlignParent {
    GRXLayoutInflater * inflater = [GRXTestHelper inflaterForFileWithName:@"relative_parent.grx"];

    expectParentRule(@"topLeft", GRXRelativeLayoutParentRuleAlignTop);
    expectParentRule(@"topLeft", GRXRelativeLayoutParentRuleAlignLeft);

    expectParentRule(@"topRight", GRXRelativeLayoutParentRuleAlignTop);
    expectParentRule(@"topRight", GRXRelativeLayoutParentRuleAlignRight);

    expectParentRule(@"bottomLeft", GRXRelativeLayoutParentRuleAlignBottom);
    expectParentRule(@"bottomLeft", GRXRelativeLayoutParentRuleAlignLeft);

    expectParentRule(@"bottomRight", GRXRelativeLayoutParentRuleAlignBottom);
    expectParentRule(@"bottomRight", GRXRelativeLayoutParentRuleAlignRight);

    expectParentRule(@"center", GRXRelativeLayoutParentRuleCenter);

    expectParentRule(@"vCenterLeft", GRXRelativeLayoutParentRuleCenterVertical);
    expectParentRule(@"vCenterLeft", GRXRelativeLayoutParentRuleAlignLeft);

    expectParentRule(@"hCenterTop", GRXRelativeLayoutParentRuleCenterHorizontal);
    expectParentRule(@"hCenterTop", GRXRelativeLayoutParentRuleAlignTop);
}

- (void) testAlignRelative {

}

#pragma mark - Helper methods

- (BOOL)viewForId:(NSString*)identifier
    hasParentRule:(GRXRelativeLayoutParentRule)rule
       inInflater:(GRXLayoutInflater*)inflater {
    UIView * view = [inflater viewForIdentifier:identifier];
    GRXRelativeLayoutParams * params = (GRXRelativeLayoutParams*)view.grx_layoutParams;
    return [params hasParentRule:rule];
}

@end
