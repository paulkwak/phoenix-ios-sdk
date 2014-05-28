//
//  TSPhoenix
//	TSEventLogRetrieve.h
//
//  Created by Steve on May 28th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSModelAbstract.h"

@class TSEventType;
@class TSProject;



@interface TSEventLogRetrieve: TSModelAbstract <NSCoding>

- (id)initWithDictionary: (NSDictionary *)dict;

- (void)mapFromDictionary: (NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *eventTypeID;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) NSNumber *eventLogRetrieveID;
@property (nonatomic, strong) NSNumber *projectID;
@property (nonatomic, strong) NSNumber *companyID;
@property (nonatomic, strong) NSNumber *providerID;
@property (nonatomic, strong) NSNumber *phoenixIDentity_UserId;
@property (nonatomic, copy) NSString *correlationID;
@property (nonatomic, strong) NSNumber *eventParentID;
@property (nonatomic, strong) NSNumber *targetID;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSArray *metaDataParameters;
@property (nonatomic, copy) NSString *ipAddress;
@property (nonatomic, strong) NSNumber *progress;
@property (nonatomic, copy) NSString *statusDescription;
@property (nonatomic, strong) NSNumber *success;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifyDate;



// Expanded properties
// These will be nil, unless specific parameters "expand=propertyname" are set to expand these properties

@property (nonatomic, strong) TSEventType *eventType;
@property (nonatomic, strong) TSProject *project;



// TODO
+ (NSArray *)expandableProperties;

@end
