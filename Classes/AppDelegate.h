//
//  ArtFlowAppDelegate.h
//  ArtFlow
//
//  Created by Lee Tze Cheun on 8/8/11.
//  Copyright 2011 TC Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArtFlowViewController;


@interface AppDelegate : NSObject <UIApplicationDelegate> {

@private
    UIWindow *_window;
    ArtFlowViewController *_rootViewController;
}

@end

