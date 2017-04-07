# FGFileApi

API for Future Gateway file management.

## Methods

### `public func download(_ downloadableFile: FGDownloadableFile, to destination: URL, _ callback: @escaping FGDownloadPayloadResponseCallback)`

Downloads file from API to mobile device.

#### Parameters

* `downloadableFile` - interface for file to download, it can be a `FGInputFile` or a `FGOutputFile`
* `destination` - path to which the file will be downloaded
* `callback` - result callback of the method

### `public func upload(_ inputFile: FGInputFile, to uploadLink: FGApiLink, from source: URL, _ callback: @escaping FGUploadPayloadResponseCallback)`

Uploads a file from mobile device to API.

#### Parameters

* `inputFile` - `FGInputFile` object with filename
* `uploadLink` - link to which the file will be uploaded
* `source` - path from which the file will be uploaded
* `callback` - result callback of the method
