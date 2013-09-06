//
//  ExplorerPageViewController.m
//  Explorer
//
//  Created by Saumitra Bhanage on 8/11/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "ExplorerPageViewController.h"
#import "ContentViewController.h"
#import "LXPImage.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "AFImageRequestOperation.h"


@interface ExplorerPageViewController ()

@end

@implementation ExplorerPageViewController

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
    
    self.screenIdentifierArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 100; i++) {
        [self.screenIdentifierArray addObject:[NSString stringWithFormat:@"This is screen %d", i]];
    }
    
    // Initialize UIPageViewController and define its style
    NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
    
    self.pageViewController.dataSource = self;
    
    // Initial view controller will be object at index 0
    ContentViewController *initialViewController = [self viewControllerAtIndex:0];
    
    //Add one view controller in set of view controllers
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageViewController.view.frame = [self.view bounds];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Helper methods

- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    // Check if requested index is in range of our data
    if ( index > ([self.screenIdentifierArray count] - 1)  ) {
        return nil;
    }
    
    // Create ContentViewController with required data.
    ContentViewController *cVC = [[ContentViewController alloc] init];
    [cVC setDataObjectString:[self.screenIdentifierArray objectAtIndex:index]];
    [cVC setDataObjectImage:[self imageAtIndex:index]];
    
    if ( [self.imageCache count] > 0 ) {
        LXPImage *imageObject = [self.imageCache objectAtIndex:index];
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
        [cVC setDataObjectMapPin:point];
    }
    return cVC;
}

- (NSUInteger)indexOfViewController:(ContentViewController *)viewController {
    return [self.screenIdentifierArray indexOfObject:viewController.dataObjectString];
    //return [self.imageCache indexOfObject:viewController.dataObjectImage];
}

# pragma mark data source methods

// Implement Before and After view controller methods to switch view controllers
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    // Get index of current view controller and return previous view controller
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if ( index == 0 || index == NSNotFound ) {
        return nil;
    }
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    // Get index of current view controller and reuturn next view controller
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if ( index == NSNotFound ) {
        return nil;
    }
    index++;
    
    return [self viewControllerAtIndex:index];
}

# pragma mark photo apis

- (UIImage *)imageAtIndex:(NSUInteger)index {
    
    if ( self.imageCache == nil ) {
        self.imageCache = [[NSMutableArray alloc] init];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=799b2f943c3d1e7a42ca6911ef046e0c&tags=night%2C+%09+city%2C+%09+architecture%2C+%09+street%2C+%09+building%2C++urban%2C+%09+church%2C+%09+longexposure%2C+%09+moon%2C+%09+cathedral&sort=interestingness-desc&safe_search=safe&has_geo=1&geo_context=2&lat=37.788268&lon=-122.407332&radius=20&radius_units=mi&extras=geo&format=rest&auth_token=72157635406074918-03fbcb6accff5a1d&api_sig=d1c85c801b964658fb4ca0f33bd90247"]];
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
    
    NSString *imageName;
    __block UIImage *myImage;
    if ( [self.imageCache count] > 0 ) {
        //ima geName = [[NSString alloc] initWith initWithFormat:@"%@", [self.imageCache objectAtIndex:index]];
        LXPImage *imageObject = [self.imageCache objectAtIndex:index];
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
        
        [self.imageCache addObject:imageObject];
    }
    
}

@end





