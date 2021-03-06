//
//  ContentViewController.h
//  Explorer
//
//  Created by Saumitra Bhanage on 8/11/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ContentViewController : UIViewController <MKMapViewDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) IBOutlet UILabel *screenIdentifierString;
@property (nonatomic, strong) IBOutlet UIImageView *imageToExplore;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) id dataObjectString;
@property (nonatomic, strong) id dataObjectImage;
@property (nonatomic, strong) id dataObjectMapPin;

@property (nonatomic, strong) id dataObjectImageIndex;

@property (nonatomic) NSMutableArray *mainImageCache;

@end
