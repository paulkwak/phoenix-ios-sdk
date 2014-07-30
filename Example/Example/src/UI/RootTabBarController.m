//
//  RootTabBarController.m
//  Example
//
//  Created by Son Nguyen on 30/07/2014.
//  Copyright (c) 2014 Tigerspike Products. All rights reserved.
//

#import "RootTabBarController.h"

#import "HomeViewController.h"

#import "LoginViewController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    HomeViewController *homeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
    UINavigationController *mediaNavigationController = [[UIStoryboard storyboardWithName:@"MediaStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MediaNavigationController"];
    UINavigationController *analyticViewController = [[UIStoryboard storyboardWithName:@"AnalyticStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"AnalyticNavigationController"];
    UINavigationController *messageNavigationController = [[UIStoryboard storyboardWithName:@"MessageStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageNavigationController"];
    UINavigationController *syndicateNavigationController = [[UIStoryboard storyboardWithName:@"SyndicateStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"SyndicateNavigationController"];
    
    self.viewControllers = @[homeViewController, syndicateNavigationController, mediaNavigationController, messageNavigationController, analyticViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![TSPhoenixClient identity].isUserAuthenticated)
    {
        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

@end
