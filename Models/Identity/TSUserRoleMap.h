//
//  TSPhoenix
//	TSUserRoleMap.h
//
//  Created by Steve on May 23rd 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSModelAbstract.h"

@class TSProject;
@class TSRole;
@class TSUser;
@class TSCompany;
@class TSProvider;



@interface TSUserRoleMap: TSModelAbstract <NSCoding>

- (id)initWithDictionary: (NSDictionary *)dict;

- (void)mapFromDictionary: (NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *userRoleMapID;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *roleID;
@property (nonatomic, strong) NSNumber *providerID;
@property (nonatomic, strong) NSNumber *companyID;
@property (nonatomic, strong) NSNumber *projectID;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifyDate;



// Expanded properties
// These will be nil, unless specific parameters "expand=propertyname" are set to expand these properties

@property (nonatomic, strong) TSProject *project;
@property (nonatomic, strong) TSRole *role;
@property (nonatomic, strong) TSUser *user;
@property (nonatomic, strong) TSCompany *company;
@property (nonatomic, strong) TSProvider *provider;



// TODO
+ (NSArray *)expandableProperties;

@end
