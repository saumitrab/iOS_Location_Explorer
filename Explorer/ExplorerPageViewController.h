//
//  ExplorerPageViewController.h
//  Explorer
//
//  Created by Saumitra Bhanage on 8/11/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ExplorerPageViewController : UIViewController <UIPageViewControllerDataSource, NSXMLParserDelegate, MKMapViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *screenIdentifierArray;

@property (nonatomic, strong) NSMutableArray *imageCache;

@end
