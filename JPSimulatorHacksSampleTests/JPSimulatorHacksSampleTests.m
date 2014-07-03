//
//  JPSimulatorHacksSampleTests.m
//  JPSimulatorHacksSampleTests
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

#define EXP_SHORTHAND

#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Expecta/Expecta.h>
#import <JPSimulatorHacks/JPSimulatorHacks.h>
#import <KIF/KIF.h>
#import <KIF/UIAccessibilityElement-KIFAdditions.h>
#import <XCTest/XCTest.h>

@interface JPSimulatorHacksSampleTests : XCTestCase

@end

@implementation JPSimulatorHacksSampleTests

+ (void)setUp
{
    [super setUp];
    [KIFTestActor setDefaultTimeout:3.0f];
    [JPSimulatorHacks grantAccessToAddressBook];
    [JPSimulatorHacks grantAccessToPhotos];
    [JPSimulatorHacks setDefaultKeyboard:@"de_DE@hw=German;sw=QWERTZ-German"];
    [JPSimulatorHacks disableKeyboardHelpers];
}

- (void)testAddAssetWithURL
{
    NSURL *assetURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/plu/JPSimulatorHacks/master/Data/test.png"];
    ALAsset *asset = [JPSimulatorHacks addAssetWithURL:assetURL];
    expect(asset).notTo.beNil();
}

- (void)testAddressBookAccess
{
    expect(ABAddressBookGetAuthorizationStatus()).to.equal(kABAuthorizationStatusAuthorized);
}

- (void)testPhotosAccess
{
    expect([ALAssetsLibrary authorizationStatus]).to.equal(ALAuthorizationStatusAuthorized);
}

- (void)testKeyboardSettings
{
    static NSString *TextField = @"TextField";
    [tester waitForViewWithAccessibilityLabel:TextField];

    // If the keyboard settings do not get applied, this will end up autocorrected and will fail:
    // Charly said, Main Street is crowded
    [tester clearTextFromAndThenEnterText:@"charly said, main street "
           intoViewWithAccessibilityLabel:TextField];

    // These are only on the German keyboard and proves that setDefaultKeyboard works.
    [tester waitForViewWithAccessibilityLabel:@"ä"];
    [tester waitForViewWithAccessibilityLabel:@"ö"];
    [tester waitForViewWithAccessibilityLabel:@"ü"];
}

@end
