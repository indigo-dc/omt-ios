
# Indigo Omt Ios Library

iOS library which simplifies access to INDIGO DataCloud API

## Requirements

- `macOS >= 10.12`
- `Xcode >= 8.0`
- `CocoaPods >= 1.1.1`

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

to be continued...

<!---
 ## Installation
 
 Indigo Omt Ios Library is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:
 
 ```ruby
 pod 'IndigoOmtIosLibrary'
 ```
 --->

## License

IndigoOmtIosLibrary is available under the Apache License, Version 2.0. See the LICENSE file for more info.

## Code coverage

To run tests with code coverage please install [xcov](https://github.com/nakiostudio/xcov)

```
sudo gem install xcov
```

and then run shell script from root directory

```
./run_code_coverage.sh
```


> Powered by [xcov](https://github.com/nakiostudio/xcov)
## Current coverage for IndigoOmtIosLibrary.framework is `96%`
Files changed | - | - 
--- | --- | ---
FGTaskApi.swift | `0%` | :skull:
FGApplication.swift | `0%` | :skull:
FGTaskCollectionApi.swift | `62%` | :warning:
FGRequestHelperPayload.swift | `100%` | :white_check_mark:
FGAlamofireRequestHelper.swift | `100%` | :white_check_mark:
FGApiLink.swift | `100%` | :white_check_mark:
FGRootApiResolver.swift | `100%` | :white_check_mark:
FGApiRoot.swift | `100%` | :white_check_mark:
FGApiRootVersion.swift | `100%` | :white_check_mark:
FGDateUtil.swift | `100%` | :white_check_mark:
DataRequest+IndigoOmtIosLibrary.swift | `100%` | :white_check_mark:
FGFutureGateway.swift | `100%` | :white_check_mark:
FGFutureGatewayError.swift | `100%` | :white_check_mark:
FGApiResponse.swift | `100%` | :white_check_mark:
FGInputFile.swift | `100%` | :white_check_mark:
FGOutputFile.swift | `100%` | :white_check_mark:
FGRuntimeDataObject.swift | `100%` | :white_check_mark:
FGSessionHelper.swift | `100%` | :white_check_mark:
FGTask.swift | `100%` | :white_check_mark:
FGTaskCollection.swift | `100%` | :white_check_mark:
FGAbstractResolvedApi.swift | `100%` | :white_check_mark:
FGEmptyObject.swift | `100%` | :white_check_mark:
FGRequestHelperResponse.swift | `100%` | :white_check_mark:
FGAbstractApi.swift | `100%` | :white_check_mark:

---

> Powered by [xcov](https://github.com/nakiostudio/xcov)
