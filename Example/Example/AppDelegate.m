//
//  AppDelegate.m
//  Example
//
//  Created by Steve on 14/1/14.
//  Copyright (c) 2014 Tigerspike Products. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSString *configFile = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ServiceConfigFile"];
    NSString *configPath = [[NSBundle mainBundle] pathForResource:configFile ofType:nil];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:configPath];
    
    
    [self setupPhoenixClientWithConfig:config[@"PhoenixPlatform"]];

    
    // Authentication
    
    /*
    [[TSPhoenixClient identity] authenticateWithUsername:@"john@apple.com"
                                                password:@"abc123"
                                                 success:^(AFOAuthCredential *credential) {
                                                   
                                                 } failure:^(NSError *error) {
                                                   
                                                 }];
    
    */
    
    
    // Get the current user's profile
     /*
     [[TSPhoenixClient identity] getMyUserWithCompletion:^(TSUser *user, NSError *error) {
         <#code#>
     }];
     */
     
    
    
    return YES;
}

#error Please fill out ServiceConfig.plist before moving on
- (void)setupPhoenixClientWithConfig:(NSDictionary *)config
{
    NSNumber *projectID = config[@"ProjectID"];
    
    [TSPhoenixClient setUpWithBaseURL:[NSURL URLWithString:config[@"ServiceRoot"]]
                             clientID:config[@"ClientID"]
                         clientSecret:config[@"ClientSecret"]
                            projectID:projectID.integerValue];
}

@end
