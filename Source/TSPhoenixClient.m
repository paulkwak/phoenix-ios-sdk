//
//  TSPhoenixClient.m
//  fuse
//
//  Created by Steve on 4/4/13.
//  Copyright (c) 2013 Tigerspike. All rights reserved.
//

#import "TSPhoenixClient.h"

#import "TSPhoenix.h"
#import "AFOAuth2Client.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

#import "TSPhoenixIdentity.h"
#import "TSPhoenixSyndicate.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIKit+AFNetworking.h>
#import "TSModelAbstract.h"

NSString * const TSPhoenixKeyValueDatabaseSQLiteName = @"TSPhoenixStore.sqlite";

@interface TSPhoenixClient() {
    YapDatabase *_database;
}

@end

@implementation TSPhoenixClient

static NSURL *phoenix_baseURL;
static NSString *phoenix_clientID;
static NSString *phoenix_clientSecret;
static NSInteger phoenix_projectID;

- (id)init {

    NSAssert(phoenix_baseURL != nil, @"BaseURL missing. did you call [TSPhoenixClient setUp...]?");
    NSAssert(phoenix_clientID != nil, @"BaseURL missing. did you call [TSPhoenixClient setUp...]?");
    NSAssert(phoenix_clientSecret != nil, @"BaseURL missing. did you call [TSPhoenixClient setUp...]?");
    NSAssert(phoenix_projectID > 0, @"projectID missing. did you call [TSPhoenixClient setUp...]?");
    
    self = [super initWithBaseURL:phoenix_baseURL];
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
//    [self.requestSerializer setHeader:@"Accept" value:@"application/json"];
//    [self setDefaultHeader:@"Accept-Encoding" value:@"gzip, deflate"];
//    self.parameterEncoding = AFJSONParameterEncoding;
    self.defaultDateFormatter = (NSDateFormatter *)[[ISO8601DateFormatter alloc] init];
    
    self.identity = [[TSPhoenixIdentity alloc] initWithPhoenixClient:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(HTTPOperationDidFinish:)
                                                 name:AFNetworkingOperationDidFinishNotification
                                               object:nil];

    
    NSFileManager *fm = [NSFileManager defaultManager];

    NSArray *array = [fm URLsForDirectory:NSLibraryDirectory
                                inDomains:NSUserDomainMask];
    
    // KeyValueDB
    NSString* path = [(NSURL *)array[0] path];
    
    path = [path stringByAppendingPathComponent:@"TSPhoenix"];
    if (![fm fileExistsAtPath:path])
        [fm createDirectoryAtPath:path
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    path = [path stringByAppendingPathComponent:TSPhoenixKeyValueDatabaseSQLiteName];
    
    _database = [[YapDatabase alloc] initWithPath:path];
    
    _readOnlyDatabaseConnection = [_database newConnection];
    
    _writeDatabaseConnection = [_database newConnection];
    _writeDatabaseConnection.objectCacheEnabled = NO;
    _writeDatabaseConnection.metadataCacheEnabled = NO;
    
    // Identity setup deffered till we get the clientID / secret

    NSParameterAssert(_database);
    
    self.syndicate = [[TSPhoenixSyndicate alloc] initWithPhoenixClient:self];

    self.messaging = [[TSPhoenixMessaging alloc] initWithPhoenixClient:self];
    self.media = [[TSPhoenixMedia alloc] initWithPhoenixClient:self];
    self.analytics = [[TSPhoenixAnalytics alloc] initWithPhoenixClient:self];
    self.forum = [[TSPhoenixForum alloc] initWithPhoenixClient:self];
    
    self.paginators = [NSMutableSet new];
    
    return self;
}

+ (id)sharedInstance {
    
    static dispatch_once_t once;
    static id sharedManager;
    dispatch_once(&once, ^ {
        sharedManager = [[self alloc] init];
    
    });
    return sharedManager;
}

// Convenience
+ (TSPhoenixIdentity *)identity {
    return [[TSPhoenixClient sharedInstance] identity];
}

+ (TSPhoenixSyndicate *)syndicate {
    return [[TSPhoenixClient sharedInstance] syndicate];
}


+ (TSPhoenixMedia *)media {
    return [[TSPhoenixClient sharedInstance] media];
}

+ (TSPhoenixMessaging *)messaging {
    return [[TSPhoenixClient sharedInstance] messaging];
}

+ (TSPhoenixAnalytics *)analytics {
    return [[TSPhoenixClient sharedInstance] analytics];
}

+ (TSPhoenixForum *)forum {
    return [[TSPhoenixClient sharedInstance] forum];
}

+ (void)setUpWithBaseURL: (NSURL *)baseURL
                clientID: (NSString *)clientID
            clientSecret: (NSString *)clientSecret
               projectID: (NSInteger)projectID {
    phoenix_baseURL = baseURL;
    phoenix_clientID = clientID;
    phoenix_clientSecret = clientSecret;
    phoenix_projectID = projectID;
    
    // Initialize the singleton
    [TSPhoenixClient sharedInstance];
}

#pragma mark - Networking

- (void)setUpNetworking {
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
}

- (void)setAuthorizationHeaderWithToken:(NSString *)token {
    // Use the "Bearer" type as an arbitrary default
    [self setAuthorizationHeaderWithToken:token ofType:@"Bearer"];
}

- (void)setAuthorizationHeaderWithCredential:(AFOAuthCredential *)credential {
    [self setAuthorizationHeaderWithToken:credential.accessToken ofType:credential.tokenType];
}

- (void)setAuthorizationHeaderWithToken:(NSString *)token
                                 ofType:(NSString *)type
{
    // See http://tools.ietf.org/html/rfc6749#section-7.1
    if ([[type lowercaseString] isEqualToString:@"bearer"]) {
        AFHTTPRequestSerializer *serializer;
        serializer = self.requestSerializer;
        if (!serializer)
            serializer = [AFHTTPRequestSerializer serializer];
        [serializer setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
        self.requestSerializer = serializer;
        
    }
}

#pragma mark - Error handling


/*
 Capture all http errors here
 */
- (void)HTTPOperationDidFinish:(NSNotification *)notification {
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[notification object];
    
    if (![operation isKindOfClass:[AFHTTPRequestOperation class]])
        return;
   
    if (operation.isCancelled) return;

//    if ([operation isKindOfClass:[AFImageRequestOperation class]]) return; // ignore image download errors
    
    if (operation.error) {
        NSLog(@"Network error: %@", operation.error);
    }
    
    /*
     Leave error handling to SDK user
    if (operation.error.code == NSURLErrorNotConnectedToInternet) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:operation.error.localizedDescription
                              delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self.operationQueue cancelAllOperations];
        
        
    }
    */
    
    NSInteger statusCode = operation.response.statusCode;
    if (statusCode == 401 || statusCode == 403) {
        
        // Token expired
        //        [self.identity logout];

        NSLog(@"HTTP error %@, Token may have expired.", operation.error);
        // The next refreshToken call will log the user out
    }
    
}


#pragma mark - Database 

- (void)saveObjectsToDatabase: (NSArray *)objects {
    [self.writeDatabaseConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [objects enumerateObjectsUsingBlock:^(TSModelAbstract *obj, NSUInteger idx, BOOL *stop) {
            if ([transaction hasObjectForKey:obj.dbKey
                                inCollection:obj.dbCollection]) {
                [transaction replaceObject:obj
                                    forKey:obj.dbKey
                              inCollection:obj.dbCollection];
            } else {
                [transaction setObject:obj
                                forKey:obj.dbKey
                          inCollection:obj.dbCollection];
            }
            
        }];
    }];
}

- (void)deleteObjectsInDatabase: (NSArray *)objects {
    [self.writeDatabaseConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [objects enumerateObjectsUsingBlock:^(TSModelAbstract *obj, NSUInteger idx, BOOL *stop) {
            [transaction removeObjectForKey:obj.dbKey
                               inCollection:obj.dbCollection];
        }];
    }];
}

