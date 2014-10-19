#import "GRXComplexData.h"
#import "GRXTextGenerator.h"

@implementation GRXComplexDataHeader

@synthesize formattedDate = _formattedDate;

- (NSString *)formattedDate {
    if (_formattedDate == nil) {
        static NSDateFormatter *formatter;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"dd.MM.yyyy hh:mm:ss";
        });
        _formattedDate = [formatter stringFromDate:_date];
    }
    return _formattedDate;
}

@end

@implementation GRXComplexDataBody


@end

@implementation GRXComplexData

+ (NSArray *)generateDataWithCount:(NSUInteger)count {
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; ++i) {
        GRXComplexData *data = [[GRXComplexData alloc] init];

        GRXComplexDataHeader *header = [[GRXComplexDataHeader alloc] init];
        header.title = [GRXTextGenerator stringWithMinimumWords:5 maxWords:16];
        NSTimeInterval dateInterval = [NSDate date].timeIntervalSince1970 - arc4random_uniform(10000);
        header.date = [NSDate dateWithTimeIntervalSince1970:dateInterval];
        header.image = [self.class randomImageWithProbability:0.9];
        header.message = [GRXTextGenerator stringWithMaxLength:150 emptyProbability:0.7];
        data.header = header;

        NSUInteger numBodies = ABS(arc4random_uniform(4));
        data.bodies = [NSMutableArray arrayWithCapacity:numBodies];
        for (NSUInteger i = 0; i < numBodies; ++i) {
            GRXComplexDataBody *body = [[GRXComplexDataBody alloc] init];
            body.title = [GRXTextGenerator stringWithMinimumWords:5 maxWords:16];
            body.subtitle = [GRXTextGenerator stringWithMaxLength:32 emptyProbability:0.3];
            body.image = [self.class randomImageWithProbability:0.6];
            body.url = [self.class randomURL];
            [(NSMutableArray *)data.bodies addObject : body];
        }
        [datas addObject:data];
    }
    return datas;
}

+ (UIImage *)randomImageWithProbability:(CGFloat)prob {
    BOOL hasImage = ((CGFloat)arc4random_uniform(1000) / 1000) < prob;
    if (NO == hasImage) {
        return nil;
    }

    NSString *name = nil;
    NSUInteger number = arc4random_uniform(3);
    switch (number) {
        case 0:
            name = @"lab.png";
            break;
        case 1:
            name = @"green.png";
            break;
        case 2:
            name = @"power.png";
            break;
    }

    if (name != nil) {
        return [UIImage imageNamed:name];
    } else {
        return nil;
    }
}

+ (NSURL *)randomURL {
    NSUInteger number = arc4random_uniform(3);
    switch (number) {
        case 0:
            return [NSURL URLWithString:@"http://www.twitter.com/gskbyte"];
        case 1:
            return [NSURL URLWithString:@"http://github.com/gskbyte/GranadaLayout"];
        default:
            return nil;
    }
}

@end
