//
//  TSPhoenix
//	TSProjectModuleMap.h
//
//  Created by Steve on May 24th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSModelAbstract.h"

@class TSProject;

#ifndef ModuleIdEnum
#define ModuleIdEnum
typedef NS_ENUM(NSUInteger, ModuleId) {
	kModuleIdIdentity = 1,
	kModuleIdMessaging,
	kModuleIdMedia,
	kModuleIdDataCapture,
	kModuleIdSyndicate,
	kModuleIdLocation,
	kModuleIdCommerce,
	kModuleIdAnalytics,
	kModuleIdAppServices,
	kModuleIdCustom,
	kModuleIdSurvey,
	kModuleIdForum,
};

#endif



@interface TSProjectModuleMap: TSModelAbstract <NSCoding>

- (id)initWithDictionary: (NSDictionary *)dict;

- (void)mapFromDictionary: (NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *projectID;
@property (nonatomic, strong) NSNumber *moduleID;
@property (nonatomic, strong) NSArray *metaDataParameters;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifyDate;



// Expanded properties
// These will be nil, unless specific parameters "expand=propertyname" are set to expand these properties

@property (nonatomic, strong) TSProject *project;



// TODO
+ (NSArray *)expandableProperties;

@end
