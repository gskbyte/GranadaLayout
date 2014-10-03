#import "GRXTestHelper.h"

@implementation GRXTestHelper

+ (GRXLayoutInflater *)inflaterForFileWithName:(NSString *)filename {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *path = [bundle pathForResource:filename ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [[GRXLayoutInflater alloc] initWithData:data];
}

+ (id)rootViewForLayoutFileWithName:(NSString *)filename {
    GRXLayoutInflater *inflater = [self.class inflaterForFileWithName:filename];
    NSAssert(inflater != nil, @"Invalid layout file: %@", filename);
    return inflater.rootView;
}

@end
