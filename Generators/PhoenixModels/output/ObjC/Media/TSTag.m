//
//  TSPhoenix
//	TSTag.m
//
//  Created by Steve on January 20th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSTag.h"
#import "TSPhoenixClient.h"

@implementation TSTag

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
	
    [self mapFromDictionary:dict];
	
    return self;
}

- (void)mapFromDictionary: (NSDictionary *)dict {
    [[self.class mappingDictionary] enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *info, BOOL *stop) {
        
        id value = dict[key];
        if (!value) return ;
        
        if ([value isKindOfClass:[NSNull class]]) {
            [self setValue:nil forKey:info[@"mappedName"]];
            return;
        }
        
        NSString *dotNetType = info[@"type"];
        
        // Dot Net date /Date(xxxxxxxxxx)/
        if ([dotNetType isEqualToString:@"System.DateTime"]) {
            NSDate *date = [[TSPhoenixClient sharedInstance].defaultDateFormatter dateFromString:value];
            [self setValue:date forKey:info[@"mappedName"]];
            return;
        }
        
        // bool
        if ([dotNetType isEqualToString:@"System.Boolean"]) {
            BOOL boolValue = [value boolValue];
            [self setValue:@(boolValue) forKey:info[@"mappedName"]];
            return;
        }
		
		// expanded properties
		if ([dotNetType isEqualToString:@"relationship"]) {
            if ([value isKindOfClass:[NSArray class]]) {
#warning TODO: expanded array properties in script, mapping
                
            } else {
                if (![value isKindOfClass:[NSDictionary class]])
                    return;
                
                NSString *className = info[@"mappedType"];
                if (!className)
                    return;
                Class MappedClass = NSClassFromString(className);
                if (!MappedClass)
                    return;
                
                id mappedObject = [[MappedClass alloc] initWithDictionary:value];
                
                [self setValue:mappedObject forKey:info[@"mappedName"]];
            }
			
			return;
        }

		
        [self setValue:value forKey:info[@"mappedName"]];
		

        
    }];
    
}

// Mapping from self.property to json['property']
+ (NSDictionary *)mappingDictionary {
	return @{
		@"Id" : @{@"type": @"System.Int32", @"mappedType":@"NSNumber", @"mappedName": @"tagID"},
		@"ProjectId" : @{@"type": @"System.Int32", @"mappedType":@"NSNumber", @"mappedName": @"projectID"},
		@"EntityTypeId" : @{@"type": @"enumList", @"mappedType":@"NSNumber", @"mappedName": @"entityTypeID"},
		@"Name" : @{@"type": @"System.String", @"mappedType":@"NSString", @"mappedName": @"name"},
		@"TagCount" : @{@"type": @"System.Int32", @"mappedType":@"NSNumber", @"mappedName": @"tagCount"},
		@"CreateDate" : @{@"type": @"System.DateTime", @"mappedType":@"NSDate", @"mappedName": @"createDate"},
		@"ModifyDate" : @{@"type": @"System.DateTime", @"mappedType":@"NSDate", @"mappedName": @"modifyDate"},
		@"Project" : @{@"type": @"relationship", @"mappedType":@"TSProject", @"mappedName": @"project"}
	};
}

- (NSString *)dbKey {
	
    return [[self class] dbKeyWithID:self.tagID];
	
}

+ (NSString *)dbKeyWithID: (NSNumber *)identifier {
    return [NSString stringWithFormat:@"Phoenix/Tag/%@", [identifier stringValue]];
}

+ (NSString *)dbCollection {
  // TODO: needs thinking: what about ArticleInderation? How to store those?
  // TODO: maybe override dbKey and dbKeyWithID:? 
  
  return @"Phoenix/Tag";
  
}

+ (instancetype)tagWithID: (NSNumber *)objectID {
   
    NSString *key = [self dbKeyWithID:objectID];
    __block id object;
    [[TSPhoenixClient sharedInstance].readOnlyDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        object = [transaction objectForKey:key inCollection:[[self class] dbCollection]];        
    }];
    return object;
}



+ (NSArray *)expandableProperties {
  return @[
   @"project"
  ];
}

+ (NSArray *)uncodableProperties {
	return [self expandableProperties];
}

@end