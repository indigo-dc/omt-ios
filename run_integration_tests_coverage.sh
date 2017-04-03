#!/bin/bash

# output dir
SCRIPT_OUTPUT='integration_tests_coverage'
mkdir -p $SCRIPT_OUTPUT

# run test
echo "Running test"
xcodebuild \
    -workspace ./Example/IndigoOmtIosLibrary.xcworkspace \
    -scheme "IndigoOmtIosLibrary_ExampleIntegration" \
    test \
    -destination "platform=iOS Simulator,name=iPhone 5" \
    &> "./$SCRIPT_OUTPUT/xcodebuild.log"

# generate coverage
echo "Generating coverage"
xcov \
    -w ./Example/IndigoOmtIosLibrary.xcworkspace \
    -s IndigoOmtIosLibrary \
    -o "./$SCRIPT_OUTPUT" \
    --exclude_targets Quick.framework,Alamofire.framework,Nimble.framework,AppAuth.framework,SwiftyJSON.framework,IndigoOmtIosLibrary_Example.app,Embassy.framework,IndigoOmtIosLibrary_ExampleIntegration.app \
    --html_report \
    &> "./$SCRIPT_OUTPUT/xcov.log"

# generate report
cat "./$SCRIPT_OUTPUT/xcodebuild.log" | xcpretty -r html --output "./$SCRIPT_OUTPUT/report.html"

# open report
open "./$SCRIPT_OUTPUT/report.html"
