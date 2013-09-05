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
    
    ///////
    // Create your coordinate
    CLLocationCoordinate2D myCoordinate = {37, -122};
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
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=926c358424da93e42e672382bd4e6463&min_upload_date=1357364469&lat=37&lon=-122&format=rest&auth_token=72157635381922773-087b24f8579db868&api_sig=26c375a700fd250063ee1e6d0699cc09"]];
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
        NSString *photourl = [NSString stringWithFormat:@"%@", [self.imageCache objectAtIndex:index]];
        
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
        [self.imageCache addObject:[NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg",
                                    [attributeDict valueForKey:@"farm"],
                                    [attributeDict valueForKey:@"server"],
                                    [attributeDict valueForKey:@"id"],
                                    [attributeDict valueForKey:@"secret"]]];
    }
    
}

@end





