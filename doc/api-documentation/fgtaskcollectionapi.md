# FGTaskCollectionApi

## Methods

### `public func listAllTasks(_ callback: @escaping FGApiResponseCallback<FGTaskCollection>)`

Lists all tasks for Future Gateway username.

#### Parameters

* `callback` - result callback of the method

### `public func createTask(_ task: FGTask, callback: @escaping FGApiResponseCallback<FGTask>)`

Create a new task.

#### Parameters

* `task` - task object to create
* `callback` - result callback of the method
