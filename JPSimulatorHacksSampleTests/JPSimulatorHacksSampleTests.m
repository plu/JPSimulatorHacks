//
//  JPSimulatorHacksSampleTests.m
//  JPSimulatorHacksSampleTests
//
//  Created by Johannes Plunien on 04/06/14.
//
//

#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <JPSimulatorHacks/JPSimulatorHacks.h>
#import <XCTest/XCTest.h>

#define ASYNC_TIMEOUT 2.0f

@interface JPSimulatorHacksSampleTests : XCTestCase

@end

@implementation JPSimulatorHacksSampleTests

+ (void)setUp
{
    [super setUp];
    [JPSimulatorHacks grantAccessToAddressBook];
    [JPSimulatorHacks grantAccessToPhotos];
}

- (void)testAddressBookAccess
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        XCTAssertTrue(granted);
        CFRunLoopStop(CFRunLoopGetMain());
    });
    XCTAssertEqual(kCFRunLoopRunStopped, CFRunLoopRunInMode(kCFRunLoopDefaultMode, ASYNC_TIMEOUT, NO));
}

- (void)testPhotosAccess
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        CFRunLoopStop(CFRunLoopGetMain());
    } failureBlock:^(NSError *error) {
        XCTFail();
    }];
    XCTAssertEqual(kCFRunLoopRunStopped, CFRunLoopRunInMode(kCFRunLoopDefaultMode, ASYNC_TIMEOUT, NO));
}

@end
