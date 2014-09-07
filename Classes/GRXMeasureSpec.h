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

CG_INLINE CGFloat GRXMeasureSpecGetDefaultValue(CGFloat sizeValue, CGFloat sizeSpecValue, GRXMeasureSpecMode mode) {
    switch (mode) {
        default:
        case GRXMeasureSpecUnspecified:
            return sizeValue;
        case GRXMeasureSpecExactly:
        case GRXMeasureSpecAtMost:
            return sizeSpecValue;
    }
}

CG_INLINE BOOL GRXMeasureSpecIsZero(GRXMeasureSpec spec) {
    return spec.width==0 && spec.widthMode==0 && spec.height==0 && spec.heightMode==0;
}

CG_INLINE BOOL GRXMeasureSpecsEqual(GRXMeasureSpec spec1, GRXMeasureSpec spec2) {
    return spec1.width == spec2.width &&
        spec1.widthMode == spec2.widthMode &&
        spec1.height == spec2.height &&
        spec1.heightMode == spec2.heightMode;
}