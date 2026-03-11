#!/bin/sh

DERIVED_DATA_PATH=DerivedData
DESTINATION="${IOS_TEST_DESTINATION:-platform=iOS Simulator,name=iPhone 16,OS=latest}"

xcodebuild test \
  -scheme FlizpaySDK \
  -destination "$DESTINATION" \
  -enableCodeCoverage YES \
  -derivedDataPath $DERIVED_DATA_PATH
