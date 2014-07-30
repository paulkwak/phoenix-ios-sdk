//
//  HomeViewController.m
//  Example
//
//  Created by Son Nguyen on 29/07/2014.
//  Copyright (c) 2014 Tigerspike Products. All rights reserved.
//

#import "HomeViewController.h"

#import "LoginViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![TSPhoenixClient identity].isUserAuthenticated)
    {
        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
