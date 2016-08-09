//
//  JPSimulatorHacks.m
//  JPSimulatorHacks
//
//  Created by Johannes Plunien on 04/06/14.
//  Copyright (C) 2014 Johannes Plunien
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "JPSimulatorHacks.h"
#import "JPSimulatorHacksDB.h"

@implementation JPSimulatorHacks

static NSString * const JPSimulatorHacksServiceAddressBook      = @"kTCCServiceAddressBook";
static NSString * const JPSimulatorHacksServicePhotos           = @"kTCCServicePhotos";
static NSString * const JPSimulatorHacksServiceCalendar         = @"kTCCServiceCalendar";
static NSString * const JPSimulatorHacksServiceHomeKit          = @"kTCCServiceWillow";
static NSString * const JPSimulatorHacksServiceContacts         = @"kTCCServiceContacts";
static NSString * const JPSimulatorHacksServiceContactsError    = @"Contacts Framework supported from iOS 9 or later";

static NSTimeInterval JPSimulatorHacksTimeout = 15.0f;

#pragma mark - Public

+ (ALAsset *)addAssetWithURL:(NSURL *)imageURL
{
    __block ALAsset *asset;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];

    NSTimeInterval timeout = JPSimulatorHacksTimeout;
    NSDate *expiryDate = [NSDate dateWithTimeIntervalSinceNow:timeout];

    while (!asset) {
        if(([(NSDate *)[NSDate date] compare:expiryDate] == NSOrderedDescending)) {
            break;
        }
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];

        [library writeImageDataToSavedPhotosAlbum:imageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            [library assetForURL:assetURL resultBlock:^(ALAsset *inAsset) {
                asset = inAsset;
            } failureBlock:nil];
        }];
    }

    return asset;
}

+ (void)editApplicationPreferences:(void (^)(NSMutableDictionary *preferences))block
{
    [self editPlist:[self applicationPreferencesPath] block:block];
}

+ (void)editGlobalPreferences:(void (^)(NSMutableDictionary *preferences))block
{
    [self editPlist:[self globalPreferencesPath] block:block];
}

+ (void)editPreferences:(void (^)(NSMutableDictionary *preferences))block
{
    [self editPlist:[self preferencesPath] block:block];
}

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

+ (BOOL)grantAccessToCalendar
{
    return [self changeAccessToService:JPSimulatorHacksServiceCalendar
                      bundleIdentifier:[NSBundle mainBundle].bundleIdentifier
                               allowed:YES];
}

+ (BOOL)grantAccessToCalendarForBundleIdentifier:(NSString *)bundleIdentifier
{
    return [self changeAccessToService:JPSimulatorHacksServiceCalendar
                      bundleIdentifier:bundleIdentifier
                               allowed:YES];
}

+ (BOOL)grantAccessToHomeKit
{
    return [self changeAccessToService:JPSimulatorHacksServiceHomeKit
                      bundleIdentifier:[NSBundle mainBundle].bundleIdentifier
                               allowed:YES];
}

+ (BOOL)grantAccessToHomeKitForBundleIdentifier:(NSString *)bundleIdentifier
{
    return [self changeAccessToService:JPSimulatorHacksServiceHomeKit
                      bundleIdentifier:bundleIdentifier
                               allowed:YES];
}

+ (BOOL)grantAccessToContacts
{
#if defined(__IPHONE_9_0) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
    return [self changeAccessToService:JPSimulatorHacksServiceContacts
                      bundleIdentifier:[NSBundle mainBundle].bundleIdentifier
                               allowed:YES];
#else
    NSLog(JPSimulatorHacksServiceContactsError);
        return NO;
#endif
}

+ (BOOL)grantAccessToContactsForBundleIdentifier:(NSString *)bundleIdentifier
{
#if defined(__IPHONE_9_0) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
    return [self changeAccessToService:JPSimulatorHacksServiceContacts
                      bundleIdentifier:bundleIdentifier
                               allowed:YES];
#else
    NSLog(JPSimulatorHacksServiceContactsError);
    return NO;
#endif
}

