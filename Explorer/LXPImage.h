//
//  LXPImage.h
//  Explorer
//
//  Created by Saumitra Bhanage on 8/12/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXPImage : NSObject

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *imageCache;

- (void)addImagesToCache;
- (UIImageView *)imageAtIndex:(NSUInteger)index;

@end
