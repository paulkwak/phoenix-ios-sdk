//
//  TSPhoenixSort.m
//  PhoenixPlatform-iOS-SDK
//
//  Created by Karen Kung on 11/08/2014.
//  Copyright (c) 2014 karen. All rights reserved.
//

#import "TSPhoenixSort.h"

#import "TSPhoenixFilter.m"

@implementation TSPhoenixSort

- (id) initWithSortField:(NSString *)sortField sortingOrder:(NSNumber *)sortingOrder
{
    self = [super init];
    if (self) {
        self.sortField = sortField;
        self.sortingOrder = sortingOrder;
    }
    
    return self;
}

- (NSArray *) sortingParameterArray
{
    NSMutableArray *resultArray = @[ [NSString stringWithFormat:@"sortby=%@", self.sortField] ];

    if (self.sortingOrder.integerValue == kSortingOrderDesc)
        [resultArray addObject:[TSPhoenixParameter sortDirectionDescendingParameter]];
    else 
        [resultArray addObject:[TSPhoenixParameter sortDirectionAscendingParameter]];
    
    return resultArray;
}

@end
