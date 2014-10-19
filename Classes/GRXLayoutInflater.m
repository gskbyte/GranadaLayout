#import "GRXLayoutInflater.h"
#import "GRXLinearLayout.h"
#import "GRXRelativeLayout.h"
#import "UIView+GRXLayoutInflater.h"
#import "GRXLayout+GRXLayoutInflater.h"

@interface GRXLayoutInflater () {
    NSMutableDictionary *_allViewsById;
    NSBundle *_bundle; // can be nil if data was not loaded from a bundle
}

@end

@implementation GRXLayoutInflater

#pragma mark - Debug options

static BOOL GRXLayoutInflaterDebugOptionsEnabled = DEBUG;

+ (BOOL)areDebugOptionsEnabled {
    return GRXLayoutInflaterDebugOptionsEnabled;
}

+ (void)setDebugOptionsEnabled:(BOOL)enabled {
    GRXLayoutInflaterDebugOptionsEnabled = enabled;
}

#pragma mark - Initialisers

- (instancetype)initWithData:(NSData *)data
                    rootView:(UIView *)rootView {
    self = [super init];
    if (self) {
        _allViewsById = [[NSMutableDictionary alloc] init];
        NSError *error;
        id JSON = [NSJSONSerialization JSONObjectWithData:data
                                                  options:0
                                                    error:&error];
        if (error) {
            NSLog(@"Error parsing layout file, invalid JSON: %@", error);
            return nil;
        }
        [self parseJSON:JSON
               rootView:rootView];
    }
    return self;
}

- (instancetype)initWithBundleFile:(NSString *)filename
                          rootView:(UIView *)rootView {
    return [self initWithFile:filename
                   fromBundle:[NSBundle mainBundle]
                     rootView:rootView];
}

- (instancetype)initWithFile:(NSString *)filename
                  fromBundle:(NSBundle *)bundle
                    rootView:(UIView *)rootView {
    NSString *path = [bundle pathForResource:filename ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _bundle = bundle;
    return [self initWithData:data
                     rootView:rootView];
}

- (instancetype)initWithData:(NSData *)data {
    return [self initWithData:data
                     rootView:nil];
}

- (instancetype)initWithBundleFile:(NSString *)filename {
    return [self initWithBundleFile:filename
                           rootView:nil];
}

- (instancetype)initWithFile:(NSString *)filename
                  fromBundle:(NSBundle *)bundle {
    return [self initWithFile:filename
                   fromBundle:bundle
                     rootView:nil];
}

- (BOOL)parseJSON:(id)JSON
         rootView:(UIView *)rootView {
    NSAssert([JSON isKindOfClass:NSDictionary.class],
             @"The layout file must be a dictionary");

    NSDictionary *layout = [JSON objectForKey:@"layout"];
    NSAssert(layout != nil,
             @"'layout' node must be defined in the root");
    NSAssert([layout isKindOfClass:NSDictionary.class],
             @"'layout' node must be a dictionary");

    _rootView = [self parseViewNodeRecursively:layout
                                    parentView:rootView.superview
                                       outView:rootView];
    [_rootView grx_didLoadFromInflater:self];

    return YES;
}

- (UIView *)parseViewNodeRecursively:(NSDictionary *)node
                          parentView:(UIView *)parentView
                             outView:(UIView *)outView {
    NSString *className = node[@"class"];
    id inflationObject = node[@"inflate"];
    if (className != nil) {
        outView = [self initializeViewWithClassName:className outView:outView];
    } else if (inflationObject != nil) {
        NSDictionary *inflationDict = nil;
        if ([inflationObject isKindOfClass:NSDictionary.class]) {
            inflationDict = inflationObject;
        } else if ([inflationObject isKindOfClass:NSString.class]) {
            inflationDict = @{@"filename": inflationObject};
        } else {
            NSAssert(NO, @"Invalid inflation object");
        }

        outView = [self initializeViewWithInflationDict:inflationDict
                                                outView:outView];
        if (outView == nil) {
            return nil;
        }
    } else {
        NSLog(@"Warning: Please specify 'class' or 'inflate' to inflate a view. Layout can be badly formed.");
        return nil;
    }


    GRXLayoutParams *layoutParams = nil;
    if ([parentView isKindOfClass:GRXLayout.class]) {
        GRXLayout *parentLayout = (GRXLayout *)parentView;
        Class layoutParamsClass = [parentLayout.class layoutParamsClass];
        layoutParams = [[layoutParamsClass alloc] init];
        [parentLayout configureSubviewLayoutParams:layoutParams
                                    fromDictionary:node
                                        inInflater:self];
    } else {
        layoutParams = [[GRXLayoutParams alloc] init];
        [GRXLayout configureUnparentedLayoutParams:layoutParams
                                    fromDictionary:node];
    }
    [outView grx_configureFromDictionary:node];
    outView.grx_layoutParams = layoutParams;

    NSString *identifier = node[@"id"];
    if (identifier != nil) {
        if ([_allViewsById objectForKey:identifier] != nil) {
            NSLog(@"Warning: identifier used more than once in layout file: %@", identifier);
        }
        [_allViewsById setObject:outView forKey:identifier];

        if ([self.class areDebugOptionsEnabled]) {
            outView.grx_debugIdentifier = identifier;
        }
    }

    NSArray *subviews = node[@"subviews"];
    for (NSDictionary *subviewDict in subviews) {
        UIView *subview = [self parseViewNodeRecursively:subviewDict
                                              parentView:outView
                                                 outView:nil];
        if (subview != nil) {
            [outView addSubview:subview];
        }
    }

    return outView;
}

- (UIView *)initializeViewWithClassName:(NSString *)className
                                outView:(UIView *)outView {
    Class viewClass = NSClassFromString(className);
    if (viewClass == nil) {
        NSLog(@"Unknown view class '%@', layout can be badly formed", className);
        return nil;
    }

    if (outView == nil) {
        outView = [[viewClass alloc] initWithFrame:CGRectZero];
    } else {
        NSAssert([outView isMemberOfClass:viewClass],
                 @"The root view defined in the file and the view to be inflated must have the same class");
    }
    return outView;
}

- (UIView *)initializeViewWithInflationDict:(NSDictionary *)inflateDict
                                    outView:(UIView *)outView {
    NSString *filename = inflateDict[@"filename"];
    NSString *bundleIdentifier = inflateDict[@"bundle"];
    NSBundle *bundle = _bundle;
    if (bundleIdentifier != nil) {
        bundle = [NSBundle bundleWithIdentifier:bundleIdentifier];
    }
    if (bundle == nil) {
        bundle = [NSBundle mainBundle];
    }

    GRXLayoutInflater *inflater = [[GRXLayoutInflater alloc] initWithFile:filename fromBundle:bundle rootView:outView];
    if (inflater.rootView == nil) {
        NSLog(@"Warning: Error inflating file '%@' from bundle '%@'. Layout will be incomplete.", filename, bundle.bundleIdentifier);
    }
    return inflater.rootView;
}

- (id)viewForIdentifier:(NSString *)identifier {
    id val = _allViewsById[identifier];
    if (val == nil) {
        NSLog(@"Warning: view not found for identifier %@", identifier);
    }
    return val;
}

@end
