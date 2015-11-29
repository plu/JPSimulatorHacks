[![Build Status](https://travis-ci.org/plu/JPSimulatorHacks.svg?branch=master)](https://travis-ci.org/plu/JPSimulatorHacks)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# JPSimulatorHacks

## Description

Hack the Simulator in your tests (grant access to photos, contacts, calendar ...).

Did you ever have the problem that your code was wrapping the `AddressBook`, the `EventKit` or the `ALAssetsLibrary` APIs? Running tests can be annoying then. There's this `UIAlertView` asking the user to grant access to the contacts and photos, which blocks and breaks your tests. Using `JPSimulatorHacks` you can easily grant this access before running your tests.

If you encounter any problems, please check out the [caveats](#caveats)
documented below.

### Installation

Install JPSimulatorHacks with [Cocoapods](http://cocoapods.org/)

```
pod 'JPSimulatorHacks'
```

## Usage

### AddressBook

```objc
#import <JPSimulatorHacks/JPSimulatorHacks.h>

@implementation MyAppTests

+ (void)setUp
{
    [super setUp];
    [JPSimulatorHacks grantAccessToAddressBook];
}

@end
```

This will grant access to the addressbook for the current bundle identifier.
There's also an API to specify the bundle identifier, if necessary:

```objc
+ (BOOL)grantAccessToAddressBookForBundleIdentifier:(NSString *)bundleIdentifier;
```

### Calendar

```objc
#import <JPSimulatorHacks/JPSimulatorHacks.h>

@implementation MyAppTests

+ (void)setUp
{
    [super setUp];
    [JPSimulatorHacks grantAccessToCalendar];
}

@end
```

This will grant access to the calendar for the current bundle identifier.
There's also an API to specify the bundle identifier, if necessary:

```objc
+ (BOOL)grantAccessToCalendarForBundleIdentifier:(NSString *)bundleIdentifier;
```

### HomeKit

```objc
#import <JPSimulatorHacks/JPSimulatorHacks.h>

@implementation MyAppTests

+ (void)setUp
{
    [super setUp];
    [JPSimulatorHacks grantAccessToHomeKit];
}

@end
```

This will grant access to `HomeKit` for the current bundle identifier.
There's also an API to specify the bundle identifier, if necessary:

```objc
+ (BOOL) grantAccessToHomeKitForBundleIdentifier:(NSString *)bundleIdentifier;
```

### Photos

```objc
#import <JPSimulatorHacks/JPSimulatorHacks.h>

@implementation MyAppTests

+ (void)setUp
{
    [super setUp];
    [JPSimulatorHacks grantAccessToPhotos];
}

@end
```

This will grant access to the photos library for the current bundle identifier.
There's also an API to specify the bundle identifier, if necessary:

```objc
+ (BOOL)grantAccessToPhotosForBundleIdentifier:(NSString *)bundleIdentifier;
```

You can also add some test images from a given URL. The method will block until
the Asset has been stored. This is helpful so your tests will only start after
the Asset is available.

```objc
[JPSimulatorHacks grantAccessToPhotos];
NSURL *assetURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/plu/JPSimulatorHacks/master/Data/test.png"];
ALAsset *asset = [JPSimulatorHacks addAssetWithURL:assetURL];
```

### Timeout

By default it tries to write the necessary entries to the `TCC.db` within
15 seconds. If that's not enough time, it just gives up and returns `NO`
from the methods. If for any reason that is not enough time, you can
change this default timeout via:

```objc
+ (void)setUp
{
    [super setUp];
    [JPSimulatorHacks setTimeout:30.0f];
}
```

## Caveats

* `JPSimulatorHacks` only works if unit test suite is run against
real application target: Its `Host Application` *is not* set to `None`!
See also: http://stackoverflow.com/a/28135995/598057
* When using Xcode bots, sometimes the tests run into an timeout.
* The keyboard helpers have been removed in 1.3.0

## License (MIT)

Copyright (C) 2014 Johannes Plunien

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
