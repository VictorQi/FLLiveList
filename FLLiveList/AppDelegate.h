//
//  AppDelegate.h
//  FLLiveList
//
//  Created by v.q on 16/5/28.
//  Copyright © 2016年 victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly, strong) PXAPIHelper *apiHelper;

+ (AppDelegate *)shareAppDelegate;

@end

