#import "GRXCollectionViewTestController.h"
#import <GRXLayoutInflater.h>

static NSString * baseText = @"Lorem fistrum a wan apetecan no puedor. Sexuarl la caidita está la cosa muy malar te voy a borrar el cerito mamaar. Se calle ustée qué dise usteer ahorarr fistro ese que llega llevame al sircoo tiene musho peligro fistro pecador benemeritaar. Hasta luego Lucas ese que llega apetecan te voy a borrar el cerito te va a hasé pupitaa está la cosa muy malar jarl caballo blanco caballo negroorl ese hombree a wan. Benemeritaar no puedor jarl llevame al sircoo diodenoo te va a hasé pupitaa te voy a borrar el cerito ese hombree. Pupita sexuarl qué dise usteer al ataquerl la caidita está la cosa muy malar. Qué dise usteer ahorarr va usté muy cargadoo diodenoo mamaar la caidita va usté muy cargadoo va usté muy cargadoo papaar papaar. Ese pedazo de sexuarl no puedor no puedor. Diodeno tiene musho peligro te va a hasé pupitaa benemeritaar va usté muy cargadoo diodenoo amatomaa apetecan está la cosa muy malar te va a hasé pupitaa. Pecador se calle ustée te voy a borrar el cerito diodeno ahorarr diodeno jarl diodenoo te voy a borrar el cerito a gramenawer ese que llega. Está la cosa muy malar torpedo condemor torpedo a wan va usté muy cargadoo va usté muy cargadoo al ataquerl ese hombree ese hombree fistro. Me cago en tus muelas no te digo trigo por no llamarte Rodrigor llevame al sircoo diodenoo torpedo.";

@interface GRXCollectionViewTestController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSMutableArray * cellDatas;
@property (nonatomic) NSUInteger numberOfItems;

@end

@interface GRXInflatedCellData : UICollectionViewCell

@property (nonatomic) NSString *title, *subtitle, *message;
@property (nonatomic) BOOL showImage;

@end

@interface GRXInflatedCell : UICollectionViewCell

@property (nonatomic) GRXInflatedCellData *data;
@property (nonatomic) GRXLayout * root;
@property (nonatomic) UIImageView * image;
@property (nonatomic) UITextView *title, *message;
@property (nonatomic) UILabel *subtitle;

+ (CGSize) sizeForData:(GRXInflatedCellData*)data;

@end


@implementation GRXCollectionViewTestController

- (instancetype) init {
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
    return [self initWithCollectionViewLayout:flow];
}

- (instancetype) initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if(self) {
        NSArray * words = [baseText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.numberOfItems = 20 + arc4random_uniform(200);
        self.cellDatas = [NSMutableArray arrayWithCapacity:self.numberOfItems];
        for(NSUInteger i=0; i<self.numberOfItems; ++i) {
            GRXInflatedCellData * data = [[GRXInflatedCellData alloc] init];

            NSUInteger titleLength = 5 + ABS(arc4random_uniform(16));
            NSUInteger titleBegin = ABS(arc4random_uniform(20));
            data.title = [[words subarrayWithRange:NSMakeRange(titleBegin, titleLength)] componentsJoinedByString:@" "];

            NSUInteger subtitleLength = 4 + ABS(arc4random_uniform(8));
            NSUInteger subtitleBegin = ABS(arc4random_uniform(20));
            data.subtitle = [[words subarrayWithRange:NSMakeRange(subtitleBegin, subtitleLength)] componentsJoinedByString:@" "];

            NSInteger messageLength = 0 + ABS(arc4random_uniform(100));
            messageLength -= 50;
            if(messageLength < 0) {
                messageLength = 0;
            }
            data.message = [[words subarrayWithRange:NSMakeRange(0, messageLength)] componentsJoinedByString:@" "];

            data.showImage = arc4random()%2;

            [self.cellDatas addObject:data];
        }
    }
    return self;
}

+ (NSString *)selectionTitle {
    return @"CollectionViewCell example";
}

+ (NSString *)selectionDetail {
    return @"";
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.collectionView registerClass:GRXInflatedCell.class
            forCellWithReuseIdentifier:NSStringFromClass(GRXInflatedCell.class)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GRXInflatedCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(GRXInflatedCell.class)
                                                                       forIndexPath:indexPath];
    GRXInflatedCellData * data = self.cellDatas[indexPath.row];
    cell.data = data;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GRXInflatedCellData * data = self.cellDatas[indexPath.row];
    CGSize size = [GRXInflatedCell sizeForData:data];

    NSLog(@"[%d] -> %.0f, %.0f", indexPath.row, size.width, size.height);

    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 0, 0, 8);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

@end

@implementation GRXInflatedCellData
@end

@implementation GRXInflatedCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        GRXLayoutInflater * inflater = [[GRXLayoutInflater alloc] initWithFile:@"cell_test.grx"
                                                                    fromBundle:[NSBundle bundleForClass:self.class]];
        self.root = inflater.rootView;
        self.image = [inflater viewForIdentifier:@"image"];
        self.image.backgroundColor = [UIColor blueColor];
        self.image.contentMode = UIViewContentModeScaleAspectFit;

        self.title = [inflater viewForIdentifier:@"title"];
        self.subtitle = [inflater viewForIdentifier:@"subtitle"];
        self.message = [inflater viewForIdentifier:@"message"];

        [self.contentView addSubview:self.root];
    }
    return self;
}

- (void)setData:(GRXInflatedCellData *)data {
    _data = data;

    self.title.attributedText = [[NSAttributedString alloc] initWithString:data.title];
    self.subtitle.text = data.subtitle;

    self.message.attributedText = [[NSAttributedString alloc] initWithString:data.message];
    self.message.grx_visibility = data.message.length == 0 ? GRXViewVisibilityGone : GRXViewVisibilityVisible;

    self.image.image = [UIImage imageNamed:@"lab.png"];
    self.image.grx_visibility = data.showImage ? GRXViewVisibilityVisible : GRXViewVisibilityGone;

    [self.root setNeedsLayout];
}

+ (CGSize) sizeForData:(GRXInflatedCellData*)data {
    static GRXInflatedCell * staticCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticCell = [[GRXInflatedCell alloc] initWithFrame:CGRectZero];
    });
    staticCell.data = data;

    [staticCell.root grx_invalidateMeasuredSize];
    [staticCell setNeedsLayout];
    [staticCell layoutIfNeeded];

    return staticCell.root.size;
}

@end