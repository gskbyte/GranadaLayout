#import "GRXLabelTestViewController.h"
#import "GRXLinearLayout.h"

@implementation GRXLabelTestViewController

+ (NSString *)selectionTitle {
    return @"UILabel test";
}

+ (NSString *)selectionDetail {
    return @"Tests height calculation for UILabel";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureRandomizeButton];
    [self randomizeText];
}

- (GRXLinearLayout *)topLinearLayout {
    return (GRXLinearLayout*)self.topLayout;
}

- (void)configureRandomizeButton {
    self.navigationItem.rightBarButtonItem =     [[UIBarButtonItem alloc] initWithTitle:@"Random"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(randomizeText)];
}

static NSString * ipsum =@""
"Lorem fistrum no puedor mamaar quietooor a gramenawer. Condemor quietooor por la gloria de mi madre diodenoo diodeno no puedor a wan pecador pupita ese que llega. Ahorarr no te digo trigo por no llamarte Rodrigor por la gloria de mi madre a gramenawer benemeritaar no te digo trigo por no llamarte Rodrigor al ataquerl ahorarr quietooor.\n"
"Al ataquerl amatomaa me cago en tus muelas a gramenawer a wan quietooor hasta luego Lucas te voy a borrar el cerito tiene musho peligro. Amatomaa quietooor llevame al sircoo al ataquerl caballo blanco caballo negroorl.";

- (void) randomizeText {
    for(UILabel * label in self.topLayout.subviews) {
        NSUInteger length = arc4random_uniform(ipsum.length);

        NSString * displayedText = [ipsum substringWithRange:NSMakeRange(0, length)];
        NSMutableString * text = [NSMutableString stringWithString:@""];
        NSUInteger numLines = arc4random_uniform(5);
        label.numberOfLines = numLines;
        [text appendFormat:@" numLines(%d) >", numLines];
        CGFloat fontSize = 11 + arc4random_uniform(70)/10;
        label.font = [UIFont systemFontOfSize:fontSize];
        [text appendFormat:@" fontSize(%.0f) >", fontSize];

        [text appendFormat:@"%@", displayedText];
        label.text = text;
    }
}

- (GRXLayout *) initializeTopLayout {
    GRXLayout * top = [[GRXLinearLayout alloc] initWithDirection:GRXLinearLayoutDirectionVertical];
    return top;
}

- (void)createViews {
    [super createViews];

    UILabel * label0 = [[UILabel alloc] initWithDefaultParamsInLayout:self.topLayout];
    label0.numberOfLines = 1;
    label0.grx_linearLayoutParams.margins = UIEdgeInsetsMake(4, 4, 4, 4);
    label0.grx_linearLayoutParams.width = GRXMatchParent;
    label0.backgroundColor = [UIColor greenColor];

    UILabel * label1 = [[UILabel alloc] initWithDefaultParamsInLayout:self.topLayout];
    label1.numberOfLines = 4;
    label1.grx_linearLayoutParams.margins = UIEdgeInsetsMake(4, 4, 4, 4);
    label1.grx_linearLayoutParams.width = GRXMatchParent;
    label1.backgroundColor = [UIColor redColor];


    UILabel * label2 = [[UILabel alloc] initWithDefaultParamsInLayout:self.topLayout];
    label2.grx_linearLayoutParams.margins = UIEdgeInsetsMake(4, 4, 4, 4);
    label2.grx_linearLayoutParams.width = GRXMatchParent;
    label2.backgroundColor = [UIColor yellowColor];
}
@end
