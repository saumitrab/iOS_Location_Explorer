//
//  User.m
//  Explorer
//
//  Created by Saumitra Bhanage on 9/7/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "User.h"

@implementation User

static float _userLat;
static float _userLon;

+ (void)setUserLat:(float)lat{
    _userLat = lat;
}

+ (void)setUserLon:(float)lon{
    _userLon = lon;
}

+ (float)userLat {
    return _userLat;
}

+ (float)userLon {
    return _userLon;
}

@end