- (void)saveObjectsToDatabase: (NSArray *)objects completion:(dispatch_block_t)completionBlock {
    [self.writeDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [objects enumerateObjectsUsingBlock:^(TSModelAbstract *obj, NSUInteger idx, BOOL *stop) {
            if ([transaction hasObjectForKey:obj.dbKey
                                inCollection:obj.dbCollection]) {
                [transaction replaceObject:obj
                                    forKey:obj.dbKey
                              inCollection:obj.dbCollection];
            } else {
                [transaction setObject:obj
                                forKey:obj.dbKey
                          inCollection:obj.dbCollection];
            }
            
        }];
    } completionBlock:completionBlock];

}

- (void)deleteObjectsInDatabase: (NSArray *)objects completion:(dispatch_block_t)completionBlock {
    [self.writeDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [objects enumerateObjectsUsingBlock:^(TSModelAbstract *obj, NSUInteger idx, BOOL *stop) {
            [transaction removeObjectForKey:obj.dbKey inCollection:obj.dbCollection];
        }];
    } completionBlock:completionBlock];
}

+ (YapDatabase *)database {
    return [[self sharedInstance] database];
}

+ (YapDatabaseConnection *)readOnlyDatabaseConnection {
    return [[self sharedInstance] readOnlyDatabaseConnection];
}

+ (YapDatabaseConnection *)writeDatabaseConnection {
    return [[self sharedInstance] writeDatabaseConnection];
}

// Synchronous
+ (void)saveObjectsToDatabase: (NSArray *)objects {
    [[self sharedInstance] saveObjectsToDatabase:objects];
}

+ (void)deleteObjectsInDatabase: (NSArray *)objects {
    [[self sharedInstance] deleteObjectsInDatabase:objects];
}

// Async
+ (void)saveObjectsToDatabase: (NSArray *)objects completion:(dispatch_block_t)completionBlock {
    [[self sharedInstance] saveObjectsToDatabase:objects completion:completionBlock];
}

+ (void)deleteObjectsInDatabase: (NSArray *)objects completion:(dispatch_block_t)completionBlock {
    [[self sharedInstance] deleteObjectsInDatabase:objects completion:completionBlock];
}

#pragma mark - 

- (NSString *)clientID {
    return phoenix_clientID;
}

- (NSString *)clientSecret{
    return phoenix_clientSecret;
}

- (NSInteger)projectID {
    return phoenix_projectID;
}



@end
