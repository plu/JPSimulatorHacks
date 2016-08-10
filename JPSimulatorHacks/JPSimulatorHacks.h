//
//  JPSimulatorHacks.h
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

#import <Foundation/Foundation.h>

@class ALAsset;

@interface JPSimulatorHacks : NSObject

// This is blocking, on purpose!
+ (ALAsset *)addAssetWithURL:(NSURL *)imageURL;

+ (void)editApplicationPreferences:(void (^)(NSMutableDictionary *preferences))block;
+ (void)editGlobalPreferences:(void (^)(NSMutableDictionary *preferences))block;
+ (void)editPreferences:(void (^)(NSMutableDictionary *preferences))block;

+ (BOOL)grantAccessToAddressBook;
+ (BOOL)grantAccessToAddressBookForBundleIdentifier:(NSString *)bundleIdentifier;

+ (BOOL)grantAccessToPhotos;
+ (BOOL)grantAccessToPhotosForBundleIdentifier:(NSString *)bundleIdentifier;

+ (BOOL)grantAccessToCalendar;
+ (BOOL)grantAccessToCalendarForBundleIdentifier:(NSString *)bundleIdentifier;

+ (BOOL)grantAccessToHomeKit;
+ (BOOL)grantAccessToHomeKitForBundleIdentifier:(NSString *)bundleIdentifier;

+ (BOOL)grantAccessToContacts;
+ (BOOL)grantAccessToContactsForBundleIdentifier:(NSString *)bundleIdentifier;

+ (void)setTimeout:(NSTimeInterval)timeout;

@end
