//
//  ExplorerPageViewController.m
//  Explorer
//
//  Created by Saumitra Bhanage on 8/11/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "ExplorerPageViewController.h"
#import "ContentViewController.h"

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
    
    // Initialize data to display
    
    self.screenIdentifierArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< 10; i++) {
        [self.screenIdentifierArray addObject:[NSString stringWithFormat:@"This is screen %d", i]];
    }
    
    
    // Initialize UIPageViewController and define its style
    NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey:UIPageViewControllerOptionSpineLocationKey];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
    
    [self.pageViewController setDataSource:self];
    
    // Initial view controller will be object at index 0
    ContentViewController *initialViewController = [self viewControllerAtIndex:0];
    
    //Add one view controller in set of view controllers
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self.pageViewController.view setFrame:self.view.bounds];
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
    if ( index > (self.screenIdentifierArray.count - 1)  ) {
        return nil;
    }
    
    // Create ContentViewController with required object.
    ContentViewController *cVC = [[ContentViewController alloc] init];
    [cVC setDataObject:[self.screenIdentifierArray objectAtIndex:index]];
     
     return cVC;
}

- (NSUInteger)indexOfViewController:(ContentViewController *)viewController {
    return [self.screenIdentifierArray indexOfObject:viewController.dataObject];
}

# pragma mark data source methods

// Implement Before and After view controller methods to switch view controllers

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    // Get index of current view controller and return previous view controller
    // cast viewController to ContentViewController to use indexOfViewController
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if ( index == 0 || index == NSNotFound ) {
        return nil;
    }
    
    index--;
    ContentViewController *cVC = [self viewControllerAtIndex:index];
    return cVC;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    // Get index of current view controller and reuturn next view controller
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if ( index == NSNotFound ) {
        return nil;
    }
    
    index++;
    ContentViewController *cVC = [self viewControllerAtIndex:index];
    return cVC;
}


@end





