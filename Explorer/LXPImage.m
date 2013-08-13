//
//  LXPImage.m
//  Explorer
//
//  Created by Saumitra Bhanage on 8/12/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "LXPImage.h"

@implementation LXPImage

- (void)initImageCache {
    self.imageCache = [[NSMutableArray alloc]init];
}

- (void)addImagesToCache {
    for ( int i = 0; i < 5; i++ ) {
        UIImageView *myImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone5wp.jpg"]];
        [self.imageCache addObject:myImage];
    }
}

@end
