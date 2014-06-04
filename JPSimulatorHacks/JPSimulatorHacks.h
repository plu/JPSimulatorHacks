//
//  JPSimulatorHacks.h
//  JPSimulatorHacks
//
//  Created by Johannes Plunien on 04/06/14.
//
//

#import <Foundation/Foundation.h>

@interface JPSimulatorHacks : NSObject

+ (BOOL)grantAccessToAddressBook;
+ (BOOL)grantAccessToAddressBookForBundleIdentifier:(NSString *)bundleIdentifier;

+ (BOOL)grantAccessToPhotos;
+ (BOOL)grantAccessToPhotosForBundleIdentifier:(NSString *)bundleIdentifier;

@end
