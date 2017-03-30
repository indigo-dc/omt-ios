#!/bin/bash

# output dir
SCRIPT_OUTPUT='unit_tests_coverage'
mkdir -p $SCRIPT_OUTPUT

# run test
echo "Running test"
xcodebuild \
    -workspace ./Example/IndigoOmtIosLibrary.xcworkspace \
    -scheme "IndigoOmtIosLibrary_Example" \
    test \
    -destination "platform=iOS Simulator,name=iPhone 5" \
    &> "./$SCRIPT_OUTPUT/xcodebuild.log"

# generate coverage
echo "Generating coverage"
xcov \
    -w ./Example/IndigoOmtIosLibrary.xcworkspace \
    -s IndigoOmtIosLibrary \
    -o "./$SCRIPT_OUTPUT" \
    --exclude_targets Quick.framework,Alamofire.framework,Nimble.framework,AppAuth.framework,SwiftyJSON.framework,IndigoOmtIosLibrary_Example.app \
    --html_report \
    &> "./$SCRIPT_OUTPUT/xcov.log"

# show report
echo "Opening report"
open "./$SCRIPT_OUTPUT/index.html"
