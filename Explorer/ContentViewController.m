//
//  ContentViewController.m
//  Explorer
//
//  Created by Saumitra Bhanage on 8/11/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "ContentViewController.h"
#import "LXPImage.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"
//#include "User.h"

#include "LXPImageCache.h"

@interface ContentViewController ()

@property UIActivityIndicatorView *activityView;

@end

//static NSMutableArray *_imageCache;

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
    
    if ( self.mainImageCache == nil ) {
        self.mainImageCache = [LXPImageCache getImageCache];
        if ( self.mainImageCache == nil ) {
            self.activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            self.activityView.center=self.view.center;
            
            [self.activityView startAnimating];
            
            [self.view addSubview:self.activityView];
        }
    }

    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    self.screenIdentifierString.text = self.dataObjectString;
    
    // Get image from image at index function.
    self.imageToExplore.image = [self imageAtIndex:[self.dataObjectImageIndex integerValue]];
    
    // Get image lat lon from LXPImage object
    if ( [self.mainImageCache count] > 0 ) {
        LXPImage *imageObject = [self.mainImageCache objectAtIndex:[self.dataObjectImageIndex integerValue]];
        ///////
        // Create your coordinate
        CLLocationCoordinate2D myCoordinate;
        myCoordinate.latitude = imageObject.imageLat;
        myCoordinate.longitude = imageObject.imageLon;
        
        //Create your annotation
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        // Set your annotation to point at your coordinate
        point.coordinate = myCoordinate;
        //If you want to clear other pins/annotations this is how to do it
        //for (id annotation in self.mapView.annotations) {
        //    [self.mapView removeAnnotation:annotation];
        //}
        //Drop pin on map
        [self.mapView addAnnotation:point];
        
        MKMapRect zoomRect = MKMapRectNull;
        
        // Get user location in center
        MKMapPoint annotationPoint = MKMapPointForCoordinate(self.mapView.userLocation.coordinate);
        zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.5, 0.5);
        
        // Get photo location in center
        MKMapPoint photoPoint = MKMapPointForCoordinate(myCoordinate);
        MKMapRect pointRect = MKMapRectMake(photoPoint.x, photoPoint.y, 0.5, 0.5);
        
        // Union two rectagles
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
        
        [self.mapView setVisibleMapRect:zoomRect animated:YES];
    }

    UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(didTapMap)];
    [self.mapView addGestureRecognizer:tapRec];
    
    UITapGestureRecognizer* tapRecImage = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(didTapImage)];
    [self.imageToExplore addGestureRecognizer:tapRecImage];
    
    //self.mapView.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapImage {
    
    if ( self.mapView.hidden ) {
        self.mapView.hidden = NO;
    } else {
        self.mapView.hidden = YES;
    }
    
}

- (void)didTapMap {
    NSLog(@"TapMap");
    //[self.mapView]
    
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        
        // Get current image stats
        LXPImage *imageObject = [self.mainImageCache objectAtIndex:[self.dataObjectImageIndex integerValue]];
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(imageObject.imageLat, imageObject.imageLon);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:imageObject.imageTitle];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    [LXPImageCache setImageCache:self.mainImageCache];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"photo"])
    {
        // http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        NSString *imageURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg",
                              [attributeDict valueForKey:@"farm"],
                              [attributeDict valueForKey:@"server"],
                              [attributeDict valueForKey:@"id"],
                              [attributeDict valueForKey:@"secret"]];
        
        float imageLat = [[attributeDict valueForKey:@"latitude"] doubleValue];
        float imageLon = [[attributeDict valueForKey:@"longitude"] doubleValue];
        NSString *imageTitle = [attributeDict valueForKey:@"title"];
        
        LXPImage *imageObject = [[LXPImage alloc] initWithImageURL:imageURL imageLat:imageLat imageLon:imageLon imageTitle:imageTitle];
        
        [self.mainImageCache addObject:imageObject];
    }
    
    [self.activityView stopAnimating];
    NSLog(@"self.mainImageCache count = %d ", [self.mainImageCache count]);
}

- (UIImage *)imageAtIndex:(NSUInteger)index {
    
    NSString *imageName;
    __block UIImage *myImage;
    if ( [self.mainImageCache count] > 0 ) {
        LXPImage *imageObject = [self.mainImageCache objectAtIndex:index];
        NSString *photourl = [NSString stringWithFormat:@"%@", imageObject.imageURL];
        myImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photourl]]];
    } else {
        imageName = [[NSString alloc] initWithFormat:@"exp2.jpg"];
        myImage = [UIImage imageNamed:imageName];
    }
    
    return myImage;
}

-(void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    NSLog(@"here");
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    //self.mapView.showsUserLocation = YES;
    
    if ( self.mainImageCache == nil ) {
        self.mainImageCache = [[NSMutableArray alloc] init];
        
        NSString *apiKey = @"949ce7138975554b541558dd43e41a89";
        NSString *userLat = [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.latitude];
        NSString *userLon = [NSString stringWithFormat:@"%f", self.mapView.userLocation.location.coordinate.longitude];
        
        NSString *flickrQueryString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=flowers%%2Cgarden%%2Clake%%2Clandscape%%2Cinstagramapp%%2Cnature%%2C-fire%%2C-parade%%2Ctravel%%2Csea%%2Cpark&safe_search=2&geo_context=2&lat=%@&lon=%@&radius=20&radius_units=mi&extras=geo&format=rest", apiKey, userLat, userLon];
        
        NSLog(@"flickrQueryStirng = %@", flickrQueryString);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:flickrQueryString]];
        
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            XMLParser.delegate = self;
            [XMLParser parse];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Retrieving data" message:[NSString stringWithFormat:@"%@",error]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];
        }];
        
        [operation start];
    }
    
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
}

@end
