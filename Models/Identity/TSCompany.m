//
//  TSPhoenix
//	TSCompany.m
//
//  Created by Steve on May 28th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSCompany.h"
#import "TSPhoenixClient.h"
#import "NSArray+Mapping.h"

@implementation TSCompany

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
        
        // Phoenix date ISO 8601/
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
		
        // expanded array properties
        if ([dotNetType isEqualToString:@"relationship.array"]) {
            if (![value isKindOfClass:[NSArray class]]) {
                NSLog(@"Warning: mapping skips array expansion %@ because the value %@ is not an array", info[@"mappedName"], value);
                return;
            }
            
            NSString *className = info[@"arrayContentType"];
            if (!className)
                return;
            
            Class DestinationClass = NSClassFromString(className);
            if (!DestinationClass) {
                NSLog(@"Warning: unsuccessful mapping because class %@ not found", className);
                return;
            }
            
            NSArray *mappedArray = [value mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
                return [[DestinationClass alloc] initWithDictionary:obj];
            }];
            
            [self setValue:mappedArray forKey:info[@"mappedName"]];

            return;
        }
		
        // expanded properties
        if ([dotNetType isEqualToString:@"relationship"]) {
            
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
			
		        return;
        }

		
        [self setValue:value forKey:info[@"mappedName"]];
		

        
    }];
    
}

// Mapping from self.property to json['property']
+ (NSDictionary *)mappingDictionary {
	return @{
		@"Id" : @{@"type": @"System.Int32", @"mappedType":@"NSNumber", @"mappedName": @"companyID"},
		@"ProviderId" : @{@"type": @"System.Int32", @"mappedType":@"NSNumber", @"mappedName": @"providerID"},
		@"Name" : @{@"type": @"System.String", @"mappedType":@"NSString", @"mappedName": @"name"},
		@"Reference" : @{@"type": @"System.String", @"mappedType":@"NSString", @"mappedName": @"reference"},
		@"IsActive" : @{@"type": @"System.Boolean", @"mappedType":@"NSNumber", @"mappedName": @"isActive"},
		@"LogoUrl" : @{@"type": @"System.String", @"mappedType":@"NSString", @"mappedName": @"logoUrl"},
		@"CreateDate" : @{@"type": @"System.DateTime", @"mappedType":@"NSDate", @"mappedName": @"createDate"},
		@"ModifyDate" : @{@"type": @"System.DateTime", @"mappedType":@"NSDate", @"mappedName": @"modifyDate"},
		@"MetaDataParameters" : @{@"type": @"List<KeyValuePair<string, string>>", @"mappedType":@"NSArray", @"mappedName": @"metaDataParameters"},
		@"Provider" : @{@"type": @"relationship", @"mappedType":@"TSProvider", @"mappedName": @"provider"},
		@"Domains" : @{@"type": @"relationship.array", @"mappedType":@"NSArray", @"mappedName": @"domains", @"arrayContentType": @"TSDomain"}
	};
}

- (NSString *)dbKey {
	
    return [[self class] dbKeyWithID:self.companyID];
	
}

+ (NSString *)dbKeyWithID: (NSNumber *)identifier {
    return [NSString stringWithFormat:@"Phoenix/Company/%@", [identifier stringValue]];
}

+ (NSString *)dbCollection {
  // TODO: needs thinking: what about ArticleInderation? How to store those?
  // TODO: maybe override dbKey and dbKeyWithID:? 
  
  return @"Phoenix/Company";
  
}

+ (instancetype)companyWithID: (NSNumber *)objectID {
   
    NSString *key = [self dbKeyWithID:objectID];
    __block id object;
    [[TSPhoenixClient sharedInstance].readOnlyDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        object = [transaction objectForKey:key inCollection:[[self class] dbCollection]];        
    }];
    return object;
}



+ (NSArray *)expandableProperties {
  return @[
   @"provider",

  ];
}

+ (NSArray *)uncodableProperties {
	return [self expandableProperties];
}

- (NSUInteger)hash {
  return [self.dbKey hash];
}


@end