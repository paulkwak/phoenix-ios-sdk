//
//  HomeViewController.m
//  Example
//
//  Created by Son Nguyen on 29/07/2014.
//  Copyright (c) 2014 Tigerspike Products. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (IBAction)logoutButtonHandler:(UIButton *)sender
{
    [[TSPhoenixClient identity] logout];
}

- (IBAction)moreInfoButtonHandler:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://developers.phoenixplatform.com.sg/"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getUserData];
}

- (void)getUserData
{
    [[TSPhoenixClient identity] getMyUserWithCompletion:^(TSUser *user, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return;
        }
        
        self.welcomeLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        self.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.imageUrl]]];
    }];
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
