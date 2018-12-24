//
//  FontStretch.m
//  JWOMPA
//
//  Created by BadhanGanesh on 06/03/18.
//  Copyright © 2018 Relienttekk. All rights reserved.
//

#import "FontStretchView.h"
#import <CoreText/CoreText.h>
#import "JWOMPA-Bridging-Header.h"

@implementation FontStretchView

- (void)drawRect:(CGRect)rect {
    [self drawScaledString:self.text];
}

- (void)drawScaledString:(NSString *)string {
    
    CGFloat SCREEN_WIDTH = UIScreen.mainScreen.bounds.size.width;
    CGFloat SCREEN_HEIGHT = UIScreen.mainScreen.bounds.size.height;
    CGFloat SCREEN_MAX_LENGTH = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    CGFloat SCREEN_MIN_LENGTH = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    
    BOOL IS_IPHONE_4_OR_LESS = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH < 568.0;
    BOOL IS_IPHONE_SE = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH == 568.0;
    BOOL IS_IPHONE_7 = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH == 667.0;
    BOOL IS_IPHONE_7PLUS = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH == 736.0;
    BOOL IS_IPHONE_X = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH == 812.0;
    BOOL IS_IPAD = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH == 1024.0;
    
    self.backgroundColor = [UIColor clearColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    NSAttributedString *attrString = [self generateAttributedString:string];
    
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attrString, CFRangeMake(0, string.length),
                                   kCTForegroundColorAttributeName, [UIColor whiteColor].CGColor);
    
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef) attrString);
    
    // CTLineGetTypographicBounds doesn't give correct values,
    // using GetImageBounds instead
    CGRect imageBounds = CTLineGetImageBounds(line, context);
    CGFloat width = imageBounds.size.width;
    CGFloat height = imageBounds.size.height;
    
    CGFloat padding = 0;
    
    width += padding;
    height += padding;
    
    float sx = self.bounds.size.width / width;
    float sy = self.bounds.size.height / height;
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    if (IS_IPHONE_SE) {
        CGContextTranslateCTM(context, 1, self.bounds.size.height / 1.48);
        CGContextScaleCTM(context, 0.87, -0.38);
    } else if (IS_IPHONE_7) {
        CGContextTranslateCTM(context, 1, self.bounds.size.height / 1.45);
        CGContextScaleCTM(context, 0.87, -0.35);
    } else if (IS_IPHONE_7PLUS) {
        CGContextTranslateCTM(context, 1, self.bounds.size.height / 1.43);
        CGContextScaleCTM(context, 0.87, -0.34);
    } else if (IS_IPHONE_X) {
        CGContextTranslateCTM(context, 1, self.bounds.size.height / 1.38);
        CGContextScaleCTM(context, 0.87, -0.327);
    }
    
    CGContextScaleCTM(context, sx, sy);
    
    CGContextSetTextPosition(context, -imageBounds.origin.x + padding/2, -imageBounds.origin.y + padding/2);
    
    CTLineDraw(line, context);
    CFRelease(line);
}

- (NSAttributedString *)generateAttributedString:(NSString *)string {
    
    CTFontRef helv = CTFontCreateWithName(CFSTR("FuturaBT-Book"),18, NULL);
    
    CGColorRef color = [UIColor whiteColor].CGColor;
    CGColorRef bgColor = [UIColor clearColor].CGColor;
    
    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)helv, (NSString *)kCTFontAttributeName,
                                    color, (NSString *)kCTForegroundColorAttributeName, bgColor, (NSString *)kCTBackgroundColorAttributeName, nil];
    
    NSAttributedString *attrString = [[NSMutableAttributedString alloc]
                                       initWithString:string
                                       attributes:attributesDict];
    
    return attrString;
}

@end
