//
//  ArtModel.m
//  ArtFlow
//
//  Created by Lee Tze Cheun on 8/8/11.
//  Copyright 2011 TC Lee. All rights reserved.
//

#import "Painting.h"

#pragma mark Private Interface

@interface Painting ()

@property (nonatomic, copy) NSString *imageName;

@end


#pragma mark -

@implementation Painting

@synthesize imageName = _imageName;
@synthesize title = _title;
@synthesize artist = _artist;


#pragma mark -
#pragma mark Initialize

- (id) initWithImageName: (NSString *) imageName 
                   title: (NSString *) title 
                  artist: (NSString *) artist {
    
    if (self = [super init]) {
        self.imageName = imageName;
        self.title = title;
        self.artist = artist;
    }
    return self;
}


#pragma mark -
#pragma mark Properties Accessors

- (UIImage *) image {    
    if (nil == _image) {        
        // Not using [UIImage imageNamed:] because we don't want the image to be cached
        // in memory.      
        NSString *imageFileName = [self.imageName stringByDeletingPathExtension];
        NSString *imageExtension = [self.imageName pathExtension];
        NSString *imageFilePath = [[NSBundle mainBundle] pathForResource: imageFileName 
                                                                  ofType: imageExtension];
        _image = [[UIImage alloc] initWithContentsOfFile: imageFilePath];        
    }
    return _image;
}


#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
    [_image release], _image = nil;
    [_imageName release], _imageName = nil;
    [_title release], _title = nil;
    [_artist release], _artist = nil;
    [super dealloc];
}

@end
