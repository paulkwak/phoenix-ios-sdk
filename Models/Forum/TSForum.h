//
//  TSPhoenix
//	TSForum.h
//
//  Created by Steve on May 28th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSModelAbstract.h"

@class TSProject;

#ifndef DefaultCommentStatusTypeIdEnum
#define DefaultCommentStatusTypeIdEnum
typedef NS_ENUM(NSUInteger, DefaultCommentStatusTypeId) {
	kDefaultCommentStatusTypeIdPending = 1,
	kDefaultCommentStatusTypeIdApproved,
	kDefaultCommentStatusTypeIdDeclined,
	kDefaultCommentStatusTypeIdPreApproved,
};

#endif



@interface TSForum: TSModelAbstract <NSCoding>

- (id)initWithDictionary: (NSDictionary *)dict;

- (void)mapFromDictionary: (NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *forumID;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifyDate;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *metaDataParameters;
@property (nonatomic, strong) NSNumber *defaultCommentStatusTypeID;
@property (nonatomic, strong) NSNumber *projectID;



// Expanded properties
// These will be nil, unless specific parameters "expand=propertyname" are set to expand these properties

@property (nonatomic, strong) TSProject *project;



// TODO
+ (NSArray *)expandableProperties;

@end
