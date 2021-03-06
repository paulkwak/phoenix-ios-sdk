//
//  TSPhoenix
//	TSEdition.h
//
//  Created by Steve on May 28th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSModelAbstract.h"

@class TSProject;

#ifndef StatusTypeIdEnum
#define StatusTypeIdEnum
typedef NS_ENUM(NSUInteger, StatusTypeId) {
	kStatusTypeIdNew = 1,
	kStatusTypeIdImportInProgress,
	kStatusTypeIdImportFailed,
	kStatusTypeIdImportSucceeded,
	kStatusTypeIdPackagingInProgress,
	kStatusTypeIdPackagingFailed,
	kStatusTypeIdPackagingSucceeded,
	kStatusTypeIdBroadcastInProgress,
	kStatusTypeIdBroadcastFailed,
	kStatusTypeIdBroadcastSucceeded,
};

#endif



@interface TSEdition: TSModelAbstract <NSCoding>

- (id)initWithDictionary: (NSDictionary *)dict;

- (void)mapFromDictionary: (NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *editionID;
@property (nonatomic, strong) NSNumber *projectID;
@property (nonatomic, strong) NSNumber *statusTypeID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *editionDescription;
@property (nonatomic, copy) NSString *coverImageUrl;
@property (nonatomic, strong) NSNumber *majorVersion;
@property (nonatomic, strong) NSNumber *minorVersion;
@property (nonatomic, strong) NSNumber *pointVersion;
@property (nonatomic, strong) NSDate *liveDate;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifyDate;
@property (nonatomic, strong) NSArray *metaDataParameters;



// Expanded properties
// These will be nil, unless specific parameters "expand=propertyname" are set to expand these properties

@property (nonatomic, strong) TSProject *project;



// TODO
+ (NSArray *)expandableProperties;

@end
