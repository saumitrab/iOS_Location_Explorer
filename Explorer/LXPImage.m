//
//  LXPImage.m
//  Explorer
//
//  Created by Saumitra Bhanage on 8/12/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "LXPImage.h"

@interface LXPImage ()

@end

@implementation LXPImage

// TODO: Prototype code, implement an image cache.
+ (UIImage *)imageAtIndex:(NSUInteger)index {
    
    /*
    static NSMutableArray *imageCache = nil;
    if ( imageCache == nil ) {
        imageCache = [[NSMutableArray alloc] init];
    }
    */
    
    NSString *imageName = [[NSString alloc] initWithFormat:@"wp%d.jpg",index];
    UIImage *myImage = [UIImage imageNamed:imageName];
    return myImage;
}


@end
