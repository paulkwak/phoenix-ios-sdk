//
//  TSModelAbstract+DBMetadata.h
//  fuse
//
//  Created by Steven on 24/5/14.
//  Copyright (c) 2014 Tigerspike. All rights reserved.
//

#import "TSModelAbstract.h"

@interface TSModelAbstract (DBMetadata)

// These methods provide easy access to DB metadata column
// They will be moved to Phoenix SDK

- (id)valueForDBMetadataKey: (NSString *)key;

- (void)setValue:(id)value forDBMetadataKey:(NSString *)key;

@end
