/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import "RCTRootView.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Change to YES to use pre-bundled js (do `npm run bundle` first)
  BOOL useBundle = NO;
  
  // This is now automated in run scripts.
  // Provided here as a manual override only.
  // (Run/debug on device requires computer & device to use the same wifi network)
  NSString *wifiIP = nil;
  
  // Port is not yet configurable in the react-native-cli.
  // Provided here as a manual override only.
  NSString *port = @"8081";
  
  // App component registered in index.ios.js
  NSString *moduleName = @"ReactNativeAutoIP";
  
  // ________________________________________________________
  
  BOOL isDebug = DEBUG;
  BOOL isSimulator = TARGET_IPHONE_SIMULATOR;
  NSURL *jsCodeLocation = nil;
  NSString *address = @"localhost";
  if (isDebug && !isSimulator && !useBundle && !wifiIP)
  {
    // The IP is stashed in a file in the app bundle in the run script. It won't be added to Git.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ReactNativeServerConfig" ofType:@"txt"];
    wifiIP = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if ([wifiIP length] > 0) {
      address = [[wifiIP componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] firstObject];
    }
  }
  
  NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
  [standardDefaults setValue:port forKey:@"websocket-executor-port"];
  [standardDefaults setValue:address forKey:@"websocket-executor-address"];
  [standardDefaults synchronize];
  
  if (isDebug && !useBundle) {
    jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/index.ios.bundle?platform=ios&dev=true", address, port]];
  }
  else {
    jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
  }

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:moduleName
                                               initialProperties:nil
                                                   launchOptions:launchOptions];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
