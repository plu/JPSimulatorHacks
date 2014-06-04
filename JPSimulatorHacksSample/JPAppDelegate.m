//
//  JPAppDelegate.m
//  JPSimulatorHacksSample
//
//  Created by Johannes Plunien on 04/06/14.
//
//

#import "JPAppDelegate.h"

@implementation JPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
