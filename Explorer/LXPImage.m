//
//  LXPImage.m
//  Explorer
//
//  Created by Saumitra Bhanage on 8/12/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "LXPImage.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"


@interface LXPImage ()

@end

@implementation LXPImage


- (id)initWithImageURL:(NSString *)imageURL imageLat:(float)imageLat imageLon:(float)imageLon {
    
    self = [super init];
    
    if ( self != nil) {
        self.imageURL = imageURL;
        self.imageLat = imageLat;
        self.imageLon = imageLon;
     }
    
    return self;
}



@end
