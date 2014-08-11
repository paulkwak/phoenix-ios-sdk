//
//  TSPhoenixSort.h
//  PhoenixPlatform-iOS-SDK
//
//  Created by Karen Kung on 11/08/2014.
//  Copyright (c) 2014 karen. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SortingTypeIdEnum
#define SortingTypeIdEnum
typedef NS_ENUM(NSUInteger, SortingOrder) {
	kSortingOrderDesc = 1,
    kSortingOrderAsce,
};

#endif

@interface TSPhoenixSort : NSObject

@property (nonatomic, retain) NSString *sortField;
@property (nonatomic, retain) NSNumber *sortingOrder;

- (id) initWithSortField:(NSString *)sortField sortingOrder:(NSNumber *)sortingOrder;

- (NSArray *) sortingParameterArray;

@end
