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

#import <FMDB/FMDB.h>
#import "JPSimulatorHacks.h"

@implementation JPSimulatorHacks

static NSString * const JPSimulatorHacksServiceAddressBook = @"kTCCServiceAddressBook";
static NSString * const JPSimulatorHacksServicePhotos = @"kTCCServicePhotos";
static NSTimeInterval JPSimulatorHacksTimeout = 15.0f;

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

+ (void)setTimeout:(NSTimeInterval)timeout
{
    JPSimulatorHacksTimeout = timeout;
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
    NSDate *start = [NSDate date];

    while (!success) {
        NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:start];
        if (elapsed > JPSimulatorHacksTimeout) break;

        if (![[NSFileManager defaultManager] fileExistsAtPath:[self pathToTCCDB] isDirectory:NO]) continue;

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
