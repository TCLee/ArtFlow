//
//  ArtModel.h
//  ArtFlow
//
//  Created by Lee Tze Cheun on 8/8/11.
//  Copyright 2011 TC Lee. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * Model class that represents a painting.
 */
@interface Painting : NSObject {

@private
    NSString *_title;
    NSString *_artist;
    NSString *_imageName;
    UIImage *_image;    
}

/** Gets or sets the title of the painting. */
@property (nonatomic, retain) NSString *title;

/** Gets or sets the artist of the painting. */
@property (nonatomic, retain) NSString *artist;

/** Gets the painting's image. */
@property (nonatomic, readonly) UIImage *image;


/**
 * Initializes a new Painting model.
 */
- (id) initWithImageName: (NSString *)imageName 
                   title: (NSString *) title 
                  artist: (NSString *) artist;

@end
