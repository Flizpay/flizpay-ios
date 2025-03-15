#!/bin/sh
DERIVED_DATA_PATH=DerivedData
xcodebuild test \
  -scheme FlizpaySDK \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' \
  -enableCodeCoverage YES \
  -derivedDataPath $DERIVED_DATA_PATH
