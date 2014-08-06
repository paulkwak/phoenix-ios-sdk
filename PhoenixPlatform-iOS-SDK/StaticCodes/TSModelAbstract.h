//
//  TSModelAbstract.h
//  TSPhoenix
//
//  Created by Steve on 28/10/13.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSModelAbstract : NSObject <NSCoding, NSCopying>

- (id)initWithDictionary: (NSDictionary *)dict;

- (NSString *)dbKey;

+ (NSString *)dbKeyWithID: (id)identifier;

- (NSString *)dbCollection;

+ (NSString *)dbCollection;

+ (NSDictionary *)mappingDictionary;

#pragma mark - Metadata field in YapDatabase

// These methods provide easy access to DB metadata column

- (id)valueForDBMetadataKey: (NSString *)key;

- (void)setValue:(id)value forDBMetadataKey:(NSString *)key;

@end
