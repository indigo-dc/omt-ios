# FGTaskAPI

API for Future Gateway Task.

## Methods

### `public func viewTaskDetails(with id: String, _ callback: @escaping FGApiResponseCallback<FGTask>)`

Retrieves the details of the specified task.

#### Parameters

* `id` - task ID to view details
* `callback` - result callback of the method

### `public func deleteTask(with id: String, _ callback: @escaping FGApiResponseCallback<FGAnyObject>)`

Deletes a task.

#### Parameters

* `id` - task ID to delete
* `callback` - result callback of the method
