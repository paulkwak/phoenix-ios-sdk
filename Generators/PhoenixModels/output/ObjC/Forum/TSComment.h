//
//  TSPhoenix
//	TSComment.h
//
//  Created by Steve on May 26th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSModelAbstract.h"

@class TSParentComment;
@class TSProject;
@class TSTopic;

#ifndef StatusTypeIdEnum
#define StatusTypeIdEnum
typedef NS_ENUM(NSUInteger, StatusTypeId) {
	kStatusTypeIdPending = 1,
	kStatusTypeIdApproved,
	kStatusTypeIdDeclined,
};

#endif



@interface TSComment: TSModelAbstract <NSCoding>

- (id)initWithDictionary: (NSDictionary *)dict;

- (void)mapFromDictionary: (NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *commentID;
@property (nonatomic, strong) NSNumber *projectID;
@property (nonatomic, strong) NSNumber *topicID;
@property (nonatomic, strong) NSNumber *parentCommentID;
@property (nonatomic, strong) NSNumber *statusTypeID;
@property (nonatomic, strong) NSNumber *phoenixIDentity_UserId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifyDate;
@property (nonatomic, strong) NSNumber *voteCount_Overall;
@property (nonatomic, copy) NSString *author;



// Expanded properties
// These will be nil, unless specific parameters "expand=propertyname" are set to expand these properties

@property (nonatomic, strong) TSParentComment *parentComment;
@property (nonatomic, strong) TSProject *project;
@property (nonatomic, strong) TSTopic *topic;



// TODO
+ (NSArray *)expandableProperties;

@end
