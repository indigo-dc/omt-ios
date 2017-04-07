# FGAccessTokenProvider

Protocol that helps getting access from authorization object and fetching new token when current one is invalid.

## Methods

### `func getAccessToken() -> String`

Gets access token from current authorization object.

#### Returns

String with access token.

### `func requestNewAccessToken(_ callback: @escaping FGAccessTokenProviderCallback)`

Send request for new access token.

#### Parameters

* `callback` - result callback of the method
