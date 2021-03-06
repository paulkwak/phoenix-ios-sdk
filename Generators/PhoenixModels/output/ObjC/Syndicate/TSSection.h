//
//  TSPhoenix
//	TSSection.h
//
//  Created by Steve on May 28th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSModelAbstract.h"





@interface TSSection: TSModelAbstract <NSCoding>

- (id)initWithDictionary: (NSDictionary *)dict;

- (void)mapFromDictionary: (NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *sectionID;
@property (nonatomic, strong) NSNumber *projectID;
@property (nonatomic, strong) NSNumber *parentSectionID;
@property (nonatomic, strong) NSNumber *phoenixIDentity_GroupId_Owner;
@property (nonatomic, strong) NSNumber *phoenixIDentity_GroupId_Subscriber;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sectionDescription;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSNumber *rank;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, strong) NSNumber *majorVersion;
@property (nonatomic, strong) NSNumber *minorVersion;
@property (nonatomic, strong) NSNumber *pointVersion;
@property (nonatomic, strong) NSArray *metaDataParameters;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifyDate;



// Expanded properties
// These will be nil, unless specific parameters "expand=propertyname" are set to expand these properties




// TODO
+ (NSArray *)expandableProperties;

@end
