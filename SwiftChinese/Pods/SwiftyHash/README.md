# SwiftyHash

SwiftyHash is a Swifty wrapper for CommonCrypto to easy use.

## Requirements

* iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+
* Xcode 8.0+
* Swift 3.0+

## Support

* Data in memory & File in disk
* md5
* sha1
* sha2(sha224, sha256, sha384, sha512)

## Examples

### For data in memory

```swift
let words: String = "A Swifty wrapper for CommonCrypto"
let sha256: String = words.digest.sha256
```

### For file in disk
```swift
guard let path = Bundle.main.path(forResource: "Github", ofType: "png") else {
    fatalError("Fail to find the image 'Github.png'")
}
let md5: String? = path.fileDigest.md5
```

## Installation

### [CocoaPods](http://cocoapods.org)

> CocoaPods 1.1.0+ is required to build SwiftyHash 0.3.0+.

To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SwiftyHash', '~> 0.3'
end
```
Then, run the following command:

```bash
$ pod install
```

## License

SwiftyHash is released under the MIT license. See LICENSE for details.
