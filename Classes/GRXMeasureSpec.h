typedef NS_ENUM(NSUInteger, GRXMeasureSpecMode) {
    GRXMeasureSpecUnspecified = 0,
    GRXMeasureSpecExactly,
    GRXMeasureSpecAtMost
};

typedef struct GRXMeasureSpec {
    CGFloat width;
    GRXMeasureSpecMode widthMode;

    CGFloat height;
    GRXMeasureSpecMode heightMode;
} GRXMeasureSpec;


CG_INLINE GRXMeasureSpec
GRXMeasureSpecMake(CGFloat width, GRXMeasureSpecMode widthMode,
                   CGFloat height, GRXMeasureSpecMode heightMode)
{
    GRXMeasureSpec spec;
    spec.width = width;
    spec.widthMode = widthMode;
    spec.height = height;
    spec.heightMode = heightMode;
    return spec;
}

CG_INLINE CGFloat GRXDefaultSizeValueForSpec(CGFloat sizeValue, CGFloat sizeSpecValue, GRXMeasureSpecMode mode) {
    switch (mode) {
        default:
        case GRXMeasureSpecUnspecified:
            return sizeValue;
        case GRXMeasureSpecExactly:
        case GRXMeasureSpecAtMost:
            return sizeSpecValue;
    }
}
