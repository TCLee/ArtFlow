//
//  ArtFlowViewController.h
//  ArtFlow
//
//  Created by Lee Tze Cheun on 8/8/11.
//  Copyright 2011 TC Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <TapkuLibrary/TapkuLibrary.h>

/**
 * Controller for the CoverFlow view.
 */
@interface ArtFlowViewController : UIViewController 
    <TKCoverflowViewDataSource, TKCoverflowViewDelegate> {

@private
    // Array of model objects that represent the paintings.
    NSMutableArray *_paintings;
        
    // Tapku CoverFlow view.
    TKCoverflowView *_coverFlowView;
        
    // Label for the painting's title.
    UILabel *_titleLabel;
        
    // Label for the paiting's artist.
    UILabel *_artistLabel;        
}

@end
