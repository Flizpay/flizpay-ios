#!/bin/sh

xcodebuild test \
  -scheme FlizpaySDK \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' \
  -sdk iphonesimulator \
  -enableCodeCoverage YES \
  CODE_SIGN_IDENTITY="FLIZpay" CODE_SIGNING_REQUIRED=NO
