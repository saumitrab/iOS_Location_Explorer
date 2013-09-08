//
//  LXPImage.h
//  Explorer
//
//  Created by Saumitra Bhanage on 8/12/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXPImage : NSObject

//+ (UIImage *)imageAtIndex:(NSUInteger)index;

@property (nonatomic) NSUInteger imageIndex;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic) float imageLat;
@property (nonatomic) float imageLon;
@property (nonatomic, strong) NSString *imageTitle;

- (id)initWithImageURL:(NSString *)imageURL imageLat:(float)imageLat imageLon:(float)imageLon imageTitle:(NSString *)imageTitle;

@end
