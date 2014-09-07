#import "GRXTextViewTestViewController.h"
#import "GRXLinearLayout.h"

@interface GRXTextViewTestViewController ()

@end

@implementation GRXTextViewTestViewController

+ (NSString *)selectionTitle {
    return @"UITextView height test";
}

+ (NSString *)selectionDetail {
    return @"Tests height calculation for UITextView";
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
    for(UITextView * tv in self.topLayout.subviews) {
        tv.editable = NO;

        NSUInteger length = arc4random_uniform(ipsum.length);

        NSString * text = [ipsum substringWithRange:NSMakeRange(0, length)];

        BOOL attributed = arc4random_uniform(3);
        if(attributed) {
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:text];
            NSUInteger numAttr = arc4random_uniform(10);
            for(NSUInteger i=0; i<numAttr; ++i) {
                NSUInteger origin = arc4random_uniform(text.length/2);
                NSUInteger length = 1+arc4random_uniform(text.length/3);
                NSRange range = NSMakeRange(origin, length);

                if(arc4random_uniform(3)) {
                    CGFloat boldSize = 11 + arc4random_uniform(70)/10;
                    [attr addAttribute:NSFontAttributeName
                                 value:[UIFont boldSystemFontOfSize:boldSize]
                                 range:range];
                }

                if(arc4random_uniform(3)) {
                    [attr addAttribute:NSLinkAttributeName
                                 value:@"https://github.com/gskbyte"
                                 range:range];
                }

                if(arc4random_uniform(3)) {
                    [attr addAttribute:NSForegroundColorAttributeName
                                 value:UIColor.grayColor
                                 range:range];
                }

            }
            tv.attributedText = attr;
        } else {
            tv.text = text;
        }
        [tv grx_setNeedsLayout];
    }
}

- (GRXLayout *) initializeTopLayout {
    GRXLayout * top = [[GRXLinearLayout alloc] initWithDirection:GRXLinearLayoutDirectionVertical];
    return top;
}

- (void)createViews {
    [super createViews];

    UITextView * t0 = [[UITextView alloc] initWithDefaultParamsInLayout:self.topLayout];
    t0.grx_linearLayoutParams.margins = UIEdgeInsetsMake(4, 4, 4, 4);
    t0.grx_linearLayoutParams.width = GRXMatchParent;
    t0.backgroundColor = [UIColor greenColor];

    UITextView * t1 = [[UITextView alloc] initWithDefaultParamsInLayout:self.topLayout];
    t1.grx_linearLayoutParams.margins = UIEdgeInsetsMake(4, 4, 4, 4);
    t1.grx_linearLayoutParams.width = GRXMatchParent;
    t1.backgroundColor = [UIColor redColor];


    UITextView * t2 = [[UITextView alloc] initWithDefaultParamsInLayout:self.topLayout];
    t2.grx_linearLayoutParams.margins = UIEdgeInsetsMake(4, 4, 4, 4);
    t2.grx_linearLayoutParams.width = GRXMatchParent;
    t2.backgroundColor = [UIColor yellowColor];
}
@end
