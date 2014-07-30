//
//  LoginViewController.m
//  Example
//
//  Created by Son Nguyen on 29/07/2014.
//  Copyright (c) 2014 Tigerspike Products. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - User Interaction

- (IBAction)hideKeyboardTapGesture:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

- (IBAction)loginButtonHandler:(UIButton *)sender
{
    if (self.loginTextField.text.length > 0 && self.passwordTextField.text.length > 0)
    {
        [self loginWithUsername:self.loginTextField.text
                       password:self.passwordTextField.text];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"Please enter username & password"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
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

#pragma mark - Login

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [[TSPhoenixClient identity] authenticateWithUsername:username
                                                password:password
                                                 success:^(AFOAuthCredential *credential) {
                                                     [self dismissViewControllerAnimated:YES completion:nil];
                                                 }
                                                 failure:^(NSError *error) {
                                                     [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                 message:error.localizedDescription
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil] show];
                                                 }];
}


@end
