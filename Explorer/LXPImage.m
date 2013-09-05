//
//  LXPImage.m
//  Explorer
//
//  Created by Saumitra Bhanage on 8/12/13.
//  Copyright (c) 2013 yahoo. All rights reserved.
//

#import "LXPImage.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"


@interface LXPImage ()

@end

@implementation LXPImage

// TODO: Prototype code, implement an image cache.
+ (UIImage *)imageAtIndex:(NSUInteger)index {
    
    static NSMutableArray *imageCache = nil;
    if ( imageCache == nil ) {
        imageCache = [[NSMutableArray alloc] init];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=4e713186a74a783890fca6f5235b1ef8&safe_search=1&lat=37&lon=-122&format=rest&auth_token=72157635366088537-a7061804b027f73e&api_sig=288ec1a2cc29be8aecf2853706ce6db5"]];
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            XMLParser.delegate = self;
            [XMLParser parse];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Retrieving data"
                                                         message:[NSString stringWithFormat:@"%@",error]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];
        }];
        
        [operation start];
        
    }
    NSString *imageName = [[NSString alloc] initWithFormat:@"wp%d.jpg",index];
    UIImage *myImage = [UIImage imageNamed:imageName];
    return myImage;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"photo"])
    {
        NSLog(@"id: %@,  owner: %@", [attributeDict valueForKey:@"id"], [attributeDict valueForKey:@"owner"]);
    }
    
}

@end
