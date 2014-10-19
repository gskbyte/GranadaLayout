#import "GRXTestHelper.h"

@implementation GRXTestHelper

+ (UIImage *)imageWithName:(NSString *)filename {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *filepath = [bundle pathForResource:filename ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    return [UIImage imageWithData:data];
}

+ (GRXLayoutInflater *)inflaterForFileWithName:(NSString *)filename {
    return [[GRXLayoutInflater alloc] initWithFile:filename
                                        fromBundle:[NSBundle bundleForClass:self.class]];
}

+ (GRXLayoutInflater *)inflaterForFileWithName:(NSString *)filename
                                      rootView:(UIView*)rootView {
    return [[GRXLayoutInflater alloc] initWithFile:filename
                                        fromBundle:[NSBundle bundleForClass:self.class]
                                          rootView:rootView];
}

+ (id)rootViewForLayoutFileWithName:(NSString *)filename {
    GRXLayoutInflater *inflater = [self.class inflaterForFileWithName:filename];
    NSAssert(inflater != nil, @"Invalid layout file: %@", filename);
    return inflater.rootView;
}

@end
