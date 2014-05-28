//
//  TSPhoenix
//	TSPlatformInstance.h
//
//  Created by Steve on May 28th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSModelAbstract.h"





@interface TSPlatformInstance: TSModelAbstract <NSCoding>

- (id)initWithDictionary: (NSDictionary *)dict;

- (void)mapFromDictionary: (NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *platformInstanceID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *consoleUrl;
@property (nonatomic, copy) NSString *apiUrl;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifyDate;



// Expanded properties
// These will be nil, unless specific parameters "expand=propertyname" are set to expand these properties




// TODO
+ (NSArray *)expandableProperties;

@end
