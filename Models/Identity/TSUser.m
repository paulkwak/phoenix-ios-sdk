//
//  TSPhoenix
//	TSUser.m
//
//  Created by Steve on May 28th 2014.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSUser.h"
#import "TSPhoenixClient.h"
#import "NSArray+Mapping.h"

@implementation TSUser

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
		@"Id" : @{@"type": @"System.Int32", @"mappedType":@"NSNumber", @"mappedName": @"userID"},
		@"UserTypeId" : @{@"type": @"enumList", @"mappedType":@"NSNumber", @"mappedName": @"userTypeID"},
		@"CompanyId" : @{@"type": @"System.Int32", @"mappedType":@"NSNumber", @"mappedName": @"companyID"},
		@"Username" : @{@"type": @"System.String", @"mappedType":@"NSString", @"mappedName": @"username"},
		@"Password" : @{@"type": @"System.String", @"mappedType":@"NSString", @"mappedName": @"password"},
		@"ImageUrl" : @{@"type": @"System.String", @"mappedType":@"NSString", @"mappedName": @"imageUrl"},
		@"FirstName" : @{@"type": @"System.String", @"mappedType":@"NSString", @"mappedName": @"firstName"},
		@"LastName" : @{@"type": @"System.String", @"mappedType":@"NSString", @"mappedName": @"lastName"},
		@"LockingCount" : @{@"type": @"System.Byte", @"mappedType":@"NSNumber", @"mappedName": @"lockingCount"},
		@"Reference" : @{@"type": @"System.String", @"mappedType":@"NSString", @"mappedName": @"reference"},
		@"LastLoginDate" : @{@"type": @"System.DateTime", @"mappedType":@"NSDate", @"mappedName": @"lastLoginDate"},
		@"ExpiryDate" : @{@"type": @"System.DateTime", @"mappedType":@"NSDate", @"mappedName": @"expiryDate"},
		@"IsActive" : @{@"type": @"System.Boolean", @"mappedType":@"NSNumber", @"mappedName": @"isActive"},
		@"CreateDate" : @{@"type": @"System.DateTime", @"mappedType":@"NSDate", @"mappedName": @"createDate"},
		@"ModifyDate" : @{@"type": @"System.DateTime", @"mappedType":@"NSDate", @"mappedName": @"modifyDate"},
		@"MetaDataParameters" : @{@"type": @"List<KeyValuePair<string, string>>", @"mappedType":@"NSArray", @"mappedName": @"metaDataParameters"},
		@"Company" : @{@"type": @"relationship", @"mappedType":@"TSCompany", @"mappedName": @"company"},
		@"Identifiers" : @{@"type": @"relationship.array", @"mappedType":@"NSArray", @"mappedName": @"identifiers", @"arrayContentType": @"TSIdentifier"}
	};
}

- (NSString *)dbKey {
	
    return [[self class] dbKeyWithID:self.userID];
	
}

+ (NSString *)dbKeyWithID: (NSNumber *)identifier {
    return [NSString stringWithFormat:@"Phoenix/User/%@", [identifier stringValue]];
}

+ (NSString *)dbCollection {
  // TODO: needs thinking: what about ArticleInderation? How to store those?
  // TODO: maybe override dbKey and dbKeyWithID:? 
  
  return @"Phoenix/User";
  
}

+ (instancetype)userWithID: (NSNumber *)objectID {
   
    NSString *key = [self dbKeyWithID:objectID];
    __block id object;
    [[TSPhoenixClient sharedInstance].readOnlyDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        object = [transaction objectForKey:key inCollection:[[self class] dbCollection]];        
    }];
    return object;
}



+ (NSArray *)expandableProperties {
  return @[
   @"company",

  ];
}

+ (NSArray *)uncodableProperties {
	return [self expandableProperties];
}

- (NSUInteger)hash {
  return [self.dbKey hash];
}


@end