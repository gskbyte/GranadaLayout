#import "GRXSelectionViewController.h"
#import "GRXTestViewController.h"

#import <objc/runtime.h>

@interface GRXSelectionViewController ()

@property (nonatomic) NSArray *controllerClasses;

@end

@implementation GRXSelectionViewController


+ (NSMutableArray *)classesImplementingProtocol:(Protocol *)protocol {
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;

    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);

    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; ++i) {
        Class clazz = classes[i];

        if ([NSStringFromClass(clazz) rangeOfString:@"GRX"].location != NSNotFound) {
            NSLog(@"");
        }

        Class testProtocol = clazz;
        do {
            if ( class_conformsToProtocol(testProtocol, protocol) ) {
                break;
            }
            testProtocol = class_getSuperclass(testProtocol);
        } while (testProtocol != nil);

        if ( testProtocol != nil ) {
            [result addObject:clazz];
        }
    }

    free(classes);

    return result;
}

+ (NSMutableArray *)subclassesOfClass:(Class)parentClass {
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;

    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);

    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; ++i) {
        Class clazz = classes[i];

        do {
            clazz = class_getSuperclass(clazz);
        } while (clazz && clazz != parentClass);

        if (clazz != nil) {
            [result addObject:clazz];
        }
    }

    free(classes);

    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Test list";
    self.view.backgroundColor = [UIColor whiteColor];

    NSMutableArray *allTestControllers = [self.class classesImplementingProtocol:@protocol(GRXTestViewControllerProtocol)];
    for (NSInteger i = allTestControllers.count - 1; i >= 0; --i) {
        Class c = allTestControllers[i];
        NSString *title = [c performSelector:@selector(selectionTitle)];
        if (title == nil) {
            [allTestControllers removeObjectAtIndex:i];
        }
    }
    [allTestControllers sortUsingComparator:^NSComparisonResult (Class c1, Class c2) {
        return [[c1 selectionTitle] compare:[c2 selectionTitle]];
    }];

    self.controllerClasses = allTestControllers;

    if (FastStartViewControllerClassName.length > 0) {
        Class clazz = NSClassFromString(FastStartViewControllerClassName);
        if (clazz != nil) {
            [self.navigationController pushViewController:[[clazz alloc] init]
                                                 animated:NO];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.controllerClasses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 2;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }

    Class clazz = self.controllerClasses[indexPath.row];
    cell.textLabel.text = [clazz selectionTitle];
    cell.detailTextLabel.text = [clazz selectionDetail];

    return cell;
}

- (void)          tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class clazz = self.controllerClasses[indexPath.row];
    [self.navigationController pushViewController:[[clazz alloc] init]
                                         animated:YES];
}

@end
