// kudos to https://github.com/gskbyte/NSJSONSerialization-Comments

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GRXJSONCleaner : NSObject

+ (NSData *)cleanJSONDataWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
