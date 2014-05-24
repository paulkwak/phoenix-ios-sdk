//
//  TSModelAbstract+DBMetadata.m
//  fuse
//
//  Created by Steven on 24/5/14.
//  Copyright (c) 2014 Tigerspike. All rights reserved.
//

#import "TSModelAbstract+DBMetadata.h"

@implementation TSModelAbstract (DBMetadata)

- (id)valueForDBMetadataKey: (NSString *)key {
    __block id value;
    [[TSPhoenixClient readOnlyDatabaseConnection] readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        NSDictionary *dict = [transaction metadataForKey:[self dbKey]
                                            inCollection:[self dbCollection]];
        
        value = dict[kArticleIsCompliance];
    }];
    
    return value;
}

- (void)setValue:(id)value forDBMetadataKey:(NSString *)key {
    NSParameterAssert(key);
    [[TSPhoenixClient writeDatabaseConnection] readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        NSDictionary *dict = [transaction metadataForKey:[self dbKey]
                                            inCollection:[self dbCollection]];
        NSMutableDictionary *mutableDict = [dict mutableCopy];
        if (!mutableDict)
            mutableDict = [NSMutableDictionary new];
        
        if (!value)
            [mutableDict removeObjectForKey:key];
        else
            mutableDict[key] = value;
        
        dict = [mutableDict copy];
        [transaction replaceMetadata:dict
                              forKey:self.dbKey
                        inCollection:self.dbCollection];
    }];

}

@end
