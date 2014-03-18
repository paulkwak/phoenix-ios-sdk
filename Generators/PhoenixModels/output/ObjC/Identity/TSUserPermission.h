//
//  TSPhoenix
//	TSUserPermission.h
//
//  Created by Steve on March 18th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSModelAbstract.h"

@class TSAction;
@class TSProject;
@class TSResource;
@class TSUser;
@class TSCompany;
@class TSProvider;



@interface TSUserPermission: TSModelAbstract <NSCoding>

- (id)initWithDictionary: (NSDictionary *)dict;

- (void)mapFromDictionary: (NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *userPermissionID;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *resourceID;
@property (nonatomic, strong) NSNumber *actionID;
@property (nonatomic, strong) NSNumber *providerID;
@property (nonatomic, strong) NSNumber *companyID;
@property (nonatomic, strong) NSNumber *projectID;
@property (nonatomic, strong) NSNumber *entityID;
@property (nonatomic, strong) NSNumber *isGrant;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifyDate;



// Expanded properties
// These will be nil, unless specific parameters "expand=propertyname" are set to expand these properties

@property (nonatomic, strong) TSAction *action;
@property (nonatomic, strong) TSProject *project;
@property (nonatomic, strong) TSResource *resource;
@property (nonatomic, strong) TSUser *user;
@property (nonatomic, strong) TSCompany *company;
@property (nonatomic, strong) TSProvider *provider;



// TODO
+ (NSArray *)expandableProperties;

@end
