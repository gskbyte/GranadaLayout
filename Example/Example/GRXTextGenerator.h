#import <UIKit/UIKit.h>

@interface GRXTextGenerator : NSObject

+ (NSString *)stringWithMinimumLength:(NSUInteger)minLength
                            maxLength:(NSUInteger)maxLength;
+ (NSString *)stringWithMinimumWords:(NSUInteger)minWords
                            maxWords:(NSUInteger)maxWords;
+ (NSString *)stringWithMaxLength:(NSUInteger)minLength
                 emptyProbability:(CGFloat)emptyProbability;

@end
