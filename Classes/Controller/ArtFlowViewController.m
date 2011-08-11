//
//  ArtFlowViewController.m
//  ArtFlow
//
//  Created by Lee Tze Cheun on 8/8/11.
//  Copyright 2011 TC Lee. All rights reserved.
//

#import "ArtFlowViewController.h"
#import "Painting.h"


#pragma mark Constants

// Total number of paintings.
#define PAINTINGS_COUNT 10

// Default cover width and height.
#define COVER_WIDTH  227
#define COVER_HEIGHT 300

// Number of covers in the CoverFlow view. 
// We'll reuse the same paintings again to save space.
#define NUMBER_OF_COVERS 50

// Convert angle in degress to radians for rotation.
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


#pragma mark -
#pragma mark Private Interface

@interface ArtFlowViewController ()

@property (nonatomic, retain) NSMutableArray *paintings;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *artistLabel;
@property (nonatomic, retain) TKCoverflowView *coverFlowView;

- (void) initData;
- (UILabel *) createCaptionLabelWithFrame: (CGRect) frame 
                          placeholderText: (NSString *) text 
                                 fontSize: (CGFloat) fontSize;
@end


#pragma mark -

@implementation ArtFlowViewController

@synthesize paintings = _paintings;
@synthesize titleLabel = _titleLabel;
@synthesize artistLabel = _artistLabel;
@synthesize coverFlowView = _coverFlowView;



#pragma mark -
#pragma mark View Life Cycle

// Create the caption label with given placeholder text.
- (UILabel *) createCaptionLabelWithFrame: (CGRect) frame
                          placeholderText: (NSString *) text 
                                 fontSize: (CGFloat) fontSize {
    
    UILabel *captionLabel = [[[UILabel alloc] initWithFrame: frame] autorelease];
    captionLabel.text = text;
    captionLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    captionLabel.textAlignment = UITextAlignmentCenter;
    captionLabel.font = [UIFont boldSystemFontOfSize: fontSize];
    captionLabel.backgroundColor = [UIColor clearColor];
    captionLabel.textColor = [UIColor whiteColor];
        
    return captionLabel;
}

// Create the view programatically without using NIB.
- (void) loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];            
    
    // Create and add the CoverFlow view.
    _coverFlowView = [[TKCoverflowView alloc] initWithFrame: CGRectMake(0, 0, 480, 300)];
    self.coverFlowView.coverflowDelegate = self;
    self.coverFlowView.dataSource = self;
    self.coverFlowView.coverSize = CGSizeMake(COVER_WIDTH, COVER_WIDTH);
    self.coverFlowView.coverAngle = DEGREES_TO_RADIANS(65.0);
    self.coverFlowView.coverSpacing = 95.0;
    [self.view addSubview: self.coverFlowView];    
    
    // Create and add the title label.    
    CGRect titleLabelFrame = self.view.bounds;
    titleLabelFrame.origin.y = titleLabelFrame.size.height - 65.0;
    titleLabelFrame.size.height = 20.0;
    self.titleLabel = [self createCaptionLabelWithFrame: titleLabelFrame 
                                        placeholderText: @"Mona Lisa, 1880" 
                                               fontSize: 17];        
    [self.view addSubview: self.titleLabel];    
    
    // Create and add the artist label.
    CGRect artistLabelFrame = self.view.bounds;
    artistLabelFrame.origin.y = artistLabelFrame.size.height - 40.0;
    artistLabelFrame.size.height = 20.0;        
    self.artistLabel = [self createCaptionLabelWithFrame: artistLabelFrame 
                                         placeholderText: @"Leonardo da Vinci" 
                                                fontSize: 15];
    [self.view addSubview: self.artistLabel];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the CoverFlow's data source data.    
    [self initData];    
}

// Start at the middle cover of the CoverFlow.
- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [self.coverFlowView bringCoverAtIndexToFront: (NUMBER_OF_COVERS / 2) - 1 animated: NO];
}

// CoverFlow UI should only work in Landscape mode.
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark -
#pragma mark Initialize Data 

// Initialize the CoverFlow's data source data.
- (void) initData {
    // Load the paintings data from plist file.
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Paintings" ofType: @"plist"];
    NSArray *data = [[NSArray alloc] initWithContentsOfFile: path];
        
    _paintings = [[NSMutableArray alloc] initWithCapacity: PAINTINGS_COUNT];
    
    // Create the array of Painting model objects for the data source.
    for (NSUInteger index = 0; index < PAINTINGS_COUNT; index++) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSDictionary *paintingData = [data objectAtIndex: index];                        
        Painting *painting = [[Painting alloc] initWithImageName: [paintingData objectForKey: @"ImageName"]
                                                           title: [paintingData objectForKey: @"Title"]
                                                          artist: [paintingData objectForKey: @"Artist"]];
        [self.paintings addObject: painting];
        
        [painting release], painting = nil;        
        [pool release];
    }
    
    // Release the paintings data loaded from plist file.
    [data release], data = nil;
    
    // Total number of paintings to be displayed on the CoverFlow view.
    // We're going to be reusing some of the paintings to save memory.
    self.coverFlowView.numberOfCovers = NUMBER_OF_COVERS;
}


#pragma mark -
#pragma mark TKCoverflowView DataSource

- (TKCoverflowCoverView *) coverflowView: (TKCoverflowView *) coverflowView coverAtIndex: (int) index {
    TKCoverflowCoverView *coverView = [coverflowView dequeueReusableCoverView];
    
    // If no reusable cover view, we'll have to create a new one.
    if (nil == coverView) {                
        coverView = [[[TKCoverflowCoverView alloc] initWithFrame: 
                      CGRectMake(0, 0, COVER_WIDTH, COVER_HEIGHT)] autorelease];
        coverView.baseline = 0;
    }
    
    // Load the painting onto the cover view.
    Painting *painting = [self.paintings objectAtIndex: (index % self.paintings.count)];
    coverView.image = painting.image;    
    
    return coverView;
}


#pragma mark -
#pragma mark TKCoverflowView Delegate

// Zoom in on the cover when cover is tapped.
- (void) coverflowView: (TKCoverflowView *) coverflowView coverAtIndexWasTapped: (int) index {
    TKCoverflowCoverView *coverView = [coverflowView coverAtIndex:index];            

    [UIView transitionWithView: coverView 
                      duration: 1.0 
                       options: (UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionCurveEaseInOut)  
                    animations: ^{} 
                    completion: NULL];
}

// Update the title and artist label when a new cover slides into center.
- (void) coverflowView: (TKCoverflowView *) coverflowView coverAtIndexWasBroughtToFront: (int) index {
    Painting *painting = [self.paintings objectAtIndex: (index % self.paintings.count)];    
    self.titleLabel.text = painting.title;
    self.artistLabel.text = painting.artist;    
}


#pragma mark -
#pragma mark Memory Management

- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void) viewDidUnload {
    [super viewDidUnload];
    
    self.paintings = nil;
    self.titleLabel = nil;
    self.artistLabel = nil;
    self.coverFlowView = nil;
}

- (void) dealloc {
    [_paintings release], _paintings = nil;
    [_titleLabel release], _titleLabel = nil;
    [_artistLabel release], _artistLabel = nil;    
    [_coverFlowView release], _coverFlowView = nil;
    
    [super dealloc];
}

@end
