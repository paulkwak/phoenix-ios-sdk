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
