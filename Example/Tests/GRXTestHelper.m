#import "GRXTestHelper.h"

@implementation GRXTestHelper

+ (UIImage *)imageWithName:(NSString *)filename {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *filepath = [bundle pathForResource:filename ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    return [UIImage imageWithData:data];
}

+ (GRXLayoutInflater *)inflaterForFileWithName:(NSString *)filename {
    GRXLayoutInflater *inflater = [[GRXLayoutInflater alloc] initWithFile:filename
                                                               fromBundle:[NSBundle bundleForClass:self.class]];
    if (inflater.parseError) {
        NSLog(@"Error inflating file %@: %@", filename, inflater.parseError);
    }
    return inflater;
}

+ (GRXLayoutInflater *)inflaterForFileWithName:(NSString *)filename
                                      rootView:(UIView *)rootView {
    GRXLayoutInflater *inflater = [[GRXLayoutInflater alloc] initWithFile:filename
                                                               fromBundle:[NSBundle bundleForClass:self.class]
                                                                 rootView:rootView];
    if (inflater.parseError) {
        NSLog(@"Error inflating file %@: %@", filename, inflater.parseError);
    }
    return inflater;
}

+ (id)rootViewForLayoutFileWithName:(NSString *)filename {
    GRXLayoutInflater *inflater = [self inflaterForFileWithName:filename];
    NSAssert(inflater != nil, @"Invalid layout file: %@", filename);
    return inflater.rootView;
}

@end
