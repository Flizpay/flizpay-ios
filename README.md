# FLIZpay iOS SDK

[![Platform](https://img.shields.io/badge/platform-iOS-blue)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/swift-5-orange)](https://swift.org/)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen)](https://swift.org/package-manager/)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/FlizpaySDK.svg)](https://cocoapods.org/pods/FlizpaySDK)
[![Version](https://img.shields.io/github/v/tag/Flizpay/flizpay-ios)](https://github.com/Flizpay/flizpay-ios/releases)
[![iOS SDK Tests](https://github.com/Flizpay/flizpay-ios/actions/workflows/run-tests.yml/badge.svg)](https://github.com/Flizpay/flizpay-ios/actions/workflows/run-tests.yml)
[![Coverage Status](https://coveralls.io/repos/github/Flizpay/flizpay-ios/badge.svg?branch=main)](https://coveralls.io/github/Flizpay/flizpay-ios?branch=main)
[![License](https://img.shields.io/github/license/Flizpay/flizpay-ios)](LICENSE)

Welcome to the FLIZpay iOS SDK! Easily integrate secure, seamless, and user-friendly payments directly into your iOS app.

## 🚀 Overview

The FLIZpay SDK simplifies accepting payments by managing the entire payment flow via an integrated webview, securely and intuitively within your app.

Get started with our 📚 [integration guide](https://www.docs.flizpay.de/docs/sdk/Installation)

---

## 📦 Requirements

The FLIZpay iOS SDK requires Xcode 15 or later and is compatible with apps targeting iOS 13 or above.

## 💻 Installation

### Swift Package Manager

Add the following to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/Flizpay/flizpay-ios.git", from: "0.2.0")
]
```

### CocoaPods

Add the following to your `Podfile`:

```ruby
pod 'FlizpaySDK', '~> 0.2.0'
```

Then run:

```bash
pod install
```

## ⚡️ Quick Start

After installing the SDK, initiate payments effortlessly by: 
- authorizing your transaction with the `API_KEY` in your backend to obtain a token
- use it to load the FLIZPay environment in your application

```swift
import FlizpaySDK

FlizpaySDK.initiatePayment(
    from: currentViewController,
    token: token,
    amount: userAmount
) { error in
    // Handle any error returned from the SDK.
    print("Payment failed: \(error)")
}
```

### Parameters

- **`from`** (`UIViewController`, required): The Presenting View Controller where the webview is going to be attached
- **`token`** (`String`, required): JWT authentication token obtained from your backend (Check our docs on how to authenticate).
- **`amount`** (`String`, required): The payment amount.
- **`@closure onFailure `** (`Function`, optional): Block that receives an error param to be called when the webview can't be opened
---

## 📖 Detailed Integration Guide

For comprehensive integration details, API authentication steps, obtaining JWT tokens, and additional examples, see our [Integration Documentation](https://www.docs.flizpay.de/docs/sdk/Installation).

---

## 📄 License

FLIZpay SDK is available under the MIT license. See the [LICENSE](LICENSE) file for more details.

---

## 🛟 Support

Need assistance?

👉 [Talk to our devs](https://support.flizpay.de)

---

Happy coding! 🚀🎉

