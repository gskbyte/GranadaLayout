#import "GRXSelectionViewController.h"
#import "GRXTestViewController.h"

#import "GRXTestViewController.h"

#import <objc/runtime.h>

@interface GRXSelectionViewController ()

@property (nonatomic) NSArray * controllerClasses;

@end

@implementation GRXSelectionViewController

+ (NSMutableArray *) subclassesOfClass:(Class)parentClass {
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;

    classes = (__unsafe_unretained Class *) malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);

    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i=0; i < numClasses; ++i) {
        Class superClass = classes[i];
        do {
            superClass = class_getSuperclass(superClass);
        } while(superClass && superClass != parentClass);

        if (superClass != nil) {
            [result addObject:classes[i]];
        }
    }

    free(classes);

    return result;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Test list";
    self.view.backgroundColor = [UIColor whiteColor];

    NSMutableArray * allSubclasses = [self.class subclassesOfClass:GRXTestViewController.class];
    [allSubclasses sortUsingComparator:^NSComparisonResult(Class c1, Class c2) {
        return [[c1 selectionTitle] compare:[c2 selectionTitle]];
    }];
    self.controllerClasses = allSubclasses;

    if(FastStartViewControllerClassName.length > 0) {
        Class clazz = NSClassFromString(FastStartViewControllerClassName);
        if(clazz != nil) {
            [self.navigationController pushViewController:[[clazz alloc] init]
                                                 animated:NO];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.controllerClasses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
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

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class clazz = self.controllerClasses[indexPath.row];
    [self.navigationController pushViewController:[[clazz alloc] init]
                                         animated:YES];
}

@end
