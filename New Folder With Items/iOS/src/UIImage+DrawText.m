//
//  UIImage+DrawText.m
//  Glimp
//
//  Created by Ahmed Salah on 10/17/14.
//  Copyright (c) 2014 Ahmed Salah. All rights reserved.
//

#import "UIImage+DrawText.h"

@implementation UIImage (DrawText)
-(UIImage *) drawText:(NSString*) text
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);

    
    CGSize sz = ([[UIScreen mainScreen] scale] == 2)?CGSizeMake(self.size.width/2.f, self.size.height/2.f):CGSizeMake(self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0.0f);
    [self drawInRect:CGRectMake(0,0,sz.width,sz.height)];
    CGRect rect = CGRectMake(-20,sz.height-26
                             ,sz.width, 15);
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];;
    NSDictionary *attributes;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    attributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:13],
                    NSParagraphStyleAttributeName: paragraphStyle };
    [[UIColor whiteColor] setFill];

    const CGRect outerRect = CGRectInset(rect, 1, 1);
    CGContextFillEllipseInRect(context, outerRect);
    
    [[UIColor colorWithRed:0 green:122/255. blue:1 alpha:1] setFill];
    const CGRect innerRect = CGRectInset(rect, 3, 3);
    CGContextFillEllipseInRect(context, innerRect);
    
    [[UIColor lightGrayColor] setStroke];
    CGContextSetLineWidth(context, 1);
    CGContextStrokeEllipseInRect(context, outerRect);
    CGContextStrokeEllipseInRect(context, innerRect);
    

//    const CGSize textSize = [text sizeWithAttributes:attributes];
//    CGRect textRect = CGRectInset(rect, 5, 5);
//    textRect.origin.y = rect.origin.y + (rect.size.height - textSize.height) / 2;
//    textRect.size.height = textSize.height;
//    [text drawInRect:textRect withAttributes:attributes];

    [text drawInRect:CGRectIntegral(rect) withAttributes:attributes];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
