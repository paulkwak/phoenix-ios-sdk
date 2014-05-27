///
//  TSPhoenixConstants.h
//  fuse
//
//  Created by Steve on 4/4/13.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//


#ifndef                                       TSPhoenixConstants_h
#define                                       TSPhoenixConstants_h


#pragma mark                                  -


#define kPhoenixStatusBarNotificationDuration 1.5

#define kPhoenixResponsePageSize              100



// Notifications

// User authenticated successfully
#define kPhoenixIdentityDidLoginNotification @"PhoenixUserDidLogin"

// User gets logged out
#define kPhoenixIdentityDidLogoutNotification @"logout"

// Auth token refreshed
#define kPhoenixIdentityDidRefreshTokenNotification @"refreshToken"

// URLs and Paths

// Keys in KeyChain
#define kPhoenixClientAuthenticationCredentialKey @"phoenix-client-credential"
#define kPhoenixUserAuthenticationCredentialKey @"phoenix-user-credential"

///////////////////////////////////
#pragma mark - Identify

// OAuth2
#define kIdentityTokenPath @"identity/v1/oauth/token"


#define kPhoenixIdentityRetrievePasswordResetTokenPath @"identity/v1/projects/%d/users/retrievepassword?username=%@&templateId=%d&target = Email"


#define kGetMyUserPath @"users/me"


#define kPhoenixIdentityResetPasswordPath @"identity/v1/projects/%d/users/resetpassword"

#define kPhoenixIdentityChangePasswordPath @"identity/v1/projects/%d/users/me/changepassword"


// GET, POST
#define kPhoenixIdentityMembershipsPath @"identity/v1/projects/%d/memberships"
#define kPhoenixIdentityMembershipPattern @"identity/v1/projects/:project/memberships"

#define kPhoenixIdentityDeleteMembershipPath @"identity/v1/projects/%d/groups/%d/memberships"









// Media Interaction Log: API not available

// Profile
#define kPhoenixMediaCreateProfilePath @"media/v1/projects/%d/profiles"
#define kPhoenixMediaDeleteProfilePath @"media/v1/projects/%d/profiles/{profileID}"
#define kPhoenixMediaGetProfilePath @"media/v1/projects/%d/profiles/{profileID}"
#define kPhoenixMediaListProfilePath @"media/v1/projects/%d/profiles"
#define kPhoenixMediaUploadProfilePath @"media/v1/ projects/%d/customers/{ID}"


#endif
