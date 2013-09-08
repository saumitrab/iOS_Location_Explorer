//
//  User.h
//  Explorer
//
//  Created by Saumitra Bhanage on 9/7/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (float)userLat;
+ (float)userLon;

+ (void)setUserLat:(float)lat;
+ (void)setUserLon:(float)lon;


@end
