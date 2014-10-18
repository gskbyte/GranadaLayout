#import "GRXComplexCellCollectionViewTestController.h"
#import "GRXComplexData.h"
#import "GRXComplexCollectionViewCell.h"
#import "GRXLoadMoreCell.h"
#import <GranadaLayout/GRXLayoutInflater.h>

const static NSUInteger GRXNumItemsPerRequest = 10;

typedef NS_ENUM(NSUInteger, GRXComplexCellControllerSection) {
    GRXComplexCellControllerSectionCells = 0,
    GRXComplexCellControllerSectionLoadMore,

    GRXComplexCellControllerSectionCount
};

@interface GRXComplexCellCollectionViewTestController ()

@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSMutableArray *cellDatas;

@end

@implementation GRXComplexCellCollectionViewTestController

- (instancetype)init {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    return [self initWithCollectionViewLayout:flow];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.cellDatas = [NSMutableArray arrayWithCapacity:GRXNumItemsPerRequest];
        [self.cellDatas addObjectsFromArray:[GRXComplexData generateDataWithCount:GRXNumItemsPerRequest]];
    }
    return self;
}

+ (NSString *)selectionTitle {
    return @"Complex UICollectionViewCell example";
}

+ (NSString *)selectionDetail {
    return @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [GRXLayoutInflater setDebugOptionsEnabled:NO];

    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.collectionView registerClass:GRXComplexCollectionViewCell.class
            forCellWithReuseIdentifier:NSStringFromClass(GRXComplexCollectionViewCell.class)];
    [self.collectionView registerClass:GRXLoadMoreCell.class
            forCellWithReuseIdentifier:NSStringFromClass(GRXLoadMoreCell.class)];

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.accessibilityLabel = @"Pull to refresh";
    [self.refreshControl addTarget:self
                            action:@selector(beginRefreshing)
                  forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];

}

- (void)beginRefreshing {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSMutableArray *newCellDatas = [NSMutableArray arrayWithCapacity:GRXNumItemsPerRequest];
        [newCellDatas addObjectsFromArray:[GRXComplexData generateDataWithCount:GRXNumItemsPerRequest]];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.cellDatas = newCellDatas;
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        });

    });
}

- (void)beginLoadMoreCells {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSMutableArray *newCellDatas = [NSMutableArray arrayWithCapacity:GRXNumItemsPerRequest];
        [newCellDatas addObjectsFromArray:[GRXComplexData generateDataWithCount:GRXNumItemsPerRequest]];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView performBatchUpdates:^{
                NSUInteger oldNumObjects = self.cellDatas.count;
                [self.cellDatas addObjectsFromArray:newCellDatas];
                NSMutableArray *newIndexPaths = [NSMutableArray arrayWithCapacity:newCellDatas.count];
                for(NSUInteger i= oldNumObjects; i<self.cellDatas.count; ++i) {
                    [newIndexPaths addObject:[NSIndexPath indexPathForItem:i
                                                                 inSection:GRXComplexCellControllerSectionCells]];
                }
                [self.collectionView insertItemsAtIndexPaths:newIndexPaths];
            } completion:^(BOOL finished) {

            }];
        });
        
    });
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return GRXComplexCellControllerSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case GRXComplexCellControllerSectionCells:
            return self.cellDatas.count;
        case GRXComplexCellControllerSectionLoadMore:
            return 1;
        default:
            return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case GRXComplexCellControllerSectionCells: {
            GRXComplexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(GRXComplexCollectionViewCell.class)
                                                                                           forIndexPath:indexPath];
            GRXComplexData *data = self.cellDatas[indexPath.row];
            cell.data = data;
            return cell;
        }
        case GRXComplexCellControllerSectionLoadMore: {
            GRXLoadMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(GRXLoadMoreCell.class)
                                                                              forIndexPath:indexPath];
            [self beginLoadMoreCells];
            return cell;
        }
        default:
            return nil; // explode
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case GRXComplexCellControllerSectionCells: {
            GRXComplexData *data = self.cellDatas[indexPath.row];
            CGSize size = [GRXComplexCollectionViewCell sizeForData:data];

            //NSLog(@"[%zd] -> %.0f, %.0f", indexPath.row, size.width, size.height);
            
            return size;
        }
        case GRXComplexCellControllerSectionLoadMore: {
            return [GRXLoadMoreCell cellSizeForCollectionView:collectionView];
        }
        default:
            return CGSizeZero; // explode
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 0, 0, 8);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}


@end
