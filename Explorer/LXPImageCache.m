//
//  LXPImageCache.m
//  Explorer
//
//  Created by Saumitra Bhanage on 9/7/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "LXPImageCache.h"

@implementation LXPImageCache

static NSMutableArray *_imageCache;

+(NSMutableArray *)getImageCache {
    return _imageCache;
}

+(void)setImageCache:(NSMutableArray *)imageCache {
    if ( _imageCache == nil ) {
        _imageCache = imageCache;
    }
}

@end
