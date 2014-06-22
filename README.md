[![Build Status](https://travis-ci.org/plu/JPSimulatorHacks.svg?branch=1.0.1)](https://travis-ci.org/plu/JPSimulatorHacks)

# JPSimulatorHacks

## Description

Hack the Simulator in your tests (grant access to photos, contacts, ...).

Did you ever have the problem that your code was wrapping the `AddressBook` or
the `ALAssetsLibrary` APIs? Running tests can be annoying then. There's this
`UIAlertView` asking the user to grant access to the contacts and photos,
which blocks and breaks your tests. Using `JPSimulatorHacks` you can easily
grant this access before running your tests.

## Usage

```objc
#import <JPSimulatorHacks/JPSimulatorHacks.h>

@implementation MyAppTests

+ (void)setUp
{
    [super setUp];
    [JPSimulatorHacks grantAccessToAddressBook];
    [JPSimulatorHacks grantAccessToPhotos];
}

@end
```

This will grant access to the addressbook and the photos library for the
current bundle identifier. There's also an API to specify the bundle
identifier, if necessary:

```objc
+ (BOOL)grantAccessToAddressBookForBundleIdentifier:(NSString *)bundleIdentifier;
+ (BOOL)grantAccessToPhotosForBundleIdentifier:(NSString *)bundleIdentifier;
```

### Timeout

By default it tries to write the necessary entries to the `TCC.db` within
15 seconds. If that's not enough time, it just gives up and returnes `NO`
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

* Currently the whole thing is only supported for application tests.
* When using Xcode bots, sometimes the tests run into an timeout.

## License (MIT)

Copyright (C) 2014 Johannes Plunien

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
