# FGFutureGateway

FGFutureGateway is the main class and the entry point of the library. It is essential to gain access to the api classes.

## Constructors

### `public init(url: URL, username: String, provider: FGAccessTokenProvider)`

Creates Future Gateways instance object.

#### Parameters

* `url` - URL to the Future Gateway instance
* `username` - the Future Gateway username
* `provider` - the access token provider for accessing Future Gateway API, see [here](/api-documentation/fgaccesstokenprovider.md)

## Properties

### `public let apiVersion: String`

Currently supported API version.

### `public let applicationCollection: FGApplicationCollectionApi`

Application collection API.

### `public let fileApi: FGFileApi`

File API.

### `public let taskApi: FGFileApi`

Task API.

### `public let taskCollectionApi: FGTaskCollectionApi`

Task collection API.
