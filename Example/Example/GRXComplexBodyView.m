#import "GRXComplexBodyView.h"
#import <GranadaLayout/GRXLayoutInflater.h>

@interface GRXComplexBodyView ()

@property (nonatomic) UIImageView *image;
@property (nonatomic) UILabel *title, *subtitle;
@property (nonatomic) UITextView *url;

@end

@implementation GRXComplexBodyView

- (void) loadViews {
    GRXLayoutInflater *inflater = [[GRXLayoutInflater alloc] initWithFile:@"complex_cell_body.grx"
                                                               fromBundle:[NSBundle bundleForClass:self.class]];
    self.grx_layoutParams.margins = UIEdgeInsetsMake(4, 0, 0, 0);
    self.padding = UIEdgeInsetsMake(4, 4, 4, 4);
    for(UIView *v in [inflater.rootView subviews]) {
        [self addSubview:v];
    }

    self.image = [inflater viewForIdentifier:@"image"];
    self.image.backgroundColor = [UIColor blueColor];
    self.image.contentMode = UIViewContentModeScaleAspectFit;

    self.title = [inflater viewForIdentifier:@"title"];
    self.title.font = [UIFont boldSystemFontOfSize:16];
    self.title.numberOfLines = 2;

    self.subtitle = [inflater viewForIdentifier:@"subtitle"];
    self.subtitle.numberOfLines = 3;
    self.subtitle.font = [UIFont systemFontOfSize:12];
    self.subtitle.textColor = [UIColor grayColor];

    self.url = [inflater viewForIdentifier:@"url"];
    self.url.font = [UIFont systemFontOfSize:14];
    self.url.textAlignment = NSTextAlignmentCenter;

    self.backgroundColor = [UIColor grayColor];

}

- (void)setBody:(GRXComplexDataBody *)body {
    self.image.image = body.image;
    self.image.grx_visibility = body.image!=nil ? GRXVisibilityVisible : GRXVisibilityGone;

    self.title.text = body.title;
    self.title.grx_visibility = body.title.length>0 ? GRXVisibilityVisible : GRXVisibilityGone;

    self.subtitle.text = body.subtitle;
    self.subtitle.grx_visibility = body.subtitle.length>0 ? GRXVisibilityVisible : GRXVisibilityGone;

    if(body.url != nil) {
        self.url.attributedText = [[NSAttributedString alloc] initWithString:body.url.absoluteString
                                                                  attributes:@{NSLinkAttributeName : body.url}];
    }
    self.url.grx_visibility = body.url!=nil ? GRXVisibilityVisible : GRXVisibilityGone;
}


@end
