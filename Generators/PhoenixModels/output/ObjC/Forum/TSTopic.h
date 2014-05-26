//
//  TSPhoenix
//	TSTopic.h
//
//  Created by Steve on May 26th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSModelAbstract.h"

@class TSForum;

#ifndef TopicTypeIdEnum
#define TopicTypeIdEnum
typedef NS_ENUM(NSUInteger, TopicTypeId) {
	kTopicTypeIdArticle = 1,
	kTopicTypeIdMedia,
};

#endif



@interface TSTopic: TSModelAbstract <NSCoding>

- (id)initWithDictionary: (NSDictionary *)dict;

- (void)mapFromDictionary: (NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *topicID;
@property (nonatomic, strong) NSNumber *forumID;
@property (nonatomic, strong) NSNumber *topicTypeID;
@property (nonatomic, strong) NSNumber *targetID;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifyDate;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *reference;



// Expanded properties
// These will be nil, unless specific parameters "expand=propertyname" are set to expand these properties

@property (nonatomic, strong) TSForum *forum;



// TODO
+ (NSArray *)expandableProperties;

@end
