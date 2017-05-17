//
//  UIImage+BMScan.m
//  BMScanDemo
//
//  Created by __liangdahong on 2017/4/30.
//  Copyright © http://idhong.com All rights reserved.
//  Copyright © https://github.com/asiosldh/BMScan All rights reserved.
//

#import "UIImage+BMScan.h"
#import "BMScanController.h"

@implementation UIImage (BMScan)

- (UIImage *)bm_imageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (instancetype)bm_loadImageWithName:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[BMScanController class]] pathForResource:@"BMScan" ofType:@"bundle"]];
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
}

- (NSArray<NSString *> *)bm_identifyCodeArray {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    CIImage *image = [[CIImage alloc] initWithImage:self];
    NSArray <CIQRCodeFeature *> *features = (NSArray <CIQRCodeFeature *> *)[detector featuresInImage:image];
    NSMutableArray *codeArray = [@[] mutableCopy];
    [features enumerateObjectsUsingBlock:^(CIQRCodeFeature * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.messageString.length) {
            [codeArray addObject:obj.messageString];
        }
    }];
    return codeArray;
}

@end