+ (void)setTimeout:(NSTimeInterval)timeout
{
    JPSimulatorHacksTimeout = timeout;
}

#pragma mark - Private

+ (NSString *)cddbPath
{
    return [[self libraryURL] URLByAppendingPathComponent:@"TCC/TCC.db"].URLByStandardizingPath.path;
}

+ (NSString *)globalPreferencesPath
{
    return [[self libraryURL] URLByAppendingPathComponent:@"Preferences/.GlobalPreferences.plist"].URLByStandardizingPath.path;
}

+ (NSString *)applicationPreferencesPath
{
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    return [paths.firstObject URLByAppendingPathComponent:@"../Preferences/com.apple.Preferences.plist"].URLByStandardizingPath.path;
}

+ (NSURL *)libraryURL
{
    static NSURL *result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSBundle mainBundle].bundleURL URLByAppendingPathComponent:@".."];
        do {
            url = [[url URLByAppendingPathComponent:@".."] URLByStandardizingPath];
            NSURL *libraryURL = [url URLByAppendingPathComponent:@"Library"];
            BOOL isDirectory;
            if ([[NSFileManager defaultManager] fileExistsAtPath:libraryURL.path isDirectory:&isDirectory] && isDirectory) {
                url = libraryURL;
                break;
            }
        } while (![url.path isEqualToString:@"/"]);
        result = url;
    });
    return result;
}

+ (NSString *)preferencesPath
{
    return [[self libraryURL] URLByAppendingPathComponent:@"Preferences/com.apple.Preferences.plist"].URLByStandardizingPath.path;
}

#pragma mark - Helper

+ (BOOL)changeAccessToService:(NSString *)service
             bundleIdentifier:(NSString *)bundleIdentifier
                      allowed:(BOOL)allowed
{
#if !(TARGET_IPHONE_SIMULATOR)
    return NO;
#endif

    BOOL success = NO;
    NSDate *start = [NSDate date];

    while (!success) {
        NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:start];
        if (elapsed > JPSimulatorHacksTimeout) break;

        if (![[NSFileManager defaultManager] fileExistsAtPath:[self cddbPath]]) continue;

        JPSimulatorHacksDB *db = [JPSimulatorHacksDB databaseWithPath:[self cddbPath]];
        if (![db open]) continue;

        NSString *query = @"REPLACE INTO access (service, client, client_type, allowed, prompt_count) VALUES (?, ?, ?, ?, ?)";
        NSArray *parameters = @[service, bundleIdentifier, @"0", [@(allowed) stringValue], @"0"];
        if ([db executeUpdate:query withArgumentsInArray:parameters]) {
            success = YES;
        }
        else {
            [db close];
            NSLog(@"JPSimulatorHacks ERROR: %@", [db lastErrorMessage]);
        }

        [db close];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
    }

    return success;
}

+ (void)editPlist:(NSString *)plistPath block:(void (^)(NSMutableDictionary *))block
{
#if !(TARGET_IPHONE_SIMULATOR)
    return;
#endif

    [self waitForFile:plistPath];

    NSMutableDictionary *preferences = [[NSDictionary dictionaryWithContentsOfFile:plistPath] mutableCopy];
    block(preferences);

    NSData *data = [NSPropertyListSerialization dataWithPropertyList:preferences
                                                              format:NSPropertyListBinaryFormat_v1_0
                                                             options:0
                                                               error:nil];
    [data writeToFile:plistPath atomically:YES];
}

+ (BOOL)waitForFile:(NSString *)filePath
{
    BOOL success = NO;
    NSDate *start = [NSDate date];

    while (!success) {
        NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:start];
        if (elapsed > JPSimulatorHacksTimeout) break;
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) continue;

        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if ([attributes valueForKey:NSFileSize] == 0) continue;

        success = YES;
    }

    return success;
}

@end
