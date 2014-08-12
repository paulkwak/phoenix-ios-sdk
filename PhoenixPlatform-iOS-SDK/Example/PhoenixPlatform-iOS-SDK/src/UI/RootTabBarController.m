//
//  RootTabBarController.m
//  Example
//
//  Created by Son Nguyen on 30/07/2014.
//  Copyright (c) 2014 Tigerspike Products. All rights reserved.
//

#import "RootTabBarController.h"

#import "LoginViewController.h"


@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINavigationController *homeNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    UINavigationController *mediaNavigationController = [[UIStoryboard storyboardWithName:@"MediaStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MediaNavigationController"];
    UINavigationController *analyticViewController = [[UIStoryboard storyboardWithName:@"AnalyticStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"AnalyticNavigationController"];
    UINavigationController *messageNavigationController = [[UIStoryboard storyboardWithName:@"MessageStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageNavigationController"];
    UINavigationController *syndicateNavigationController = [[UIStoryboard storyboardWithName:@"SyndicateStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"SyndicateNavigationController"];
    
    self.viewControllers = @[homeNavigationController, syndicateNavigationController, mediaNavigationController, messageNavigationController, analyticViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoginIfNotAuthenticated)
                                                 name:kPhoenixIdentityDidLogoutNotification
                                               object:nil];
}

- (void)showLoginIfNotAuthenticated
{
    if (![TSPhoenixClient identity].isUserAuthenticated)
    {
        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

@end
