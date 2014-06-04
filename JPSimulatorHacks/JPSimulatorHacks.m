//
//  JPSimulatorHacks.m
//  JPSimulatorHacks
//
//  Created by Johannes Plunien on 04/06/14.
//
//

#import <FMDB/FMDB.h>
#import "JPSimulatorHacks.h"

@implementation JPSimulatorHacks

static NSString * const JPSimulatorHacksServiceAddressBook = @"kTCCServiceAddressBook";
static NSString * JPSimulatorHacksServicePhotos = @"kTCCServicePhotos";

#pragma mark - Public

+ (BOOL)grantAccessToAddressBook
{
    return [self changeAccessToService:JPSimulatorHacksServiceAddressBook
                      bundleIdentifier:[NSBundle mainBundle].bundleIdentifier
                               allowed:YES];
}

+ (BOOL)grantAccessToAddressBookForBundleIdentifier:(NSString *)bundleIdentifier
{
    return [self changeAccessToService:JPSimulatorHacksServiceAddressBook
                      bundleIdentifier:bundleIdentifier
                               allowed:YES];
}

+ (BOOL)grantAccessToPhotos
{
    return [self changeAccessToService:JPSimulatorHacksServicePhotos
                      bundleIdentifier:[NSBundle mainBundle].bundleIdentifier
                               allowed:YES];
}

+ (BOOL)grantAccessToPhotosForBundleIdentifier:(NSString *)bundleIdentifier
{
    return [self changeAccessToService:JPSimulatorHacksServicePhotos
                      bundleIdentifier:bundleIdentifier
                               allowed:YES];
}

#pragma mark - Private

+ (BOOL)changeAccessToService:(NSString *)service
             bundleIdentifier:(NSString *)bundleIdentifier
                      allowed:(BOOL)allowed
{
#if !(TARGET_IPHONE_SIMULATOR)
    return NO;
#endif

    BOOL success = NO;

    while (!success) {
        FMDatabase *db = [FMDatabase databaseWithPath:[self pathToTCCDB]];
        if (![db open]) continue;
        if (![db goodConnection]) continue;

        NSString *query = @"REPLACE INTO access (service, client, client_type, allowed, prompt_count) VALUES (?, ?, ?, ?, ?)";
        NSArray *parameters = @[service, bundleIdentifier, @"0", [@(allowed) stringValue], @"0"];
        if ([db executeUpdate:query withArgumentsInArray:parameters]) {
            success = YES;
        }
        else {
            NSLog(@"JPSimulatorHacks ERROR: %@", [db lastErrorMessage]);
        }
        [db close];
    }

    return success;
}

+ (NSString *)pathToTCCDB
{
    NSURL *mainBundleURL = [NSBundle mainBundle].bundleURL;
    NSURL *relativeTCCDBURL = [mainBundleURL URLByAppendingPathComponent:@"../../../Library/TCC/TCC.db"];
    return [[relativeTCCDBURL URLByStandardizingPath] path];
}

@end
