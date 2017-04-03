
# Indigo Omt Ios Library

iOS library which simplifies access to INDIGO DataCloud API

## Current version

Current version od the library is 0.1.3

## Requirements

- `macOS >= 10.12`
- `Xcode >= 8.0`
- `CocoaPods >= 1.2.0`

## Dependencies

This project uses following libraries
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

## Example

To run the example project
- clone this repository,
- run `pod install` from the `Example` directory,
- open `IndigoOmtIosLibrary.xcworkspace` from the same directory.

## Installation

Indigo Omt Ios Library is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```
pod 'IndigoOmtIosLibrary'
```

## License

IndigoOmtIosLibrary is available under the Apache License, Version 2.0. See the LICENSE file for more info.

## Code coverage

To run tests with code coverage please install [xcov](https://github.com/nakiostudio/xcov)

```
sudo gem install xcov
```

and then run shell script from root directory

```
./run_unit_tests_coverage.sh
```

You can view unit tests coverage [here](http://htmlpreview.github.io/?https://github.com/indigo-dc/omt-ios/blob/master/unit_tests_coverage/index.html).
