//
//  ArtFlowAppDelegate.m
//  ArtFlow
//
//  Created by Lee Tze Cheun on 8/8/11.
//  Copyright 2011 TC Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "ArtFlowViewController.h"
#import "UIImage+Alpha.h"
#import "UIImage+Resize.h"


#pragma mark Constants

#define NUMBER_OF_IMAGES               10
#define THUMBNAIL_WIDTH                225
#define THUMBNAIL_COMPRESSION_QUALITY  0.7


#pragma mark -
#pragma mark Private Interface

@interface AppDelegate ()

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) ArtFlowViewController *rootViewController;

- (void) resizeImages;

@end


#pragma mark -

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootViewController = _rootViewController;


#pragma mark -
#pragma mark Application Life Cycle

- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions {    
    // Uncomment to resize the images in the app bundle.
    //[self resizeImages];
    
    _window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    _rootViewController = [[ArtFlowViewController alloc] init];    
    [self.window addSubview: self.rootViewController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark -
#pragma mark Private Methods

// Utility method to resize images in the app bundle.
- (void) resizeImages {    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex: 0];
    
    for (NSUInteger index = 0; index < NUMBER_OF_IMAGES; index++) {
        NSString *imageName = [NSString stringWithFormat: @"%lu.png", index];
        
        // Must add alpha layer to PNG to adhere to Quartz2D supported pixel formats.
        UIImage *image = [[UIImage imageNamed: imageName] imageWithAlpha];
        
        // Crop and resize the image.
        // Note that we're adding 1 pixel of transparent border to prevent the jagged edges
        // from appearing when the image layer is rotated in the CoverFlow UI.
        UIImage *thumbnailImage = [image thumbnailImage: THUMBNAIL_WIDTH 
                                      transparentBorder: 1
                                           cornerRadius: 0 
                                   interpolationQuality: kCGInterpolationHigh];
        
        // Save the resized images to the app's Documents directory.
        NSData *imageData = UIImagePNGRepresentation(thumbnailImage);        
        NSString *imageFilePath = [documentsDirectoryPath stringByAppendingPathComponent: imageName];
        [imageData writeToFile: imageFilePath atomically: YES];
    }    
}


#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
    [_window release], _window = nil;
    [_rootViewController release], _rootViewController = nil;
    
    [super dealloc];
}


@end
