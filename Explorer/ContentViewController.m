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
#include "User.h"

#include "LXPImageCache.h"

@interface ContentViewController ()

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
    }
    
    //self.mapView.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        LXPImage *imageObject = [[LXPImage alloc] initWithImageURL:imageURL imageLat:imageLat imageLon:imageLon];
        
        [self.mainImageCache addObject:imageObject];
    }
    
    NSLog(@"self.mainImageCache count = %d ", [self.mainImageCache count]);
}

- (UIImage *)imageAtIndex:(NSUInteger)index {
    
    NSString *imageName;
    __block UIImage *myImage;
    if ( [self.mainImageCache count] > 0 ) {
        //ima geName = [[NSString alloc] initWith initWithFormat:@"%@", [self.imageCache objectAtIndex:index]];
        LXPImage *imageObject = [self.mainImageCache objectAtIndex:index];
        NSString *photourl = [NSString stringWithFormat:@"%@", imageObject.imageURL];
        
        /*
         NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photourl]];
         AFImageRequestOperation *operation;
         
         operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         completionBlock(image);
         myImage = image;
         }
         failure:nil];
         [operation start];
         */
        myImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photourl]]];
    } else {
        imageName = [[NSString alloc] initWithFormat:@"wp3.jpg"];
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
        
        NSString *flickrQueryString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=flowers%%2Cgarden%%2Clake%%2Clandscape%%2Cinstagramapp%%2Cnature%%2Cwater%%2Ctravel%%2Csea%%2Cpark&lat=%@&lon=%@&radius=20&radius_units=mi&extras=geo&format=rest", apiKey, userLat, userLon];
        
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
}

@end
