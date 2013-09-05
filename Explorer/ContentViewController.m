//
//  ContentViewController.m
//  Explorer
//
//  Created by Saumitra Bhanage on 8/11/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenIdentifierString.text = self.dataObjectString;
    self.imageToExplore.image =  self.dataObjectImage;
    [self.mapView addAnnotation:self.dataObjectMapPin];
    [self.mapView showsUserLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
