# FLIZpay iOS SDK

[![Platform](https://img.shields.io/badge/platform-iOS-blue)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/swift-5-orange)](https://swift.org/)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen)](https://swift.org/package-manager/)
[![Version](https://img.shields.io/github/v/tag/yourusername/FLIZpaySDK)](https://github.com/yourusername/FLIZpaySDK/releases)
[![License](https://img.shields.io/github/license/yourusername/FLIZpaySDK)](LICENSE)

Welcome to the FLIZpay iOS SDK! Easily integrate secure, seamless, and user-friendly payments directly into your iOS app.

## 🚀 Overview

The FLIZpay SDK simplifies accepting payments by managing the entire payment flow via an integrated webview, securely and intuitively within your app.

---

## 📦 Installation

FLIZpay SDK is available through Swift Package Manager.

1. In Xcode, select `File > Add Packages...`
2. Enter the repository URL:

```https://github.com/yourusername/FLIZpaySDK.git```

3. Choose the desired version or branch, then add it to your project.

---

## ⚡️ Quick Start

After installing the SDK, initiate payments effortlessly:

```swift
import FlizpaySDK

FlizpaySDK.initiatePayment(amount: "49.99", token: "YOUR_JWT_TOKEN")
```

### Parameters

- **`amount`** (`String`, required): The payment amount.
- **`token`** (`String`, optional): JWT authentication token obtained from your backend.

---

## 📖 Detailed Integration Guide

For comprehensive integration details, API authentication steps, obtaining JWT tokens, and additional examples, see our [Integration Documentation](#).

---

## 📄 License

FLIZpay SDK is available under the MIT license. See the [LICENSE](LICENSE) file for more details.

---

## 🛟 Support

Need assistance? Our support team is here to help.

👉 [Contact FLIZpay Support](https://support.flizpay.de)

---

Happy coding! 🚀🎉

