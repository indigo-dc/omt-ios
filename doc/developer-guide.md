## Requirements

* `macOS >= 10.12`
* `Xcode >= 8.0`
* `CocoaPods >= 1.2.0`

## Dependencies

This project uses following libraries
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

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
let url: URL = URL(string: "http://my-fg-instance.com")
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
