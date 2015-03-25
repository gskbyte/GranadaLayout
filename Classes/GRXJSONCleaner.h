// kudos to https://github.com/gskbyte/NSJSONSerialization-Comments

#import <Foundation/Foundation.h>

@interface GRXJSONCleaner : NSObject

+ (NSData *)cleanJSONDataWithData:(NSData *)data;

@end
