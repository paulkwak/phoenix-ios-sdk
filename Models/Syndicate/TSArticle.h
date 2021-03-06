//
//  TSPhoenix
//	TSArticle.h
//
//  Created by Steve on May 28th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSModelAbstract.h"

@class TSProject;



@interface TSArticle: TSModelAbstract <NSCoding>

- (id)initWithDictionary: (NSDictionary *)dict;

- (void)mapFromDictionary: (NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *articleID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *articleDescription;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *contentData;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, strong) NSDate *publishDate;
@property (nonatomic, strong) NSArray *metaDataParameters;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSNumber *viewCount_Overall;
@property (nonatomic, strong) NSNumber *voteCount_Overall;
@property (nonatomic, strong) NSNumber *rating_Overall;
@property (nonatomic, strong) NSNumber *commentCount_Overall;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifyDate;
@property (nonatomic, strong) NSNumber *projectID;
@property (nonatomic, strong) NSArray *assets;



// Expanded properties
// These will be nil, unless specific parameters "expand=propertyname" are set to expand these properties

@property (nonatomic, strong) TSProject *project;



// TODO
+ (NSArray *)expandableProperties;

@end
