# ``RKUtils/Foundation/URL``

File reading utilities for URL.

## Overview

URL extensions in RKUtils provide simple file I/O on top of Foundation's `URL` type. Reading a file is expressed directly on the URL itself, keeping call sites clean and removing the need for a throwaway string receiver.

```swift
let fileURL = URL(fileURLWithPath: "/path/to/file.txt")
if let content = fileURL.readFromFile() {
    print(content)
}
```

## Topics

### File Operations

Read file contents directly from the URL.

- ``URL/readFromFile()``

## See Also

- ``RKUtils/Swift/String``
