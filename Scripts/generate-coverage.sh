#!/bin/sh
OUTPUT_FILE="coverage/lcov.info"
IGNORE_FILENAME_REGEX=".build|Tests|Pods|Carthage|DerivedData"
BUILD_PATH="DerivedData"

INSTR_PROFILE=$(find $BUILD_PATH -name "*.profdata")

mkdir -p $(dirname "$OUTPUT_FILE")

# Export to code coverage file
xcrun llvm-cov export -format=lcov \
  "DerivedData/Build/Products/Debug-iphonesimulator/FlizpaySDK.o" \
  --instr-profile=$INSTR_PROFILE \
  --ignore-filename-regex=$IGNORE_FILENAME_REGEX > $OUTPUT_FILE

echo "Coverage report generated at $OUTPUT_FILE"