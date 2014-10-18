#import "GRXTextGenerator.h"

static NSString *GRXRandomTextBase = @"Lorem fistrum a wan apetecan no puedor. Sexuarl la caidita está la cosa muy malar te voy a borrar el cerito mamaar. Se calle ustée qué dise usteer ahorarr fistro ese que llega llevame al sircoo tiene musho peligro fistro pecador benemeritaar. Hasta luego Lucas ese que llega apetecan te voy a borrar el cerito te va a hasé pupitaa está la cosa muy malar jarl caballo blanco caballo negroorl ese hombree a wan. Benemeritaar no puedor jarl llevame al sircoo diodenoo te va a hasé pupitaa te voy a borrar el cerito ese hombree. Pupita sexuarl qué dise usteer al ataquerl la caidita está la cosa muy malar. Qué dise usteer ahorarr va usté muy cargadoo diodenoo mamaar la caidita va usté muy cargadoo va usté muy cargadoo papaar papaar. Ese pedazo de sexuarl no puedor no puedor. Diodeno tiene musho peligro te va a hasé pupitaa benemeritaar va usté muy cargadoo diodenoo amatomaa apetecan está la cosa muy malar te va a hasé pupitaa. Pecador se calle ustée te voy a borrar el cerito diodeno ahorarr diodeno jarl diodenoo te voy a borrar el cerito a gramenawer ese que llega. Está la cosa muy malar torpedo condemor torpedo a wan va usté muy cargadoo va usté muy cargadoo al ataquerl ese hombree ese hombree fistro. Me cago en tus muelas no te digo trigo por no llamarte Rodrigor llevame al sircoo diodenoo torpedo.";

@implementation GRXTextGenerator

+ (NSArray*)words {
    static NSArray *GRXRandomTextGeneratorWords;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GRXRandomTextGeneratorWords = [GRXRandomTextBase componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    });
    return GRXRandomTextGeneratorWords;
}

+ (NSString*)stringWithMinimumLength:(NSUInteger)minLength
                                 maxLength:(NSUInteger)maxLength {
    NSUInteger length = minLength + arc4random_uniform(maxLength-minLength);
    NSUInteger begin = arc4random_uniform(GRXRandomTextBase.length-length);
    return [GRXRandomTextBase substringWithRange:NSMakeRange(begin, length)];
}

+ (NSString*)stringWithMinimumWords:(NSUInteger)minWords
                                 maxWords:(NSUInteger)maxWords {
    if(minWords > self.class.words.count) {
        minWords = self.class.words.count-1;
    }

    if(maxWords > self.class.words.count) {
        maxWords = self.class.words.count-1;
    }

    NSUInteger words = minWords + arc4random_uniform(maxWords-minWords);
    NSUInteger begin = arc4random_uniform([self.class words].count-words);

    return [[self.class.words subarrayWithRange:NSMakeRange(begin, words)] componentsJoinedByString:@" "];
}

+ (NSString*)stringWithMaxLength:(NSUInteger)maxLength
                      emptyProbability:(CGFloat)emptyProbability {
    NSUInteger random = arc4random_uniform(1000);
    if(random < emptyProbability*1000) {
        return @"";
    }
    return [self.class stringWithMinimumLength:0 maxLength:maxLength];
}

@end
