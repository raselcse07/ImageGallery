# Image Gallary

## API Key Setup

```App/Config/APIConfig.swift```

```swift
 var authKey: String {
        switch self {
            case .pexels:
                return YOUR_KEY
        }
    }
```
** At this moment, there is a default key. You can also use it.

## API Header Setup

```App/Config/APIConfig.swift```

```swift
var headers: Headers {
        switch self {
            case .pexels:
                return [
                    "Authorization" : "Bearer \(authKey)"
                ]
        }
    }
```

## API Base URL Setup

```App/Config/APIConfig+DEV.swift```
```App/Config/APIConfig+PROD.swift```
```App/Config/APIConfig+STG.swift```

```swift
extension APIConfig {
    var baseURLString: String {
        return BASE_URL
    }
}

```
** There is a base url for `Pexels` now. 

## Dependency

```pod```

```
RxSwift
RxCocoa
Kingfisher
RxTest
```
