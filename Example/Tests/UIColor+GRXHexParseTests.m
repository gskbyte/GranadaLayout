#import <XCTest/XCTest.h>
#import <GranadaLayout/UIColor+GRXHexParse.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>


@interface UIColor_GRXHexParseTests : XCTestCase

@end

@implementation UIColor_GRXHexParseTests

- (void)textHexIntegers {
    CGFloat red, green, blue, alpha;

    UIColor *redColor = [UIColor grx_colorFromRGBHex:0xFF0000];
    [redColor getRed:&red green:&green blue:&blue alpha:&alpha];
    expect(red).to.equal(1);
    expect(green).to.equal(0);
    expect(blue).to.equal(0);
    expect(alpha).to.equal(1);

    UIColor *orangeColor = [UIColor grx_colorFromRGBHex:0xffa500];
    [orangeColor getRed:&red green:&green blue:&blue alpha:&alpha];
    expect(red).to.equal(1);
    expect(green).to.equal(165/255);
    expect(blue).to.equal(0);
    expect(alpha).to.equal(1);

    UIColor *royalBlue = [UIColor grx_colorFromRGBHex:0x4169e1];
    [royalBlue getRed:&red green:&green blue:&blue alpha:&alpha];
    expect(red).to.equal(65/255.0);
    expect(green).to.equal(105/255.0);
    expect(blue).to.equal(225/255.0);
    expect(alpha).to.equal(1);
}

- (void)testInvalidStrings {
    expect(^{
        [UIColor grx_colorFromRGBHexString:@"#1"];
    }).to.raise(@"Invalid color value");

    expect(^{
        [UIColor grx_colorFromRGBHexString:@"#dasdasdasdasd da"];
    }).to.raise(@"Invalid color value");
}

- (void)testValidRRGGBBStrings {
    CGFloat red, green, blue, alpha;

    UIColor *orangeColor = [UIColor grx_colorFromRGBHexString:@"#ffa500"];
    [orangeColor getRed:&red green:&green blue:&blue alpha:&alpha];
    expect(red).to.equal(1);
    expect(green).to.equal(165/255.0);
    expect(blue).to.equal(0);
    expect(alpha).to.equal(1);

    UIColor *royalBlue = [UIColor grx_colorFromRGBHexString:@"#4169e1"];
    [royalBlue getRed:&red green:&green blue:&blue alpha:&alpha];
    expect(red).to.equal(65/255.0);
    expect(green).to.equal(105/255.0);
    expect(blue).to.equal(225/255.0);
    expect(alpha).to.equal(1);
}

- (void)testValidAARRGGBBStrings {
    CGFloat red, green, blue, alpha;

    UIColor *orangeColor = [UIColor grx_colorFromRGBHexString:@"#49ffa500"];
    [orangeColor getRed:&red green:&green blue:&blue alpha:&alpha];
    expect(red).to.equal(1);
    expect(green).to.equal(165/255.0);
    expect(blue).to.equal(0);
    expect(alpha).to.equal(73/255.0);

    UIColor *royalBlue = [UIColor grx_colorFromRGBHexString:@"#254169e1"];
    [royalBlue getRed:&red green:&green blue:&blue alpha:&alpha];
    expect(red).to.equal(65/255.0);
    expect(green).to.equal(105/255.0);
    expect(blue).to.equal(225/255.0);
    expect(alpha).to.equal(37/255.0);
}

@end
