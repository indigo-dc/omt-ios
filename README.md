
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
* clone this repository,
* run `pod install` from the `Example` directory,
* open `IndigoOmtIosLibrary.xcworkspace` from the same directory.
* find `Example for IndigoOmtIosLibrary/Classes/Common/Constants.swift` and set
  * YOUR_FUTURE_GATEWAY_URL
  * YOUR_ISSUER_URL // e.g. IAM instance
  * YOUR_CLIENT_ID
  * YOUR_CLIENT_SECRET // optionally
  * YOUR_SCHEME_FOR_REDIRECT
* find `Example for IndigoOmtIosLibrary/Supporting Files/Info.plist` and set
  * YOUR_APP_BUNDLE

## Installation

Indigo Omt Ios Library is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'IndigoOmtIosLibrary'
```

## Usage

```swift
import IndigoOmtIosLibrary

// Future gateway object needs an access token provider to access API on the server.
// The provider is defined in FGAccessTokenProvider interface.
// You can find a sample implementation of the protocol in example app.
let accessTokenProvider: FGAccessTokenProvider = AppAuthAccessTokenProvider(...)

// It also needs API URL and username for API requests
let url: URL = ...
let username: String = "futureGatewayUser"

// create future gateway object
let fg = FGFutureGateway(url: url, username: username, provider: accessTokenProvider)

// now you can list all tasks
fg.taskCollectionApi.listAllTasks { (response: FGApiResponse<FGTaskCollection>) in
    guard let tasks = response.value?.tasks else {
        return
    }
    
    print(tasks)
}
```

## License

IndigoOmtIosLibrary is available under the Apache License, Version 2.0. See the LICENSE file for more info.

## Unit and integration tests

See [here](https://github.com/indigo-dc/omt-ios/blob/master/REPORTS.md).
