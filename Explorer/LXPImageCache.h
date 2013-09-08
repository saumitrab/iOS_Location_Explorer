//
//  LXPImageCache.h
//  Explorer
//
//  Created by Saumitra Bhanage on 9/7/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXPImageCache : NSObject

+(NSMutableArray *)getImageCache;
+(void)setImageCache:(NSMutableArray *)imageCache;

@end
