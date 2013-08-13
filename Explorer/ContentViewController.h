//
//  ContentViewController.h
//  Explorer
//
//  Created by Saumitra Bhanage on 8/11/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *screenIdentifierString;
@property (nonatomic, strong) IBOutlet UIImageView *imageToExplore;

@property (nonatomic, strong) id dataObjectString;
@property (nonatomic, strong) id dataObjectImage;


@end
