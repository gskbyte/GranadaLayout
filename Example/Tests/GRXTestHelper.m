#import "GRXTestHelper.h"

@implementation GRXTestHelper

+ (GRXLayoutInflater *)inflaterForFileWithName:(NSString *)filename {
    return [[GRXLayoutInflater alloc] initWithFile:filename
                                        fromBundle:[NSBundle bundleForClass:self.class]];
}

+ (id)rootViewForLayoutFileWithName:(NSString *)filename {
    GRXLayoutInflater *inflater = [self.class inflaterForFileWithName:filename];
    NSAssert(inflater != nil, @"Invalid layout file: %@", filename);
    return inflater.rootView;
}

@end
